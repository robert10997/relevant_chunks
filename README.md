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
# Example text about the solar system
text = "The solar system consists of the Sun and everything that orbits around it. " \
       "Earth is the third planet from the Sun and the only known planet to harbor life. " \
       "It has a protective atmosphere and liquid water on its surface. " \
       "Mars, often called the Red Planet, has evidence of ancient water flows and organic molecules. " \
       "Scientists believe Mars once had conditions suitable for microbial life. " \
       "Venus, despite being similar in size to Earth, has a runaway greenhouse effect " \
       "making its surface hot enough to melt lead."

# Query about potentially habitable planets
results = Tokentrim.process(text, "Which planets could support life?")
puts "Results for habitability-related content:"
results.each do |result|
  puts "\nChunk: #{result[:chunk]}"
  puts "Relevance Score: #{result[:score]}/100"
  puts "---"
end
```

Example output:

```
Results for habitability-related content:
Chunk: "Earth is the third planet from the Sun and the only known planet to harbor life. It has a protective atmosphere and liquid water on its surface."
Relevance Score: 95/100
---
Chunk: "Mars, often called the Red Planet, has evidence of ancient water flows and organic molecules. Scientists believe Mars once had conditions suitable for microbial life."
Relevance Score: 85/100
---
Chunk: "Venus, despite being similar in size to Earth, has a runaway greenhouse effect making its surface hot enough to melt lead."
Relevance Score: 60/100
---
Chunk: "The solar system consists of the Sun and everything that orbits around it."
Relevance Score: 10/100
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
