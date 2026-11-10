# Rendered by scripts/render-formula.ts and pushed to the tap by
# .github/workflows/release.yml. The copy in the tap repository is GENERATED —
# edit this template, never that file, or the next release overwrites the fix.
#
# This is a tap formula, not a homebrew-core one. Core requires a build from
# source and rejects software that updates itself; see docs/decisions.md.
class Paddock < Formula
  desc "Watch and answer your coding agents from your phone"
  homepage "https://github.com/lntvan166/paddock"
  version "0.16.1"
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
      url "https://github.com/lntvan166/paddock/releases/download/v0.16.1/paddock-macos-aarch64"
      sha256 "a5faec3f4678c18b3171271184dea957af7396004046306059b781e36412a961"
    end
    on_intel do
      url "https://github.com/lntvan166/paddock/releases/download/v0.16.1/paddock-macos-x86_64"
      sha256 "4feb51211d88dcb2d597e81b193642d6763ac4de5f468e98db19ea6b2952d8c0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/lntvan166/paddock/releases/download/v0.16.1/paddock-linux-aarch64"
      sha256 "ff91f5f3a23d08489fb61adc0cd8a492fd0de2570ee53cacc6bcc364dfbe785e"
    end
    on_intel do
      url "https://github.com/lntvan166/paddock/releases/download/v0.16.1/paddock-linux-x86_64"
      sha256 "82fc4bac37174de928c7f3ae123eddcdb0fd4e52d3192932ec5b5b7ebc135951"
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
