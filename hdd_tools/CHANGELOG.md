# Changelog

All notable changes to this project will be documented in this file, in reverse chronological order by release.

## 0.50.0 - 2021-03-29

### Added

- Added an option to update the drives database

### Changed

- Nothing.

### Deprecated

- Nothing.

### Removed

- Nothing

### Fixed

- Nothing.

## 0.49.0 - 2021-03-25

### Added

- Added a more descriptive UI for the _Configuration_ tab in Home Assistant.

### Changed

- Nothing.

### Deprecated

- Nothing.

### Removed

- The disable _Protection Mode_ option has been removed. There is not need of it anymore.

### Fixed

- Nothing.

## 0.48.0 - 2021-03-23

### Added

- Add support for `/dev/nvme0` out of the box
- Add the option to disable _Protection Mode_ in _Home Assistant_ to support devices different than `/dev/sda0` and `/dev/nvme0`

### Changed

- Nothing.

### Deprecated

- Nothing.

### Removed

- Nothing.

### Fixed

- Nothing.

## 0.47.0 - 2021-03-08

### Added

- Add support for homeassistant 2021.2.0+

### Changed

- Nothing.

### Deprecated

- Nothing.

### Removed

- Nothing.

### Fixed

- Nothing.

## 0.46.0 - 2020-11-29

### Added

- `attributes_format` which can be one of `list` or `object` to tell this addon which format the JSON output has.

### Changed

- When `debug` is enabled, the sensor data is not published to `home-assistant` anymore.

### Deprecated

- Nothing.

### Removed

- Nothing.

### Fixed

- Nothing.

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
