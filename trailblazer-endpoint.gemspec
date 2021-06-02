# frozen_string_literal: true

require_relative "lib/trailblazer/endpoint/version"

Gem::Specification.new do |spec|
  spec.name          = "trailblazer-endpoint"
  spec.version       = Trailblazer::Endpoint::VERSION
  spec.authors       = ["Yogesh Khater"]
  spec.email         = ["yogeshjain999@gmail.com"]

  spec.summary       = "Endpoints for activities"
  spec.description   = "Define endpoints in controller to run activities"
  spec.homepage      = "https://github.com/trailblazer/endpoint"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/trailblazer/endpoint"
  spec.metadata["changelog_uri"] = "https://github.com/trailblazer/endpoint"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "trailblazer-activity-dsl-linear", "~> 0.4"
  spec.add_dependency "trailblazer-context", ">= 0.4.0", "< 1.0.0"

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "trailblazer", "~> 2.1"
  spec.add_development_dependency "dry-validation", "~> 1.6"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rack-test", "~> 1.1"
end
