# Prepare Example

This example demonstrates a Buildkite pipeline configuration using Dhall. It defines a pipeline that prepares the monorepo triage execution by dynamically generating and uploading a pipeline based on the provided environment variables.

## How to Run

1. **Install Dhall**:
   Ensure you have Dhall installed on your system. You can follow the installation instructions from the [Dhall website](https://dhall-lang.org/).

2. **Set Environment Variables**:
   - `BUILDKITE_PIPELINE_MODE`: Specifies the pipeline mode. Defaults to `PullRequest` if not set.
   - `BUILDKITE_PIPELINE_FILTER`: Specifies the pipeline filter. Defaults to `FastOnly` if not set.

   Example:
   ```bash
   export BUILDKITE_PIPELINE_MODE=PullRequest
   export BUILDKITE_PIPELINE_FILTER=FastOnly
   ```

3. **Convert to YAML**:
   Use the `dhall-to-yaml` command to convert the Dhall file into a YAML file that can be used by Buildkite:
   ```bash
   dhall-to-yaml --file Prepare.dhall > pipeline.yml
   ```

4. **Upload to Buildkite**:
   Upload the generated `pipeline.yml` to Buildkite using the Buildkite CLI:
   ```bash
   buildkite-agent pipeline upload pipeline.yml
   ```

## What It Does

This example defines a Buildkite pipeline with the following characteristics:
- **Pipeline**: A single step is defined in the pipeline.
- **Commands**:
  - Exports the `BUILDKITE_PIPELINE_MODE` environment variable.
  - Exports the `BUILDKITE_PIPELINE_FILTER` environment variable.
  - Dynamically generates and uploads a pipeline using the `Monorepo.dhall` configuration.
- **Label**: The step is labeled as `Prepare monorepo triage`.
- **Key**: The step is identified with the key `monorepo-${scope}-${filter}`, where `scope` and `filter` are dynamically set based on the environment variables.
- **Target**: The step is configured to run on a `Multi` size target.

Above Pipeline is an example of a complete project which based on filter and scope executes only a subset of jobs. 

If scope is equals to PullRequest, there is also triage performed which can filter out jobs which are not hit by git changes. 

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