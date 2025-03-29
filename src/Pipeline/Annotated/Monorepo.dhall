let Tag = ./Tag.dhall

let Scope = ./Scope.dhall

let JobSpec = ./JobSpec.dhall

let Cmd = ../../Lib/Cmds.dhall

let Pipeline = ../../Pipeline/Annotated/Type.dhall

let Prelude = ../../External/Prelude.dhall

let List/map = Prelude.List.map

let SelectFiles = ../../Lib/SelectFiles.dhall

let Filter = ./Filter.dhall

let Command = ../../Command/Base.dhall

let Size = ../../Command/Size.dhall

let triggerCommand = ./TriggerCommand.dhall

let commands
    : List Tag.Type -> Text  -> Scope.Type -> List JobSpec.Type -> List Cmd.Type
    =     \(tags : List Tag.Type)
      ->  \(filterName : Text)
      ->  \(scope : Scope.Type)
      ->  \(jobs : List JobSpec.Type)
      ->  List/map
            JobSpec.Type
            Cmd.Type
            (     \(job : JobSpec.Type)
              ->  let targetScope = Scope.capitalName scope


                  let dirtyWhen = SelectFiles.compile job.dirtyWhen

                  let trigger =
                        triggerCommand "src/Jobs/${job.path}/${job.name}.dhall"

                  in        if Filter.contains job.tags tags

                      then  let cmd =
                        
                                  if Scope.hasAny scope job.scope 

                                  then  ''
                                          echo "Triggering ${job.name} because this is a release buildkite run"
                                          ${Cmd.format trigger}
                                        ''

                                  else  if Scope.hasAny scope job.scope 

                                  then  ''
                                          echo "Triggering ${job.name} because this is a nightly buildkite run"
                                          ${Cmd.format trigger}
                                        ''
                        
                                  else if Scope.hasAny scope job.scope 

                                  then  ''
                                          if (cat _computed_diff.txt | egrep -q '${dirtyWhen}'); then
                                                echo "Triggering ${job.name} for reason:"
                                                cat _computed_diff.txt | egrep '${dirtyWhen}'
                                                ${Cmd.format trigger}
                                          fi
                                        ''

                        

                                  else  ''
                                          echo "Skipping ${job.name} because it does not run at any scope"
                                        ''

                            in  Cmd.quietly cmd

                      else  Cmd.quietly
                              ''
                                echo "Skipping ${job.name} because this is a ${filterName} stage"
                              ''
            )
            jobs


in      \(filterName : Text)
    ->  \(tags: List Tag.Type ) 
    ->  \(scope : Scope.Type )
    ->  \(jobs : List JobSpec.Type)
    ->  \(prefixCommands : List Cmd.Type)
    ->  let pipelineType =
              Pipeline.build
                Pipeline.Config::{
                , spec = JobSpec::{
                  , name = "monorepo-triage-${filterName}"
                  , dirtyWhen = [ SelectFiles.everything ]
                  }
                , steps =
                  [ Command.build
                      Command.Config::{
                      , commands =
                          prefixCommands # commands tags filterName scope jobs
                      , label =
                          "Monorepo triage ${filterName}"
                      , key = "cmds-${filterName}"
                      , target = Size.Type.Multi
                      }
                  ]
                }

        in  pipelineType.pipeline
