module Data.GitLog (
    totalAuthorCommitTime
  ) where

import Data.Commit
import Data.List
import Data.Time.Clock

diffTimeList :: [UTCTime] -> [NominalDiffTime]
diffTimeList list = zipWith diffUTCTime (tail list) list

diffCommitTimeList :: [Commit] -> [NominalDiffTime]
diffCommitTimeList = diffTimeList . sort . (map datetime)

filterAuthorCommitList :: String -> [Commit] -> [Commit]
filterAuthorCommitList a = filter (\x -> author x == a)

totalDiffCommitTime :: NominalDiffTime -> [NominalDiffTime] -> NominalDiffTime
totalDiffCommitTime interval = (foldr (+) 0) . (filter (< interval))

totalAuthorCommitTime :: NominalDiffTime -> String -> [Commit] -> NominalDiffTime
totalAuthorCommitTime interval author = (totalDiffCommitTime interval) . diffCommitTimeList . (filterAuthorCommitList author)
