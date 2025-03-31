{- Scope defines job selection strategy based on the type of the change

 Goal of the pipeline can be either quick feedback for CI changes
 or Nightly run which supposed to be run only on nightly changes.
 PullRequest - filter eligible jobs based on Scopes and then apply triage based on changed made in PR
 Stable - filter only eligible jobs and do not perform triage
-}
let Prelude = ../../External/Prelude.dhall

let List/any = Prelude.List.any

let Scope = < PullRequest | Nightly | Release >

let toNatural =
      \(scope : Scope) ->
        merge { PullRequest = 0, Nightly = 1, Release = 2 } scope

let equal
    : Scope -> Scope -> Bool
    = \(left : Scope) ->
      \(right : Scope) ->
        Prelude.Natural.equal (toNatural left) (toNatural right)

let hasAny
    : Scope -> List Scope -> Bool
    = \(input : Scope) ->
      \(scopes : List Scope) ->
        List/any Scope (\(x : Scope) -> equal x input) scopes

let contains
    : List Scope -> List Scope -> Bool
    = \(left : List Scope) ->
      \(right : List Scope) ->
        List/any Scope (\(x : Scope) -> hasAny x left) right

let capitalName =
      \(scope : Scope) ->
        merge
          { PullRequest = "PullRequest"
          , Release = "Release"
          , Nightly = "Nightly"
          }
          scope

let isStable =
      \(scope : Scope) ->
        merge { PullRequest = False, Release = True, Nightly = True } scope

in  { Type = Scope, capitalName, isStable, toNatural, equal, hasAny, contains }
