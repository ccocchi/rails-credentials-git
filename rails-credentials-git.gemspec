# frozen_string_literal: true

require_relative "lib/rails-credentials-git/version"

Gem::Specification.new do |spec|
  spec.name          = "rails-credentials-git"
  spec.version       = RailsCredentialsGit::VERSION
  spec.authors       = ["ccocchi"]
  spec.email         = ["cocchi.c@gmail.com"]

  spec.summary       = "Fastest way to diff your Rails credentials files in git"
  spec.description   = "Fastest way to diff your Rails credentials files in git"
  spec.homepage      = "https://github.com/ccocchi/rails-credentials-git"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = ["rails_credentials_git"]
  spec.require_paths = ["lib"]

  spec.add_dependency "thor", "> 0.19", "< 2"

  spec.add_development_dependency "bundler", "~> 2.2.5"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "activesupport", ">= 5.2", "< 7"
end
