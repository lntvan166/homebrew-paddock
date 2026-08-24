# Rendered by scripts/render-formula.ts and pushed to the tap by
# .github/workflows/release.yml. The copy in the tap repository is GENERATED —
# edit this template, never that file, or the next release overwrites the fix.
#
# This is a tap formula, not a homebrew-core one. Core requires a build from
# source and rejects software that updates itself; see docs/decisions.md.
class Paddock < Formula
  desc "Watch and answer your coding agents from your phone"
  homepage "https://github.com/lntvan166/paddock"
  version "0.9.0"
  license "MIT"

  # paddock reads herdr's own socket protocol and does nothing without it, so
  # the dependency is real rather than a convenience. herdr is in
  # homebrew-core, and a tap formula may depend on a core formula (the reverse
  # is what Homebrew forbids), so brew can guarantee herdr is present instead
  # of `paddock doctor` reporting its absence after the install.
  #
  # No version constraint, deliberately: paddock's herdr check is directional
  # (README) — a NEWER herdr is accepted, only an older one is refused. Core
  # never moves backwards, so tracking whatever it ships stays correct.
  depends_on "herdr"

  on_macos do
    on_arm do
      url "https://github.com/lntvan166/paddock/releases/download/v0.9.0/paddock-macos-aarch64"
      sha256 "4a5cf1055e6a32e6a0a2b9c5d4972d11e0f359562a334619d3dde5e2521f47a5"
    end
    on_intel do
      url "https://github.com/lntvan166/paddock/releases/download/v0.9.0/paddock-macos-x86_64"
      sha256 "89643c7406849ad43868c257aebcf033b780bc49e24ceac0c1dc2f43b1e5e147"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/lntvan166/paddock/releases/download/v0.9.0/paddock-linux-aarch64"
      sha256 "bcc5c016c43c2d128551f06047840dfe1669c32371d5d0c7e0b49d4a9fdddf09"
    end
    on_intel do
      url "https://github.com/lntvan166/paddock/releases/download/v0.9.0/paddock-linux-x86_64"
      sha256 "6c6d6ee818af0581440c74951fb9bfcc1d066f2caac1fd29a89b5b8b7e8b896e"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  def install
    # The release assets are bare binaries, not archives, so Homebrew stages
    # each one under its own platform-specific name. Exactly one is present.
    asset = Dir["paddock-*"].first
    odie "no paddock binary in the staged download" if asset.nil?
    bin.install asset => "paddock"
  end

  def caveats
    <<~CAVEAT
      Homebrew owns this install, so `paddock update` will decline and send you
      back here. Upgrade with:
        brew upgrade paddock
    CAVEAT
  end

  test do
    # The failure this catches has happened here before: a binary that reports
    # 0.0.0-dev because a build-time define never reached it. Every test in the
    # suite stayed green while every released binary was unupdatable.
    ENV["PADDOCK_NO_UPDATE_CHECK"] = "1"
    assert_match version.to_s, shell_output("#{bin}/paddock --version")
  end
end
