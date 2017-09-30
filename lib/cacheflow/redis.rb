module Cacheflow
  module Redis
    module Notifications
      def logging(commands)
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
        return unless logger.debug?

        name = "%s (%.2fms)" % ["Redis", event.duration]

        commands = []
        event.payload[:commands].map do |op, *args|
          commands << "#{op.to_s.upcase} #{args.join(" ")}".strip
        end

        debug "  #{color(name, RED, true)} #{commands.join(" >> ")}"
      end
    end
  end
end

Redis::Client.prepend(Cacheflow::Redis::Notifications)
Cacheflow::Redis::Instrumenter.attach_to(:redis)
