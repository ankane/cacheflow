module Cacheflow
  module Redis
    module ClientNotifications
      def call(command, redis_config)
        payload = {
          commands: [command]
        }
        ActiveSupport::Notifications.instrument("query.redis", payload) do
          super
        end
      end

      def call_pipelined(commands, redis_config)
        payload = {
          commands: commands
        }
        ActiveSupport::Notifications.instrument("query.redis", payload) do
          super
        end
      end
    end

    class Instrumenter < ActiveSupport::LogSubscriber
      def query(event)
        return if !logger.debug? || Cacheflow.silenced?

        name = "%s (%.2fms)" % ["Redis", event.duration]

        commands = []
        event.payload[:commands].map do |op, *args|
          commands << "#{op.to_s.upcase} #{Cacheflow.args(args)}".strip
        end

        debug "  #{color(name, RED, bold: true)} #{commands.join(" >> ")}"
      end
    end
  end
end

RedisClient.register(Cacheflow::Redis::ClientNotifications)
Cacheflow::Redis::Instrumenter.attach_to(:redis)
