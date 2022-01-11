require_relative "test_helper"

class MemcachedTest < Minitest::Test
  def test_set_get
    client.set("hello", "world")
    client.get("hello")

    expected = {"query.memcached" => 2}
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
    @client ||= Dalli::Client.new
  end
end
