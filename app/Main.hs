{-# LANGUAGE OverloadedStrings #-}
module Main where

import Control.Applicative
import Data.Aeson
import qualified Data.ByteString.Lazy       as BL
import qualified Data.ByteString.Lazy.Char8 as BLC
import Data.Commit
import Data.CommitList
import Data.List
import Data.Maybe
import Data.Time.Clock
import GHC.Word

import System.Environment (getArgs)

main :: IO ()
main = do
  args    <- getArgs
  commits <- getCommitList $ head args
--  limit   <- getCommitList $ args !! 0
--  commits <- getCommitList $ args !! 1
  mapM_ print $ aggregateCommitList intervalLimit commits

intervalLimit :: NominalDiffTime
intervalLimit = 60 * 60 * 4 -- 4 hours

getCommitList file = do
  mapMaybe (\x -> decode x :: Maybe Commit) <$> BLC.lines <$> BL.readFile file
