class Submarine < Formula
  desc "Tiny toolkit for LLM-powered subtitle translation workflows"
  homepage "https://github.com/lebe-dev/submarine"
  url "https://github.com/lebe-dev/submarine/releases/download/0.15.0/sm-0.15.0-macos-arm64.zip"
  version "0.15.0"
  sha256 "6a2c2428c1e5c031fdb502353743534f2818132b95d402d01676140fdb16f6cb"
  license "MIT"

  def install
    bin.install "sm"
  end

  test do
    assert_match "sm 0.15.0", shell_output("#{bin}/sm --version")
  end
end
