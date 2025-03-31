{-|
This type represents a simple structure that binds together a `name` and a `key`.
It is primarily used in the context of dependencies within a module.
-}
let TaggedKey = { Type = { name : Text, key : Text }, default = {=} }

let ofKey
    : Text -> TaggedKey.Type
    = \(key : Text) -> { name = "", key }

in  { Type = TaggedKey.Type, ofKey }
