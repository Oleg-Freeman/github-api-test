#!/bin/bash

echo "Script Started"

GIT_FILES_LIST=git ls-tree -r HEAD schemas | awk '{print $4}'

SCHEMAS=$(echo "$GIT_FILES_LIST" | \
          head -c -1 | \
          jq -R -s -c 'split(" ")')

echo "$GIT_FILES_LIST"
echo "$SCHEMAS"

echo "Script Ended"
