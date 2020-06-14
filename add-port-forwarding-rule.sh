#!/bin/bash

source .env

function add_rule ()
{
  echo "session_token: $session_token"
  LAN_IP=$1
  WAN_PORT=$2
  LAN_PORT=$3
  ENABLED=$4
  COMMENT=$5
  res=$(curl -ks -X POST $BASE_URL/fw/redir/ -H "X-Fbx-App-Auth: $session_token" -d '{
      "enabled": '$ENABLED',
      "comment": "'$COMMENT'",
      "lan_port": '$LAN_PORT',
      "wan_port_start": '$WAN_PORT',
      "wan_port_end": '$WAN_PORT',
      "lan_ip": "'$LAN_IP'",
      "ip_proto": "tcp",
      "src_ip": "0.0.0.0"
  }')
  echo $res | jq
}

function get_certbot_id_rule ()
{
  curl -ks $BASE_URL/fw/redir/ -H "X-Fbx-App-Auth: $session_token" | jq '.result[] | select(.comment=="for certbot - temp") | .id'
}

if [ $# -ne 6 ]; then
  echo "Usage: $0 app_token_file lan_ip wan_port lan_port enabled comment"
  echo '  Exemple: $0 fr.freebox.myapp 192.168.0.18 80 80 false "for my https server"'
  exit 1
fi
APP_TOKEN_FILE=$1
LAN_IP=$2
WAN_PORT=$3
LAN_PORT=$4
ENABLED=$5
COMMENT=$6

session_token=$(./login.sh $1)
add_rule $LAN_IP $WAN_PORT $LAN_PORT $ENABLED $COMMENT