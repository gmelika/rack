#!/bin/bash

set -e

# Run the args, and track the command, exit code and time elapsed
#
# usage:
#  track delete-all-apps.sh
#  track echo hello
#  track false

SECONDS=0

track(){
  echo "track $1 $2 $3: "
  curl -s https://api.segment.io/v1/track       \
    -H "Content-Type: application/json" -X POST \
    --user $SEGMENT_WRITE_KEY:                  \
    -d "{
      \"userId\": \"circleci\",
      \"event\": \"CI Command\",
      \"properties\": {
        \"branch\": \"$CIRCLE_BRANCH\",
        \"code\": $2,
        \"cmd\": \"$1\",
        \"region\": \"$AWS_REGION\",
        \"seconds\": $3
      }
    }"
}

"$@"

track $1 $? $SECONDS
