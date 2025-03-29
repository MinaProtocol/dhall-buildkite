-- Tag defines pipeline
-- Using tags one can tailor pipeline for any need. Each job should be tagged with one or several tags
-- then on pipeline settings we can define which tagged jobs to include or exclue in pipeline

let Tag = ./Tag.dhall

let Filter = { Type = { name : Text, tags : List Tag.Type } }

in  { FastOnly = { name = "FastOnly", tags = [ Tag.Fast ] }
    , LongOnly = { name = "LongOnly", tags = [ Tag.Long ] }
    , Type = Filter.Type
    }
