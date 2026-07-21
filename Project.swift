import ProjectDescription

let project = Project(
  name: "TuistBrewSmoke",
  targets: [
    .target(
      name: "TuistBrewSmoke",
      destinations: .macOS,
      product: .commandLineTool,
      bundleId: "me.rbbtsn0w.tuist-brew-ci-smoke",
      deploymentTargets: .macOS("14.0"),
      buildableFolders: ["Sources"]
    ),
  ]
)
