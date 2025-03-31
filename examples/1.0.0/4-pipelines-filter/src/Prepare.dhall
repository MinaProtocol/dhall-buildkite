-- Autogenerates any pre-reqs for monorepo triage execution
-- Keep these rules lean! They have to run unconditionally.
let Base = ./Base.dhall

let Cmd = Base.Lib.Cmds

let Pipeline = Base.Pipeline.Annotated.Type

let JobSpec = Base.Pipeline.Annotated.JobSpec

let SelectFiles = Base.Lib.SelectFiles

let Command = Base.Command.Base

let TaggedKey = Base.Command.TaggedKey

let Cmds = Base.Lib.Cmds

let Docker = Cmds.Docker

let Size = Base.Command.Size.Type

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
            , target = Size.Multi
            }
        ]
      }

in  (Pipeline.build config).pipeline
