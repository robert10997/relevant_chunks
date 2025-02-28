# RelevantChunks

RelevantChunks is a Ruby gem that provides intelligent text chunking and relevance scoring using Claude/Anthropic's AI models. It features smart boundary detection and configurable overlap.

## Features

-   Smart text chunking with natural boundary detection
-   Configurable chunk size and overlap
-   Relevance scoring using Claude/Anthropic
-   BYOK (Bring Your Own Key) model

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'relevant_chunks'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install relevant_chunks
```

## Usage

First, configure RelevantChunks with your Anthropic API key:

```ruby
RelevantChunks.configure do |config|
  config.api_key = "your_anthropic_api_key"
  config.max_tokens = 1000  # optional, default: 1000
  config.overlap_size = 100 # optional, default: 100
end
```

Then use it to process text:

```ruby
text = "The solar system consists of the Sun and everything that orbits around it. " \
       "This includes eight planets, numerous moons, asteroids, comets, and other celestial objects. " \
       "Earth is the third planet from the Sun and the only known planet to harbor life. " \
       "Mars, often called the Red Planet, has been the subject of numerous exploration missions."

# Query about Mars
results = RelevantChunks.process(text, "Tell me about Mars")
results.each do |result|
  puts "Chunk: #{result[:chunk]}"
  puts "Score: #{result[:score]}/100"
  puts "---"
end
```

Example output:

```
Chunk: "Mars, often called the Red Planet, has been the subject of numerous exploration missions."
Score: 95/100
---
Chunk: "Earth is the third planet from the Sun and the only known planet to harbor life."
Score: 35/100
---
Chunk: "The solar system consists of the Sun and everything that orbits around it."
Score: 10/100
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/robert10997/relevant_chunks.

## License

The gem is available as open source under the terms of the MIT License.
