# frozen_string_literal: true

require "spec_helper"
require "logger"

RSpec.describe RelevantChunks do
  let(:logger) { Logger.new($stdout) }

  after do
    described_class.configuration = nil
  end

  it "has a version number" do
    logger.info "Testing version number"
    expect(described_class::VERSION).not_to be_nil
  end

  describe RelevantChunks::Chunker do
    subject(:chunker) { described_class.new(max_tokens: 50, overlap_size: 10) }

    let(:text) { "This is a test sentence. Here is another one. And a third sentence for good measure." }
    let(:short_text) { "First sentence. Second sentence. Third sentence." }

    describe "#chunk_text" do
      it "splits text into chunks with overlap" do
        chunks = chunker.chunk_text(text)
        expect(chunks.size).to be > 1
      end

      it "includes the beginning in the first chunk" do
        chunks = chunker.chunk_text(text)
        expect(chunks.first).to include("This is a test sentence")
      end

      it "includes the ending in the last chunk" do
        chunks = chunker.chunk_text(text)
        expect(chunks.last).to include("for good measure")
      end

      it "respects natural boundaries" do
        chunks = chunker.chunk_text(short_text)
        expect(chunks[0..-2]).to all(match(/\A.*[.!?]\s*\z/))
      end
    end
  end
end

RSpec.describe RelevantChunks::Processor do
  subject(:processor) { described_class.new(api_key: api_key, **processor_options) }

  let(:api_key) { "test_key" }
  let(:text) { "This is a test sentence. Here is another one." }
  let(:query) { "What is this about?" }
  let(:response_body) { { content: [{ text: "75" }] }.to_json }
  let(:processor_options) { {} }

  before do
    RelevantChunks.configure do |config|
      config.api_key = api_key
    end

    stub_request(:post, "https://api.anthropic.com/v1/messages")
      .with(
        headers: {
          "Accept" => "application/json",
          "Anthropic-Version" => "2023-06-01",
          "Content-Type" => "application/json",
          "x-api-key" => api_key
        }
      )
      .to_return(
        status: 200,
        body: response_body,
        headers: { "Content-Type" => "application/json" }
      )
  end

  after do
    described_class.configuration = nil
  end

  it "processes text and returns an array" do
    expect(processor.process(text, query)).to be_an(Array)
  end

  it "returns chunks with expected structure" do
    result = processor.process(text, query).first
    expect(result).to include(
      chunk: be_a(String),
      score: be_a(Integer),
      response: be_a(Object)
    )
  end

  describe "configuration options" do
    describe "model selection" do
      let(:processor_options) { { model: "claude-3-5-sonnet-latest" } }

      it "uses the specified model" do
        expect(processor.model).to eq("claude-3-5-sonnet-latest")
      end

      it "includes the model in API requests" do
        stub = stub_request(:post, "https://api.anthropic.com/v1/messages")
               .with(
                 body: hash_including(model: "claude-3-5-sonnet-latest")
               )
               .to_return(status: 200, body: response_body)

        processor.process(text, query)
        expect(stub).to have_been_requested
      end
    end

    describe "temperature control" do
      let(:processor_options) { { temperature: 0.7 } }

      it "uses the specified temperature" do
        expect(processor.temperature).to eq(0.7)
      end

      it "includes the temperature in API requests" do
        stub = stub_request(:post, "https://api.anthropic.com/v1/messages")
               .with(
                 body: hash_including(temperature: 0.7)
               )
               .to_return(status: 200, body: response_body)

        processor.process(text, query)
        expect(stub).to have_been_requested
      end
    end

    describe "system prompt" do
      let(:custom_prompt) { "Custom scoring system prompt" }
      let(:processor_options) { { system_prompt: custom_prompt } }

      it "uses the custom system prompt" do
        expect(processor.system_prompt).to eq(custom_prompt)
      end

      it "includes the custom prompt in API requests" do
        stub = stub_request(:post, "https://api.anthropic.com/v1/messages")
               .with(
                 body: hash_including(system: custom_prompt)
               )
               .to_return(status: 200, body: response_body)

        processor.process(text, query)
        expect(stub).to have_been_requested
      end
    end

    describe "scoring range" do
      let(:processor_options) { { max_score: 10 } }
      let(:response_body) { { content: [{ text: "7" }] }.to_json }

      it "uses the specified maximum score" do
        expect(processor.max_score).to eq(10)
      end

      it "adjusts the system prompt to use the custom range" do
        expect(processor.system_prompt).to include("scale of 0-10")
      end

      it "correctly processes scores in the custom range" do
        result = processor.process(text, query).first
        expect(result[:score]).to be_between(0, 10)
      end
    end
  end
end
