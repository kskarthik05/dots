#!/usr/bin/env bash
# Rofi passes the app's display name as the first argument, and the
# command to execute as the second argument (after --no-startup-id).
APP_NAME="$1"
APP_COMMAND="$2"

# Clean up the app name for use as a workspace name.
# Replace spaces with hyphens, convert to lowercase, and remove special characters.
WS_NAME=$(echo "$APP_NAME" | tr ' ' '-' | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9-]//g')

# Send the command to Sway
echo "$APP_NAME" > ~/test
swaymsg "workspace $WS_NAME; exec --no-startup-id $APP_NAME"
