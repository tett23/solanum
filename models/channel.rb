class Channel
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :title, String, :length=>1024
  property :description, Text
  property :create_account_id, Integer
  property :permission, Integer

  #has n, :accounts, :through=>Resource

  def self.find_by_title(title)
    first(:title=>title)
  end
end
