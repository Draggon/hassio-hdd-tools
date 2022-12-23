# Changelog

All notable changes to this project will be documented in this file, in reverse chronological order by release.

## 1.1.0 - 2022-12-23

### Added

- Polish translation for configuration

### Changed

- Nothing.

### Deprecated

- Nothing.

### Removed

- Nothing.

### Fixed

- Nothing.

## 1.0.0 - 2022-12-19

### Added

- The possibility to specify the device type to smartctl
- Spanish translations for descriptions

### Changed

- Nothing.

### Deprecated

- Nothing.

### Removed

- Nothing.

### Fixed

- Nothing.

## 0.53.0 - 2022-06-22

### Added

- Nothing

### Changed

- Nothing.

### Deprecated

- Nothing.

### Removed

- Nothing.

### Fixed

- Fixed error `s6-overlay-suexec: fatal` produced by changes in Home Assistant.

## 0.52.0 - 2021-12-30

### Added

- New option to let choose between temperature or SMART state as main value of the sensor. Check the documentation before changing it to adjust the sensor name accordingly between `sensor` and `binary_sensor` .

### Changed

- Nothing.

### Deprecated

- Nothing.

### Removed

- Nothing.

### Fixed

- Nothing.

## 0.51.0 - 2021-10-20

### Added

- Added attributes for long term storage statistics in Home Assistant.

### Changed

- Nothing.

### Deprecated

- Nothing.

### Removed

- Nothing.

### Fixed

- Nothing.

## 0.50.2 - 2021-10-08

### Added

- Added again full access (protected mode) option. Something has changed in Home Assistant and now it seems to need it again.

### Changed

- Nothing.

### Deprecated

- Nothing.

### Removed

- Nothing

### Fixed

- Preserve permissions when copying scripts.

## 0.50.1 - 2021-03-31

### Added

- Nothing.

### Changed

- Nothing.

### Deprecated

- Nothing.

### Removed

- Nothing

### Fixed

- Fixed execution permissions when updating database.

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
