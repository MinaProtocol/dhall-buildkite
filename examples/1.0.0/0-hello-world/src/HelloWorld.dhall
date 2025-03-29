let Base = ./Base.dhall

let Cmd = Base.Lib.Cmds

let Pipeline = Base.Pipeline.Type

let Command = Base.Command.Base

let Size = Base.Command.Size.Type

in  Pipeline.build
      [ Command.build
          Command.Config::{
          , commands = [ Cmd.run "echo hello world" ]
          , label = "Hello world"
          , key = "hello-world"
          , target = Size.Multi
          }
      ]
