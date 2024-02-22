# dependencies
require "active_support"

# modules
require_relative "cacheflow/version"

module Cacheflow
  def self.activate
    require_relative "cacheflow/memcached" if defined?(Dalli)
    require_relative "cacheflow/redis" if defined?(Redis) || defined?(RedisClient)
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
    require_relative "cacheflow/sidekiq"
  end

  # private
  def self.args(args)
    args.map { |v| v.to_s.dup.force_encoding("UTF-8").valid_encoding? ? v : "<binary-data>" }.join(" ")
  end
end

if defined?(Rails)
  require_relative "cacheflow/railtie"
else
  Cacheflow.activate
end
