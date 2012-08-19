#encoding: utf-8

require 'optparse'

PID_FILE = 'tmp/carolinense.pid'

def start
  raise 'carolinense was started' if File.exists?(PID_FILE)

  pid = start_process
  open(PID_FILE, 'w'){|f| f.write(pid)}
end

def stop
  begin
    if File.exists?(PID_FILE)
      pid = open(PID_FILE).read
      File.unlink(PID_FILE)
      kill_process(pid.to_i)
    end
  rescue

  end
end

def restart
  stop()
  start()
end

def start_process
  Process.spawn('ruby carolinense/server.rb')
end

def kill_process(pid)
  Process.kill(:SIGHUP, pid)
end

opt = OptionParser.new

opt.on('-e ENV') do |env|
  p env
end
opt.on('-a ACTION') do |action|
  p action
  case action
  when 'start'
    start()
  when 'stop'
    stop()
  when 'restart'
    restart()
  end

end

opt.parse!(ARGV)


