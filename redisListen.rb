require 'octocore'
require 'daemons'
require 'json'
require 'ruby-kafka'

class EventsRedisListener

  def initialize(config_file=nil)
    if config_file.nil?
      config_file = File.join(File.expand_path(File.dirname(__FILE__)), 'config')
    end
    Octo.connect_with config_file
    @redisListener = Cequel::Record.redis

    kafka_config = Octo.get_config :kafka
    @kafka_bridge = Octo::KafkaBridge.new(kafka_config)

    Signal.trap('INT') { @redisListener.interrupt }
  end

  def startListening

    # It should ideally be psubscribe, but psusbcribe
    #  doesn't seem to work for a weird reason

    @redisListener.subscribe('__keyevent@0__:expired') do |on|
      on.message do |channel, msg|
        if ( msg =~ /shadow:(.*)/ )
          msg = msg.sub 'shadow:',''
          enterpriseId = msg.split('_').first
          @kafka_bridge.push({
                                 event_name:'funnel_update',
                                 enterprise:{custom_id: enterpriseId},
                                rediskey: msg
                             })
          puts msg

        end
      end
    end

  end

end

def main(config_file)
  ec = EventsRedisListener.new(config_file)
  ec.startListening
end

if __FILE__ == $0

  curr_dir = File.expand_path(File.dirname(__FILE__))

  opts = {
      app_name: 'redisListen',
      dir_mode: :script,
      dir: 'shared/pids',
      log_dir: "#{ curr_dir }/shared/log",
      log_output: true,
      monitor: true,
      multiple: true
  }

  config_file = File.join(curr_dir, 'config')

  Daemons.run_proc('redisListen', opts) do
    main(config_file)
  end
end