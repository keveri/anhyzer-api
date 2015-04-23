{-# LANGUAGE OverloadedStrings #-}

module Api.Authentication (checkAuth) where

import           Control.Applicative
import qualified Control.Monad as M
import qualified Data.ByteString.Char8 as B
import           Snap.Core
import           Snap.Snaplet

isValidKey :: B.ByteString -> Bool
isValidKey = (==) "secret"

checkAuth :: Handler b v ()
checkAuth = do
  header <- getHeader "x-api-key" <$> getRequest
  case header of Just key -> M.unless (isValidKey key) unAuthorized
                 Nothing  -> unAuthorized

unAuthorized :: Handler b v ()
unAuthorized = do
  modifyResponse $ setResponseCode 401
  writeBS "Unauthorized"
  r <- getResponse
  finishWith r

