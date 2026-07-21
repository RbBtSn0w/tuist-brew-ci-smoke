# Tuist Homebrew CI Smoke Test

This public repository verifies that a GitHub-hosted macOS runner can:

1. Install Tuist from the official `tuist/tuist` Homebrew tap without Mise.
2. Constrain Tuist to the `4.202.x` release line.
3. Generate a minimal macOS project.
4. Build the generated project without code signing.

The workflow intentionally pins a minor release line rather than an exact patch.
The official tap currently exposes `tuist@4.202`, while historical patch formulas
may be pruned. Projects that require an exact patch across every environment
should continue to use Mise or update their pin to a patch formula that is
available in the tap.

Run the same smoke test locally:

```bash
brew tap tuist/tuist
brew install --formula tuist@4.202
tuist generate --no-open
xcodebuild \
  -project TuistBrewSmoke.xcodeproj \
  -scheme TuistBrewSmoke \
  -configuration Debug \
  -destination 'generic/platform=macOS' \
  CODE_SIGNING_ALLOWED=NO \
  build
```
