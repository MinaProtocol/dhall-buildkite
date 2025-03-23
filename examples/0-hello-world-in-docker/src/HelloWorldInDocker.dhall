let Base =
      https://s3.us-west-2.amazonaws.com/dhall.packages.minaprotocol.com/buildkite/releases/1.0.0/package.dhall sha256:71e937f539a066733a4918f79d65184192c35dd2c1c29cfa519e4f9e0cf9545e

let Cmd = Base.Lib.Cmds

let Pipeline = Base.Pipeline.Dsl

let JobSpec = Base.Pipeline.JobSpec

let Command = Base.Command.Base

let Docker = Base.Command.Docker.Type

let Size = Base.Command.Size

in  Pipeline.build
      Pipeline.Config::{
      ,  spec = JobSpec::{
        , name = "HelloWorldInDocker"
        , path = "."
        }
      , steps =
        [ Command.build
            Command.Config::{
            , commands = [ Cmd.run "echo hello world" ]
            , label = "Hello world"
            , key = "hello-world"
            , target = Size.Multi
            , docker = Some Docker::{ image = "debian:focal" }
            }
        ]
      }
