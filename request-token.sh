#!/bin/bash

source .env

msg=$(echo '{"app_id": "'$APP_ID'","app_name": "'$APP_NAME'","app_version": "0.0.1","device_name": "'$DEVICE_NAME'"}')
result=$(curl -ks -X POST $BASE_URL/login/authorize/ -d "$msg" | jq '.result')

track_id=$(echo "$result" | jq '.track_id' | tr -d \")
app_token=$(echo "$result" | jq '.app_token' | tr -d \")

echo "app_token: $app_token"
echo "Writing app_token to: $APP_TOKEN_FILE"
echo $app_token > $HOME/.${APP_ID}_app_token
echo "track_id: $track_id"

while true; do 
  sleep 1
  result=$(curl -ks -X GET $BASE_URL/login/authorize/$track_id | jq '.result')
  req_status=$(echo $result | jq '.status' | tr -d \" )
  challenge=$(echo "$result" | jq '.challenge' | tr -d \" )

  if [ "$req_status" == "granted" ]; then
    echo "status: app_token is valid and can be used to open a session. It has been record in .${APP_ID}_app_token"
    break;
  fi
  if [ "$req_status" == "unknown" ]; then
    echo "status: app_token is invalid or has been revoked"
    exit 1
  fi
  if [ "$req_status" == "pending" ]; then
    echo "status: user has not confirmed the authorization request yet"
  fi
  if [ "$req_status" == "timeout" ]; then
    echo "status: user did not confirmed the authorization within the given time"
    exit 1
  fi
  if [ "$req_status" == "denied" ]; then
    echo "status: user denied the authorization request"
    exit 1
  fi
done
