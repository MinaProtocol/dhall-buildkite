{-|
This is a simple list containing Buildkite environment variables. These variables
are commonly used in Buildkite pipelines to access metadata about the build,
pipeline, and agent. Each variable in the list corresponds to a specific piece
of information provided by the Buildkite environment.

Examples of common Buildkite environment variables:
- `BUILDKITE_BUILD_ID`: The unique ID for the current build.
- `BUILDKITE_PIPELINE_SLUG`: The slug of the pipeline being executed.
- `BUILDKITE_AGENT_NAME`: The name of the agent running the build.

This list can be used to reference or validate the presence of these variables
in your Buildkite scripts or configurations.
-}

[ "BUILDKITE_AGENT_ACCESS_TOKEN"
, "BUILDKITE_PIPELINE_PROVIDER"
, "BUILDKITE_BRANCH"
, "BUILDKITE_SOURCE"
, "BUILDKITE_PIPELINE_NAME"
, "BUILDKITE_AGENT_META_DATA_CLUSTER"
, "BUILDKITE_SCRIPT_PATH"
, "BUILDKITE_LABEL"
, "BUILDKITE_REPO"
, "BUILDKITE_REBUILT_FROM_BUILD_NUMBER"
, "BUILDKITE_PULL_REQUEST_BASE_BRANCH"
, "BUILDKITE_REBUILT_FROM_BUILD_ID"
, "BUILDKITE_TAG"
, "BUILDKITE_TRIGGERED_FROM_BUILD_NUMBER"
, "BUILDKITE_PIPELINE_ID"
, "BUILDKITE_MESSAGE"
, "BUILDKITE_BUILD_NUMBER"
, "BUILDKITE_TRIGGERED_FROM_BUILD_ID"
, "BUILDKITE_PLUGINS"
, "BUILDKITE_COMMIT"
, "BUILDKITE_STEP_KEY"
, "BUILDKITE_STEP_ID"
, "BUILDKITE_PULL_REQUEST_REPO"
, "BUILDKITE_AGENT_META_DATA_SIZE"
, "BUILDKITE_PROJECT_PROVIDER"
, "BUILDKITE_ORGANIZATION_SLUG"
, "BUILDKITE_AGENT_ID"
, "BUILDKITE_BUILD_AUTHOR"
, "BUILDKITE_PULL_REQUEST"
, "BUILDKITE_BUILD_CREATOR"
, "BUILDKITE_COMMAND"
, "BUILDKITE_PIPELINE_SLUG"
, "BUILDKITE_PIPELINE_MODE"
, "BUILDKITE"
, "BUILDKITE_RETRY_COUNT"
, "BUILDKITE_PIPELINE_DEFAULT_BRANCH"
, "BUILDKITE_TRIGGERED_FROM_BUILD_PIPELINE_SLUG"
, "BUILDKITE_BUILD_ID"
, "BUILDKITE_BUILD_URL"
, "BUILDKITE_AGENT_NAME"
, "BUILDKITE_BUILD_CREATOR_EMAIL"
, "BUILDKITE_JOB_ID"
, "BUILDKITE_BUILD_AUTHOR_EMAIL"
, "BUILDKITE_ARTIFACT_PATHS"
, "BUILDKITE_PROJECT_SLUG"
, "BUILDKITE_AGENT_META_DATA_QUEUE"
, "BUILDKITE_TIMEOUT"
, "BUILDKITE_STEP_IDENTIFIER"
, "NIGHTLY"
]
