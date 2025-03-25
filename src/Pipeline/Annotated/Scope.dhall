-- Scope defines job selection strategy based on the type of the change
--
-- Goal of the pipeline can be either quick feedback for CI changes
-- or Nightly run which supposed to be run only on stable changes.
-- PullRequest - filter eligible jobs based on tags and then apply triage based on changed made in PR
-- Stable - filter only eligible jobs and do not perform triage

let Scope = < PullRequest | Stable | Both >

let capitalName =
          \(scope : Scope)
      ->  merge
            { PullRequest = "PullRequest", Stable = "Stable", Both = "Both" }
            scope

let isStable =
          \(scope : Scope)
      ->  merge { PullRequest = False, Stable = True, Both = True } scope

in  { Type = Scope, capitalName = capitalName, isStable = isStable }
