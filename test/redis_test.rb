require_relative "test_helper"

class RedisTest < Minitest::Test
  def test_colors
    client = Redis.new
    client.set("hello", "world")
    client.get("hello")

    client.multi do
      client.set "foo", "bar"
      client.incr "baz"
    end
  end
end
