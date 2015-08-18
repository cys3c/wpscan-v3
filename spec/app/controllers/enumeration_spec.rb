require 'spec_helper'

describe WPScan::Controller::Enumeration do
  subject(:controller) { described_class.new }
  let(:target_url)     { 'http://wp.lab/' }
  let(:parsed_options) { { url: target_url } }

  before do
    WPScan::Browser.reset
    described_class.parsed_options = parsed_options
  end

  describe '#enum_message' do
    after { expect(controller.enum_message(type)).to eql @expected }

    context 'when type argument is incorrect' do
      let(:type) { 'spec' }

      it 'returns nil' do
        @expected = nil
      end
    end

    %w(plugins themes).each do |t|
      context "type = #{t}" do
        let(:type) { t }

        context 'when vulnerable' do
          let(:parsed_options) { super().merge(enumerate: { :"vulnerable_#{type}" => true }) }

          it 'returns the expected string' do
            @expected = "Enumerating Vulnerable #{type.capitalize}"
          end
        end

        context 'when all' do
          let(:parsed_options) { super().merge(enumerate: { :"all_#{type}" => true }) }

          it 'returns the expected string' do
            @expected = "Enumerating All #{type.capitalize}"
          end
        end

        context 'when most popular' do
          let(:parsed_options) { super().merge(enumerate: { type.to_sym => true }) }

          it 'returns the expected string' do
            @expected = "Enumerating Most Popular #{type.capitalize}"
          end
        end
      end
    end
  end

  describe '#before_scan' do
    context 'when a Class already exist' do
      module WPScan
        module Finders
          module PluginVersion
            module RspecFailure
              class Comments
              end
            end
          end
        end
      end

      it 'raises an error' do
        expect { controller.before_scan }
          .to raise_error('WPScan::Finders::PluginVersion::RspecFailure has already a Comments class')
      end
    end

    context 'when everything is fine' do
      it 'creates the expected classes' do
        dynamic_finders_config['plugins'].each do |name, config|
          %w(Comments).each do |klass|
            next unless config[klass]['version'] && name != 'rspec-failure'

            constant_name = name.tr('-', '_').camelize

            # Will have to change the below if new classes are added
            defined_klass = WPScan::Finders::PluginVersion.const_get("#{constant_name}::Comments")

            expect(defined_klass::PATTERN).to eql Regexp.new(config[klass]['pattern'], Regexp::IGNORECASE)
          end
        end
      end
    end
  end

  describe '#cli_options' do
    it 'contains the correct options' do
      expect(controller.cli_options.map(&:to_sym)).to eql([
        :enumerate, :exclude_content_based,
        :plugins_list, :plugins_detection, :plugins_version_all,
        :themes_list, :themes_detection, :themes_version_all,
        :timthumbs_list, :timthumbs_detection,
        :config_backups_list, :config_backups_detection,
        :medias_detection,
        :users_list, :users_detection
      ])
    end
  end

  describe '#enum_users' do
    before { expect(controller.formatter).to receive(:output).twice }
    after { controller.enum_users }

    context 'when --enumerate has been supplied' do
      let(:parsed_options) { super().merge(enumerate: { users: (1..10) }) }

      it 'calls the target.users with the correct range' do
        expect(controller.target).to receive(:users).with(hash_including(range: (1..10)))
      end
    end

    context 'when --passwords supplied but no --username or --usernames' do
      let(:parsed_options) { super().merge(passwords: 'some-file.txt') }

      it 'calls the target.users with the default range' do
        expect(controller.target).to receive(:users).with(hash_including(range: (1..10)))
      end
    end
  end

  describe '#run' do
    context 'when no :enumerate' do
      it 'returns nil' do
        expect(controller.run).to eql nil
      end
    end

    context 'when --passwords supplied but no --username or --usernames' do
      let(:parsed_options) { super().merge(passwords: 'some-file.txt') }

      it 'calls the enum_users' do
        expect(controller).to receive(:enum_users)
        controller.run
      end
    end

    context 'when :enumerate' do
      after { controller.run }

      [:plugins, :all_plugins, :vulnerable_plugins].each do |option|
        context "when #{option}" do
          let(:parsed_options) { super().merge(enumerate: { option => true }) }

          it 'calls the #enum_plugins' do
            expect(controller).to receive(:enum_plugins)
          end
        end
      end

      [:themes, :all_themes, :vulnerable_themes].each do |option|
        context "#{option}" do
          let(:parsed_options) { super().merge(enumerate: { option => true }) }

          it 'calls the #enum_themes' do
            expect(controller).to receive(:enum_themes)
          end
        end
      end

      [:timthumbs, :config_backups, :medias, :users].each do |option|
        context "when #{option}" do
          let(:parsed_options) { super().merge(enumerate: { option => true }) }

          it "calls the ##{option}" do
            expect(controller).to receive("enum_#{option}".to_sym)
          end
        end
      end
    end
  end
end
