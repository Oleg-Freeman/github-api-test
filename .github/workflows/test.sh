#!/bin/bash

GIT_FILES_LIST=$(git ls-tree -r HEAD schemas | awk '{print $4}')

PAYLOAD=$(for i in $GIT_FILES_LIST; do
    LAST_MODIFIED_DATE=$(git log -1 --pretty="format:%ci" $i)
    AUTHOR=$(git log -1 --pretty="format:%an" $i)

    jq --null-input \
      --arg path "$i" \
      --arg updatedAt "$LAST_MODIFIED_DATE" \
      --arg author "$AUTHOR" \
      '{"path": $path, "updatedAt": $updatedAt, "author": $author}'
done | jq -n '.items |= [inputs]')

#echo "$PAYLOAD"

curl -X POST \
    -H "Accept: application/json" \
    https://httpbin.org/post \
    -d "$PAYLOAD"

$SHELL
