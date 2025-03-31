{-|
# Command.Retry

This module defines a `Retry` type and a `build` function for configuring retry behavior in Buildkite command steps.

## Types

### `Retry.Type`

The `Retry.Type` represents a retry configuration with the following fields:
- `exit_status`: Specifies the exit status that triggers a retry. It can be:
  - `Code`: An integer exit code.
  - `Any`: A wildcard for any exit code.
- `limit`: An optional natural number specifying the maximum number of retries.

### `Retry.default.limit`

The default value for the `limit` field, which is `None Natural`.

## Functions

### `build`

The `build` function constructs a retry configuration for a Buildkite command step.

#### Parameters:
- `flake_retry_limit`: An optional natural number specifying the retry limit for flaky tests.
- `retries`: A list of additional retry configurations of type `Retry.Type`.

#### Returns:
A record with the following fields:
- `automatic`: A list of automatic retry configurations (`B/Retry.ListAutomaticRetry/Type`), derived from the provided `retries` and default retry rules.
- `manual`: A manual retry configuration (`B/Manual.Manual/Type`) with default settings.
-}
let Prelude = ../External/Prelude.dhall

let B = ../External/Buildkite.dhall

let List/map = Prelude.List.map

let Optional/map = Prelude.Optional.map

let B/ExitStatus = B.definitions/automaticRetry/properties/exit_status/Type

let B/AutoRetryChunk = B.definitions/automaticRetry/Type.Type

let B/Retry =
      B.definitions/commandStep/properties/retry/properties/automatic/Type

let B/Manual = B.definitions/commandStep/properties/retry/properties/manual/Type

let ExitStatus = < Code : Integer | Any >

let Retry =
      { Type = { exit_status : ExitStatus, limit : Optional Natural }
      , default.limit = None Natural
      }

let build =
      \(flake_retry_limit : Optional Natural) ->
      \(retries : List Retry.Type) ->
        { automatic = Some
            ( let xs
                  : List B/AutoRetryChunk
                  = List/map
                      Retry.Type
                      B/AutoRetryChunk
                      ( \(retry : Retry.Type) ->
                          { exit_status = Some
                              ( merge
                                  { Code =
                                      \(i : Integer) -> B/ExitStatus.Integer i
                                  , Any = B/ExitStatus.String "*"
                                  }
                                  retry.exit_status
                              )
                          , limit =
                              Optional/map
                                Natural
                                Integer
                                Natural/toInteger
                                retry.limit
                          }
                      )
                      (   [ Retry::{
                            , exit_status = ExitStatus.Code -1
                            , limit = Some 4
                            }
                          , Retry::{
                            , exit_status = ExitStatus.Code +255
                            , limit = Some 4
                            }
                          , Retry::{
                            , exit_status = ExitStatus.Code +1
                            , limit = flake_retry_limit
                            }
                          , Retry::{
                            , exit_status = ExitStatus.Code +100
                            , limit = Some 4
                            }
                          , Retry::{
                            , exit_status = ExitStatus.Code +128
                            , limit = Some 4
                            }
                          , Retry::{
                            , exit_status = ExitStatus.Code +143
                            , limit = Some 4
                            }
                          , Retry::{
                            , exit_status = ExitStatus.Code +125
                            , limit = Some 4
                            }
                          ]
                        # retries
                      )

              in  B/Retry.ListAutomaticRetry/Type xs
            )
        , manual = Some
            ( B/Manual.Manual/Type
                { allowed = Some True
                , permit_on_passed = Some True
                , reason = None Text
                }
            )
        }

in  { Type = Retry.Type, build }
