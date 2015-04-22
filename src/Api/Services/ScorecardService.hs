{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE FlexibleInstances #-}

module Api.Services.ScorecardService where

import           Api.Types
import           Control.Lens
import           Control.Monad.State.Class
import           Data.Aeson
import qualified Data.ByteString.Char8 as B
import           Snap.Core
import           Snap.Snaplet
import           Snap.Snaplet.PostgresqlSimple

data ScorecardService = ScorecardService { _pg :: Snaplet Postgres }

makeLenses ''ScorecardService

scorecardRoutes :: [(B.ByteString, Handler b ScorecardService ())]
scorecardRoutes = [ ("/", method GET getScorecards)
                  , ("/", method POST createScorecard) ]

createScorecard :: Handler b ScorecardService ()
createScorecard = do
  name <- getPostParam "name"
  execute "INSERT INTO scorecards (name) VALUES (?)" (Only name)
  modifyResponse $ setResponseCode 201

getScorecards :: Handler b ScorecardService ()
getScorecards = do
  scorecards <- query_ "SELECT * FROM scorecards"
  modifyResponse $ setHeader "Content-Type" "application/json"
  writeLBS . encode $ (scorecards :: [Scorecard])

scorecardServiceInit :: SnapletInit b ScorecardService
scorecardServiceInit = makeSnaplet "scorecards" "Scorecard Service" Nothing $ do
  pg <- nestSnaplet "pg" pg pgsInit
  addRoutes scorecardRoutes
  return $ ScorecardService pg

instance HasPostgres (Handler b ScorecardService) where
  getPostgresState = with pg get
