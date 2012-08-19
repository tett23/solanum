#encoding: utf-8

require 'em-websocket'
require 'json'
require 'logger'
require 'bundler'
#Bundler.require
require 'dm-core'
require 'dm-validations'

require './models/log'
require './models/account'

DataMapper.setup(:default, "sqlite3:./db/solanum_development.db")
DataMapper.finalize

require './carolinense/route_resolver'

module EventMachine
  class Channel
    attr_reader :subs
  end
end

EM::run do
  @log = Logger.new('log/websocket.log', 'daily')
  @log.datetime_format = "%F %T"
  @channels = Hash.new
  @messages = 0

  EM::PeriodicTimer.new(60) do
    @subscribes = 0
    @channels.each do |path, channel|
      @subscribes += channel.subs.size
    end

    @log.debug "#{@subscrivers} users generationg #{@messages / 60} messages per second."
    @messages = 0
  end

  EM::WebSocket.start(:host=> "0.0.0.0", :port=>8080) do |socket|
    socket.onopen do
      Definetion::Routes.instance.call(request_path(socket), {:socket=>socket, :channel=>channel_for_socket(socket)})
      payload = Hash.new

      sid = channel_for_socket(socket).subscribe do |message|
        json = JSON.parse(message)
        account_id = json['account_id']

        unless account_id.nil?
          account = Account.first(:id => account_id)
          json["account_name"] = account.name
        end

        Log.create(:channel=>socket.request["path"], :account_id=>account_id, :body=>json.to_json.to_s)
        socket.send json.to_json
      end

      Log.all(:channel=>socket.request["path"], :order=>[:id.desc], :limit=>10).each do |log|
        socket.send log.body
      end

      @log.info payload[:type] = 'system'
      @log.info payload[:body] = "#{sid} connected"
      channel_for_socket(socket).push payload.to_json
      #socket.onmessage do |data|
      #  channel_for_socket(socket).push data
      #  @messages += channel_for_socket(socket).subs.size
      #end

      socket.onclose do
        channel_for_socket(socket).unsubscribe(sid)
        @log.info payload[:type] = 'system'
        @log.info payload[:body] = "#{sid} disconnected"
        channel_for_socket(socket).push payload.to_json
      end
    end

    socket.onerror do |error|
      @log.error "#{error.message}"
    end
  end

  def request_path(socket)
    socket.request['path'].downcase
  end

  def channel_for_socket(socket)
    path = socket.request["path"].downcase
    @channels[path] = EM::Channel.new unless @channels.key?(path)

    @channels[path]
  end
end
