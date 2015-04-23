require 'spec_helper'

def it_calls_the_formatter_with_the_correct_parameter(version)
  it 'calls the formatter with the correct parameter' do
    expect(controller.formatter).to receive(:output)
      .with('version', hash_including(version: version), 'wp_version')
  end
end

describe WPScan::Controller::WpVersion do
  subject(:controller) { described_class.new }
  let(:target_url)     { 'http://ex.lo/' }
  let(:parsed_options) { { url: target_url } }

  before do
    WPScan::Browser.reset
    described_class.parsed_options = parsed_options
  end

  describe '#cli_options' do
    its(:cli_options) { should_not be_empty }
    its(:cli_options) { should be_a Array }

    it 'contains to correct options' do
      expect(controller.cli_options.map(&:to_sym)).to eq [:wp_version_all, :wp_version_detection]
    end
  end

  describe '#run' do
    before do
      expect(controller.target).to receive(:wp_version)
        .with(
          hash_including(
            mode: parsed_options[:wp_version_detection] || parsed_options[:detection_mode],
            confidence_threshold: parsed_options[:wp_version_all] ? 0 : 100
          )
        ).and_return(stubbed)
    end

    after { controller.run }

    [:mixed, :passive, :aggressive].each do |mode|
      context "when --detection-mode #{mode}" do
        let(:parsed_options) { super().merge(detection_mode: mode) }

        [WPScan::WpVersion.new('4.0')].each do |version|
          context "when version = #{version}" do
            let(:stubbed) { version }

            it_calls_the_formatter_with_the_correct_parameter(version)
          end
        end
      end
    end

    context 'when --wp-version-all supplied' do
      let(:parsed_options) { super().merge(wp_version_all: true) }
      let(:stubbed) { WPScan::WpVersion.new('3.9.1') }

      it_calls_the_formatter_with_the_correct_parameter(WPScan::WpVersion.new('3.9.1'))
    end

    context 'when --wp-version-detection mode supplied' do
      let(:parsed_options) do
        super().merge(detection_mode: :mixed, wp_version_detection: :passive)
      end
      let(:stubbed) { WPScan::WpVersion.new('4.1') }

      it_calls_the_formatter_with_the_correct_parameter(WPScan::WpVersion.new('4.1'))
    end
  end
end
