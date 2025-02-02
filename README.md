# TokenTrim

TokenTrim is a Ruby gem that provides intelligent text chunking and relevance scoring using Claude/Anthropic's AI models. It features smart boundary detection, configurable overlap, and optional parallel processing for paid users.

## Features

### Core Features (MIT Licensed)

-   Smart text chunking with natural boundary detection
-   Configurable chunk size and overlap
-   Relevance scoring using Claude/Anthropic
-   BYOK (Bring Your Own Key) model

### Commercial Features (Commercial License)

-   Parallel processing for faster results
-   Priority support
-   Additional features coming soon

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tokentrim'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install tokentrim
```

## Usage

First, configure TokenTrim with your Anthropic API key:

```ruby
Tokentrim.configure do |config|
  config.api_key = "your_anthropic_api_key"
  config.max_tokens = 1000  # optional, default: 1000
  config.overlap_size = 100 # optional, default: 100
end
```

Then use it to process text:

```ruby
# Example text about space exploration
text = "NASA's Artemis program aims to land the first woman and next man on the Moon by 2024. " \
       "This ambitious goal will establish sustainable lunar exploration by 2028. " \
       "SpaceX, led by Elon Musk, focuses on developing reusable rockets and spacecraft. " \
       "Their Starship project aims to enable human missions to Mars. " \
       "Blue Origin, founded by Jeff Bezos, is developing the New Glenn rocket " \
       "and the Blue Moon lunar lander for future space missions."

# Query about Mars missions
results = Tokentrim.process(text, "Tell me about Mars missions")
puts "Results for Mars-related content:"
results.each do |result|
  puts "\nChunk: #{result[:chunk]}"
  puts "Relevance Score: #{result[:score]}/100"
  puts "---"
end

# Query about Moon missions
results = Tokentrim.process(text, "What are the plans for Moon exploration?")
puts "\nResults for Moon-related content:"
results.each do |result|
  puts "\nChunk: #{result[:chunk]}"
  puts "Relevance Score: #{result[:score]}/100"
  puts "---"
end
```

Example output:

```
Results for Mars-related content:
Chunk: "SpaceX, led by Elon Musk, focuses on developing reusable rockets and spacecraft. Their Starship project aims to enable human missions to Mars."
Relevance Score: 95/100
---
Chunk: "Blue Origin, founded by Jeff Bezos, is developing the New Glenn rocket and the Blue Moon lunar lander for future space missions."
Relevance Score: 35/100
---
Chunk: "NASA's Artemis program aims to land the first woman and next man on the Moon by 2024. This ambitious goal will establish sustainable lunar exploration by 2028."
Relevance Score: 15/100

Results for Moon-related content:
Chunk: "NASA's Artemis program aims to land the first woman and next man on the Moon by 2024. This ambitious goal will establish sustainable lunar exploration by 2028."
Relevance Score: 90/100
---
Chunk: "Blue Origin, founded by Jeff Bezos, is developing the New Glenn rocket and the Blue Moon lunar lander for future space missions."
Relevance Score: 75/100
---
Chunk: "SpaceX, led by Elon Musk, focuses on developing reusable rockets and spacecraft. Their Starship project aims to enable human missions to Mars."
Relevance Score: 20/100
```

### Commercial Features

To use commercial features like parallel processing, you'll need a commercial license. Visit https://tokentrim.com to purchase a license.

Once you have a license:

```ruby
Tokentrim.configure do |config|
  config.api_key = "your_anthropic_api_key"
  config.license_key = "your_commercial_license_key" # Required for commercial features
  config.parallel = true # Now enabled with valid license
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/robert10997/tokentrim.

## License

TokenTrim uses a dual-license model:

-   Core features are available under the MIT License
-   Commercial features require a paid license from https://tokentrim.com

For more details, see the [LICENSE](LICENSE) file and [Commercial License Terms](https://tokentrim.com/license).
