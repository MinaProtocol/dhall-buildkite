{-|
  Module run command in postgres docker container. It can also setup the database.
  Please refer to examples for usage.

-}
let Cmd = ../../Lib/Cmds.dhall

let Spec =
      { Type =
          { environment : List Text
          , initDb : Text
          , version : Text
          , cmd : Cmd.Type
          }
      , default =
        { environment = [] : List Text, initDb = Text, version = "12.4-alpine" }
      }

let Db =
      { Type = { port : Text, user : Text, dbName : Text, password : Text }
      , default =
        { port = "5432"
        , user = "postgres"
        , password = "postgres"
        , dbName = "archive"
        }
      }

let conn
    : Db.Type -> Text
    = \(db : Db.Type) ->
        "postgres://${db.user}:${db.password}@localhost:${db.port}/${db.dbName}"

let dockerName = "postgres"

let setupDb
    : Spec.Type -> Cmd.Type
    = \(spec : Spec.Type) ->
        let db = Db.default

        let outerDir
            : Text
            = "\\\$BUILDKITE_BUILD_CHECKOUT_PATH"

        in  Cmd.chain
              [ "( docker stop ${dockerName} && docker rm ${dockerName} ) || true"
              , "docker run --network host --volume ${outerDir}:/workdir --workdir /workdir --name ${dockerName} -d -e POSTGRES_USER=${db.user} -e POSTGRES_PASSWORD=${db.password} -e POSTGRES_DB=${db.dbName} postgres:${spec.version}"
              , "sleep 5"
              , "docker exec ${dockerName} psql ${conn
                                                    db} -f /workdir/${spec.initDb}"
              ]

let runWith
    : Spec.Type -> List Cmd.Type
    = \(spec : Spec.Type) ->
        [ setupDb spec
        , spec.cmd
        , Cmd.run "docker stop ${dockerName}"
        , Cmd.run "docker rm ${dockerName}"
        ]

in  { runWith, setupDb, Spec }
