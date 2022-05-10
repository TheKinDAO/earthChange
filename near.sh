#!/bin/bash
# TODO: Skip storage_deposit when accountId is already 'registered'.

set -ex

if [[ "$1" == "" ]]; then
    echo "Arg1: Receiver ID"
    exit 22
fi

export master="$1"
# export NEAR_ENV=mainnet
# export master="suicunga.near"
export accountId="earthchange.near"

# export master="agnucius.testnet"
# export accountId="ec.$master"

# near delete $ID $accountId
# near create-account $ID --masterAccount $accountId

# near view $accountId ft_balance_of '{"account_id": "'$accountId'"}'
# near view $accountId ft_metadata

## TRANSFER
# Pay storage_deposit, else: "Smart contract panicked: The account $master is not registered"
near call $accountId storage_deposit '' --accountId "$master" --amount 0.00125

# Now transfer
near call $accountId ft_transfer '{"receiver_id": "'$master'", "amount": "1"}' --accountId $accountId --amount 0.000000000000000000000001
