{-# LANGUAGE OverloadedStrings #-}
module Main (main) where

import Anhyzer.Web.Server

main :: IO ()
main = parseConfig "anhyzer.cfg" >>= runApp

