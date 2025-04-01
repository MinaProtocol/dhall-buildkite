# HelloWorld Example

This example demonstrates a simple Buildkite pipeline configuration using Dhall. It defines a pipeline with a single command that prints "hello world" to the console.

## How to Run

1. **Install Dhall**:
   Ensure you have Dhall installed on your system. You can follow the installation instructions from the [Dhall website](https://dhall-lang.org/).

2. **Convert to YAML**:
   Use the `dhall-to-yaml` command to convert the Dhall file into a YAML file that can be used by Buildkite:
   ```bash
   dhall-to-yaml --file HelloWorld.dhall > pipeline.yml
   ```

3. **Upload to Buildkite**:
   Upload the generated `pipeline.yml` to Buildkite using the Buildkite CLI:
   ```bash
   buildkite-agent pipeline upload pipeline.yml
   ```

## What It Does

This example defines a Buildkite pipeline with the following characteristics:
- **Pipeline**: A single step is defined in the pipeline.
- **Command**: The step runs the command `echo hello world`.
- **Label**: The step is labeled as `Hello world`.
- **Key**: The step is identified with the key `hello-world`.
- **Target**: The step is configured to run on a `Multi` size target.

## Compatibility

This example is **guaranteed to be compatible with version 1.0.0** of the `dhall-buildkite` package. However, compatibility with newer versions is **not guaranteed**. If you are using a newer version, ensure that the `package.dhall` file referenced in the example is compatible with your version.

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