#!/bin/sh

echo "\n[ Build ]"
cabal build

echo "\n[ Copy ]"
scp dist/build/anhyzer-api/anhyzer-api anhyzer:webapps/anhyzer-api/anhyzer_temp

echo "\n[ Restart ]"
folder="/home/matson/webapps/anhyzer-api"
cmd="
sudo service anhyzer-api stop;
mv $folder/anhyzer_temp $folder/anhyzer-api;
sudo service anhyzer-api start;
"
ssh -t anhyzer $cmd

