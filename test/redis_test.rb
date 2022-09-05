require_relative "test_helper"

class RedisTest < Minitest::Test
  def test_set_get
    client.set("hello", "world")
    client.get("hello")

    assert_events({"query.redis" => 2})
    assert_commands ["SET hello world", "GET hello"]
  end

  def test_multi
    if Redis::VERSION.to_f >= 4.6
      client.multi do |pipeline|
        pipeline.set "foo", "bar"
        pipeline.incr "baz"
      end
    else
      client.multi do
        client.set "foo", "bar"
        client.incr "baz"
      end
    end

    assert_events({"query.redis" => 1})
    assert_commands ["MULTI >> SET foo bar >> INCR baz >> EXEC"]
  end

  def test_redis_client
    skip unless defined?(RedisClient)

    redis = RedisClient.new
    redis.call("SET", "hello", "world")
    redis.call("GET", "hello")

    assert_events({"query.redis" => 3})
    assert_commands ["HELLO 3", "SET hello world", "GET hello"]
  end

  def test_silence
    assert_silence do
      Cacheflow.silence do
        client.get("silence")
      end
    end
  end

  def client
    @client ||= Redis.new
  end
end
