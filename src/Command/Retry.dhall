-- Commands are the individual command steps that CI runs

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
          \(flake_retry_limit : Optional Natural)
      ->  \(retries : List Retry.Type)
      ->  { automatic = Some
              ( let xs
                    : List B/AutoRetryChunk
                    = List/map
                        Retry.Type
                        B/AutoRetryChunk
                        (     \(retry : Retry.Type)
                          ->  { exit_status = Some
                                  ( merge
                                      { Code =
                                              \(i : Integer)
                                          ->  B/ExitStatus.Integer i
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

in  { Type = Retry.Type, build = build }
