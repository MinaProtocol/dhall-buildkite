{-|
This module aggregates support for three plugins in Buildkite:

1. **Docker**: Provides functionality for managing Docker containers within Buildkite pipelines.
2. **Docker Login**: Handles authentication with Docker registries to enable pulling and pushing Docker images.
3. **Summon**: Integrates with Summon to securely inject AWS environment variables into the Buildkite pipeline.

By combining these plugins, this module simplifies the configuration and management of Buildkite pipelines that require Docker operations, secure registry access, and AWS environment variable handling.
-}
let B = ../External/Buildkite.dhall

let Prelude = ../External/Prelude.dhall

let Docker = ../Plugin/Docker/Type.dhall

let DockerLogin = ../Plugin/DockerLogin/Type.dhall

let Summon = ../Plugin/Summon/Type.dhall

let Optional/map = Prelude.Optional.map

let Optional/toList = Prelude.Optional.toList

let Map = Prelude.Map

let List/concat = Prelude.List.concat

let B/Plugins/Partial = B.definitions/commandStep/properties/plugins/Type

let Plugins =
      < Docker : Docker.Type
      | DockerLogin : DockerLogin.Type
      | Summon : Summon.Type
      >

let B/Plugins = B/Plugins/Partial Plugins Plugins

let dockerPart =
      \(docker : Optional Docker.Type) ->
        Optional/toList
          (Map.Type Text Plugins)
          ( Optional/map
              Docker.Type
              (Map.Type Text Plugins)
              ( \(docker : Docker.Type) ->
                  toMap { `docker#v3.5.0` = Plugins.Docker docker }
              )
              docker
          )

let dockerLoginPart =
      \(docker_login : Optional DockerLogin.Type) ->
        Optional/toList
          (Map.Type Text Plugins)
          ( Optional/map
              DockerLogin.Type
              (Map.Type Text Plugins)
              ( \(dockerLogin : DockerLogin.Type) ->
                  toMap
                    { `docker-login#v2.0.1` = Plugins.DockerLogin dockerLogin }
              )
              docker_login
          )

let summonPart =
      \(summon : Optional Summon.Type) ->
        Optional/toList
          (Map.Type Text Plugins)
          ( Optional/map
              Summon.Type
              (Map.Type Text Plugins)
              ( \(summon : Summon.Type) ->
                  toMap { `angaza/summon#v0.1.0` = Plugins.Summon summon }
              )
              summon
          )

let allPlugins =
      \(d : Optional Docker.Type) ->
      \(dl : Optional DockerLogin.Type) ->
      \(s : Optional Summon.Type) ->
        List/concat
          (Map.Entry Text Plugins)
          (dockerPart d # summonPart s # dockerLoginPart dl)

let build =
      \(d : Optional Docker.Type) ->
      \(dl : Optional DockerLogin.Type) ->
      \(s : Optional Summon.Type) ->
        if    Prelude.List.null (Map.Entry Text Plugins) (allPlugins d dl s)
        then  None B/Plugins
        else  Some (B/Plugins.Plugins/Type (allPlugins d dl s))

in  { docker = dockerPart
    , dockerLogin = dockerLoginPart
    , summon = summonPart
    , allPlugins
    , Type = Plugins
    , build
    }
