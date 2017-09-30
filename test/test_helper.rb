require "bundler/setup"
require "dalli"
require "redis"
Bundler.require(:default)
require "minitest/autorun"
require "minitest/pride"

ActiveSupport::LogSubscriber.logger = ActiveSupport::Logger.new(STDOUT)
