require 'spec_helper'

describe WPScan::Target do
  subject(:target) { described_class.new(url) }
  let(:url)        { 'http://ex.lo' }

  it_behaves_like WPScan::Target::Platform::WordPress

  [:wp_version, :main_theme, :plugins, :themes, :timthumbs, :config_backups, :medias, :users].each do |method|
    describe "##{method}" do
      before do
        return_value = [:wp_version, :main_theme].include?(method) ? false : []

        expect(WPScan::Finders.const_get("#{method.to_s.camelize}::Base"))
          .to receive(:find).with(target, opts).and_return(return_value)
      end

      after { target.send(method, opts) }

      let(:opts) { {} }

      context 'when no options' do
        it 'calls the finder with the correct arguments' do
          # handled by before hook
        end
      end

      context 'when options' do
        let(:opts) { { mode: :passive, somthing: 'k' } }

        it 'calls the finder with the corect arguments' do
          # handled by before hook
        end
      end

      context 'when called multiple times' do
        it 'calls the finder only once' do
          target.send(method, opts)
        end
      end
    end
  end

  describe '#vulnerable?' do
    context 'when all attributes are nil' do
      it { should_not be_vulnerable }
    end

    context 'when wp_version found' do
      context 'when not vulnerable' do
        before { target.instance_variable_set(:@wp_version, WPScan::WpVersion.new('4.1')) }

        it { should_not be_vulnerable }
      end

      context 'when vulnerable' do
        before { target.instance_variable_set(:@wp_version, WPScan::WpVersion.new('3.8.1')) }

        it { should be_vulnerable }
      end
    end

    context 'when config_backups' do
      before do
        target.instance_variable_set(:@config_backups, [WPScan::ConfigBackup.new(target.url('/a-file-url'))])
      end

      it { should be_vulnerable }
    end

    context 'when users' do
      before do
        target.instance_variable_set(:@users, [WPScan::User.new('u1'), WPScan::User.new('u2')])
      end

      context 'when no passwords' do
        it { should_not be_vulnerable }
      end

      context 'when at least one password has been found' do
        before { target.users[1].password = 'owned' }

        it { should be_vulnerable }
      end
    end
  end
end
