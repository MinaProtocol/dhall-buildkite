let Base = ../Base.dhall

let Cmd = Base.Lib.Cmds

let Pipeline = Base.Pipeline.Annotated.Type

let JobSpec = Base.Pipeline.Annotated.JobSpec

let Scope = Base.Pipeline.Annotated.Scope

let Command = Base.Command.Base

let TaggedKey = Base.Command.TaggedKey

let S = Base.Lib.SelectFiles

let Cmds = Base.Lib.Cmds

let Docker = Cmds.Docker

let Size = Base.Command.Size.Type

let Tag = ../Filters/Tag.dhall

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
            , target = Size.Multi
            }
        ]
      }
