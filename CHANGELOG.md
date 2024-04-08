
# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.4] - 2024-04-08
### Fixed
- New values set via generated "=" setters now properly persist on save. Thanks @1v [#16](https://github.com/shkm/enummer/issues/16)
- New values set via a model's `update` methods now properly persist. Thanks @1v [#18](https://github.com/shkm/enummer/issues/18)
- Falsey values (e.g. `"false"`) now correctly set values to `false` . Thanks @1v [#19](https://github.com/shkm/enummer/issues/19)

## [1.0.3]
### Added
- This changelog
- README entry for `with_` scope
- Support for strings in setters (previously symbols only). Thanks @luctus

## [1.0.2] - 2022-02-14
### Fixed
- Case in which values could deserialize into '0', throwing an error (see [#9](https://github.com/shkm/enummer/issues/9))
### Removed
- Gemfile.lock

## [1.0.1] - 2022-02-04
### Added
- Official support for SQLite & MariaDB
- CI testing strategies for SQLite & MariaDB

## [1.0.0] - 2022-02-04
### Added
- Basics

[Unreleased]: https://github.com/shkm/enummer/compare/v1.0.4...HEAD
[1.0.4]: https://github.com/shkm/enummer/compare/v1.0.3...v1.0.4
[1.0.3]: https://github.com/shkm/enummer/compare/v1.0.2...v1.0.3
[1.0.2]: https://github.com/shkm/enummer/compare/v1.0.1...v1.0.2
[1.0.1]: https://github.com/shkm/enummer/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/shkm/enummer/releases/tag/v1.0.0
