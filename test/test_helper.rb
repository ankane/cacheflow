require "bundler/setup"
require "dalli"
require "redis"
Bundler.require(:default)
require "minitest/autorun"
require "minitest/pride"

ActiveSupport::LogSubscriber.logger = ActiveSupport::Logger.new(STDOUT)

$events = Hash.new(0)
ActiveSupport::Notifications.subscribe(/memcached|redis/) do |name, _start, _finish, _id, _payload|
  $events[name] += 1
end

class Minitest::Test
  def setup
    $events.clear
  end
end
