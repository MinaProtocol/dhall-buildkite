{-|
The `tag` module provides functionality to label annotated jobs with tags.
These tags can then be used to filter jobs based on specific criteria, 
making it easier to organize and manage jobs in a system. By associating 
tags with jobs, users can efficiently query and group jobs for processing 
or analysis.

Key Features:
- Assign tags to jobs for categorization.
- Enable job filtering based on assigned tags.
- Simplify job management and organization.

Use this module to enhance the flexibility and scalability of job handling 
in your application.

Example: 

<pre>
    ...
      JobSpec::{
        ...
        , tags = [ Tag.Fast ]
        , scope =
          [ Scope.Type.PullRequest, Scope.Type.Release, Scope.Type.Nightly ]
        }
    ...
</pre>
-}

let Prelude = ../../External/Prelude.dhall

let Natural/equal = Prelude.Natural.equal

let Tag = { id : Natural, name : Text }

let equal = \(left : Tag) -> \(right : Tag) -> Natural/equal left.id right.id

in  { Type = Tag, equal = equal }
