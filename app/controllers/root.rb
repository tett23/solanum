Solanum.controllers :root do
  get :index, :map=>'/' do
    render 'root/index'
  end
end
