# Tuist Homebrew CI Smoke Test

This public repository verifies that a GitHub-hosted macOS runner can:

1. Install an official Tuist formula with Homebrew without Mise.
2. Pin the formula source and Tuist patch version.
3. Generate a minimal macOS project.
4. Build the generated project without code signing.

The workflow downloads a versioned formula from a pinned commit of the official
`tuist/homebrew-tuist` repository. This avoids two sources of drift: a moving tap
branch and Homebrew's unversioned cask.

The direct `brew tap tuist/tuist` route was also tested on `macos-15` on July 21,
2026. It failed while loading the tap's `tuist` cask because its
`conflicts_with formula:` declaration was incompatible with the runner's
Homebrew cask DSL. Installing the pinned formula file avoids loading that cask.

Run the same smoke test locally:

```bash
curl --fail --silent --show-error --location \
  https://raw.githubusercontent.com/tuist/homebrew-tuist/b204b859ef513f488de94bcc0d2a58383cb350fe/Formula/tuist@4.202.5.rb \
  --output /tmp/tuist@4.202.5.rb
brew install --formula /tmp/tuist@4.202.5.rb
tuist generate --no-open
xcodebuild \
  -project TuistBrewSmoke.xcodeproj \
  -scheme TuistBrewSmoke \
  -configuration Debug \
  -destination 'generic/platform=macOS' \
  CODE_SIGNING_ALLOWED=NO \
  build
```
