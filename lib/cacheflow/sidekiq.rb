module Cacheflow
  module Sidekiq
    module InstanceMethods
      def redis(...)
        Cacheflow.silence do
          super
        end
      end
    end

    module Client
      module InstanceMethods
        def push(...)
          Cacheflow.silence do
            super
          end
        end
      end
    end
  end
end

if defined?(::Sidekiq::Capsule)
  ::Sidekiq::Capsule.prepend(Cacheflow::Sidekiq::InstanceMethods)
end

::Sidekiq::Config.prepend(Cacheflow::Sidekiq::InstanceMethods)
::Sidekiq::Client.prepend(Cacheflow::Sidekiq::Client::InstanceMethods)
