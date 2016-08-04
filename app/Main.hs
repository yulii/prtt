{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Main where

import Control.Applicative
import Data.Aeson
import qualified Data.ByteString.Lazy     as BL
import qualified Data.ByteString.Lazy.Char8 as BLC
import Data.Maybe
import Data.Time.Clock
import GHC.Word
import GHC.Generics

import Lib

data Commit = Commit { sha :: String, datetime :: UTCTime, ref :: String, author :: String, message :: String } deriving (Show, Generic)

instance FromJSON Commit
instance ToJSON Commit


main :: IO ()
main = do
  commits <- BL.readFile "commits.json"
  mapM_ print $ BLC.lines commits
  -- TODO: Nothing が含まれていないか、データの検査をして例外処理する
  mapM_ print $ mapMaybe (\x -> decode x :: Maybe Commit) $ BLC.lines commits
