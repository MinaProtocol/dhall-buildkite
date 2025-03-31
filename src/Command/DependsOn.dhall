{-|
# Command.DependsOn

This module provides utilities for working with the `DependsOn` type, which
is used to define dependencies between steps in a Buildkite pipeline.

## Types

### `DependsOn.Type`

The `DependsOn.Type` is an alias for the `OuterUnion/Type` defined in the
Buildkite schema. It represents the type of a dependency.

## Functions

### `DependsOn.depends`

This function takes a list of `Text` keys and produces a `DependsOn.Type`
value that represents a list of dependencies. Each dependency is created
with `allow_failure` set to `Some False` and `step` set to the corresponding
key.

#### Example:

<pre>
  ...
   depends_on = [ { name="job-name" , key="step-key"  }]
  ...
</pre>

Above code is used in Base.dhall to define the `depends_on` field in a Buildkite
pipeline.

See TaggedKey.dhall for more details.

-}
let Prelude = ../External/Prelude.dhall

let B = ../External/Buildkite.dhall

let TaggedKey = ./TaggedKey.dhall

let List/map = Prelude.List.map

let OuterUnion/Type = B.definitions/dependsOn/Type

let InnerUnion/Type = B.definitions/dependsOn/union/Type

let DependsOn =
      { Type = OuterUnion/Type
      , depends =
          \(keys : List Text) ->
            OuterUnion/Type.ListDependsOn/Type
              ( List/map
                  Text
                  InnerUnion/Type
                  ( \(k : Text) ->
                      InnerUnion/Type.DependsOn/Type
                        { allow_failure = Some False, step = Some k }
                  )
                  keys
              )
      }

let ofTexts =
      \(keys : List Text) ->
        if    Prelude.List.null Text keys
        then  None DependsOn.Type
        else  Some (DependsOn.depends keys)

let ofTaggedKeys =
      \(keys : List TaggedKey.Type) ->
        let flattened =
              List/map
                TaggedKey.Type
                Text
                (\(k : TaggedKey.Type) -> "_${k.name}-${k.key}")
                keys

        in  ofTexts flattened

in  { DependsOn, ofTaggedKeys, ofTexts }
