-- Commands are the individual command steps that CI runs

let B = ../External/Buildkite.dhall

let Retry = ./Retry.dhall

let B/SoftFail = B.definitions/commandStep/properties/soft_fail/Type

let B/Skip = B.definitions/commandStep/properties/skip/Type

let B/If = B.definitions/commandStep/properties/if/Type

let Cmd = ../Lib/Cmds.dhall

let Decorate = ../Lib/Decorate.dhall

let SelectFiles = ../Lib/SelectFiles.dhall

let Docker = ../Plugin/Docker/Type.dhall

let DockerLogin = ../Plugin/DockerLogin/Type.dhall

let Summon = ../Plugin/Summon/Type.dhall

let Plugins = ../Plugin/Type.dhall

let Size = ./Size.dhall

let ArtifactPaths = ./ArtifactPaths.dhall

let DependsOn = ./DependsOn.dhall

let B/Command =
      B.definitions/commandStep/Type Text Text Plugins.Type Plugins.Type

let TaggedKey = ./TaggedKey.dhall

let Config =
      { Type =
          { commands : List Cmd.Type
          , depends_on : List TaggedKey.Type
          , artifact_paths : List SelectFiles.Type
          , env : List TaggedKey.Type
          , label : Text
          , key : Text
          , target : Size.Type
          , docker : Optional Docker.Type
          , docker_login : Optional DockerLogin.Type
          , summon : Optional Summon.Type
          , retries : List Retry.Type
          , flake_retry_limit : Optional Natural
          , soft_fail : Optional B/SoftFail
          , skip : Optional B/Skip
          , if : Optional B/If
          , timeout_in_minutes : Optional Integer
          }
      , default =
          { depends_on = [] : List TaggedKey.Type
          , docker = None Docker.Type
          , docker_login = None DockerLogin.Type
          , summon = None Summon.Type
          , artifact_paths = [] : List SelectFiles.Type
          , env = [] : List TaggedKey.Type
          , retries = [] : List Retry.Type
          , flake_retry_limit = Some 0
          , soft_fail = None B/SoftFail
          , skip = None B/Skip
          , if = None B/If
          , timeout_in_minutes = None Integer
          }
      }

let build
    : Config.Type -> B/Command.Type
    =     \(c : Config.Type)
      ->  B/Command::{
          , agents = Size.toAgent c.target
          , commands =
              B.definitions/commandStep/properties/commands/Type.ListString
                (Decorate.decorateAll c.commands)
          , depends_on = DependsOn.ofTaggedKeys c.depends_on
          , artifact_paths = ArtifactPaths c.artifact_paths
          , key = Some c.key
          , label = Some c.label
          , timeout_in_minutes = c.timeout_in_minutes
          , retry = Some (Retry.build c.flake_retry_limit c.retries)
          , soft_fail = c.soft_fail
          , skip = c.skip
          , if = c.if
          , plugins = Plugins.build c.docker c.docker_login c.summon
          }

in  { Config = Config, build = build, Type = B/Command.Type }
