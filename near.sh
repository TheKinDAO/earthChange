#!/bin/bash
# TODO: Skip storage_deposit when accountId is already 'registered'.

set -ex
# export NEAR_ENV=mainnet
# ID=earthchange.near
export master="agnucius.testnet"
export accountId="ec.$master"

echo "This script is untested, so exiting for now..."
exit 0

# near delete $ID $accountId
# near create-account $ID --masterAccount $accountId

near view $accountId ft_balance_of '{"account_id": "'$accountId'"}'
near view $accountId ft_metadata

## TRANSFER
# Pay storage_deposit, else: "Smart contract panicked: The account $master is not registered"
near call $accountId storage_deposit '' --accountId "$master" --amount 0.00125

# Now transfer
near call $accountId ft_transfer '{"receiver_id": "'$master'", "amount": "1"}' --accountId $accountId --amount 0.000000000000000000000001
