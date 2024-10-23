require "bundler/setup"
require "dalli"
require "redis"
require "active_support/all"
Bundler.require(:default)
require "minitest/autorun"
require "minitest/pride"

$io = StringIO.new("")
ActiveSupport::LogSubscriber.logger = ActiveSupport::Logger.new($io)

$events = Hash.new(0)
ActiveSupport::Notifications.subscribe(/memcached|redis/) do |name, _start, _finish, _id, _payload|
  $events[name] += 1
end

if ActiveSupport::VERSION::MAJOR >= 7 && ActiveSupport::VERSION::STRING.to_f != 7.2
  ActiveSupport.cache_format_version = ActiveSupport::VERSION::STRING.to_f
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

  def assert_events(expected)
    assert_equal expected, $events
  end

  def assert_commands(commands)
    commands.each do |command|
      assert_match command, $io.string
    end
  end

  def assert_silence
    yield
    assert_equal "", $io.string
  end
end
