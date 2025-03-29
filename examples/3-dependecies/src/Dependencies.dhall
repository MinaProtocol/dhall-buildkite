let Base = ../../../src/Command/Base.dhall

let Cmd = ../../../src/Lib/Cmds.dhall

let Pipeline = ../../../src/Pipeline/Type.dhall

let Command = ../../../src/Command/Base.dhall

let TaggedKey = ../../../src/Command/TaggedKey.dhall

let Cmds = ../../../src/Lib/Cmds.dhall

let Docker = Cmds.Docker

let Size = ../../../src/Command/Size.dhall

in  Pipeline.build
      [ Command.build
          Command.Config::{
          , commands = [ Cmd.run "echo hello world outside docker" ]
          , label = "Mixed commands"
          , key = "mixed-commands"
          , target = Size.Type.Multi
          }
      , Command.build
          Command.Config::{
          , commands = [ Cmd.run "echo hello world outside docker" ]
          , label = "Mixed commands"
          , key = "mixed-commands"
          , target = Size.Type.Multi
          , depends_on = [ TaggedKey.ofKey "mixed-commands" ]
          }
      ]
