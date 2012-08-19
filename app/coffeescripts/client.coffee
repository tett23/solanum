$ ->
  channel = $('#channel_settings').data('channel')
  socket = new WebSocket('ws://localhost:8080/channels/'+channel)
  account_id = $('#user_info').data('account-id')
  auth_token = $('#user_info').data('auth-token')

  socket.onopen = ->
    console.log('opened')

  socket.onmessage = (message) ->
    console.log(message.data)
    tag = parseMessage(message.data)
    $('#messages').append(tag)

  parseMessage = (message) ->
    message = JSON.parse(message)
    tag = $('<div class="message_line clearfix"></div>')
    speaker_name = if message.type == 'system' then 'system' else message.account_name
    console.log speaker_name
    speaker = '<div class="speaker">'+speaker_name+'</div>'
    message_body = '<div class="body">'+message.body.replace(/\n/, '<br>')+'</div>'

    tag.addClass(message.type)
    tag.html(speaker+message_body)
  $('#submit').click ->
    message = $('#message').val()

    socket.send(createMessage(message))

  createMessage = (message) ->
    data = {
      type: 'message',
      body: message,
      account_id: account_id,
      auth_token: auth_token
    }

    JSON.stringify(data)

  shiftFlag = false
  $('#message').keydown (e) ->
    if e.keyCode == 16 # shift
      shiftFlag = true
    if shiftFlag && e.keyCode == 13 # shift+enter
      $('#submit').trigger('click')
  $('#message').keyup (e) ->
    if e.keyCode == 16
      shiftFlag = false
