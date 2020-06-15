#!/bin/bash
cd "$(dirname "$0")"
source .env

function update_rule_by_id ()
{
  ID=$1
  FIELD=$2
  VALUE=$3

  re='^[0-9]+$'
  if ! [[ $VALUE =~ $re ]] &&  [ "$VALUE" != "true" ] && [ "$VALUE" != "false" ]; then
    VALUE=\"$VALUE\"
  fi
  curl -ks -X PUT -H "X-Fbx-App-Auth: $session_token" $BASE_URL/fw/redir/$ID -d "{\"$FIELD\": $VALUE}"
}

if [ $# -ne 5 ]; then
  echo "Usage: $0 app_token_file search_field value field_to_update new_value"
  echo '  Exemple: '$0' fr.freebox.myapp comment "my temp rule" enabled false'
  echo '  Exemple: '$0' fr.freebox.myapp lan_ip 192.168.0.13 lan_ip 192.168.0.13'
  echo '  Exemple: '$0' fr.freebox.myapp wan_port 80 wan_port 443'
  exit 1
fi

SEARCH_FIELD=$2
VALUE=$3
FIELD=$4
NEW_VALUE=$5
session_token=$(./login.sh $1)
IDS=$(./get-id-rule.sh $1 $SEARCH_FIELD $VALUE)
for ID in $IDS; do
  echo "rule id: $ID"
  update_rule_by_id $ID $FIELD $NEW_VALUE
done