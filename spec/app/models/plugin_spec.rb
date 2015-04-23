require 'spec_helper'

describe WPScan::Plugin do
  subject(:plugin) { described_class.new(name, target, opts) }
  let(:name)       { 'spec' }
  let(:target)     { WPScan::Target.new('http://wp.lab/') }
  let(:opts)       { {} }

  before { expect(target).to receive(:content_dir).and_return('wp-content') }

  describe '#new' do
    its(:url) { should eql 'http://wp.lab/wp-content/plugins/spec/' }
  end

  describe '#version' do
    after do
      expect(WPScan::Finders::PluginVersion::Base).to receive(:find).with(plugin, @expected_opts)
      plugin.version(version_opts)
    end

    let(:default_opts) { { confidence_threshold: 100 } }

    context 'when no :detection_mode' do
      context 'when no :mode opt supplied' do
        let(:version_opts) { { something: 'k' } }

        it 'calls the finder with the correct parameters' do
          @expected_opts = default_opts.merge(mode: nil, something: 'k')
        end
      end

      context 'when :mode supplied' do
        let(:version_opts) { { mode: :passive } }

        it 'calls the finder with the correct parameters' do
          @expected_opts = default_opts.merge(mode: :passive)
        end
      end
    end

    context 'when :version_all' do
      let(:opts)         { super().merge(version_all: true) }
      let(:version_opts) { {} }

      it 'calls the finder with the correct parameters' do
        @expected_opts = { mode: nil, confidence_threshold: 0 }
      end
    end

    context 'when :detection_mode' do
      let(:opts) { super().merge(mode: :passive) }

      context 'when no :mode' do
        let(:version_opts) { {} }

        it 'calls the finder with the :passive mode' do
          @expected_opts = default_opts.merge(mode: :passive)
        end
      end

      context 'when :mode' do
        let(:version_opts) { { mode: :mixed } }

        it 'calls the finder with the :mixed mode' do
          @expected_opts = default_opts.merge(mode: :mixed)
        end
      end
    end
  end

  describe '#vulnerabilities' do
    after do
      expect(plugin.vulnerabilities).to eq @expected
      expect(plugin.vulnerable?).to eql @expected.empty? ? false : true
    end

    context 'when plugin not in the DB' do
      let(:name) { 'not-in-db' }

      it 'returns an empty array' do
        @expected = []
      end
    end

    context 'when in the DB' do
      context 'when no vulnerabilities' do
        let(:name) { 'no-vulns' }

        it 'returns an empty array' do
          @expected = []
        end
      end

      context 'when vulnerabilities' do
        let(:name) { 'theme-my-login' }
        let(:all_vulns) do
          [
            WPScan::Vulnerability.new(
              'Theme My Login - First Vuln',
              { wpvulndb: '1' },
              'LFI',
              '6.3.10'
            ),
            WPScan::Vulnerability.new('Theme My Login - No Fixed In', wpvulndb: '2')
          ]
        end

        context 'when no plugin version' do
          before { expect(plugin).to receive(:version).at_least(1).and_return(false) }

          it 'returns all the vulnerabilities' do
            @expected = all_vulns
          end
        end

        context 'when plugin version' do
          before { expect(plugin).to receive(:version).at_least(1).and_return(WPScan::Version.new(number)) }

          context 'when < to a fixed_in' do
            let(:number) { '5.0' }

            it 'returns it' do
              @expected = all_vulns
            end
          end

          context 'when >= to a fixed_in' do
            let(:number) { '6.3.10' }

            it 'does not return it ' do
              @expected = [all_vulns.last]
            end
          end
        end
      end
    end
  end
end
