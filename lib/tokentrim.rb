# frozen_string_literal: true

require_relative "tokentrim/version"
require_relative "tokentrim/chunker"
require_relative "tokentrim/processor"
require "net/http"
require "json"

# TokenTrim provides intelligent text chunking and relevance scoring using Claude/Anthropic.
# Core features are available under MIT license, while commercial features require a paid license.
#
# @example Basic usage
#   Tokentrim.configure do |config|
#     config.api_key = "your_anthropic_api_key"
#   end
#
#   results = Tokentrim.process("Your text here", "Your query")
#
# @example Using commercial features
#   Tokentrim.configure do |config|
#     config.api_key = "your_anthropic_api_key"
#     config.license_key = "your_license_key"
#     config.parallel = true
#   end
module Tokentrim
  # Base error class for TokenTrim
  class Error < StandardError; end

  # Raised when license validation fails
  class LicenseError < Error; end

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
    attr_accessor :api_key, :max_tokens, :overlap_size, :parallel, :license_key

    # Initialize a new Configuration instance
    #
    # @return [Configuration]
    def initialize
      @max_tokens = 1000
      @overlap_size = 100
      @parallel = false
    end
  end

  # Process text with the given query
  #
  # @param text [String] The text to process
  # @param query [String] The query to score chunks against
  # @return [Array<Hash>] Array of chunks with relevance scores
  # @raise [Error] If API key is not configured
  # @raise [LicenseError] If using commercial features without a valid license
  # @example
  #   results = Tokentrim.process("Long text here", "What is this about?")
  #   results.each do |result|
  #     puts "Chunk: #{result[:chunk]}"
  #     puts "Score: #{result[:score]}"
  #   end
  def self.process(text, query)
    raise Error, "API key not configured" unless configuration&.api_key

    validate_license! if using_commercial_features?

    processor = Processor.new(
      api_key: configuration.api_key,
      max_tokens: configuration.max_tokens,
      overlap_size: configuration.overlap_size,
      parallel: configuration.parallel
    )

    processor.process(text, query)
  end

  # Check if commercial features are being used
  #
  # @return [Boolean]
  def self.using_commercial_features?
    configuration.parallel
  end

  # Validate the license key for commercial features
  #
  # @raise [LicenseError] If license validation fails
  def self.validate_license!
    return unless using_commercial_features?
    raise LicenseError, "License key required for commercial features" unless configuration.license_key

    begin
      uri = URI("https://tokentrim.com/api/v1/validate_license")
      response = Net::HTTP.post(
        uri,
        { license_key: configuration.license_key }.to_json,
        "Content-Type" => "application/json"
      )

      raise LicenseError, "Invalid or expired license key" unless response.is_a?(Net::HTTPSuccess)
    rescue StandardError => e
      raise LicenseError, "License validation failed: #{e.message}"
    end
  end
end
