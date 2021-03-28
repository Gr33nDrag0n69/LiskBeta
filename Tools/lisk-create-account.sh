#!/bin/bash

# Gr33nDrag0n v1.0.0 (2021-03-28)

#OnionFilePath="~/hash_onion.test.json"

LiskAccount_JsonData=$( lisk-core account:create | jq '.[0]' )

EncryptionPassphrase=$( lisk-core account:create | jq '.[0] | .passphrase' |  tr -d '"' )

echo "========================================================================================================================"
echo "Account Passphrase     : $( echo $LiskAccount_JsonData | jq '.passphrase' |  tr -d '"' )"
echo "Account Private Key    : $( echo $LiskAccount_JsonData | jq '.privateKey' |  tr -d '"' )"
echo "Account Public Key     : $( echo $LiskAccount_JsonData | jq '.publicKey' |  tr -d '"' )"
echo "Account Binary Address : $( echo $LiskAccount_JsonData | jq '.binaryAddress' |  tr -d '"' )"
echo "Account Address        : $( echo $LiskAccount_JsonData | jq '.address' |  tr -d '"' )"
echo "========================================================================================================================"
echo "Encryption Passphrase  : $EncryptionPassphrase"
echo "========================================================================================================================"

#lisk-core hash-onion -o "$OnionFilePath"
