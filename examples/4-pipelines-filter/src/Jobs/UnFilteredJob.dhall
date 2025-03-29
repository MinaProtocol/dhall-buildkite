let Base = ../../../src/Command/Base.dhall

let Cmd = ../../../src/Lib/Cmds.dhall

let Pipeline = ../../../src/Pipeline/Annotated/Type.dhall

let JobSpec = ../../../src/Pipeline/Annotated/JobSpec.dhall

let Scope = ../../../src/Pipeline/Annotated/Scope.dhall

let Command = ../../../src/Command/Base.dhall

let TaggedKey = ../../../src/Command/TaggedKey.dhall

let Cmds = ../../../src/Lib/Cmds.dhall

let S = ../../../src/Lib/SelectFiles.dhall

let Docker = Cmds.Docker

let Size = ../../../src/Command/Size.dhall

let Tag = ./Tag.dhall

in  Pipeline.build
      Pipeline.Config::{
      , spec = JobSpec::{
        , dirtyWhen = [ S.strictlyStart (S.contains "filtered") ]
        , path = "."
        , name = "UnFilteredJob"
        , tags = [ Tag.Long ]
        }
      , steps =
        [ Command.build
            Command.Config::{
            , commands = [ Cmd.run "echo from not filtered job" ]
            , label = "Command from not filtered job"
            , key = "not-filtered-command"
            , target = Size.Type.Multi
            }
        ]
      }
