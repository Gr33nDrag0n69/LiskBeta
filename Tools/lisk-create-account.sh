#!/bin/bash

# Gr33nDrag0n v1.0.0 (2021-03-28)

OnionFilePath="~/"

LiskAccount_JsonData=$( lisk-core account:create | jq '.[0]' )

EncryptionPassphrase=$( lisk-core account:create | jq '.[0] | .passphrase' |  tr -d '"' )


echo "================================================================================"
echo "Account Passphrase    : $( echo $LiskAccount_JsonData | jq '.passphrase' |  tr -d '"' )"
echo "================================================================================"
echo "Encryption Passphrase : $EncryptionPassphrase"
echo "================================================================================"

