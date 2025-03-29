let Base =
      https://s3.us-west-2.amazonaws.com/dhall.packages.minaprotocol.com/buildkite/releases/1.0.0/package.dhall sha256:e9f8f4891b01836575b565eb9d9f56bfe40eb4cc5b3f617c93f563d74ef5288c

let Cmd = Base.Lib.Cmds

let Pipeline = Base.Pipeline.Type

let Command = Base.Command.Base

let Size = Base.Command.Size

in  Pipeline.build
      [ Command.build
          Command.Config::{
          , commands = [ Cmd.run "echo hello world" ]
          , label = "Hello world"
          , key = "hello-world"
          , target = Size.Multi
          }
      ]
