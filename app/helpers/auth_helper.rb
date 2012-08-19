#encoding: utf-8

require 'digest/sha1'

Solanum.helpers do
  AUTH_TOKEN_EXPIRE = 60*60*24*3

  def issue_auth_token
    Digest::SHA1.hexdigest(rand.to_s)
  end

  def set_auth_token(account)
    account = Account.first(:id=>account.id)
    return false if account.nil?

    token = issue_auth_token()
    account.update(:auth_token=>token, :auth_token_issued=>Time.now)
  end

  def auth_token_expire(account)
    return false if account.auth_token_issued.nil?
    !(Time.now > Time.parse(account.auth_token_issued.to_s)+AUTH_TOKEN_EXPIRE)
  end

  def auth(account)
    return false if account.auth_token.nil?

    account = Account.first(:id=>account.id, :auth_token=>account.auth_token)
    return false if account.nil?

    auth_token_expire(account)
  end
end
