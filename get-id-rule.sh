#!/bin/bash
cd "$(dirname "$0")"
source .env

function get_id_rule ()
{
  SEARCH_FIELD=$1
  VALUE=$2

  re='^[0-9]+$'
  if ! [[ $VALUE =~ $re ]] &&  [ "$VALUE" != "true" ] && [ "$VALUE" != "false" ]; then
    VALUE=\"$VALUE\"
  fi

  curl -ks $BASE_URL/fw/redir/ -H "X-Fbx-App-Auth: $session_token" | jq ".result[] | select(.$SEARCH_FIELD==$VALUE) | .id"
}

if [ $# -ne 3 ]; then
  echo "Usage: $0 app_token_file search_field value"
  echo '  Exemple: '$0' .fr.freebox.myapp comment "my temp rule"'
  echo '  Exemple: '$0' .fr.freebox.myapp lan_ip 192.168.0.13'
  echo '  Exemple: '$0' .fr.freebox.myapp wan_port 80'
  exit 1
fi

SEARCH_FIELD=$2
VALUE=$3
session_token=$(./login.sh $1)
get_id_rule $SEARCH_FIELD $VALUE
