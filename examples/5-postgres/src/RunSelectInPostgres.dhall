let Base = ./Base.dhall

let Command = Base.Command.Base

let Cmd = Base.Lib.Cmds

let Pipeline = Base.Pipeline.Type

let TaggedKey = Base.Command.TaggedKey

let Size = Base.Command.Size.Type

let Postgres = Base.Steps.Postgres.Type

let spec =
      Postgres.Spec::{
      , initDb = "./examples/1.1.0/0-postgres/src/init_db.sql"
      , cmd =
          Cmd.run
            "psql ////\$PG_CONN -c 'SELECT * FROM users' --no-align --tuples-only"
      }

in  Pipeline.build
      [ Command.build
          Command.Config::{
          , commands = Postgres.runWith spec
          , label = "Simple Select in postgres"
          , key = "select-in-postgres"
          , target = Size.Multi
          }
      ]
