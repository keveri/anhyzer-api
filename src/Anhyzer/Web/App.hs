{-# LANGUAGE OverloadedStrings #-}
module Anhyzer.Web.App (anhyzerApp) where

import Anhyzer.Web.Actions.Scorecard as Scorecard
import Anhyzer.Types
import Web.Spock.Safe

anhyzerApp :: AnhyzerApp ()
anhyzerApp = do
  get root $ text "Anhyzer API"
  subcomponent "/api" anhyzerApi

anhyzerApi :: AnhyzerApp ()
anhyzerApi =
  subcomponent "scorecards" $ do
    get ""     Scorecard.index
    post ""    Scorecard.create
    get var    Scorecard.show
    put var    Scorecard.update
    delete var Scorecard.remove

