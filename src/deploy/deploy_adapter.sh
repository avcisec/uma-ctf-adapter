#!/usr/bin/env bash

source .env

echo "Deploying UmaCtfAdapter..."

echo "Deploy args:
Finder: $FINDER
LayerZeroSender: $LZSENDER
"

OUTPUT="$(forge script Deploy \
    --private-key $PK \
    --rpc-url $RPC_URL \
    --json \
    --broadcast \
    -s "deploy(address,address)" $FINDER $LZSENDER)"

ADAPTER=$(echo "$OUTPUT" | grep "{" | jq -r .returns.adapter.value)
echo "Adapter deployed: $ADAPTER"

echo "Complete!"
