-- Autogenerates any pre-reqs for monorepo triage execution
-- Keep these rules lean! They have to run unconditionally.

let Base = ../../../src/Command/Base.dhall

let Cmd = ../../../src/Lib/Cmds.dhall

let Pipeline = ../../../src/Pipeline/Annotated/Type.dhall

let JobSpec = ../../../src/Pipeline/Annotated/JobSpec.dhall

let SelectFiles = ../../../src/Lib/SelectFiles.dhall

let Command = ../../../src/Command/Base.dhall

let TaggedKey = ../../../src/Command/TaggedKey.dhall

let Cmds = ../../../src/Lib/Cmds.dhall

let Docker = Cmds.Docker

let Size = ../../../src/Command/Size.dhall

let scope = env:BUILDKITE_PIPELINE_MODE as Text ? "PullRequest"

let filter = env:BUILDKITE_PIPELINE_FILTER as Text ? "FastOnly"

let config
    : Pipeline.Config.Type
    = Pipeline.Config::{
      , spec = JobSpec::{
        , name = "prepare"
        , dirtyWhen = [ SelectFiles.everything ]
        }
      , steps =
        [ Command.build
            Command.Config::{
            , commands =
              [ Cmd.run "export BUILDKITE_PIPELINE_MODE=${scope}"
              , Cmd.run "export BUILDKITE_PIPELINE_FILTER=${filter}"
              , Cmd.quietly
                  "dhall-to-yaml --quoted <<< '(./Monorepo.dhall) { scope=Scope.Type.${scope}, filter=Filter.Type.${filter}  }' | buildkite-agent pipeline upload"
              ]
            , label = "Prepare monorepo triage"
            , key = "monorepo-${scope}-${filter}"
            , target = Size.Type.Multi
            }
        ]
      }

in  (Pipeline.build config).pipeline
