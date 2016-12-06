{-# LANGUAGE OverloadedStrings #-}
module Main where

import Control.Applicative
import Data.Aeson
import qualified Data.ByteString.Lazy       as BL
import qualified Data.ByteString.Lazy.Char8 as BLC
import Data.Commit
import Data.List
import Data.Maybe
import Data.Ord
import Data.Time.Clock
import GHC.Word

main :: IO ()
main = do
  commits <- getCommitList "commits.json"
  -- TODO: Nothing が含まれていないか、データの検査をして例外処理する
  mapM_ print $ sortBy (\x y -> compare (datetime x) (datetime y)) commits
  putStrLn "======"
  mapM_ print $ diffUTCTimeList $ datetimeList commits
  putStrLn "======"
  print $ foldr (+) 0 $ filter (< intervalLimit) $ diffUTCTimeList $ datetimeList commits

intervalLimit :: NominalDiffTime
intervalLimit = 60 * 60 * 4 -- 4 hours

datetimeList = (sortBy (\x y -> compare x y)) . (map datetime)
diffUTCTimeList list = zipWith diffUTCTime (tail list) list

getCommitList file = do
  mapMaybe (\x -> decode x :: Maybe Commit) <$> BLC.lines <$> BL.readFile file
