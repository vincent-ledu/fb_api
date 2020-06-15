#!/bin/bash
cd "$(dirname "$0")"
source .env

function delete_rule_by_id ()
{
  curl -ks -X DELETE -H "X-Fbx-App-Auth: $session_token" $BASE_URL/fw/redir/$1
}

if [ $# -ne 3 ]; then
  echo "Usage: $0 app_token_file search_field value"
  echo '  Exemple: '$0' fr.freebox.myapp comment "my temp rule"'
  echo '  Exemple: '$0' fr.freebox.myapp lan_ip 192.168.0.13'
  echo '  Exemple: '$0' fr.freebox.myapp wan_port 80'
  exit 1
fi

SEARCH_FIELD=$2
VALUE=$3
session_token=$(./login.sh $1)
IDS=$(./get-id-rule.sh $SEARCH_FIELD $VALUE)
for ID in $IDS; do
  delete_rule_by_id $1 $ID
done