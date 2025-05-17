#!/usr/bin/env bash

# Author: Haitham Aouati
# GitHub: github.com/haithamaouati

set -euo pipefail

# Styling
normal='\033[0m'
bold='\033[1m'

# Config
API_URL="https://stoic.tekloon.net/stoic-quote"

# Dependency Check
require_command() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Error: '$1' is not installed." >&2
    exit 1
  }
}

# Fetch and Parse Quote
fetch_quote() {
  local response quote author

  response=$(curl -s --fail "$API_URL") || {
    echo "Error: Failed to connect to API." >&2
    exit 1
  }

  quote=$(echo "$response" | jq -r '.data.quote') || {
    echo "Error: Unable to parse quote." >&2
    exit 1
  }

  # Sanitize trailing @ or whitespace
  quote=$(echo "$quote" | sed 's/[@[:space:]]*$//')

  author=$(echo "$response" | jq -r '.data.author') || {
    echo "Error: Unable to parse author." >&2
    exit 1
  }

  if [[ -z "$author" || "$author" == "null" ]]; then
    author="Unknown"
  fi

  clear

  echo -e "${bold}Stoicism Quote${normal}\n"
  echo -e "“$quote”"
  echo -e "  — ${bold}$author${normal}\n"
}

# Main
main() {
  require_command curl
  require_command jq
  fetch_quote
}

main "$@"
