#!/bin/bash

test -r .env && source .env

if [ -z "${SLACK_TOKEN}" ]; then echo "SLACK_TOKEN env var required!"; exit 1; fi
if [ -z "${SLACK_USER_ID}" ]; then echo "SLACK_USER_ID env var required!"; exit 1; fi

STATUS_EXP_MIN=${2:-60}
status_exp=$(( $(gdate +%s) + $(( STATUS_EXP_MIN * 60 )) ))

DND_ENABLED=false

case "${1}" in
  clear)
    status_text=""
    status_emoji=""
  ;;
  lunch)
    status_text="Lunch"
    status_emoji=":pizza:"
  ;;
  workout)
    status_text="Workout"
    status_emoji=":weight_lifter:"
  ;;
  focus)
    status_text="Focus time"
    status_emoji=":headphones:"
    DND_ENABLED=true
  ;;
  *)
    echo "Usage: $0 [lunch|workout|focus] [minutes status active (default 60)]"
    echo "       $0 clear"
    exit 1
  ;;
esac

body=$(echo '{
  "profile": {
    "status_text": "'"${status_text}"'",
    "status_emoji": "'"${status_emoji}"'",
    "status_expiration": '"${status_exp}"'
  }
}' | jq -r '.')

curl -s -X POST \
  -H "Content-type: application/json; charset=utf-8" \
  -H "Authorization: Bearer ${SLACK_TOKEN}" \
  -H "X-Slack-User: ${SLACK_USER_ID}" \
  -d "${body}" \
  https://slack.com/api/users.profile.set | jq .

if [ "${DND_ENABLED}" == "true" ]; then
  curl -s \
    -H "Content-type: application/x-www-form-urlencoded" \
    -H "X-Slack-User: ${SLACK_USER_ID}" \
    -d "token=${SLACK_TOKEN}&num_minutes=${STATUS_EXP_MIN}" \
    https://slack.com/api/dnd.setSnooze | jq .
fi
