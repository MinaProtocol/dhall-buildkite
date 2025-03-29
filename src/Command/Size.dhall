{-|
This module defines a `Size` type and provides functions to map specific `Size` values
to agent tags in the form of a Dhall map.

- **Purpose**: The code maps `Size` enum values to corresponding agent tags, which are
    represented as a map of `Text` keys and values. This is useful for categorizing or
    tagging agents based on their size or purpose.

- **Inputs**:
    - `Size`: An enum type with the following possible values:
        - `XLarge`
        - `Large`
        - `Medium`
        - `Small`
        - `Integration`
        - `QA`
        - `Hardfork`
        - `Multi`
        - `Perf`

- **Outputs**:
    - `toAgentTag`: A function that takes a `Size` value and returns a map of agent tags
        (`Map Text Text`) corresponding to the given size.
    - `toAgent`: A function that takes a `Size` value and returns an optional map
        (`Optional (Map Text Text)`) of agent tags. If the resulting map is empty, it
        returns `None`.

-}

let Prelude = ../External/Prelude.dhall

let Map = Prelude.Map

let Size =
      < XLarge
      | Large
      | Medium
      | Small
      | Integration
      | QA
      | Hardfork
      | Multi
      | Perf
      >

let toAgentTag =
          \(target : Size)
      ->  merge
            { XLarge = toMap { size = "generic" }
            , Large = toMap { size = "generic" }
            , Medium = toMap { size = "generic" }
            , Small = toMap { size = "generic" }
            , Integration = toMap { size = "integration" }
            , QA = toMap { size = "qa" }
            , Hardfork = toMap { size = "hardfork" }
            , Perf = toMap { size = "perf" }
            , Multi = toMap { size = "generic-multi" }
            }
            target

let toAgent =
          \(target : Size)
      ->  let agents = toAgentTag target

          in        if Prelude.List.null (Map.Entry Text Text) agents

              then  None (Map.Type Text Text)

              else  Some agents

in  { Type = Size, toAgentTag = toAgentTag, toAgent = toAgent }
