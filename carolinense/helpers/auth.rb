definetions do
  helpers do
    AUTH_TOKEN_EXPIRE = 60*60*24*3

    def auth?(id, token)
      account = Account.first(:id=>id, :auth_token=>token)
      return false if account.nil?

      auth_token_expire(account)
    end
  end

  def auth_token_expire(account)
    return false if account.auth_token_issued.nil?
    !(Time.now > Time.parse(account.auth_token_issued.to_s)+AUTH_TOKEN_EXPIRE)
  end
end
