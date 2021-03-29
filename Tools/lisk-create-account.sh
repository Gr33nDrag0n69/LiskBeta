#!/bin/bash

# Gr33nDrag0n v1.0.0 (2021-03-28)

Onion_FilePath="$HOME/lisk-auto-onion.json"
Config_FilePath="$HOME/lisk-auto-config.json"

echo -e "Creating Account ...\n"
LiskAccount_JsonData=$( lisk-core account:create | jq '.[0]' )
AccountPassphrase=$( echo $LiskAccount_JsonData | jq '.passphrase' |  tr -d '"' )
AccountPrivateKey=$( echo $LiskAccount_JsonData | jq '.privateKey' |  tr -d '"' )
AccountPublicKey=$( echo $LiskAccount_JsonData | jq '.publicKey' |  tr -d '"' )
AccountBinaryAddress=$( echo $LiskAccount_JsonData | jq '.binaryAddress' |  tr -d '"' )
AccountAddress=$( echo $LiskAccount_JsonData | jq '.address' |  tr -d '"' )

echo -e "Creating Encryption Password ...\n"
EncryptionPassword=$( lisk-core account:create | jq '.[0] | .passphrase' |  tr -d '"' )

echo -e "Creating Account Encrypted Passphrase ...\n"
EncryptedPassphrase=$( lisk-core passphrase:encrypt --password "$EncryptionPassword" --passphrase "$AccountPassphrase" | jq '.encryptedPassphrase' |  tr -d '"' )

echo -e "Writing Hash-Onion to $Onion_FilePath ...\n"
lisk-core hash-onion -o $Onion_FilePath

echo -e "Loading Hash-Onion to Memory ...\n"
HashOnion=$( cat $Onion_FilePath )

echo -e "Writing Config to $Config_FilePath ...\n"
cat > $Config_FilePath << EOF_Config 
{
    "logger": {
        "fileLogLevel": "info"
    },

    "forging": {
        "delegates": [
            {
                "address":"$AccountBinaryAddress",
                "encryptedPassphrase":"$EncryptedPassphrase",
                "hashOnion": $HashOnion
            }
        ]
    },

    "plugins": {
        "httpApi": {
            "whiteList": [
                "127.0.0.1"
            ]
        }
    }
}
EOF_Config

echo ""
echo "========================================================================================================================"
echo ""
echo "Passphrase           : $AccountPassphrase"
echo "Private Key          : $AccountPrivateKey"
echo "Public Key           : $AccountPublicKey"
echo "Binary Address       : $AccountBinaryAddress"
echo "Address              : $AccountAddress"
echo "Encryption Password  : $EncryptionPassword"
echo ""
echo "========================================================================================================================"
echo ""
echo "IMPORTANT: Save a copy of the previous values to a safe place!"
echo ""
