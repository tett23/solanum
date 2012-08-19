Solanum.controllers :sessions do

  get :new do
    render 'sessions/new', :layout=>:sessions
  end

  post :create do
    if account = Account.authenticate(params[:email], params[:password])
      set_current_account(account)
      set_auth_token(account)
      redirect url(:root, :index)
    elsif Padrino.env == :development && params[:bypass]
      account = Account.first
      set_current_account(account)
      set_auth_token(account)
      redirect url(:root, :index)
    else
      params[:email], params[:password] = h(params[:email]), h(params[:password])
      flash[:warning] = "Login or password wrong."
      redirect url(:sessions, :new)
    end
  end

  delete :destroy do
    set_current_account(nil)
    redirect url(:sessions, :new)
  end
end
