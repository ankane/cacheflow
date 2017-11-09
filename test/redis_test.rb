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

    Cacheflow.silence do
      client.get("silence")
    end
  end
end
