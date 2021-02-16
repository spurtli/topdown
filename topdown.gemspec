# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "topdown/version"

Gem::Specification.new do |spec|
  spec.name = "topdown"
  spec.version = Topdown::VERSION
  spec.authors = ["Hannes Moser"]
  spec.email = ["box@hannesmoser.at"]

  spec.summary = %q{Service objects and pipelines for Ruby}
  spec.description = %q{Service objects and pipelines for Ruby}
  spec.homepage = "https://www.spurtli.com"

  spec.required_ruby_version = ">= 2.5.0"

  spec.license = "MIT"

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) {|f| File.basename(f)}
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.2.10"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
