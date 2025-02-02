# frozen_string_literal: true

require_relative "lib/tokentrim/version"

Gem::Specification.new do |spec|
  spec.name = "tokentrim"
  spec.version = Tokentrim::VERSION
  spec.authors = ["Robert Lucy"]
  spec.email = ["robertlucy@gmail.com"]

  spec.summary = "Smart text chunking and relevance scoring using Claude/Anthropic"
  spec.description = "TokenTrim provides intelligent text chunking with smart boundaries and overlap, plus relevance scoring using Claude/Anthropic's AI models. Core features are MIT licensed, with additional commercial features available under a separate license. Visit https://tokentrim.com for licensing details."
  spec.homepage = "https://github.com/robert10997/tokentrim"
  spec.required_ruby_version = ">= 3.0.0"
  spec.license = "MIT" # Core features only, commercial features require separate license

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/robertlucy/tokentrim"
  spec.metadata["changelog_uri"] = "https://github.com/robertlucy/tokentrim/blob/main/CHANGELOG.md"
  spec.metadata["license_uri"] = "https://tokentrim.com/license"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", "~> 2.9"
  spec.add_dependency "parallel", "~> 1.24"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
