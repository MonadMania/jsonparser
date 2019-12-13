{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_jsonparser (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/mnt/c/Users/Operation 1/Desktop/haskell-projects/toys/jsonparser/.stack-work/install/x86_64-linux/79655fe9df2e310fbeff3b09c4576d6353f6f7b88e521394f26ba1b1c2f8549d/8.6.5/bin"
libdir     = "/mnt/c/Users/Operation 1/Desktop/haskell-projects/toys/jsonparser/.stack-work/install/x86_64-linux/79655fe9df2e310fbeff3b09c4576d6353f6f7b88e521394f26ba1b1c2f8549d/8.6.5/lib/x86_64-linux-ghc-8.6.5/jsonparser-0.1.0.0-90MT0Ziiw4w6yesbqDz5rf-jsonparser"
dynlibdir  = "/mnt/c/Users/Operation 1/Desktop/haskell-projects/toys/jsonparser/.stack-work/install/x86_64-linux/79655fe9df2e310fbeff3b09c4576d6353f6f7b88e521394f26ba1b1c2f8549d/8.6.5/lib/x86_64-linux-ghc-8.6.5"
datadir    = "/mnt/c/Users/Operation 1/Desktop/haskell-projects/toys/jsonparser/.stack-work/install/x86_64-linux/79655fe9df2e310fbeff3b09c4576d6353f6f7b88e521394f26ba1b1c2f8549d/8.6.5/share/x86_64-linux-ghc-8.6.5/jsonparser-0.1.0.0"
libexecdir = "/mnt/c/Users/Operation 1/Desktop/haskell-projects/toys/jsonparser/.stack-work/install/x86_64-linux/79655fe9df2e310fbeff3b09c4576d6353f6f7b88e521394f26ba1b1c2f8549d/8.6.5/libexec/x86_64-linux-ghc-8.6.5/jsonparser-0.1.0.0"
sysconfdir = "/mnt/c/Users/Operation 1/Desktop/haskell-projects/toys/jsonparser/.stack-work/install/x86_64-linux/79655fe9df2e310fbeff3b09c4576d6353f6f7b88e521394f26ba1b1c2f8549d/8.6.5/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "jsonparser_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "jsonparser_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "jsonparser_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "jsonparser_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "jsonparser_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "jsonparser_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
