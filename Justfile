# Homebrew tap management tasks

# Audit the submarine formula
audit:
    HOMEBREW_NO_INSTALL_FROM_API=1 brew audit --new lebe-dev/tap/submarine

# Install submarine formula locally for testing
install:
    HOMEBREW_NO_INSTALL_FROM_API=1 brew install --build-from-source --verbose lebe-dev/tap/submarine

# Run formula tests
test:
    HOMEBREW_NO_INSTALL_FROM_API=1 brew test lebe-dev/tap/submarine

# Uninstall submarine formula
uninstall:
    brew uninstall submarine

# Full test cycle: audit, install, test
test-all: audit install test
    @echo "All tests passed!"

# Clean uninstall and reinstall
reinstall: uninstall install
    @echo "Reinstalled successfully!"

# Update an existing formula to a new version from GitHub release URL
update-release URL BINARY="":
    #!/usr/bin/env bash
    set -euo pipefail

    URL="{{ URL }}"
    BINARY="{{ BINARY }}"

    echo "Updating Homebrew formula from GitHub release..."
    echo ""

    # Validate URL format
    if [[ ! "$URL" =~ ^https://github\.com/([^/]+)/([^/]+)/releases/download/([^/]+)/(.+)$ ]]; then
        echo "Error: Invalid GitHub release URL format"
        echo "Expected: https://github.com/owner/project/releases/download/version/file.zip"
        exit 1
    fi

    PROJECT="${BASH_REMATCH[2]}"
    VERSION="${BASH_REMATCH[3]}"
    FILENAME="${BASH_REMATCH[4]}"

    # Find formula by project name
    FORMULA_FILE=$(echo "$PROJECT" | tr '[:upper:]' '[:lower:]' | tr '_' '-')
    FORMULA_PATH="Formula/${FORMULA_FILE}.rb"
    if [ ! -f "$FORMULA_PATH" ]; then
        echo "Error: Formula not found at $FORMULA_PATH"
        echo "Use 'just add-release' to create a new formula"
        exit 1
    fi

    echo "Found formula: $FORMULA_PATH"
    echo "Downloading archive and calculating SHA256..."
    TEMP_FILE=$(mktemp)
    if ! curl -L -f -o "$TEMP_FILE" "$URL" 2>/dev/null; then
        rm -f "$TEMP_FILE"
        echo "Error: Failed to download archive from $URL"
        exit 1
    fi

    SHA256=$(shasum -a 256 "$TEMP_FILE" | awk '{print $1}')
    echo "SHA256: $SHA256"

    # Detect binary name if not provided
    if [ -z "$BINARY" ]; then
        echo "Detecting binary name from archive..."
        TEMP_DIR=$(mktemp -d)

        if [[ "$FILENAME" =~ \.zip$ ]]; then
            unzip -q "$TEMP_FILE" -d "$TEMP_DIR"
        elif [[ "$FILENAME" =~ \.(tar\.gz|tgz)$ ]]; then
            tar -xzf "$TEMP_FILE" -C "$TEMP_DIR"
        else
            rm -f "$TEMP_FILE"
            rm -rf "$TEMP_DIR"
            echo "Error: Unsupported archive format. Only .zip and .tar.gz are supported"
            exit 1
        fi

        BINARY=$(find "$TEMP_DIR" -type f -perm +111 -exec basename {} \; | head -n 1)
        rm -rf "$TEMP_DIR"

        if [ -z "$BINARY" ]; then
            rm -f "$TEMP_FILE"
            echo "Error: Could not detect binary name. Please specify with BINARY parameter"
            exit 1
        fi

        echo "Detected binary: $BINARY"
    fi

    rm -f "$TEMP_FILE"

    VERSION_CLEAN="${VERSION#v}"

    # Update formula fields in-place
    sed -i '' "s|  url \".*\"|  url \"${URL}\"|" "$FORMULA_PATH"
    sed -i '' "s|  version \".*\"|  version \"${VERSION_CLEAN}\"|" "$FORMULA_PATH"
    sed -i '' "s|  sha256 \".*\"|  sha256 \"${SHA256}\"|" "$FORMULA_PATH"
    sed -i '' "s|assert_match \".*\", shell_output(\"#{bin}/${BINARY} --version\")|assert_match \"${BINARY} ${VERSION_CLEAN}\", shell_output(\"#{bin}/${BINARY} --version\")|" "$FORMULA_PATH"

    echo ""
    echo "Formula updated successfully: $FORMULA_PATH"
    echo "  version: ${VERSION_CLEAN}"
    echo "  sha256:  ${SHA256}"
    echo ""
    echo "Next steps:"
    echo "  1. Verify changes: cat $FORMULA_PATH"
    echo "  2. Run: just test-all"

# Add a new formula from GitHub release URL
add-release URL BINARY="" NAME="":
    #!/usr/bin/env bash
    set -euo pipefail

    URL="{{ URL }}"
    BINARY="{{ BINARY }}"
    NAME="{{ NAME }}"

    echo "Creating Homebrew formula from GitHub release..."
    echo ""

    # Validate URL format
    if [[ ! "$URL" =~ ^https://github\.com/([^/]+)/([^/]+)/releases/download/([^/]+)/(.+)$ ]]; then
        echo "Error: Invalid GitHub release URL format"
        echo "Expected: https://github.com/owner/project/releases/download/version/file.zip"
        echo "Example: https://github.com/lebe-dev/submarine/releases/download/0.13.1/sm-0.13.1-macos-arm64.zip"
        exit 1
    fi

    OWNER="${BASH_REMATCH[1]}"
    PROJECT="${BASH_REMATCH[2]}"
    VERSION="${BASH_REMATCH[3]}"
    FILENAME="${BASH_REMATCH[4]}"

    # Determine formula name
    if [ -z "$NAME" ]; then
        FORMULA_NAME="$PROJECT"
    else
        FORMULA_NAME="$NAME"
    fi

    # Convert formula name to lowercase with hyphens
    FORMULA_FILE=$(echo "$FORMULA_NAME" | tr '[:upper:]' '[:lower:]' | tr '_' '-')

    # Convert to CamelCase for class name
    CLASS_NAME=$(echo "$FORMULA_NAME" | perl -pe 's/(^|[-_])(.)/\U$2/g' | sed 's/[-_]//g')

    # Check if formula already exists
    FORMULA_PATH="Formula/${FORMULA_FILE}.rb"
    if [ -f "$FORMULA_PATH" ]; then
        echo "Error: Formula already exists at $FORMULA_PATH"
        echo "Please remove it first or use a different name with NAME parameter"
        exit 1
    fi

    echo "Downloading archive and calculating SHA256..."
    TEMP_FILE=$(mktemp)
    if ! curl -L -f -o "$TEMP_FILE" "$URL" 2>/dev/null; then
        rm -f "$TEMP_FILE"
        echo "Error: Failed to download archive from $URL"
        exit 1
    fi

    SHA256=$(shasum -a 256 "$TEMP_FILE" | awk '{print $1}')
    echo "SHA256: $SHA256"

    # Detect binary name if not provided
    if [ -z "$BINARY" ]; then
        echo "Detecting binary name from archive..."
        TEMP_DIR=$(mktemp -d)

        # Detect archive type and extract
        if [[ "$FILENAME" =~ \.zip$ ]]; then
            unzip -q "$TEMP_FILE" -d "$TEMP_DIR"
        elif [[ "$FILENAME" =~ \.(tar\.gz|tgz)$ ]]; then
            tar -xzf "$TEMP_FILE" -C "$TEMP_DIR"
        else
            rm -f "$TEMP_FILE"
            rm -rf "$TEMP_DIR"
            echo "Error: Unsupported archive format. Only .zip and .tar.gz are supported"
            exit 1
        fi

        # Find first executable file
        BINARY=$(find "$TEMP_DIR" -type f -perm +111 -exec basename {} \; | head -n 1)

        rm -rf "$TEMP_DIR"

        if [ -z "$BINARY" ]; then
            rm -f "$TEMP_FILE"
            echo "Error: Could not detect binary name. Please specify with BINARY parameter"
            exit 1
        fi

        echo "Detected binary: $BINARY"
    fi

    rm -f "$TEMP_FILE"

    # Remove version prefix from VERSION if it starts with 'v'
    VERSION_CLEAN="${VERSION#v}"

    # Generate formula file
    echo ""
    echo "Generating formula file..."
    {
        echo "class ${CLASS_NAME} < Formula"
        echo '  desc "TODO: Add description"'
        echo "  homepage \"https://github.com/${OWNER}/${PROJECT}\""
        echo "  url \"${URL}\""
        echo "  version \"${VERSION_CLEAN}\""
        echo "  sha256 \"${SHA256}\""
        echo '  license "MIT"'
        echo ''
        echo '  def install'
        echo "    bin.install \"${BINARY}\""
        echo '  end'
        echo ''
        echo '  test do'
        echo "    assert_match \"version ${VERSION_CLEAN}\", shell_output(\"#{bin}/${BINARY} --version\")"
        echo '  end'
        echo 'end'
    } > "$FORMULA_PATH"

    echo "Formula created successfully at $FORMULA_PATH"
    echo ""
    echo "Next steps:"
    echo "  1. Edit $FORMULA_PATH to add proper description"
    echo "  2. Update license if not MIT"
    echo "  3. Update test block if needed"
    echo "  4. Run: just audit (or brew audit --new lebe-dev/tap/${FORMULA_FILE})"
    echo "  5. Test installation and functionality"
