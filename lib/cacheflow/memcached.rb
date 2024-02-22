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
        return if !logger.debug? || Cacheflow.silenced?

        name = "%s (%.2fms)" % ["Memcached", event.duration]
        debug "  #{color(name, BLUE, bold: true)} #{event.payload[:op].to_s.upcase} #{Cacheflow.args(event.payload[:args])}"
      end
    end
  end
end

if defined?(Dalli::Protocol::Binary)
  Dalli::Protocol::Binary.prepend(Cacheflow::Memcached::Notifications)
else
  Dalli::Server.prepend(Cacheflow::Memcached::Notifications)
end
Cacheflow::Memcached::Instrumenter.attach_to(:memcached)
