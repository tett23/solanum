definetions do
  route :'/channels/:channel' do |params|
    socket = params[:socket]
    socket.onmessage do |data|
      json = JSON.parse(data)
      is_login = auth?(json['account_id'], json['auth_token'])
      params[:channel].push({
        :type => 'system',
        :body => 'トークンの受け入れに失敗しました。ページのリロードか再ログインを要求します',
        :account_id => json['account_id']
      }.to_json) unless is_login

      params[:channel].push data
    end
  end

  route :'/test/:opt1/:opt2' do |params|
  end

  route :'/config' do

  end
end
