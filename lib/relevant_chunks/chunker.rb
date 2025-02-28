# frozen_string_literal: true

require "logger"

module RelevantChunks
  # Handles text chunking with smart boundary detection and configurable overlap
  #
  # The Chunker class splits text into chunks while trying to maintain natural
  # boundaries like sentence endings and paragraphs. It also supports overlapping
  # chunks to ensure context is maintained across chunk boundaries.
  #
  # @example
  #   chunker = RelevantChunks::Chunker.new(max_tokens: 1000, overlap_size: 100)
  #   chunks = chunker.chunk_text("Your long text here...")
  class Chunker
    class << self
      attr_accessor :configuration
    end

    # @return [Integer] Size of overlap between chunks
    attr_reader :overlap_size

    # @return [Integer] Maximum number of tokens per chunk
    attr_reader :max_tokens

    # Initialize a new Chunker instance
    #
    # @param max_tokens [Integer] Maximum number of tokens per chunk
    # @param overlap_size [Integer] Number of tokens to overlap between chunks
    # @return [Chunker]
    def initialize(max_tokens: 1000, overlap_size: 100)
      @max_tokens = max_tokens
      @overlap_size = overlap_size
      @logger = Logger.new($stdout)
    end

    # Split text into chunks with smart boundary detection
    #
    # @param text [String] The text to split into chunks
    # @return [Array<String>] Array of text chunks
    # @example
    #   chunker = RelevantChunks::Chunker.new
    #   chunks = chunker.chunk_text("First sentence. Second sentence.")
    def chunk_text(text)
      @logger.info "Starting chunk_text with text length: #{text.length}"
      return [text] if text.length <= max_tokens

      chunks = []
      current_position = 0

      while current_position < text.length
        chunk_end = find_chunk_boundary(text, current_position)
        add_chunk(text, current_position, chunk_end, chunks)

        # If we've reached the end, break
        break if chunk_end >= text.length - 1

        # Calculate next position with overlap
        next_position = calculate_next_position(current_position, chunk_end)
        break if should_stop_chunking?(next_position, current_position, text)

        current_position = next_position
        @logger.info "Moving to position: #{current_position}"
      end

      @logger.info "Final chunks: #{chunks.inspect}"
      chunks
    end

    private

    def add_chunk(text, start_pos, end_pos, chunks)
      @logger.info "Found chunk boundary at position #{end_pos}"
      chunk = text[start_pos..end_pos]
      @logger.info "Created chunk: #{chunk.inspect}"
      chunks << chunk
    end

    def calculate_next_position(current_pos, chunk_end)
      next_pos = [chunk_end - overlap_size + 1, current_pos + 1].max
      @logger.info "Next position would be: #{next_pos}"
      next_pos
    end

    def should_stop_chunking?(next_pos, current_pos, text)
      remaining_length = text.length - next_pos
      if next_pos <= current_pos || remaining_length <= overlap_size
        add_final_chunk(text, next_pos) if remaining_length.positive?
        true
      else
        false
      end
    end

    def add_final_chunk(text, start_pos)
      final_chunk = text[start_pos..]
      @logger.info "Adding final chunk: #{final_chunk.inspect}"
      final_chunk
    end

    def find_chunk_boundary(text, start_position)
      target_end = start_position + max_tokens
      @logger.info "Target end position: #{target_end}"

      return handle_text_end(text) if target_end >= text.length

      # Look for natural boundaries
      boundary = find_natural_boundary(text, start_position, target_end)
      return boundary if boundary

      # If no natural boundary found, break at the last space
      boundary = find_space_boundary(text, start_position, target_end)
      return boundary if boundary

      target_end
    end

    def handle_text_end(text)
      @logger.info "Target end exceeds text length, returning #{text.length - 1}"
      text.length - 1
    end

    def find_natural_boundary(text, start_pos, target_end)
      search_start = [target_end - 30, start_pos].max
      @logger.info "Looking for natural boundaries between #{search_start} and #{target_end}"

      target_end.downto(search_start) do |i|
        break if i >= text.length || i + 1 >= text.length

        if natural_boundary?(text, i)
          @logger.info "Found natural boundary at #{i}"
          return i
        end
      end
      nil
    end

    def natural_boundary?(text, pos)
      return false if pos + 1 >= text.length

      char = text[pos]
      next_char = text[pos + 1]
      @logger.info "Checking position #{pos}: char='#{char}', next_char='#{next_char}'"

      (char == "." && next_char == " ") ||
        (char == "?" && next_char == " ") ||
        (char == "!" && next_char == " ") ||
        (char == "\n" && next_char == "\n")
    end

    def find_space_boundary(text, start_pos, target_end)
      search_text = text[start_pos..target_end]
      @logger.info "Looking for last space in: #{search_text.inspect}"
      last_space = search_text.rindex(" ")
      return unless last_space

      @logger.info "Found last space at offset #{last_space}"
      start_pos + last_space
    end
  end
end
