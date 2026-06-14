class Submarine < Formula
  desc "Tiny toolkit for LLM-powered subtitle translation workflows"
  homepage "https://github.com/lebe-dev/submarine"
  url "https://github.com/lebe-dev/submarine/releases/download/0.16.0/sm-0.16.0-macos-arm64.zip"
  version "0.16.0"
  sha256 "3db673491f93ee69f0146114eca86ac2cefc1f8c4c2dc4a10c6c1e4f415dcbeb"
  license "MIT"

  def install
    bin.install "sm"
  end

  test do
    assert_match "sm 0.16.0", shell_output("#{bin}/sm --version")
  end
end
