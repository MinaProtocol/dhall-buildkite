-- A Pipeline is a series of build steps --
let Command = ../Command/Base.dhall

let Prelude = ../External/Prelude.dhall

let Config = List Command.Type

let List/map = Prelude.List.map

let build
    : Config -> List Command.Type
    = \(c : Config) ->
        let buildCommand =
              \(c : Command.Type) ->
                    c
                //  { key = Some
                        ( Prelude.Optional.fold
                            Text
                            c.key
                            Text
                            (\(k : Text) -> k)
                            ""
                        )
                    }

        in  List/map Command.Type Command.Type buildCommand c

in  { build, Type = Config }
