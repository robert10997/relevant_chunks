# frozen_string_literal: true

require "faraday"
require "json"

module Tokentrim
  # Handles text processing and relevance scoring using Claude/Anthropic
  #
  # The Processor class manages the chunking and scoring of text using the Anthropic API.
  #
  # @example Basic usage
  #   processor = Tokentrim::Processor.new(api_key: "your_key")
  #   results = processor.process("Long text here", "What is this about?")
  #
  # @example Advanced configuration
  #   processor = Tokentrim::Processor.new(
  #     api_key: "your_key",
  #     model: "claude-3-5-sonnet-latest",  # Use a different model variant
  #     temperature: 0.1,                 # Add slight variation to scores
  #     system_prompt: "Custom scoring system prompt...",
  #     max_score: 10                     # Use 0-10 scoring range
  #   )
  #
  # @example Scoring text relevance with different queries
  #   processor = Tokentrim::Processor.new(api_key: "your_key")
  #   text = "The solar system consists of the Sun and everything that orbits around it. " \
  #          "This includes eight planets, numerous moons, asteroids, comets, and other celestial objects. " \
  #          "Earth is the third planet from the Sun and the only known planet to harbor life. " \
  #          "Mars, often called the Red Planet, has been the subject of numerous exploration missions."
  #
  #   # Query about Mars
  #   results = processor.process(text, "Tell me about Mars")
  #   # Returns chunks with scores like:
  #   # - "Mars, often called the Red Planet..." (Score: 60)
  #   # - "...numerous exploration missions." (Score: 35)
  #   # - General solar system info (Score: 15)
  #
  #   # Query about life on planets
  #   results = processor.process(text, "What planets are known to have life?")
  #   # Returns chunks with scores like:
  #   # - "Earth is the third planet...only known planet to harbor life" (Score: 65)
  #   # - Chunks mentioning planets (Score: 35)
  #   # - Other chunks (Score: 5-15)
  class Processor
    class << self
      attr_accessor :configuration
    end

    # @return [String] Anthropic API key
    attr_reader :api_key

    # @return [Chunker] Text chunker instance
    attr_reader :chunker

    # @return [String] Claude model to use
    attr_reader :model

    # @return [Float] Temperature for scoring (0.0-1.0)
    attr_reader :temperature

    # @return [String] System prompt for scoring
    attr_reader :system_prompt

    # @return [Integer] Maximum score in the scoring range
    attr_reader :max_score

    # Initialize a new Processor instance
    #
    # @param api_key [String] Anthropic API key
    # @param max_tokens [Integer] Maximum tokens per chunk
    # @param overlap_size [Integer] Overlap size between chunks
    # @param model [String] Claude model to use (default: "claude-3-5-sonnet-latest")
    # @param temperature [Float] Temperature for scoring (0.0-1.0, default: 0.0)
    # @param system_prompt [String, nil] Custom system prompt for scoring (default: nil)
    # @param max_score [Integer] Maximum score in range (default: 100)
    # @return [Processor]
    def initialize(api_key:, max_tokens: 1000, overlap_size: 100,
                   model: "claude-3-5-sonnet-latest", temperature: 0.0,
                   system_prompt: nil, max_score: 100)
      @api_key = api_key
      @chunker = Chunker.new(max_tokens: max_tokens, overlap_size: overlap_size)
      @model = model
      @temperature = temperature
      @max_score = max_score
      @system_prompt = system_prompt || default_system_prompt
      @conn = Faraday.new(url: "https://api.anthropic.com") do |f|
        f.request :json
        f.response :json
        f.adapter :net_http
        f.headers = {
          "accept" => "application/json",
          "anthropic-version" => "2023-06-01",
          "content-type" => "application/json",
          "x-api-key" => api_key
        }
      end
    end

    # Process text and score chunks against a query
    #
    # @param text [String] The text to process
    # @param query [String] The query to score chunks against
    # @return [Array<Hash>] Array of chunks with their scores and API responses. Each hash contains:
    #   - :chunk [String] The text chunk that was scored
    #   - :score [Integer] The relevance score (0-100)
    #   - :response [Hash] The complete raw response from the Anthropic API
    # @example
    #   processor = Tokentrim::Processor.new(api_key: "your_key")
    #   results = processor.process("Long text here", "What is this about?")
    #   results.each do |result|
    #     puts "Chunk: #{result[:chunk]}"
    #     puts "Score: #{result[:score]}"
    #     puts "Raw response: #{result[:response].inspect}"
    #   end
    def process(text, query)
      chunks = chunker.chunk_text(text)
      chunks.map { |chunk| score_chunk(chunk, query) }
    end

    private

    # Score a single chunk against the query
    #
    # @param chunk [String] Text chunk to score
    # @param query [String] Query to score against
    # @return [Hash] Chunk with score and response
    def score_chunk(chunk, query)
      response = @conn.post("/v1/messages") do |req|
        req.body = {
          model: model,
          temperature: temperature,
          system: system_prompt,
          messages: [
            {
              role: "user",
              content: "Text chunk to evaluate: #{chunk}\n\nQuery: #{query}\n\nPlease output only a number from 0-#{max_score} indicating how relevant this text chunk is to the query."
            }
          ]
        }
      end

      # Parse the response body if it's a string
      body = response.body.is_a?(String) ? JSON.parse(response.body) : response.body
      score = body.dig("content", 0, "text").to_i
      { chunk: chunk, score: score, response: body }
    end

    # Default system prompt for scoring
    #
    # @return [String]
    def default_system_prompt
      "You are a text relevance scoring system. Your task is to evaluate how relevant a given text chunk is to a query. " \
        "Score on a scale of 0-#{max_score}, where 0 means completely irrelevant and #{max_score} means highly relevant. " \
        "Consider semantic meaning, not just keyword matching. Output only the numeric score."
    end
  end
end
