{-# LANGUAGE OverloadedStrings #-}
module Anhyzer.Web.App (anhyzerApp) where

import Anhyzer.Web.Actions.Scorecard as Scorecard
import Anhyzer.Types
import Web.Spock.Safe
import SimpleAuth

requireAuth :: AnhyzerApp ()
requireAuth = do
  state <- getState
  middleware $ headerAuth (asHeader state) (asKeys state)

anhyzerApp :: AnhyzerApp ()
anhyzerApp = do
  get root $ text "Anhyzer API"
  subcomponent "/api" $ requireAuth >> anhyzerApi

anhyzerApi :: AnhyzerApp ()
anhyzerApi =
  subcomponent "scorecards" $ do
    get ""     Scorecard.index
    post ""    Scorecard.create
    get var    Scorecard.show
    put var    Scorecard.update
    delete var Scorecard.remove

