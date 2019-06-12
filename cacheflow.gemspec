require_relative "lib/cacheflow/version"

Gem::Specification.new do |spec|
  spec.name          = "cacheflow"
  spec.version       = Cacheflow::VERSION
  spec.summary       = "Colorized logging for Memcached and Redis"
  spec.homepage      = "https://github.com/ankane/cacheflow"
  spec.license       = "MIT"

  spec.author        = "Andrew Kane"
  spec.email         = "andrew@chartkick.com"

  spec.files         = Dir["*.{md,txt}", "{lib}/**/*"]
  spec.require_path  = "lib"

  spec.required_ruby_version = ">= 2.4"

  spec.add_dependency "activesupport", ">= 5"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "dalli"
  spec.add_development_dependency "redis"
end
