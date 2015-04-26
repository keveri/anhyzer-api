{-# LANGUAGE OverloadedStrings #-}
module Anhyzer.Types where

import           Data.Aeson
import qualified Data.ByteString as BS (ByteString)
import qualified Data.Text as T
import           Database.Persist.Sqlite hiding (get, delete)
import           Web.Spock.Safe

type AuthHeader = BS.ByteString
type ApiKeys = [BS.ByteString]
type SessionVal = Maybe SessionId
type AnhyzerApp a = SpockM SqlBackend SessionVal AnhyzerState a
type AnhyzerAction a = SpockAction SqlBackend SessionVal AnhyzerState a

data AppConfig = AppConfig
  { acDb     :: T.Text
  , acPort   :: Int
  , acHeader :: AuthHeader
  , acKeys   :: ApiKeys
  }

data AnhyzerState = AnhyzerState 
  { asHeader :: AuthHeader
  , asKeys   :: ApiKeys
  }

data AnhyzerError = AnhyzerError { aeError :: T.Text }

instance ToJSON AnhyzerError where
  toJSON (AnhyzerError err) = object [ "error" .= err ]

