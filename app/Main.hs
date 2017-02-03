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
  mapM_ print $ map (\x -> (fst x, diffHours(snd x)) ) $ aggregateCommitList intervalLimit commits

intervalLimit :: NominalDiffTime
intervalLimit = 60 * 60 * 8 -- 8 hours

diffHours :: NominalDiffTime -> [Char]
diffHours t = show ( realToFrac ( truncate ( t / 60 / 60 * 10 ) ) / 10 ) ++ "h"

getCommitList file = do
  mapMaybe (\x -> decode x :: Maybe Commit) <$> BLC.lines <$> BL.readFile file
