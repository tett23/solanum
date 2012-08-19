class AccountsChannels
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :account_id, Integer
  property :channel_id, Integer

  #belongs_to :channel
  #has n, :account

  def self.channel_members(channel_id)
    all(:channel_id => channel_id).map do |member|
      member.account_id
    end
  end

  def self.member_channels(account_id)
    all(:account_id => account_id).map do |channel|
      channel.id
    end
  end

  def self.add(channel_id, account_ids)
    account_ids.each do |account_id|
      self.create(:channel_id=>channel_id, :account_id=>account_id)
    end

    return true
  end
end
