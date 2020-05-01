# slack-status-updater

Simple bash script to update your Slack status and, optionally, Do not disturb mode, from your terminal.

## Requirements

* [Slack App](https://api.slack.com/apps)
* User Token Scopes required:
  * `dnd:write`
  * `users.profile.write`

## Setup

Create a file `.env` in the same directory as the update script with the contents:

```bash
# access token from the "OAuth & Permissions" section of your Slack App
export SLACK_TOKEN="xoxp-00000000-00000000-00000000-00000000-00000000-00000000-00000000"

# Your Slack User ID (the user Id that will have the status updated)
export SLACK_USER_ID="UXXX1234"
```

## Running

```bash
# Clear status
./slack-status-update clear

# Set status for the default 60 minutes
./slack-status-update lunch

# Set status for 90 minutes, enjoy life
./slack-status-update lunch -m 90

# Set status for 90 minutes, enjoy life, while on Do Not Disturb mode
./slack-status-update lunch -m 90 -d
```
