killall coaid
killall coaid
killall coaid
killall coaid

rm -rf ./testnode-1
rm -rf ./testnode-2
rm -rf ./testnode-3


coaid init node1 --chain-id evmos_9000-1 --home ./testnode-1
coaid init node2 --chain-id evmos_9000-1 --home ./testnode-2
coaid init node3 --chain-id evmos_9000-1 --home ./testnode-3


coaid keys add val1 --keyring-backend test --home ./testnode-1
coaid keys add val2 --keyring-backend test --home ./testnode-2
coaid keys add val3 --keyring-backend test --home ./testnode-3




VAL1=$(coaid keys show val1 -a --keyring-backend test --home ./testnode-1)
VAL2=$(coaid keys show val2 -a --keyring-backend test --home ./testnode-2)
VAL3=$(coaid keys show val3 -a --keyring-backend test --home ./testnode-3)


echo $VAL1
echo $VAL2
echo $VAL3

GENESIS=./testnode-1/config/genesis.json
TMP_GENESIS=./testnode-1/config/tmp_genesis.json

jq '.app_state["staking"]["params"]["bond_denom"]="acoai"' "$GENESIS" >"$TMP_GENESIS" && mv "$TMP_GENESIS" "$GENESIS"
jq '.app_state["gov"]["deposit_params"]["min_deposit"][0]["denom"]="acoai"' "$GENESIS" >"$TMP_GENESIS" && mv "$TMP_GENESIS" "$GENESIS"
        # When upgrade to cosmos-sdk v0.47, use gov.params to edit the deposit params
jq '.app_state["gov"]["params"]["min_deposit"][0]["denom"]="acoai"' "$GENESIS" >"$TMP_GENESIS" && mv "$TMP_GENESIS" "$GENESIS"
jq '.app_state["evm"]["params"]["evm_denom"]="acoai"' "$GENESIS" >"$TMP_GENESIS" && mv "$TMP_GENESIS" "$GENESIS"
jq '.app_state["inflation"]["params"]["mint_denom"]="acoai"' "$GENESIS" >"$TMP_GENESIS" && mv "$TMP_GENESIS" "$GENESIS"


coaid add-genesis-account $VAL1 100000000000000000000000000acoai --home ./testnode-1
coaid add-genesis-account $VAL2 100000000000000000000000000acoai --home ./testnode-1
coaid add-genesis-account $VAL3 100000000000000000000000000acoai --home ./testnode-1

cp ./testnode-1/config/genesis.json ./testnode-2/config/genesis.json
cp ./testnode-1/config/genesis.json ./testnode-3/config/genesis.json

coaid gentx val1 1000000000000000000000acoai  --chain-id evmos_9000-1  --keyring-backend test --home ./testnode-1/ --gas-prices 1000000000acoai
coaid gentx val2 1000000000000000000000acoai  --chain-id evmos_9000-1  --keyring-backend test --home ./testnode-2/ --gas-prices 1000000000acoai
coaid gentx val3 1000000000000000000000acoai  --chain-id evmos_9000-1  --keyring-backend test --home ./testnode-3/ --gas-prices 1000000000acoai






cp ./testnode-2/config/gentx/* ./testnode-1/config/gentx/
cp ./testnode-3/config/gentx/* ./testnode-1/config/gentx/


coaid collect-gentxs --home ./testnode-1

cp ./testnode-1/config/genesis.json ./testnode-2/config/genesis.json
cp ./testnode-1/config/genesis.json ./testnode-3/config/genesis.json


NODE1_ID=$(coaid tendermint show-node-id --home ./testnode-1)

echo $NODE1_ID

sed -i \
  -e 's|allow_duplicate_ip = false|allow_duplicate_ip = true|g' \
  -e 's|persistent_peers = ".*"|persistent_peers = ""|g' \
  ./testnode-1/config/config.toml


sed -i \
  -e 's|proxy_app = "tcp://127.0.0.1:26658"|proxy_app = "tcp://127.0.0.1:36658"|g' \
  -e 's|laddr = "tcp://0.0.0.0:26656"|laddr = "tcp://0.0.0.0:36656"|g' \
  -e 's|laddr = "tcp://127.0.0.1:26657"|laddr = "tcp://127.0.0.1:36657"|g' \
  -e 's|pprof_laddr = "localhost:6060"|pprof_laddr = "localhost:6061"|g' \
  -e "s|persistent_peers = \"\"|persistent_peers = \"${NODE1_ID}@0.0.0.0:26656\"|g" \
  -e 's|allow_duplicate_ip = false|allow_duplicate_ip = true|g' \
  ./testnode-2/config/config.toml

sed -i \
  -e 's|proxy_app = "tcp://127.0.0.1:26658"|proxy_app = "tcp://127.0.0.1:46658"|g' \
  -e 's|laddr = "tcp://0.0.0.0:26656"|laddr = "tcp://0.0.0.0:46656"|g' \
  -e 's|laddr = "tcp://127.0.0.1:26657"|laddr = "tcp://127.0.0.1:46657"|g' \
  -e 's|pprof_laddr = "localhost:6060"|pprof_laddr = "localhost:6062"|g' \
  -e "s|persistent_peers = \"\"|persistent_peers = \"${NODE1_ID}@0.0.0.0:26656\"|g" \
  -e 's|allow_duplicate_ip = false|allow_duplicate_ip = true|g' \
  ./testnode-3/config/config.toml

rm -rf node-1.log
rm -rf node-2.log
rm -rf node-3.log

coaid start --home ./testnode-1 --chain-id evmos_9000-1 > node-1.log 2>&1 &
coaid start --home ./testnode-2 --chain-id evmos_9000-1 > node-2.log 2>&1 &
coaid start --home ./testnode-3 --chain-id evmos_9000-1 > node-3.log 2>&1 &
