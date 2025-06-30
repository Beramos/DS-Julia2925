#!/bin/bash
# filepath: /home/bramdj/Desktop/git/DS-Julia2925/ops/check-secret-remote.sh

if [ $# -ne 1 ]; then
  echo "Usage: $0 SERVER_ADDRESS"
  exit 1
fi

SERVER_ADDRESS="$1"

echo -e "\033[1;34m🔍 Connecting to $SERVER_ADDRESS to check Pluto service secret...\033[0m"

# Get the last 100 lines of the Pluto service log and search for the URL with the secret
URL_LINE=$(ssh root@"$SERVER_ADDRESS" "journalctl -u pluto-server -n 100 --no-pager | grep -oE 'http://[0-9.:]+:1234/\?secret=[A-Za-z0-9]+' | tail -1")

if [[ -n "$URL_LINE" ]]; then
  # Replace 0.0.0.0 or 127.0.0.1 or localhost with the actual server address
  DISPLAY_URL=$(echo "$URL_LINE" | sed -E "s#(http://)(0\.0\.0\.0|127\.0\.0\.1|localhost)#\1$SERVER_ADDRESS#")
  echo -e "\033[1;32m✅ Found Pluto URL:\033[0m"
  echo -e "\033[1;33m$DISPLAY_URL\033[0m"
  echo -e "\033[1;36mOpen this URL in your browser to access Pluto.\033[0m"
else
  echo -e "\033[1;31m❌ Could not find Pluto URL with secret in the service logs.\033[0m"
  echo "Try restarting the service or wait a few seconds and try again."
fi