# Guidelines for contributing to the rsyslog documentation (rsyslog-doc) project

## Terminology

- Configuration options for inputs, actions, etc are called "parameters". There
  is a good deal of the older term distributed throughout the documentation.
  Please update it as you find it.

- The configuration format names changed between versions 8.31.0 and 8.32.0.
  See the `conf_formats.rst` document for the current terminology.
    - NOTE: We use substitution references for the format names in an effort to
      provide consistency and to easily allow future name changes if necessary.

## Formatting

- X spaces indention

## Structure

### Header levels

- TODO: mention the specific character strings used for ...
    - doc title
    - doc substitle
    - heading level 1
    - ...

## Copyright

- The old documentation format included a static copyright "footer" at the
  bottom of each page. This should be removed as it is encountered.

## Legacy format examples

- These should be removed as you encounter them. It is preferable that an
  advanced equivalent be provided in its place, but simply removing the
  old content is also acceptable.
