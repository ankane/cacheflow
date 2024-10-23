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
    args.map { |v| binary?(v) ? "<binary-data>" : v }.join(" ")
  end

  # private
  def self.binary?(v)
    v = v.to_s
    # string encoding creates false positives, so try to determine based on value
    v.include?("\x00") || !v.dup.force_encoding(Encoding::UTF_8).valid_encoding?
  end
end

if defined?(Rails)
  require_relative "cacheflow/railtie"
else
  Cacheflow.activate
end
