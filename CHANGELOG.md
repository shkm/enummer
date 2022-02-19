
# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- This changelog
- README entry for `with_` scope

## [1.0.2] - 2022-02-14
### Fixed
- Case in which values could deserialize into '0', throwing an error (see https://github.com/shkm/enummer/issues/9)
### Removed
- Gemfile.lock

## [1.0.1] - 2022-02-04
### Added
- Official support for SQLite & MariaDB
- CI testing strategies for SQLite & MariaDB

## [1.0.0] - 2022-02-04
### Added
- Basics

[Unreleased]: https://github.com/shkm/enummer/compare/v1.0.2...HEAD
[1.0.2]: https://github.com/shkm/enummer/compare/v1.0.1...v1.0.2
[1.0.1]: https://github.com/shkm/enummer/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/shkm/enummer/releases/tag/v1.0.0
