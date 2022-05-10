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
near call earthchange.near new_default_meta $accountId 51000000000000000 --accountId $accountId

# near call $accountId new '{"owner_id": "'$accountId'", "total_supply": "51000000000000000", "metadata": { "spec": "ft-1.0.0", "name": "earthChange", "symbol": "EARTHCHANGE", "decimals": 2 , "reference": "https://docs.google.com/document/d/1cRYLXIQnNWfXNU88UvxdlKgdLfOyoXSvl4xyp6xytMU", "icon": "data:image/svg+xml, %3Csvg xmlns=\"http://www.w3.org/2000/svg\" width=\"180\" height=\"180\"%3E %3Cpath stroke=\"#000\" stroke-width=\"140\" stroke-dasharray=\"6,27.5\" d=\"M90,20V160M20,90H160\"/%3E %3C/svg%3E"}}' --accountId $accountId

near call $accountId new '{"owner_id": "'$accountId'", "total_supply": "51000000000000000", "metadata": { "spec": "ft-1.0.0", "name": "earthChange", "symbol": "EARTHCHANGE", "decimals": 2 , "reference": "https://docs.google.com/document/d/1cRYLXIQnNWfXNU88UvxdlKgdLfOyoXSvl4xyp6xytMU", "icon": "data:image/svg+xml, %3Csvg xmlns=\"http://www.w3.org/2000/svg\" width=\"180\" height=\"180\"%3E %3Cpath stroke=\"#000\" stroke-width=\"140\" stroke-dasharray=\"6,27.5\" d=\"M90,20V160M20,90H160\"/%3E %3C/svg%3E"}}' --accountId $accountId}


## At this point the contract should be depolyed and initialized
echo ...
near view $accountId ft_balance_of '{"account_id": "'$accountId'"}'
echo ...
# near view $accountId ft_metadata
echo ...
