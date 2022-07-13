require_relative "test_helper"

class RedisTest < Minitest::Test
  def test_set_get
    client.set("hello", "world")
    client.get("hello")

    expected = {"query.redis" => 2}
    assert_equal expected, $events
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
  end

  def test_silence
    assert_silent do
      Cacheflow.silence do
        client.get("silence")
      end
    end
  end

  def client
    @client ||= Redis.new
  end
end
