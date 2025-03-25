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
