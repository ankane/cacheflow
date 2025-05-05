require_relative "lib/cacheflow/version"

Gem::Specification.new do |spec|
  spec.name          = "cacheflow"
  spec.version       = Cacheflow::VERSION
  spec.summary       = "Colorized logging for Memcached, Redis, and Valkey"
  spec.homepage      = "https://github.com/ankane/cacheflow"
  spec.license       = "MIT"

  spec.author        = "Andrew Kane"
  spec.email         = "andrew@ankane.org"

  spec.files         = Dir["*.{md,txt}", "{lib}/**/*"]
  spec.require_path  = "lib"

  spec.required_ruby_version = ">= 3.2"

  spec.add_dependency "activesupport", ">= 7.1"
end
