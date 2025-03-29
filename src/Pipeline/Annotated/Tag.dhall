let Prelude = ../../External/Prelude.dhall

let Natural/equal = Prelude.Natural.equal

let Tag = { id : Natural, name : Text }



let equal = 
    \(left: Tag) 
    -> \(right: Tag) -> Natural/equal left.id right.id
in

{ Type = Tag, equal = equal }