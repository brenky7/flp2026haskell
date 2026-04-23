-- | Filtering test cases by include and exclude criteria.
--
-- The filtering algorithm is a two-phase set operation:
--
-- 1. __Include__: if no include criteria are given, all tests are included;
--    otherwise only tests matching at least one include criterion are kept.
--
-- 2. __Exclude__: tests matching any exclude criterion are removed from the
--    included set.
module SOLTest.Filter
  ( filterTests,
    matchesCriterion,
    matchesAny,
    trimFilterId,
  )
where

import Data.Char (isSpace)
import SOLTest.Types

-- ---------------------------------------------------------------------------
-- Public API
-- ---------------------------------------------------------------------------

-- | Apply a 'FilterSpec' to a list of test definitions.
--
-- Returns a pair @(selected, filteredOut)@ where:
--
-- * @selected@ are the tests that passed both include and exclude checks.
-- * @filteredOut@ are the tests that were removed by filtering.
--
-- The union of @selected@ and @filteredOut@ always equals the input list.
filterTests ::
  FilterSpec ->
  [TestCaseDefinition] ->
  ([TestCaseDefinition], [TestCaseDefinition])
filterTests spec tests =
  let useRegex = fsUseRegex spec
      includes = fsIncludes spec
      excludes = fsExcludes spec
      -- Ziadne includes = kazdy test je selected
      -- Inak musi mat aspon jeden include matchnuty
      isIncluded t = null includes || matchesAny useRegex includes t
      -- Excludu je silnejsi ako include preto ak matchne exclude, test vypadne
      keep t = isIncluded t && not (matchesAny useRegex excludes t)
   in -- filter pre selected a filteredOut
      (filter keep tests, filter (not . keep) tests)

-- | Check whether a test matches at least one criterion in the list.
matchesAny :: Bool -> [FilterCriterion] -> TestCaseDefinition -> Bool
matchesAny useRegex criteria test =
  any (matchesCriterion useRegex test) criteria

-- | Check whether a test matches a single 'FilterCriterion'.
--
-- When @useRegex@ is 'False', matching is case-sensitive string equality.
-- When @useRegex@ is 'True', the criterion value is treated as a POSIX
-- regular expression matched against the relevant field(s).
matchesCriterion :: Bool -> TestCaseDefinition -> FilterCriterion -> Bool
matchesCriterion _useRegex test criterion =
  let v = trimFilterId (filterCriterionValue criterion)

      -- any je najsilnejsie, matchuje prve
      check (ByAny _) =
        v == tcdName test
          || v == tcdCategory test
          || v `elem` tcdTags test
      check (ByCategory _) = v == tcdCategory test
      check (ByTag _) = v `elem` tcdTags test
   in check criterion

-- | Trim leading and trailing whitespace from a filter identifier.
trimFilterId :: String -> String
trimFilterId = reverse . dropWhile isSpace . reverse . dropWhile isSpace
