#!/bin/bash

# Fail on error and echo every command
set -ex

echo "See ./setup.sh and ft/src/lib.rs"

refsha="$(sha256sum reference.json | base64 --wrap=0)"
echo "$refsha"

echo "This script is untested, so exiting for now..."
exit 0

case "$1" in
    main)
        export NEAR_ENV="mainnet"
        export master="suicunga.near"
        export accountId="earthchange.near"
        echo "Deploying to MAINnet on account $accountId"
        near login  # TODO: Check if already authenticated
        ;;
    test)
        export NEAR_ENV=""
        export master="agnucius.testnet"
        export accountId="ec.$master"
        echo "Deploying to TESTnet on subaccount $accountId"
        near login  # TODO: Check if already authenticated
        near delete $accountId $master
        near create-account $accountId --masterAccount $master
        ;;
    *)
        echo "'main' or 'test'"
        ;;
esac

cargo build --all --target wasm32-unknown-unknown --release
cp target/wasm32-unknown-unknown/release/*.wasm ./res/

## Deploy
near deploy --wasmFile res/fungible_token.wasm --accountId $accountId

## Initialize
near call $accountId new_default_meta '{"owner_id": "'$accountId'", "total_supply": "510000000000000"}' --accountId $accountId
## on testnet:
# IF 'Smart contract panicked: The contract has already been initialized'
# THEN gotta do `near delete` and `near create-account` as shown above

## on mainnet:
# IF 'Error: The account earthchange.near wouldn't have enough balance to cover storage, required to have 1058106027511515800000000 yoctoNEAR more'
# THEN You should transfer some NEAR to earthchange.near

cat ./near.sh
