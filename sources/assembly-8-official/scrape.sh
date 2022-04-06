#!/bin/bash

cd $(dirname $0)

bundle exec ruby scraper.rb
qsv cat rows scraped/*.csv | qsv dedup | qsv select \!position > scraped.csv

cd ~-
