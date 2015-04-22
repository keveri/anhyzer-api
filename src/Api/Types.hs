{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE FlexibleInstances #-}

module Api.Types where

import           Control.Applicative
import qualified Data.Text as T
import           Data.Aeson
import           Snap.Snaplet.PostgresqlSimple

data Scorecard = Scorecard
  { scorecardId   :: Int
  , scorecardName :: T.Text
  }

instance FromRow Scorecard where
  fromRow = Scorecard <$> field
                      <*> field

instance ToJSON Scorecard where
  toJSON (Scorecard id name) = object [ "id" .= id, "name" .= name ]
