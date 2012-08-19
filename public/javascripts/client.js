(function() {

  $(function() {
    var account_id, auth_token, channel, createMessage, parseMessage, shiftFlag, socket;
    channel = $('#channel_settings').data('channel');
    socket = new WebSocket('ws://localhost:8080/channels/' + channel);
    account_id = $('#user_info').data('account-id');
    auth_token = $('#user_info').data('auth-token');
    socket.onopen = function() {
      return console.log('opened');
    };
    socket.onmessage = function(message) {
      var tag;
      console.log(message.data);
      tag = parseMessage(message.data);
      return $('#messages').append(tag);
    };
    parseMessage = function(message) {
      var message_body, speaker, speaker_name, tag;
      message = JSON.parse(message);
      tag = $('<div class="message_line clearfix"></div>');
      speaker_name = message.type === 'system' ? 'system' : message.account_name;
      console.log(speaker_name);
      speaker = '<div class="speaker">' + speaker_name + '</div>';
      message_body = '<div class="body">' + message.body.replace(/\n/, '<br>') + '</div>';
      tag.addClass(message.type);
      return tag.html(speaker + message_body);
    };
    $('#submit').click(function() {
      var message;
      message = $('#message').val();
      return socket.send(createMessage(message));
    });
    createMessage = function(message) {
      var data;
      data = {
        type: 'message',
        body: message,
        account_id: account_id,
        auth_token: auth_token
      };
      return JSON.stringify(data);
    };
    shiftFlag = false;
    $('#message').keydown(function(e) {
      if (e.keyCode === 16) {
        shiftFlag = true;
      }
      if (shiftFlag && e.keyCode === 13) {
        return $('#submit').trigger('click');
      }
    });
    return $('#message').keyup(function(e) {
      if (e.keyCode === 16) {
        return shiftFlag = false;
      }
    });
  });

}).call(this);
