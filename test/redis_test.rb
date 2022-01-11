require_relative "test_helper"

class RedisTest < Minitest::Test
  def test_set_get
    client.set("hello", "world")
    client.get("hello")

    expected = {"query.redis" => 2}
    assert_equal expected, $events
  end

  def test_multi
    client.multi do
      client.set "foo", "bar"
      client.incr "baz"
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
