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
