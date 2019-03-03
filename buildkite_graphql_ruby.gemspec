
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "buildkite_graphql_ruby/version"
require "buildkite_graphql_ruby"

Gem::Specification.new do |spec|
  spec.name          = "buildkite_graphql_ruby"
  spec.version       = BuildkiteGraphqlRuby::VERSION
  spec.authors       = ["Alex Evanczuk"]
  spec.email         = ["alexevanczuk@gmail.com"]

  spec.summary       = "Wrapper for buildkite graphql library"
  # spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"

  spec.files         = Dir.glob("{bin,lib}/**/*")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency 'pry-stack_explorer', '~> 0.4.9.3'
  spec.add_runtime_dependency "rainbow"
end
