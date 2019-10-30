#!/bin/bash
set -e
source common/variables
source common/functions

numberOfBootNodes=${1:-3}
numberOfValidatorNodes=${2:-4}

echo "Killing all previous Besu instances running."
if pgrep java; then pkill java; fi

echo "Starting bootnode 1."
bootnode1LogFile="out/ibft-network/bootnode-1/log"
$BESU_PATH --data-path=out/ibft-network/bootnode-1/data --genesis-file=out/ibft-network/genesis.json \
--rpc-http-enabled --rpc-http-api=ETH,NET,IBFT --host-whitelist=* --rpc-http-cors-origins=all\
 > $bootnode1LogFile &
sleep 5s
bootnode1EnodeURL=$(cat $bootnode1LogFile | grep --text "Enode URL" | awk '{print $NF}')
echo "Bootnode 1 enode URL: $bootnode1EnodeURL"

p2pPort=30304
httpPort=8546

for i in `seq 2 $numberOfBootNodes`;
do
  echo "Starting bootnode $i with p2pPort: $p2pPort and httpPort: $httpPort."
  $BESU_PATH --data-path="out/ibft-network/bootnode-$i/data" --genesis-file=out/ibft-network/genesis.json \
  --bootnodes=$bootnode1EnodeURL \
  --p2p-port=$p2pPort  --rpc-http-port=$httpPort \
  --rpc-http-enabled --rpc-http-api=ETH,NET,IBFT --host-whitelist="*" --rpc-http-cors-origins="all"\
  > "out/ibft-network/bootnode-$i/log" &
  ((i=i+1))
  ((p2pPort=p2pPort+1))
  ((httpPort=httpPort+1))
done

printBesuNodesRunning
