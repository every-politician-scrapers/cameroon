#!/bin/bash

cd $(dirname $0)

bash scrape.sh
wd sparql -f csv wikidata.js | sed -e 's/T00:00:00Z//g' -e 's#http://www.wikidata.org/entity/##g' | qsv dedup -s psid | qsv sort -s name,startDate | ifne tee wikidata.csv
bundle exec ruby diff.rb | tee diff.csv

cd -
