let Prelude = ../../External/Prelude.dhall

let Tag = ./Tag.dhall

let List/any = Prelude.List.any

let Filter = { Type = { name : Text, tags : List Tag.Type } }

let hasAny
    : Tag.Type -> List Tag.Type -> Bool
    =     \(input : Tag.Type)
      ->  \(tags : List Tag.Type)
      ->  List/any Tag.Type (\(x : Tag.Type) -> Tag.equal x input) tags

let contains
    : List Tag.Type -> List Tag.Type -> Bool
    =     \(input : List Tag.Type)
      ->  \(tags : List Tag.Type)
      ->  List/any Tag.Type (\(x : Tag.Type) -> hasAny x tags) input

in  { Type = Filter, hasAny = hasAny, contains = contains }
