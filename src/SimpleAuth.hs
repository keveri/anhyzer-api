{-# LANGUAGE OverloadedStrings #-}
module SimpleAuth (headerAuth) where

import qualified Data.ByteString      as BS (ByteString)
import qualified Data.CaseInsensitive as CI (mk)
import           Network.HTTP.Types (status401)
import           Network.HTTP.Types.Header (hContentType)
import           Network.Wai (Response, Middleware, responseLBS, requestHeaders)

failedAuth :: Response
failedAuth = responseLBS status401
  [(hContentType, "application/json")]
  "{\"error\": \"Invalid authentication header.\"}"

headerAuth :: BS.ByteString -> [BS.ByteString] -> Middleware
headerAuth h ks app req res =
  case lookup (CI.mk h) $ requestHeaders req of
    Nothing -> res failedAuth
    Just k  ->
      if k `elem` ks
        then app req res
        else res failedAuth

