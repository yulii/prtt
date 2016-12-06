module Data.TimeList (
    totalCommitTime
  ) where

import Data.Time.Clock

diffUTCTimeList :: [UTCTime] -> [NominalDiffTime]
diffUTCTimeList list = zipWith diffUTCTime (tail list) list

filterCommitTimeList :: NominalDiffTime -> [UTCTime] -> [NominalDiffTime]
filterCommitTimeList limit list = filter (< limit) (diffUTCTimeList list)

totalCommitTime :: NominalDiffTime -> [UTCTime] -> NominalDiffTime
totalCommitTime limit list = foldr (+) 0 (filterCommitTimeList limit list)
