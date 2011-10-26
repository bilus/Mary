module Paths_mary (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName
  ) where

import Data.Version (Version(..))
import System.Environment (getEnv)

version :: Version
version = Version {versionBranch = [0,1], versionTags = []}

bindir, libdir, datadir, libexecdir :: FilePath

bindir     = "/Users/martinb/Library/Haskell/ghc-7.0.2/lib/mary-0.1/bin"
libdir     = "/Users/martinb/Library/Haskell/ghc-7.0.2/lib/mary-0.1/lib"
datadir    = "/Users/martinb/Library/Haskell/ghc-7.0.2/lib/mary-0.1/share"
libexecdir = "/Users/martinb/Library/Haskell/ghc-7.0.2/lib/mary-0.1/libexec"

getBinDir, getLibDir, getDataDir, getLibexecDir :: IO FilePath
getBinDir = catch (getEnv "mary_bindir") (\_ -> return bindir)
getLibDir = catch (getEnv "mary_libdir") (\_ -> return libdir)
getDataDir = catch (getEnv "mary_datadir") (\_ -> return datadir)
getLibexecDir = catch (getEnv "mary_libexecdir") (\_ -> return libexecdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
