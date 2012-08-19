require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

class ChannelTest < Test::Unit::TestCase
  context "Channel Model" do
    should 'construct new instance' do
      @channel = Channel.new
      assert_not_nil @channel
    end
  end
end
