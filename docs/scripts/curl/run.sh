#!/bin/bash

# 1. Update cat to filename
# 2. `./run.sh`

for i in $(cat stores-00)
do
  arrIN=(${i//,/ })
  url=${arrIN[0]}
  filename=${arrIN[1]}

  curl -o $(echo $filename | sed 's/\?.*//') $(echo $url | tr '\r' ' ')

  unset arrIN
  unset url
  unset filename
done
