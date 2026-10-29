#!/usr/bin/env bash
set -euo pipefail

if (( $# > 1 )); then
  echo "Usage: bash $0 [provider]" >&2
  exit 1
fi

catalog=$(opencode api get /api/model)

if (( $# == 0 )); then
  echo "Available providers:"
  jq -r '.data | map(.providerID) | unique[]' <<< "$catalog"
  echo "Example: bash $0 openai"
  exit 0
fi

models=$(jq -e --arg provider "$1" '
  [.data[] | select(.providerID == $provider) | {
    provider: .providerID,
    model: .id,
    name: .name,
    description: (.description // null),
    capabilities: .capabilities,
    cost: .cost,
    variants: [.variants[].id]
  }] | if length > 0 then . else error("Provider has no available models") end
' <<< "$catalog")

printf '%s\n' "$models" > /tmp/models.json
echo /tmp/models.json
