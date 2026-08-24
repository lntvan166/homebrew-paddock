# homebrew-paddock

A [Homebrew](https://brew.sh) tap for
[paddock](https://github.com/lntvan166/paddock) — watch and answer your coding
agents from your phone.

## install

```bash
brew install lntvan166/paddock/paddock
```

One command. The fully-qualified name taps this repository and trusts this one
formula: since Homebrew 6.0.0 a non-official tap requires explicit trust, so a
bare `brew install paddock` cannot reach a tap.

Upgrades are Homebrew's from then on:

```bash
brew upgrade paddock
```

`paddock update` detects a Homebrew keg and declines, rather than overwriting
the binary behind `brew`'s back — the Homebrew prefix is user-writable, so that
write would succeed and leave `brew info paddock` reporting a version that is
no longer the bytes on disk.

paddock reads [herdr](https://github.com/herdrdev/herdr)'s socket protocol and
does nothing without it, so the formula depends on `herdr`, which is in
`homebrew-core`. `brew install` pulls it in.

## `Formula/paddock.rb` is generated

Do not edit it here. It is rendered from
[`packaging/homebrew/paddock.rb.tmpl`](https://github.com/lntvan166/paddock/blob/main/packaging/homebrew/paddock.rb.tmpl)
and pushed by paddock's release workflow, so the next release overwrites any
change made in this repository. Its checksums come from the release's own
`SHA256SUMS`, which means the formula and the published binaries cannot
disagree.

Why a tap and not `homebrew/core`: paddock ships pre-compiled binaries and
self-updates, and core requires a build from source and rejects software that
updates itself. The reasoning is recorded in
[`docs/decisions.md`](https://github.com/lntvan166/paddock/blob/main/docs/decisions.md).

## license

MIT, same as paddock.
