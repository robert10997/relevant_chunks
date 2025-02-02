# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2024-02-02

### Added

-   Initial release
-   Smart text chunking with natural boundary detection
-   Configurable chunk size and overlap
-   Relevance scoring using Claude/Anthropic API
-   Parallel processing support (commercial feature)
-   Advanced configuration options:
    -   Model selection (claude-3-5-sonnet-latest)
    -   Temperature control (0.0-1.0)
    -   Custom system prompts
    -   Configurable scoring range (default 0-100)
-   Comprehensive documentation and examples
-   CLI tool for command-line usage
-   MIT license for core features
-   Commercial license option for parallel processing

### Changed

-   N/A (initial release)

### Deprecated

-   N/A (initial release)

### Removed

-   N/A (initial release)

### Fixed

-   N/A (initial release)

### Security

-   Secure API key handling
-   No key storage in code
