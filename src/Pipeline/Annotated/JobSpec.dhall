{-|
This module is responsible for aggregating runtime job data, which can be
utilized to help organize and manage pipelines effectively. It provides
functionality to collect, process, and structure job-related information
to streamline pipeline execution.
-}
let SelectFiles = ../../Lib/SelectFiles.dhall

let Scope = ./Scope.dhall

let Tag = ./Tag.dhall

in  { Type =
        { path : Text
        , name : Text
        , scope : List Scope.Type
        , dirtyWhen : List SelectFiles.Type
        , tags : List Tag.Type
        }
    , default =
      { path = "."
      , name = ""
      , scope = [ Scope.Type.PullRequest ]
      , dirtyWhen = [] : List SelectFiles.Type
      , tags = [] : List Tag.Type
      }
    }
