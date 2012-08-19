require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

class AccountsChannelsTest < Test::Unit::TestCase
  context "AccountsChannels Model" do
    should 'construct new instance' do
      @accounts_channels = AccountsChannels.new
      assert_not_nil @accounts_channels
    end
  end
end
