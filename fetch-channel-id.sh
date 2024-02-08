#!/usr/bin/env bash

eval "$(jq -r '@sh "PRODUCT=\(.product)"')"

#echo -n "{\"channel_id\":\"$PRODUCT\"}"

$PRODUCT="aac"


# # convert yaml to json
set -x
cnp_json=$(curl -s https://raw.githubusercontent.com/hmcts/cnp-jenkins-config/master/team-config.yml | yq e -o=json)
set +x



channel_id=$(echo "$cnp_json" | jq --arg PRODUCT "$PRODUCT" -r '.[$PRODUCT] | .slack.channel_id')


if [ "$channel_id" = "null" ]; then
  sds_json=$(curl -s https://raw.githubusercontent.com/hmcts/sds-jenkins-config/master/team-config.yml | yq e -o=json)
  channel_id=$(echo "$sds_json" | jq --arg PRODUCT "$PRODUCT" -r '.[$PRODUCT] | .slack.channel_id')
  
  if [ "$channel_id" = "null" ]; then
    channel_id="NOT FOUND"
  fi
  # echo $channel_id
fi

echo -n "{\"channel_id\":\"$cnp_json\"}"