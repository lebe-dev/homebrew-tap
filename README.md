# Lebe-dev Homebrew Tap

Personal Homebrew tap with useful command-line tools and utilities.

## Available Formulas

### Submarine

Tiny toolkit for LLM-powered subtitle translation workflows.

**Installation:**
```bash
brew install lebe-dev/tap/submarine
```

**Features:**
- Get/set subtitles by index
- Diagnose and fix SRT file issues
- Compare and verify subtitle files
- Track translation progress
- Import/export in various formats
- Adjust timestamps with delays
- Mass rename subtitle files

**Usage:**
```bash
sm --help
sm info your-subtitles.srt
sm doctor --fix broken-subtitles.srt
sm verify original.srt translated.srt
```

**Project:** [github.com/lebe-dev/submarine](https://github.com/lebe-dev/submarine)

---

## Installation Methods

### Method 1: Direct Install
```bash
brew install lebe-dev/tap/<formula>
```

### Method 2: Tap First
```bash
brew tap lebe-dev/tap
brew install <formula>
```

### Method 3: Using Brewfile
Add to your `Brewfile`:
```ruby
tap "lebe-dev/tap"
brew "submarine"
```

Then run:
```bash
brew bundle
```

## Updating Formulas

```bash
brew update
brew upgrade lebe-dev/tap/<formula>
```

## Uninstalling

```bash
brew uninstall <formula>
```

To remove the tap completely:
```bash
brew untap lebe-dev/tap
```

## Development

See [DEV.md](DEV.md) for information on developing and contributing to this tap.

## Support

For issues with specific formulas, please report them to the respective project repositories.

For tap-related issues, open an issue at [github.com/lebe-dev/homebrew-tap](https://github.com/lebe-dev/homebrew-tap).
