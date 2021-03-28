#!/bin/bash

# Gr33nDrag0n v1.0.0 (2021-03-28)

#Onion_FilePath="~/hash_onion.test.json"
#Config_FilePath="~/lisk-core/config.json"

LiskAccount_JsonData=$( lisk-core account:create | jq '.[0]' )

AccountPassphrase=$( echo $LiskAccount_JsonData | jq '.passphrase' |  tr -d '"' )
AccountPrivateKey=$( echo $LiskAccount_JsonData | jq '.privateKey' |  tr -d '"' )
AccountPublicKey=$( echo $LiskAccount_JsonData | jq '.publicKey' |  tr -d '"' )
AccountBinaryAddress=$( echo $LiskAccount_JsonData | jq '.binaryAddress' |  tr -d '"' )
AccountAddress=$( echo $LiskAccount_JsonData | jq '.address' |  tr -d '"' )

EncryptionPassword=$( lisk-core account:create | jq '.[0] | .passphrase' |  tr -d '"' )

EncryptedPassphrase=$( lisk-core passphrase:encrypt --password "$EncryptionPassword" --passphrase "$AccountPassphrase" | jq '.encryptedPassphrase' |  tr -d '"' )

echo ""
echo "========================================================================================================================"
echo ""
echo "Passphrase           : $AccountPassphrase"
echo "Private Key          : $AccountPrivateKey"
echo "Public Key           : $AccountPublicKey"
echo "Binary Address       : $AccountBinaryAddress"
echo "Address              : $AccountAddress"
echo "Encryption Password  : $EncryptionPassword"
echo "Encrypted Passphrase : $EncryptedPassphrase"
echo ""
echo "========================================================================================================================"
echo ""

#lisk-core hash-onion -o "$OnionFilePath"
