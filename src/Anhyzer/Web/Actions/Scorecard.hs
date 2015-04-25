{-# LANGUAGE OverloadedStrings #-}
module Anhyzer.Web.Actions.Scorecard where

import           Anhyzer.Model
import           Anhyzer.Util
import           Anhyzer.Types
import           Data.Int (Int64)
import           Database.Persist.Sqlite hiding (get, delete)
import qualified Database.Persist.Sqlite as DB (get, delete)
import           Network.HTTP.Types.Status (status201, status404)
import           Web.Spock.Safe

-- CRUD

index :: AnhyzerAction ()
index = do
  ss <- runSQL (selectList [] [])
  json (ss :: [Entity Scorecard])

show :: Int64 -> AnhyzerAction ()
show sId = do
  maybeS <- runSQL $ DB.get $ toSqlKey sId
  case maybeS of
    Just s  -> json (s :: Scorecard)
    Nothing -> notFound

create :: AnhyzerAction ()
create = do
  s <- jsonBody'
  _ <- runSQL $ insert s
  setStatus status201
  json (s :: Scorecard)

update :: Int64 -> AnhyzerAction ()
update sId = do
  let key = toSqlKey sId :: Key Scorecard
  sc <- runSQL $ DB.get key
  case sc of
    Nothing -> notFound
    Just _  -> do
      maybeS <- jsonBody
      case maybeS of
        Just s  -> runSQL $ replace key (s :: Scorecard)
        Nothing -> json (AnhyzerError "Invalid json body")

remove :: Int64 -> AnhyzerAction ()
remove sId = do
  let key = toSqlKey sId :: Key Scorecard
  s <- runSQL $ DB.get key
  case s of
    Just _  -> runSQL $ DB.delete key
    Nothing -> notFound

-- Helpers

notFound :: AnhyzerAction ()
notFound = do
  setStatus status404
  json (AnhyzerError "Scorecard not found.")

