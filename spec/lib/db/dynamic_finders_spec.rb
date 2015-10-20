require 'spec_helper'

describe WPScan::DB::DynamicPluginFinders do
  subject(:dynamic_finders) { described_class }

  describe '.comments' do
    its('comments.keys') { should_not include('wordpress-mobile-pack') }

    it 'contains the expected configs' do
      comment_configs = dynamic_finders.comments

      expect(comment_configs.keys).to include('rspec-failure')

      expect(comment_configs['rspec-failure']['pattern']).to be_a Regexp
    end
  end

  describe '.urls_in_page' do
    its('urls_in_page.keys') { should_not include('rspec-failure') }
    its('urls_in_page.keys') { should include('wordpress-mobile-pack') }
  end
end

describe WPScan::DB::DynamicThemeFinders do
  subject(:dynamic_finders) { described_class }

  describe '.db_data' do
    its(:db_data) { should eql({}) }
  end
end
