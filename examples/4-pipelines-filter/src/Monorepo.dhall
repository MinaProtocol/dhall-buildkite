let Prelude = ../../../src/External/Prelude.dhall

let List/map = Prelude.List.map

let SelectFiles = ../../../src/Lib/SelectFiles.dhall

let Cmd = ../../../src/Lib/Cmds.dhall

let Command = ../../../src/Command/Base.dhall

let Docker = ../../../src/Plugin/Docker/Type.dhall

let JobSpec = ../../../src/Pipeline/Annotated/JobSpec.dhall

let Scope = ../../../src/Pipeline/Annotated/Scope.dhall

let Pipeline = ../../../src/Pipeline/Annotated/Type.dhall

let BaseFilter = ../../../src/Pipeline/Annotated/Filter.dhall

let BaseTag = ../../../src/Pipeline/Annotated/Tag.dhall

let BaseMonorepo = ../../../src/Pipeline/Annotated/Monorepo.dhall

let Filter = ./Filter.dhall

let Tag = ./Tag.dhall

let Size = ../../../src/Command/Size.dhall

let triggerCommand = ../../../src/Pipeline/Annotated/TriggerCommand.dhall

let jobs
    : List JobSpec.Type
    = List/map
        Pipeline.Type
        JobSpec.Type
        (\(pipeline : Pipeline.Type) -> pipeline.spec)
        [ ./FilteredJob.dhall, ./UnFilteredJob.dhall ]

let prefixCommands =
      [ Cmd.run
          "git config --global http.sslCAInfo /etc/ssl/certs/ca-bundle.crt"
      , Cmd.run "./generate-diff.sh > _computed_diff.txt"
      ]

in      \(args : { filter : Filter.Type, scope : Scope.Type })
    ->  BaseMonorepo
          args.filter.name
          args.filter.tags
          args.scope
          jobs
          prefixCommands
