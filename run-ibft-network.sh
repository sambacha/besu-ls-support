#!/bin/bash
set -e
source common/variables
source common/functions

echo "Killing all previous Besu instances running."
if pgrep java; then pkill java; fi

echo "Starting bootnode 1."
bootnode1LogFile="out/ibft-network/bootnode-1/log"
$BESU_PATH --data-path=out/ibft-network/bootnode-1/data --genesis-file=out/ibft-network/genesis.json --rpc-http-enabled --rpc-http-api=ETH,NET,IBFT --host-whitelist=* --rpc-http-cors-origins=all > $bootnode1LogFile &
sleep 5s
bootnode1EnodeURL=$(cat $bootnode1LogFile | grep --text "Enode URL" | awk '{print $NF}')
echo "Bootnode 1 enode URL: $bootnode1EnodeURL"
