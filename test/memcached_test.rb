require_relative "test_helper"

class MemcachedTest < Minitest::Test
  def test_colors
    client = Dalli::Client.new
    client.set("hello", "world")
    client.get("hello")

    Cacheflow.silence do
      client.get("silence")
    end
  end
end
