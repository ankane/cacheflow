module Cacheflow
  module Memcached
    module Notifications
      def request(op, *args)
        payload = {
          op: op,
          args: args
        }
        ActiveSupport::Notifications.instrument("query.memcached", payload) do
          super
        end
      end
    end

    class Instrumenter < ActiveSupport::LogSubscriber
      def query(event)
        return unless logger.debug?

        name = "%s (%.2fms)" % ["Memcached", event.duration]
        debug "  #{color(name, BLUE, true)} #{event.payload[:op].to_s.upcase} #{event.payload[:args].join(" ")}"
      end
    end
  end
end

Dalli::Server.prepend(Cacheflow::Memcached::Notifications)
Cacheflow::Memcached::Instrumenter.attach_to(:memcached)
