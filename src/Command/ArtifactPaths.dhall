{-|

Defines a function that processes a list of artifact paths
and returns a Buildkite-compatible artifact paths type.

It is used to bridge artifact path definitions with Buildkite's requirements.

-}
let B = ../External/Buildkite.dhall

let Prelude = ../External/Prelude.dhall

let SelectFiles = ../Lib/SelectFiles.dhall

let B/ArtifactPaths = B.definitions/commandStep/properties/artifact_paths/Type

in  \(artifact_paths : List SelectFiles.Type) ->
      if    Prelude.List.null SelectFiles.Type artifact_paths
      then  None B/ArtifactPaths
      else  Some (B/ArtifactPaths.String (SelectFiles.compile artifact_paths))
