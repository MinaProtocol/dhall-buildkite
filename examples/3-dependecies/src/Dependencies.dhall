let Base = ../../../src/Command/Base.dhall
let Cmd = ../../../src/Lib/Cmds.dhall
let Pipeline = ../../../src/Pipeline/Type.dhall
let Command = ../../../src/Command/Base.dhall
let Cmds = ../../../src/Lib/Cmds.dhall
let Docker = Cmds.Docker
let Size = ../../../src/Command/Size.dhall
   
--let Cmd = Base.Lib.Cmds

--let Pipeline = Base.Pipeline.Dsl

--let JobSpec = Base.Pipeline.JobSpec

--let Command = Base.Command.Base

--let Docker = Base.Lib.Cmds.Docker

-- let Size = Base.Command.Size

in  Pipeline.build
        [ Command.build
            Command.Config::{
            , commands = [ 
                Cmd.run "echo hello world outside docker" 
              ]
            , label = "Mixed commands"
            , key = "mixed-commands"
            , target = Size.Type.Multi
            }
          ,
          Command.build
            Command.Config::{
            , commands = [ 
                Cmd.run "echo hello world outside docker" 
              ]
            , label = "Mixed commands"
            , key = "mixed-commands"
            , target = Size.Type.Multi
            , depends_on = [ "mixed-commands" ]
            }
        ]
      
