#!/bin/sh

aws lambda update-function-code --function-name "updateScenarioMaster" --zip-file "fileb://build.zip"