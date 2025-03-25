let Prelude = ../External/Prelude.dhall

let B = ../External/Buildkite.dhall

let List/map = Prelude.List.map

let TaggedKey = ./TaggedKey.dhall

let OuterUnion/Type = B.definitions/dependsOn/Type

let InnerUnion/Type = B.definitions/dependsOn/union/Type

let DependsOn =
      { Type = OuterUnion/Type
      , depends =
              \(keys : List Text)
          ->  OuterUnion/Type.ListDependsOn/Type
                ( List/map
                    Text
                    InnerUnion/Type
                    (     \(k : Text)
                      ->  InnerUnion/Type.DependsOn/Type
                            { allow_failure = Some False, step = Some k }
                    )
                    keys
                )
      }

let ofTexts =
          \(keys : List Text)
      ->        if Prelude.List.null Text keys

          then  None DependsOn.Type

          else  Some (DependsOn.depends keys)

let ofTaggedKeys =
          \(keys : List TaggedKey.Type)
      ->  let flattened =
                List/map
                  TaggedKey.Type
                  Text
                  (\(k : TaggedKey.Type) -> "_${k.name}-${k.key}")
                  keys

          in  ofTexts flattened

in  { DependsOn = DependsOn, ofTaggedKeys = ofTaggedKeys, ofTexts = ofTexts }
