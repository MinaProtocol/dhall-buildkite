-- An Annotated Pipeline is a series of build steps with accompanying JobSpec,
-- information which is used to runtime pipeline handle.
--
let Command = ../../Command/Base.dhall

let JobSpec = ./JobSpec.dhall

let Pipeline = ../Type.dhall

let Config =
      { Type = { spec : JobSpec.Type, steps : List Command.Type }
      , default = {=}
      }

let AnnotatedType = { pipeline : Pipeline.Type, spec : JobSpec.Type }

let build
    : Config.Type -> AnnotatedType
    = \(c : Config.Type) -> { pipeline = Pipeline.build c.steps, spec = c.spec }

in  { Config, build, Type = AnnotatedType }
