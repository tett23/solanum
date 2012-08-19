Solanum.controllers :rooms do

  get :index do
    
    render 'rooms/index'
  end

  get :view, :map=>'/rooms/channel/:channel' do
    p params[:channel]
    render 'rooms/view'
  end

end
