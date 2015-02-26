#!/bin/bash
SCRIPTS=`dirname $0`
COFFEE=$SCRIPTS/../node_modules/coffee-script/bin/coffee

$COFFEE --watch --compile --output $SCRIPTS/../src/public/js $SCRIPTS/../app
