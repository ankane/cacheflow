require "bundler/setup"
require "dalli"
require "redis"
Bundler.require(:default)
require "minitest/autorun"
require "minitest/pride"

$io = StringIO.new("")
ActiveSupport::LogSubscriber.logger = ActiveSupport::Logger.new($io)

$events = Hash.new(0)
ActiveSupport::Notifications.subscribe(/memcached|redis/) do |name, _start, _finish, _id, _payload|
  $events[name] += 1
end

class Minitest::Test
  def setup
    $events.clear
    $io.truncate(0)
  end

  def teardown
    if ENV["VERBOSE"]
      puts "#{self.class.name}##{name}"
      print $io.string
    end
  end

  def assert_silence
    yield
    assert_equal "", $io.string
  end
end
