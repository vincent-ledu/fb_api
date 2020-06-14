#!/bin/bash

source .env

function login_get_session_token ()
{
  local APP_TOKEN_FILE=$1
  local challenge=$(curl -ks $BASE_URL/login | jq '.result.challenge' | tr -d \")
  local app_token=$(cat $APP_TOKEN_FILE)
  local pass=$(echo -n $challenge | openssl dgst -sha1 -hmac $app_token | cut -d' ' -f2)

  local payload="{\"app_id\":\"$APP_ID\",\"password\":\"$pass\"}"
  local session_token=$(curl -ks -X POST $BASE_URL/login/session/ -d $payload | jq '.result.session_token' | tr -d \")
  if [ $DEBUG ]; then
    echo "APP_TOKEN_FILE: $APP_TOKEN_FILE"
    echo "BASE_URL: $BASE_URL"
    echo "challenge: $challenge"
    echo "app_token: $app_token"
    echo "pass: $pass"
    echo "payload: $payload"
    echo "session_token: $session_token"
  fi
  echo $session_token
}

if [ $# -ne 1 ]; then
  echo "Usage: login app_token_file"
  exit 1
fi
APP_TOKEN_FILE=$1
login_get_session_token $APP_TOKEN_FILE