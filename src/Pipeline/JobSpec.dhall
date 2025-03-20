let SelectFiles = ../Lib/SelectFiles.dhall

let PipelineMode = ./Mode.dhall

in  { Type =
        { path : Text
        , name : Text
        , mode : PipelineMode.Type
        , dirtyWhen : List SelectFiles.Type
        }
    , default = { path = ".", mode = PipelineMode.Type.PullRequest }
    }
