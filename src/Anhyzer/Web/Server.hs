{-# LANGUAGE OverloadedStrings #-}
module Anhyzer.Web.Server (sessCfg, parseConfig, runApp) where

import           Anhyzer.Web.App
import           Anhyzer.Model
import           Anhyzer.Types
import           Control.Monad.Logger
import qualified Data.Configurator as C
import qualified Data.Text as T
import           Database.Persist.Sqlite hiding (get)
import           Web.Spock.Safe
import           Network.Wai.Middleware.RequestLogger

data AppConfig = AppConfig
  { acDb   :: T.Text
  , acPort :: Int
  }

appMiddleware :: AnhyzerApp ()
appMiddleware = middleware logStdout

sessCfg :: SessionCfg (Maybe a)
sessCfg = SessionCfg "AnhyzerApi" 3600 40 False Nothing Nothing

parseConfig :: FilePath -> IO AppConfig
parseConfig cfgFile = do
  cfg  <- C.load [C.Required cfgFile]
  db   <- C.require cfg "db"
  port <- C.require cfg "port"
  return (AppConfig db port)

runApp :: AppConfig -> IO ()
runApp acfg = do
  pool <- runStdoutLoggingT $ createSqlitePool (acDb acfg) 5
  runStdoutLoggingT $ runSqlPool (runMigration migrateCore) pool
  runSpock (acPort acfg) $ spock sessCfg (PCPool pool) () $ appMiddleware >> anhyzerApp

