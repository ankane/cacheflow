require "active_support"
require "cacheflow/version"

module Cacheflow
  def self.activate
    require "cacheflow/memcached" if defined?(Dalli)
    require "cacheflow/redis" if defined?(Redis)
  end
end

if defined?(Rails)
  require "cacheflow/railtie"
else
  Cacheflow.activate
end
