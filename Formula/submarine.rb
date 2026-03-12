class Submarine < Formula
  desc "Tiny toolkit for LLM-powered subtitle translation workflows"
  homepage "https://github.com/lebe-dev/submarine"
  url "https://github.com/lebe-dev/submarine/releases/download/0.14.0/sm-0.14.0-macos-arm64.zip"
  version "0.14.0"
  sha256 "871e2ffe15febcf044321c301cfcf975a5e20f33fbf889c6615042ef1fb80541"
  license "MIT"

  def install
    bin.install "sm"
  end

  test do
    assert_match "sm 0.14.0", shell_output("#{bin}/sm --version")
  end
end
