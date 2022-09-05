require_relative "test_helper"

class RedisTest < Minitest::Test
  def test_set_get
    client.set("hello", "world")
    client.get("hello")

    expected = {"query.redis" => 2}
    assert_equal expected, $events

    assert_match "SET hello world", $io.string
    assert_match "GET hello", $io.string
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

    expected = {"query.redis" => 1}
    assert_equal expected, $events

    assert_match "MULTI >> SET foo bar >> INCR baz >> EXEC", $io.string
  end

  def test_redis_client
    skip unless defined?(RedisClient)

    redis = RedisClient.new
    redis.call("SET", "hello", "world")
    redis.call("GET", "hello")

    # HELLO call
    expected = {"query.redis" => 3}
    assert_equal expected, $events

    assert_match "HELLO 3", $io.string
    assert_match "SET hello world", $io.string
    assert_match "GET hello", $io.string
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
