# Releasing chartmogul-ruby

## Prerequisites

- You must have push access to the repository
- `git`, `gh`, `jq`, `ruby`, and `bundle` must be installed
- Tags matching `v*` are protected by GitHub tag protection rulesets
- Releases are immutable once published (GitHub repository setting)
- RubyGems [trusted publishing](https://guides.rubygems.org/trusted-publishing/) must be configured for the gem (see [Repository Settings](#repository-settings-admin))

## Release Process

Run the release script from the repository root:

```sh
bin/release.sh <patch|minor|major>
```

The script will:

1. Verify prerequisites and that CI is green on `main`
2. Show any open PRs targeting `main` and ask for confirmation
3. Bump the version in `lib/chartmogul/version.rb`
4. Create a release branch, commit, push, and open a PR
5. Wait for the PR to be merged (poll every 10s)
6. Tag the merge commit and push the tag
7. Wait for the [release workflow](.github/workflows/release.yml) to complete, which will:
   - Run the full test suite across Ruby 3.2, 3.3, and 3.4
   - Verify that `ChartMogul::VERSION` matches the tag
   - Create a GitHub Release with auto-generated release notes
   - Publish to RubyGems via [OIDC trusted publishing](https://guides.rubygems.org/trusted-publishing/)
8. Print links to the GitHub Release and RubyGems page

## Changelog

Release notes are auto-generated from merged PR titles by the [release workflow](.github/workflows/release.yml). To ensure useful changelogs:

- Use clear, descriptive PR titles (e.g., "Add External ID field to Contact model")
- Prefix breaking changes with `BREAKING:` so they stand out in release notes
- After the release is created, review and edit the notes on the [Releases page](https://github.com/chartmogul/chartmogul-ruby/releases) if needed

## Pre-release Versions

For pre-release versions, use a semver pre-release suffix:

```sh
git tag vX.Y.Z-rc1
git push origin vX.Y.Z-rc1
```

These will be automatically marked as pre-releases on GitHub.

## Security

### Repository Protections

- **Immutable releases**: Once a GitHub Release is published, its tag cannot be moved or deleted, and release assets cannot be modified
- **Tag protection rulesets**: `v*` tags cannot be deleted or force-pushed

### RubyGems

- Publishing uses [OIDC trusted publishing](https://guides.rubygems.org/trusted-publishing/) — no long-lived API keys are stored in the repository. GitHub Actions authenticates directly with RubyGems via short-lived OIDC tokens.
- [RubyGems.org](https://rubygems.org) enforces version immutability: once a gem version is published, it cannot be overwritten
- Users can verify gem integrity using `gem cert` or Bundler checksums
- Bundler 2.x+ records gem checksums in `Gemfile.lock` for reproducible installs

### What This Protects Against

- A compromised maintainer account cannot modify or delete existing releases
- No long-lived RubyGems API keys exist that could be leaked or stolen
- Tags cannot be moved to point to different commits after publication
- RubyGems version immutability provides an independent verification layer beyond GitHub

### Repository Settings (Admin)

These settings must be configured by a repository admin:

1. **Immutable Releases**: Settings > General > Releases > Enable "Immutable releases"
2. **Tag Protection Ruleset**: Settings > Rules > Rulesets > New ruleset targeting tags matching `v*` with deletion, force-push, and update prevention
3. **GitHub Actions Environment**: Settings > Environments > New environment named `rubygems`
4. **RubyGems Trusted Publishing**: On rubygems.org, go to the `chartmogul-ruby` gem > Trusted Publishers > Add Publisher with: repository `chartmogul/chartmogul-ruby`, workflow `release.yml`, environment `rubygems`
