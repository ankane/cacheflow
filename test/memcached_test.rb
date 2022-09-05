require_relative "test_helper"

class MemcachedTest < Minitest::Test
  def test_set_get
    client.set("hello", "world")
    client.get("hello")

    assert_events({"query.memcached" => 2})
    assert_commands ["SET hello world 0 0", "GET hello"]
  end

  def test_silence
    assert_silence do
      Cacheflow.silence do
        client.get("silence")
      end
    end
  end

  def client
    @client ||= Dalli::Client.new
  end
end
