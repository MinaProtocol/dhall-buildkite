let Base = ../../../src/Command/Base.dhall

let Cmd = ../../../src/Lib/Cmds.dhall

let Pipeline = ../../../src/Pipeline/Annotated/Type.dhall

let JobSpec = ../../../src/Pipeline/Annotated/JobSpec.dhall

let Scope = ../../../src/Pipeline/Annotated/Scope.dhall

let Command = ../../../src/Command/Base.dhall

let TaggedKey = ../../../src/Command/TaggedKey.dhall

let S = ../../../src/Lib/SelectFiles.dhall

let Cmds = ../../../src/Lib/Cmds.dhall

let Docker = Cmds.Docker

let Size = ../../../src/Command/Size.dhall

let Tag = ./Tag.dhall

in  Pipeline.build
      Pipeline.Config::{
      , spec = JobSpec::{
        , dirtyWhen = [ S.strictlyStart (S.contains "dummy/filtered") ]
        , path = "."
        , name = "FilteredJob"
        , tags = [ Tag.Fast ]
        , scope =
          [ Scope.Type.PullRequest, Scope.Type.Release, Scope.Type.Nightly ]
        }
      , steps =
        [ Command.build
            Command.Config::{
            , commands = [ Cmd.run "echo from filtered job" ]
            , label = "Command from filtered job"
            , key = "filtered-command"
            , target = Size.Type.Multi
            }
        ]
      }
