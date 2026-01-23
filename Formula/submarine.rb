class Submarine < Formula
  desc "Tiny toolkit for LLM-powered subtitle translation workflows"
  homepage "https://github.com/lebe-dev/submarine"
  url "https://github.com/lebe-dev/submarine/releases/download/0.13.1/sm-0.13.1-macos-arm64.zip"
  version "0.13.1"
  sha256 "ecba86d7f53535c900f0898d272b8c03677087492fc77470132c92144231e740"
  license "MIT"

  def install
    bin.install "sm"
  end

  test do
    assert_match "sm 0.13.1", shell_output("#{bin}/sm --version")
  end
end
