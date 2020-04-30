#!/bin/bash

test -r .env && source .env

if [ -z "${SLACK_TOKEN}" ]; then echo "SLACK_TOKEN env var required!"; exit 1; fi
if [ -z "${SLACK_USER_ID}" ]; then echo "SLACK_USER_ID env var required!"; exit 1; fi

status_exp=$(( $(gdate +%s) + 3600 ))

if [ "${1}" == "lunch" ]; then
  status_text="Lunch"
  status_emoji=":pizza:"
elif [ "${1}" == "workout" ]; then
  status_text="Workout"
  status_emoji=":weight_lifter:"
else
  echo "Usage: $0 [lunch|workout]"
  exit 1
fi

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
