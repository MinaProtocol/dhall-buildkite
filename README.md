# Dhall Buildkite

`dhall-buildkite` is a foundational library for managing and organizing Dhall configurations. It provides reusable modules and utilities to simplify working with Dhall in your projects.

## Features

- Modular and reusable Dhall configurations.
- Simplified management of complex Dhall expressions.
- Easy integration with existing Dhall-based workflows.
- Simple Pipeline for easy workflows.
- Monorepo diff for Advanced usages.

## Installation

Clone the repository:

```bash
git clone https://github.com/MinaProtocol/dhall-buildkite.git
cd dhall-buildkite
```

## Usage

Import the desired modules into your Dhall configuration:

```dhall
let Base = https://s3.us-west-2.amazonaws.com/dhall.packages.minaprotocol.com/buildkite/releases/1.0.0/package.dhall sha256:95cffbe6d58a0054d007ef857ddd1a26d323431ad4011eee6b01b5ad0e266d37

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

```

[Documentation](https://s3.us-west-2.amazonaws.com/dhall.packages.minaprotocol.com/buildkite/releases/index.html)

See examples for more usages

## License

This project is licensed under the [MIT License](LICENSE).
