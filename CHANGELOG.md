# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.3.0] - 2025-02-27

### Changed

-   Renamed gem from `relevantchunks` to `relevant_chunks` to follow Ruby conventions
-   Updated all file paths and references to use snake_case
-   Enhanced consistency across codebase

## [0.2.0] - 2025-02-02

### Changed

-   Renamed project from TokenTrim to RelevantChunks
-   Updated all module references and documentation
-   Renamed executable from `tokentrim` to `relevant_chunks`

## [0.1.2] - 2025-02-02

### Fixed

-   Updated gem description to remove references to commercial features

## [0.1.1] - 2025-02-02

### Changed

-   Simplified gem by removing parallelization and paid features
-   Improved code readability with heredoc strings
-   Updated documentation to reflect MIT-only license

## [0.1.0] - 2025-02-02

### Added

-   Initial release
-   Smart text chunking with natural boundary detection
-   Configurable chunk size and overlap
-   Relevance scoring using Claude/Anthropic API
-   Advanced configuration options:
    -   Model selection (claude-3-5-sonnet-latest)
    -   Temperature control (0.0-1.0)
    -   Custom system prompts
    -   Configurable scoring range (default 0-100)
-   Comprehensive documentation and examples
-   CLI tool for command-line usage

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
