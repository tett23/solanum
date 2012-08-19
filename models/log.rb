require 'dm-core'

class Log
  include DataMapper::Resource
  #attr_accessor :id, :channel, :body

  # property <name>, <type>
  property :id, Serial
  property :channel, String, :length=>1024
  property :body, Text
  property :account_id, Integer

  def self.find_by_channel(channel)
    all(:channel=>channel).first
  end
end
