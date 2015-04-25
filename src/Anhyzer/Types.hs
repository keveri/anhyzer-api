{-# LANGUAGE OverloadedStrings #-}
module Anhyzer.Types where

import qualified Data.Text as T
import           Data.Aeson
import           Database.Persist.Sqlite hiding (get, delete)
import           Web.Spock.Safe

type SessionVal = Maybe SessionId
type AnhyzerApp a = SpockM SqlBackend SessionVal () a
type AnhyzerAction a = SpockAction SqlBackend SessionVal () a

data AnhyzerError = AnhyzerError { aeError :: T.Text }

instance ToJSON AnhyzerError where
  toJSON (AnhyzerError err) = object [ "error" .= err ]

