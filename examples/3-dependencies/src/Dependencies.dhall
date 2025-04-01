let Base = ./Base.dhall

let Command = Base.Command.Base

let Cmd = Base.Lib.Cmds

let Pipeline = Base.Pipeline.Type

let TaggedKey = Base.Command.TaggedKey

let Size = Base.Command.Size.Type

in  Pipeline.build
      [ Command.build
          Command.Config::{
          , commands = [ Cmd.run "echo cmd 1" ]
          , label = "First command"
          , key = "mixed-commands-1"
          , target = Size.Multi
          }
      , Command.build
          Command.Config::{
          , commands = [ Cmd.run "echo cmd 2" ]
          , label = "Second command"
          , key = "mixed-commands-2"
          , target = Size.Multi
          , depends_on = [ TaggedKey.ofKey "mixed-commands-1" ]
          }
      ]
