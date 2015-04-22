{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}

module Api.Core where

import           Api.Authentication
import           Api.Services.ScorecardService
import           Control.Lens
import qualified Data.ByteString.Char8 as B
import           Snap.Core
import           Snap.Snaplet

data Api = Api { _scorecardService :: Snaplet ScorecardService }

makeLenses ''Api

apiInit :: SnapletInit b Api
apiInit = makeSnaplet "api" "Core Api" Nothing $ do
  wrapSite (\site -> checkAuth >> site)
  ss <- nestSnaplet "scorecards" scorecardService scorecardServiceInit
  return $ Api ss
