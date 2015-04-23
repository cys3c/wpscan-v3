require 'spec_helper'

describe WPScan::Controller::BruteForce do
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
      expect(controller.cli_options.map(&:to_sym)).to eq [:passwords, :username, :usernames]
    end
  end

  describe '#users' do
    context 'when no --usernames or --username' do
      it 'calles target.users' do
        expect(controller.target).to receive(:users)
        controller.users
      end
    end

    context 'when --username' do
      let(:parsed_options) { super().merge(username: 'admin') }

      it 'returns an array with the user' do
        expect(controller.users).to eql [WPScan::User.new('admin')]
      end
    end

    context 'when --usernames' do
      let(:parsed_options) { super().merge(usernames: File.join(FIXTURES, 'users.txt')) }

      it 'returns an array with the users' do
        expected = %w(admin editor).reduce([]) do |a, e|
          a << WPScan::User.new(e)
        end

        expect(controller.users).to eql expected
      end
    end
  end

  describe '#passwords' do
    xit
  end

  describe '#output_error' do
    xit
  end

  describe '#run' do
    context 'when no --passwords is supplied' do
      it 'does not run the brute forcer' do
        expect(controller.run).to eql nil
      end
    end
  end

  describe '#brute_force' do
    xit
  end
end
