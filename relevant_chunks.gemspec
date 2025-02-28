# frozen_string_literal: true

require_relative "lib/relevant_chunks/version"

Gem::Specification.new do |spec|
  spec.name = "relevant_chunks"
  spec.version = RelevantChunks::VERSION
  spec.authors = ["Robert Lucy"]
  spec.email = ["robertlucy@gmail.com"]

  spec.summary = "Smart text chunking and relevance scoring using Claude/Anthropic"
  spec.description = "RelevantChunks provides intelligent text chunking with smart boundaries and overlap, plus relevance scoring using Claude/Anthropic's AI models."
  spec.homepage = "https://github.com/robert10997/relevant_chunks"
  spec.required_ruby_version = ">= 3.0.0"
  spec.license = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/robert10997/relevant_chunks"
  spec.metadata["changelog_uri"] = "https://github.com/robert10997/relevant_chunks/blob/main/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir[
    'lib/**/*',
    'exe/*',
    'LICENSE',
    'README.md',
    'CHANGELOG.md'
  ]
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", "~> 2.9"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
