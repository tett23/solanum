class Solanum < Padrino::Application
  register SassInitializer
  register Padrino::Rendering
  register Padrino::Mailer
  register Padrino::Helpers
  register Padrino::Admin::AccessControl

  enable :sessions
  enable :authentication
  enable :store_location
  set :login_page, '/sessions/new'

  access_control.roles_for :any do |role|
    role.protect '/'
    role.allow '/sessions'
    role.allow '/update'
  end

  access_control.roles_for :admin do |role|

  end

  before do
    unless current_account.blank?
      @channel_ids = AccountsChannels.member_channels(current_account.id)
      @channels = Channel.all(:id => @channel_ids)
    end
  end

  error 404 do
    render 'errors/404'
  end

  error 505 do
    render 'errors/505'
  end

  get :update, :map=>'/update' do
    DataMapper.auto_upgrade!
  end
end
