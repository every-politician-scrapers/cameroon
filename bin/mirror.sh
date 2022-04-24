#!/bin/bash

rm -rf mirror
mkdir -p mirror

curl -L -c /tmp/cookies -o html/official.html -A eps/1.2 $(jq -r .source.url meta.json)
