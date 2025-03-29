-- Tag defines pipeline
-- Using tags one can tailor pipeline for any need. Each job should be tagged with one or several tags
-- then on pipeline settings we can define which tagged jobs to include or exclue in pipeline

let Tag = { Type = { id : Natural, name : Text } }

in  { Fast = { id = 1, name = "Fast" }
    , Long = { id = 2, name = "Long" }
    , Type = Tag.Type
    }
