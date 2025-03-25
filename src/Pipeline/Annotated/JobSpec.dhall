let SelectFiles = ../../Lib/SelectFiles.dhall

let Scope = ./Scope.dhall

in  { Type =
        { path : Text
        , name : Text
        , scope : Scope.Type
        , dirtyWhen : List SelectFiles.Type
        }
    , default =
        { path = "."
        , name = ""
        , scope = Scope.Type.PullRequest
        , dirtyWhen = [] : List SelectFiles.Type
        }
    }
