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
            , target = Size.Multi
            }
        ]
      }
