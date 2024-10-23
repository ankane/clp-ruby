require_relative "lib/clp/version"

Gem::Specification.new do |spec|
  spec.name          = "clp"
  spec.version       = Clp::VERSION
  spec.summary       = "Linear programming solver for Ruby"
  spec.homepage      = "https://github.com/ankane/clp-ruby"
  spec.license       = "EPL-2.0"

  spec.author        = "Andrew Kane"
  spec.email         = "andrew@ankane.org"

  spec.files         = Dir["*.{md,txt}", "{lib}/**/*"]
  spec.require_path  = "lib"

  spec.required_ruby_version = ">= 3.1"

  spec.add_dependency "fiddle"
end
