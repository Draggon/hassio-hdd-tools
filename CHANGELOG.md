# Changelog

All notable changes to this project will be documented in this file, in reverse chronological order by release.

## 0.45.0 - 2020-11-28

### Added

- `sensor_name` configuration to (re-)name the sensor which is created/updated within home-assistant
- `friendly_name` configuration to (re-)name the sensors friendly name within home-assistant
- `debug` flag to enable/disable debugging
- `performance_check` flag to enable/disable performance check when starting up the addon
- `attributes_property` configuration to configure the attribute which is merged with the entity attributes

### Changed

- By adding the `attributes_property`, attributes which were parsed in 0.44 will not be attached to the sensors attributes unless you configure the new `attributes_property`.
- The `output_file` will now contain the JSON formatted output of `smartctl`.

### Deprecated

- Nothing.

### Removed

- Nothing.

### Fixed

- Nothing.

## 0.44.0 - 2020-05-17

### Added

- Added PiBenchmarks performance test

### Changed

- Nothing.

### Deprecated

- Nothing.

### Removed

- Nothing.

### Fixed

- Nothing.
