let Prelude = ./Prelude.dhall

let List/map = Prelude.List.map

let Base = ./Base.dhall

let SelectFiles = Base.Lib.SelectFiles

let Cmd = Base.Lib.Cmds

let Command = Base.Command.Base

let Docker = Base.Plugin.Docker.Type

let JobSpec = Base.Pipeline.Annotated.JobSpec

let Scope = Base.Pipeline.Annotated.Scope

let Pipeline = Base.Pipeline.Annotated.Type

let BaseFilter = Base.Pipeline.Annotated.Filter

let BaseTag = Base.Pipeline.Annotated.Tag

let BaseMonorepo = Base.Pipeline.Annotated.Monorepo

let Filter = ./Filters/Filter.dhall

let Tag = ./Filters/Tag.dhall

let Size = Base.Command.Size.Type

let triggerCommand = Base.Pipeline.Annotated.TriggerCommand

let jobs
    : List JobSpec.Type
    = List/map
        Pipeline.Type
        JobSpec.Type
        (\(pipeline : Pipeline.Type) -> pipeline.spec)
        [ ./Jobs/FilteredJob.dhall, ./Jobs/UnFilteredJob.dhall ]

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
