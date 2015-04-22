{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}

module Api.Core where

import Api.Services.ScorecardService
import Control.Lens
import Snap.Core
import Snap.Snaplet
import qualified Data.ByteString.Char8 as B

data Api = Api { _scorecardService :: Snaplet ScorecardService }

makeLenses ''Api

apiRoutes :: [(B.ByteString, Handler b Api ())]
apiRoutes = [("status", method GET respondOk)]

respondOk :: Handler b Api ()
respondOk = modifyResponse . setResponseCode $ 200

apiInit :: SnapletInit b Api
apiInit = makeSnaplet "api" "Core Api" Nothing $ do
        ts <- nestSnaplet "scorecards" scorecardService scorecardServiceInit
        addRoutes apiRoutes
        return $ Api ts
