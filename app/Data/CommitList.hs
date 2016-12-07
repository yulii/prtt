module Data.CommitList (
    aggregateCommitList
  ) where

import Data.Commit
import Data.List
import Data.Time.Clock

authorList :: [Commit] -> [String]
authorList = nub . (map author)

-- 日時の階差数列を取得する
diffTimeList :: [UTCTime] -> [NominalDiffTime]
diffTimeList list = zipWith diffUTCTime (tail list) list

diffCommitTimeList :: [Commit] -> [NominalDiffTime]
diffCommitTimeList = diffTimeList . sort . (map datetime)

-- コミットログから作業時間を集計する
totalDiffCommitTime :: NominalDiffTime -> [Commit] -> NominalDiffTime
totalDiffCommitTime interval = (foldr (+) 0) . (filter (< interval)) . diffCommitTimeList

-- 作成者毎の作業時間を集計する
aggregateCommitList :: NominalDiffTime -> [Commit] -> [(String, NominalDiffTime)]
aggregateCommitList interval list = aggregateCommitList' interval (authorList list) list

aggregateCommitList' :: NominalDiffTime -> [String] -> [Commit] -> [(String, NominalDiffTime)]
aggregateCommitList' interval []     list = []
aggregateCommitList' interval (x:xs) list = (x, totalTime):(aggregateCommitList' interval xs list)
  where
    totalTime = totalDiffCommitTime interval (selectAuthorCommit x list)
    selectAuthorCommit a = filter ((== a) . author)
