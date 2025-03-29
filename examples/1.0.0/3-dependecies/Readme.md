# Dependencies Example

This example demonstrates a Buildkite pipeline configuration using Dhall. It defines a pipeline with multiple commands where one command depends on the successful execution of another.

## How to Run

1. **Install Dhall**:
   Ensure you have Dhall installed on your system. You can follow the installation instructions from the [Dhall website](https://dhall-lang.org/).

2. **Convert to YAML**:
   Use the `dhall-to-yaml` command to convert the Dhall file into a YAML file that can be used by Buildkite:
   ```bash
   dhall-to-yaml --file Dependencies.dhall > pipeline.yml
   ```

3. **Upload to Buildkite**:
   Upload the generated `pipeline.yml` to Buildkite using the Buildkite CLI:
   ```bash
   buildkite-agent pipeline upload pipeline.yml
   ```

## What It Does

This example defines a Buildkite pipeline with the following characteristics:
- **Pipeline**: Two steps are defined in the pipeline.
- **First Command**:
  - Runs the command `echo cmd 1`.
  - Labeled as `First command`.
  - Identified with the key `mixed-commands-1`.
  - Configured to run on a `Multi` size target.
- **Second Command**:
  - Runs the command `echo cmd 2`.
  - Labeled as `Second command`.
  - Identified with the key `mixed-commands-2`.
  - Configured to run on a `Multi` size target.
  - Depends on the successful execution of the first command (`mixed-commands-1`).

## Compatibility

This example is **guaranteed to be compatible with version 1.0.0** of the `dhall-base` package. However, compatibility with newer versions is **not guaranteed**. If you are using a newer version, ensure that the `package.dhall` file referenced in the example is compatible with your version.

## Notes

- The `Base` package is fetched from the following URL:
  ```
  https://s3.us-west-2.amazonaws.com/dhall.packages.minaprotocol.com/buildkite/releases/1.0.0/package.dhall
  ```
  It is verified using the SHA256 hash:
  ```
  sha256:e9f8f4891b01836575b565eb9d9f56bfe40eb4cc5b3f617c93f563d74ef5288c
  ```
- Ensure you have network access to fetch the `Base` package when running the example.

## License

This example is provided as-is for demonstration purposes.