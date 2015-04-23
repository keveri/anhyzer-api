#!/bin/bash

user="developer"
db="anhyzer-api"

psql -U $user -h 127.0.0.1 -d $db -c "drop table scorecards;"
cat anhyzer-api.sql | psql -U $user -h 127.0.0.1 -d $db
