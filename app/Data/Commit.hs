{-# LANGUAGE DeriveGeneric #-}
module Data.Commit (
    Commit(..)
  ) where

import Data.Aeson
import Data.Time.Clock
import GHC.Generics

instance FromJSON Commit
instance ToJSON Commit

data Commit = Commit { sha      :: String
                     , datetime :: UTCTime
                     , author   :: String
                     , message  :: String } deriving (Show, Generic)
