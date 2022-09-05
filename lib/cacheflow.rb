# dependencies
require "active_support"

# modules
require "cacheflow/version"

module Cacheflow
  def self.activate
    require "cacheflow/memcached" if defined?(Dalli)
    require "cacheflow/redis" if defined?(Redis) || defined?(RedisClient)
  end

  def self.silenced?
    Thread.current[:cacheflow_silenced]
  end

  def self.silence
    previous_value = silenced?
    begin
      Thread.current[:cacheflow_silenced] = true
      yield
    ensure
      Thread.current[:cacheflow_silenced] = previous_value
    end
  end

  def self.silence_sidekiq!
    ::Sidekiq.singleton_class.prepend(Cacheflow::Sidekiq::ClassMethods)
    ::Sidekiq::Client.prepend(Cacheflow::Sidekiq::Client::InstanceMethods)
  end

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

if defined?(Rails)
  require "cacheflow/railtie"
else
  Cacheflow.activate
end
