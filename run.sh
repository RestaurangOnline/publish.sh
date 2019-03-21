#!/bin/bash

TIMESTAMP=$(date +"%Y-%m-%d_%H%M%S")
exec bash <(curl -sS https://raw.githubusercontent.com/RestaurangOnline/publish.sh/master/publish.sh?v=${TIMESTAMP})
