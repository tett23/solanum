#encoding: utf-8

Solanum.controllers :channels do

  get :index do

    render 'channels/index'
  end


  get :new, :map=>'/channels/new' do
    render 'channels/new'
  end

  post :create do
    params[:channel][:create_account_id] = current_account.id

    @channel = Channel.new(params[:channel])
    if @channel.save

      AccountsChannels.add(@channel.id, [current_account.id])
      flash[:notice] = 'channel was created: '+params[:channel][:title]
      redirect url(:channels, :show, :channel=>params[:channel][:title])
    else
      render 'channels/new'
    end
  end


  get :show, :map=>'/channels/:channel' do
    @channel = Channel.find_by_title(params[:channel])
    @member_ids = AccountsChannels.channel_members(@channel.id)
    @members = Account.all(:id => @member_ids)

    redirect :'404' if @channel.blank?

    render 'channels/show'
  end

  get :member_add, :map=>'/channels/:channel/add' do
    @channel = Channel.find_by_title(params[:channel])
    @current_members = AccountsChannels.channel_members(@channel.id)
    @members = Account.select_options

    if @channel.blank?
      redirect '404'
    end

    render 'channels/member_add'
  end

  post :member_add, :map=>'/channels/:channel/add' do |channel|
    channel = Channel.find_by_title(channel)

    if AccountsChannels.add(channel.id, params[:array][:ids])
      flash[:notice] = 'member added: '
      redirect url(:channels, :show, :channel=>channel.title)
    else
      render 'channels/new'
    end

  end

  delete :leave, :map=>'/channels/:channel/leave' do |channel|
    channel = Channel.find_by_title(channel)
    accounts_channels = AccountsChannels.first(:channel_id=>channel.id, :account_id=>current_account.id)

    if accounts_channels.nil?
      redirect '404'
    end

    if accounts_channels.destroy
      flash[:notice] = channel.title.to_s+'から退出しました'
      redirect url(:channels, :index)
    else
      flash[:notice] = '退出に失敗しました'
      render 'channels/show'
    end

  end

end
