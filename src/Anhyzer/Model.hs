{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FlexibleInstances #-}
module Anhyzer.Model where

import qualified Data.Text as T
import           Data.Time
import           Database.Persist.TH

share [mkPersist sqlSettings, mkMigrate "migrateCore"] [persistLowerCase|
Scorecard json
  name T.Text
  deriving Show
|]

