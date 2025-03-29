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
