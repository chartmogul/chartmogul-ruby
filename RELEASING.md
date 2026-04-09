# Releasing chartmogul-ruby

## Prerequisites

- You must have push access to the repository
- Tags matching `v*` are protected by GitHub tag protection rulesets
- Releases are immutable once published (GitHub repository setting)

## Release Process

1. Ensure all changes are merged to the `main` branch
2. Ensure CI is green on the `main` branch
3. Update the version in `lib/chartmogul/version.rb`
4. Update the `CHANGELOG.md` if applicable
5. Commit the version bump
6. Create and push a version tag:
   ```sh
   git tag v4.X.Y
   git push origin v4.X.Y
   ```
7. The [release workflow](.github/workflows/release.yml) will automatically create a GitHub Release with auto-generated release notes
8. Verify the release appears at https://github.com/chartmogul/chartmogul-ruby/releases
9. Build and push the gem to RubyGems:
   ```sh
   gem build chartmogul-ruby.gemspec
   gem push chartmogul-ruby-4.X.Y.gem
   ```

## Changelog

Release notes are auto-generated from merged PR titles by the [release workflow](.github/workflows/release.yml). To ensure useful changelogs:

- Use clear, descriptive PR titles (e.g., "Add External ID field to Contact model")
- Prefix breaking changes with `BREAKING:` so they stand out in release notes
- After the release is created, review and edit the notes on the [Releases page](https://github.com/chartmogul/chartmogul-ruby/releases) if needed

## Pre-release Versions

For pre-release versions, use a semver pre-release suffix:

```sh
git tag v4.X.Y-rc1
git push origin v4.X.Y-rc1
```

These will be automatically marked as pre-releases on GitHub.

## Security

### Repository Protections

- **Immutable releases**: Once a GitHub Release is published, its tag cannot be moved or deleted, and release assets cannot be modified
- **Tag protection rulesets**: `v*` tags cannot be deleted or force-pushed

### RubyGems

- [RubyGems.org](https://rubygems.org) enforces version immutability: once a gem version is published, it cannot be overwritten
- Users can verify gem integrity using `gem cert` or Bundler checksums
- Bundler 2.x+ records gem checksums in `Gemfile.lock` for reproducible installs

### What This Protects Against

- A compromised maintainer account cannot modify or delete existing releases
- Tags cannot be moved to point to different commits after publication
- RubyGems version immutability provides an independent verification layer beyond GitHub

### Repository Settings (Admin)

These settings must be configured by a repository admin:

1. **Immutable Releases**: Settings > General > Releases > Enable "Immutable releases"
2. **Tag Protection Ruleset**: Settings > Rules > Rulesets > New ruleset targeting tags matching `v*` with deletion and force-push prevention
