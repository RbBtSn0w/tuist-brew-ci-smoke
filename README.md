# Tuist Homebrew CI Smoke Test

This public repository verifies that a GitHub-hosted macOS runner can:

1. Install an official Tuist formula with Homebrew without Mise.
2. Pin the formula source and Tuist patch version.
3. Generate a minimal macOS project.
4. Build the generated project without code signing.

The workflow creates an ephemeral local tap and downloads a versioned formula
into it from a pinned commit of the official `tuist/homebrew-tuist` repository.
This satisfies Homebrew's requirement that formulae belong to a tap and avoids
two sources of drift: a moving tap branch and Homebrew's unversioned cask.

The direct `brew tap tuist/tuist` route was also tested on `macos-15` on July 21,
2026. It failed while loading the tap's `tuist` cask because its
`conflicts_with formula:` declaration was incompatible with the runner's
Homebrew cask DSL. Installing the pinned formula file avoids loading that cask.

The smoke build runs on `macos-26`. Tuist `4.202.5` requires a Swift compatibility
library that is unavailable in the default runtime environment of the tested
`macos-15` runner, even though the formula itself installs successfully there.

Run the same smoke test locally:

```bash
brew tap-new rbbtsn0w/tuist-ci
tap_path="$(brew --repository rbbtsn0w/tuist-ci)"
curl --fail --silent --show-error --location \
  https://raw.githubusercontent.com/tuist/homebrew-tuist/b204b859ef513f488de94bcc0d2a58383cb350fe/Formula/tuist@4.202.5.rb \
  --output "${tap_path}/Formula/tuist@4.202.5.rb"
brew install --formula rbbtsn0w/tuist-ci/tuist@4.202.5
tuist generate --no-open
xcodebuild \
  -project TuistBrewSmoke.xcodeproj \
  -scheme TuistBrewSmoke \
  -configuration Debug \
  -destination 'generic/platform=macOS' \
  CODE_SIGNING_ALLOWED=NO \
  build
```
