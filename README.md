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
text = "Your long text here..."
query = "What is this text about?"

results = Tokentrim.process(text, query)

results.each do |result|
  puts "Chunk: #{result[:chunk]}"
  puts "Relevance Score: #{result[:score]}"
  puts "---"
end
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
