-- | Discovering @.test@ files and their companion @.in@\/@.out@ files.
module SOLTest.Discovery (discoverTests) where

import SOLTest.Types
import System.Directory
  ( doesDirectoryExist,  -- Pridal som import lebo si myslim ze to neni v scope
    doesFileExist,      -- zadania implementovat rucne a doesFileExist tu uz bol
    listDirectory,
  )
import System.FilePath (replaceExtension, takeBaseName, (</>))

-- | Discover all @.test@ files in a directory.
--
-- When @recursive@ is 'True', subdirectories are searched recursively.
-- Returns a list of 'TestCaseFile' records, one per @.test@ file found.
-- The list is ordered by the file system traversal order (not sorted).
--
discoverTests :: Bool -> FilePath -> IO [TestCaseFile]
discoverTests recursive dir = do
  entries <- listDirectory dir
  -- Skip skrytych veci
  let visible = filter (not . isHidden) entries
      fullPaths = map (dir </>) visible
  -- Jeden krok pre jeden entry, vrati zoznam najdenych TestCaseFile
  let handle path = do
        isDir <- doesDirectoryExist path
        if isDir
          then
            if recursive
              then discoverTests True path
              else return []
          else
            if fileExt path == ".test"
              then do
                tcf <- findCompanionFiles path
                return [tcf]
              else return []
  -- Vysledky sa spoja dokopy, mapM je pre IO operacie
  results <- mapM handle fullPaths
  return (concat results)

-- | Zisti ci je file/directory skryte
isHidden :: FilePath -> Bool
isHidden ('.' : _) = True
isHidden _         = False

-- | Vrati cast cesty po poslednej lomke = filename
fileBase :: FilePath -> String
fileBase = reverse . takeWhile (/= '/') . reverse

-- | Vrati priponu suboru s bodkou
fileExt :: FilePath -> String
fileExt path =
  let name           = fileBase path
      -- Reverse lebo sa hlada posledna bodka
      (extRev, rest) = break (== '.') (reverse name)
   in case rest of
        -- Bodka existuje a je nieco pred nou = pripona
        '.' : beforeDot | not (null beforeDot) -> '.' : reverse extRev
        -- Inak ziadna pripona
        _                                      -> ""

-- | Build a 'TestCaseFile' for a given @.test@ file path, checking for
-- companion @.in@ and @.out@ files in the same directory.
findCompanionFiles :: FilePath -> IO TestCaseFile
findCompanionFiles testPath = do
  let baseName = takeBaseName testPath
      inFile = replaceExtension testPath ".in"
      outFile = replaceExtension testPath ".out"
  hasIn <- doesFileExist inFile
  hasOut <- doesFileExist outFile
  return
    TestCaseFile
      { tcfName = baseName,
        tcfTestSourcePath = testPath,
        tcfStdinFile = if hasIn then Just inFile else Nothing,
        tcfExpectedStdout = if hasOut then Just outFile else Nothing
      }
