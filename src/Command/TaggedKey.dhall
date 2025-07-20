{-|
This type represents a simple structure that binds together a `name` and a `key`.
It is primarily used in the context of dependencies within a module.
-}
let TaggedKey = { Type = { name : Optional Text, key : Text }, default = {=} }

let keyOnly
    : Text -> TaggedKey.Type
    = \(key : Text) -> { name = None Text, key = key }

let namedKey
    : Text -> Text -> TaggedKey.Type
    = \(name : Text) -> \(key : Text) -> { name = Some name, key = key }

in  { Type = TaggedKey.Type
    , keyOnly = keyOnly
    , namedKey = namedKey
    , default = {=}
    }
