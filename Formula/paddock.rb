# Rendered by scripts/render-formula.ts and pushed to the tap by
# .github/workflows/release.yml. The copy in the tap repository is GENERATED —
# edit this template, never that file, or the next release overwrites the fix.
#
# This is a tap formula, not a homebrew-core one. Core requires a build from
# source and rejects software that updates itself; see docs/decisions.md.
class Paddock < Formula
  desc "Watch and answer your coding agents from your phone"
  homepage "https://github.com/lntvan166/paddock"
  version "0.17.3"
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
      url "https://github.com/lntvan166/paddock/releases/download/v0.17.3/paddock-macos-aarch64"
      sha256 "428c4ba6005537e65c6ce641f4c2aceded6ddb3f3c525f1a152d9359bcb0e9af"
    end
    on_intel do
      url "https://github.com/lntvan166/paddock/releases/download/v0.17.3/paddock-macos-x86_64"
      sha256 "2a2ebf839d886457718d023a05c2e329385f9a6429d64e13058940c706e46782"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/lntvan166/paddock/releases/download/v0.17.3/paddock-linux-aarch64"
      sha256 "9d7b7163ba294234e96a848ee2626d63e174a6e1b152be12b20049165826a42f"
    end
    on_intel do
      url "https://github.com/lntvan166/paddock/releases/download/v0.17.3/paddock-linux-x86_64"
      sha256 "1c60217f311ced5692c079ab366c06c97c11dfa2e181e0438892112d5693ab47"
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
