module Cacheflow
  module Sidekiq
    module ClassMethods
      def redis(*_)
        Cacheflow.silence do
          super
        end
      end
    end

    module Client
      module InstanceMethods
        def push(*_)
          Cacheflow.silence do
            super
          end
        end
      end
    end
  end
end

::Sidekiq.singleton_class.prepend(Cacheflow::Sidekiq::ClassMethods)
::Sidekiq::Client.prepend(Cacheflow::Sidekiq::Client::InstanceMethods)
