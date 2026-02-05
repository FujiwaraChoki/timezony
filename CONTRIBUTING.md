# Contributing to Timezony

First off, thanks for taking the time to contribute!

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check the existing issues to avoid duplicates. When you create a bug report, include as many details as possible:

- **Use a clear and descriptive title**
- **Describe the exact steps to reproduce the problem**
- **Describe the behavior you observed and what you expected**
- **Include your macOS version and Xcode version if building from source**
- **Include screenshots if applicable**

### Suggesting Enhancements

Enhancement suggestions are welcome! Please provide:

- **A clear and descriptive title**
- **A detailed description of the proposed enhancement**
- **Explain why this enhancement would be useful**
- **List any alternatives you've considered**

### Pull Requests

1. Fork the repo and create your branch from `main`
2. Make your changes
3. Ensure your code builds without warnings
4. Test your changes thoroughly
5. Update documentation if needed
6. Submit your pull request

## Development Setup

### Prerequisites

- macOS 14.0 (Sonoma) or later
- Xcode 15.0 or later
- Swift 5.9

### Building

```bash
# Clone the repository
git clone https://github.com/FujiwaraChoki/timezony.git
cd timezony

# Open in Xcode
open Timezony.xcodeproj

# Build and run (Cmd+R in Xcode)
```

### Code Style

- Follow Swift API Design Guidelines
- Use SwiftUI best practices
- Keep views small and focused
- Use meaningful variable and function names
- Add comments for complex logic

## Project Structure

```
Timezony/
├── TimeZonyApp.swift       # Entry point
├── Models/                 # Data models
├── ViewModels/            # Business logic
├── Views/                 # SwiftUI views
└── Utilities/             # Helpers and extensions
```

## Questions?

Feel free to open an issue with your question or reach out to the maintainers.

Thank you for contributing!
