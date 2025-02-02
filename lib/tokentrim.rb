# frozen_string_literal: true

require_relative "tokentrim/version"
require_relative "tokentrim/chunker"
require_relative "tokentrim/processor"
require "net/http"
require "json"

# TokenTrim provides intelligent text chunking and relevance scoring using Claude/Anthropic.
#
# @example Basic usage
#   Tokentrim.configure do |config|
#     config.api_key = "your_anthropic_api_key"
#   end
#
#   results = Tokentrim.process("Your text here", "Your query")
module Tokentrim
  class Error < StandardError; end

  class << self
    attr_accessor :configuration
  end

  # Configures TokenTrim with the given settings
  #
  # @yield [config] Configuration object
  # @example
  #   Tokentrim.configure do |config|
  #     config.api_key = "your_anthropic_api_key"
  #     config.max_tokens = 1000
  #   end
  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration) if block_given?
  end

  # Configuration class for TokenTrim
  class Configuration
    attr_accessor :api_key, :max_tokens, :overlap_size

    # Initialize a new Configuration instance
    #
    # @return [Configuration]
    def initialize
      @max_tokens = 1000
      @overlap_size = 100
    end
  end

  # Process text with the given query
  #
  # @param text [String] The text to process
  # @param query [String] The query to score chunks against
  # @return [Array<Hash>] Array of chunks with relevance scores
  # @raise [Error] If API key is not configured
  # @example
  #   results = Tokentrim.process("Long text here", "What is this about?")
  #   results.each do |result|
  #     puts "Chunk: #{result[:chunk]}"
  #     puts "Score: #{result[:score]}"
  #   end
  def self.process(text, query)
    raise Error, "API key not configured" unless configuration&.api_key

    processor = Processor.new(
      api_key: configuration.api_key,
      max_tokens: configuration.max_tokens,
      overlap_size: configuration.overlap_size
    )

    processor.process(text, query)
  end
end
