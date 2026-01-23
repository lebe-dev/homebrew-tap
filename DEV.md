# Development Guide

This document contains information for developers working on formulas in this tap.

## Prerequisites

- [Homebrew](https://brew.sh/) installed
- [just](https://github.com/casey/just) command runner (optional, but recommended)

## Project Structure

```
homebrew-tap/
├── Formula/          # Homebrew formula files
│   └── submarine.rb
├── Justfile          # Task runner commands
├── README.md         # User documentation
└── DEV.md           # This file
```

## Development Workflow

### Adding a New Formula

1. Create a new formula file in `Formula/` directory:
   ```bash
   brew create https://github.com/user/project/releases/download/VERSION/file.zip \
     --tap lebe-dev/tap \
     --set-name project-name
   ```

2. Edit the generated formula file in `Formula/`

3. Audit the formula:
   ```bash
   just audit
   # or
   HOMEBREW_NO_INSTALL_FROM_API=1 brew audit --new lebe-dev/tap/formula-name
   ```

4. Test installation:
   ```bash
   just install
   # or
   HOMEBREW_NO_INSTALL_FROM_API=1 brew install --build-from-source --verbose lebe-dev/tap/formula-name
   ```

5. Run formula tests:
   ```bash
   just test
   # or
   HOMEBREW_NO_INSTALL_FROM_API=1 brew test lebe-dev/tap/formula-name
   ```

### Available Just Commands

The `Justfile` provides convenient commands for development:

- `just audit` - Audit the submarine formula
- `just install` - Install submarine formula locally for testing
- `just test` - Run formula tests
- `just uninstall` - Uninstall submarine formula
- `just test-all` - Full test cycle: audit, install, test
- `just reinstall` - Clean uninstall and reinstall

### Testing Formulas

Always test your formulas before committing:

1. **Syntax validation**:
   ```bash
   HOMEBREW_NO_INSTALL_FROM_API=1 brew audit --new lebe-dev/tap/formula-name
   ```

2. **Installation test**:
   ```bash
   HOMEBREW_NO_INSTALL_FROM_API=1 brew install --build-from-source --verbose lebe-dev/tap/formula-name
   ```

3. **Formula test**:
   ```bash
   HOMEBREW_NO_INSTALL_FROM_API=1 brew test lebe-dev/tap/formula-name
   ```

4. **Manual functionality test**:
   Test the actual binary/application functionality

5. **Uninstall test**:
   ```bash
   brew uninstall formula-name
   ```

## Formula Guidelines

### Basic Formula Structure

```ruby
class FormulaName < Formula
  desc "Short description of the software"
  homepage "https://project-homepage.com"
  url "https://github.com/user/project/releases/download/VERSION/archive.zip"
  version "X.Y.Z"
  sha256 "checksum-here"
  license "MIT"

  def install
    bin.install "binary-name"
  end

  test do
    assert_match "version X.Y.Z", shell_output("#{bin}/binary-name --version")
  end
end
```

### Best Practices

1. **Naming**: Use simple names without tap prefix (e.g., `submarine.rb`, not `lebe-dev-submarine.rb`)
2. **Class Name**: Match filename in CamelCase (e.g., `Submarine` for `submarine.rb`)
3. **Description**: Keep it concise and clear
4. **Tests**: Always include a test block that verifies the installation
5. **Checksums**: Use SHA256 checksums for all downloads

### Architecture Considerations

For ARM64-only binaries on macOS:
- Use a single `url` and `sha256` declaration
- Intel Macs will automatically use Rosetta 2
- No need for `on_arm` or `on_intel` blocks for URL/SHA256

## CI/CD

The repository includes GitHub Actions workflows:

- **tests.yml** - Runs on every push and PR, tests across multiple platforms
- **publish.yml** - Handles bottle publishing for merged PRs

## Resources

- [Homebrew Formula Cookbook](https://docs.brew.sh/Formula-Cookbook)
- [Homebrew Ruby API](https://rubydoc.brew.sh/Formula)
- [Homebrew Tap Documentation](https://docs.brew.sh/How-to-Create-and-Maintain-a-Tap)
