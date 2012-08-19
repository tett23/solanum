require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

class LogTest < Test::Unit::TestCase
  context "Log Model" do
    should 'construct new instance' do
      @log = Log.new
      assert_not_nil @log
    end
  end
end
