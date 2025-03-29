let Base = ./Base.dhall

let Cmd = Base.Lib.Cmds

let Pipeline = Base.Pipeline.Type

let Command = Base.Command.Base

let Docker = Base.Lib.Cmds.Docker

let Size = Base.Command.Size.Type

in  Pipeline.build
      [ Command.build
          Command.Config::{
          , commands =
            [ Cmd.run "echo hello world outside docker"
            , Cmd.runInDocker
                Docker::{ image = "alpine:3.10" }
                "echo hello world in docker"
            ]
          , label = "Mixed commands"
          , key = "mixed-commands"
          , target = Size.Multi
          }
      ]
