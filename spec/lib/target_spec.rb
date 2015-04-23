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
end
