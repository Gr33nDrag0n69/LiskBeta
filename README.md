Misc. stuff related to lisk-core beta network.

- [Disclaimer](#disclaimer)
- [Links](#links)
  - [Documentation](#documentation)
  - [Faucet](#faucet)
  - [Explorer](#explorer)
  - [Guides](#guides)
  - [Public API Endpoints](#public-api-endpoints)
- [Tools](#tools)
- [Install Lisk-Core 3 Beta 5](#install-lisk-core-3-beta-5)
  - [Install Base](#install-base)
  - [Install Lisk-Core Using Binary Method](#install-lisk-core-using-binary-method)
  - [Create your account](#create-your-account)
  - [Copy/save account output](#copysave-account-output)
  - [Fund the account](#fund-the-account)
  - [Create 'Encryption Passphrase' using a random 12-word passphrase](#create-encryption-passphrase-using-a-random-12-word-passphrase)
  - [Save only the passphrase value. (Refered as ##EncryptionPassword## for the rest of these notes.)](#save-only-the-passphrase-value-refered-as-encryptionpassword-for-the-rest-of-these-notes)
  - [Save Command Output. (Refered as ##EncryptedPassphrase## for the rest of these notes.)](#save-command-output-refered-as-encryptedpassphrase-for-the-rest-of-these-notes)
  - [Generate Hash onion](#generate-hash-onion)
  - [Install & Configure PM2](#install--configure-pm2)
  - [Create Lisk-Core PM2 config file](#create-lisk-core-pm2-config-file)
  - [Install & Configure PM2 LogManager](#install--configure-pm2-logmanager)
  - [Nginx & SSL Notes](#nginx--ssl-notes)
  - [API Notes](#api-notes)

# Disclaimer

Valid for Lisk Betanet ONLY!

**For most questions, take the time to read official Lisk-Core & Lisk-SDK documentation! [Links below](#documentation)**

This page is not intended to be a dummy proof guide, more a sanitized version of my personnal notes created by reading others guides and official documentation.

Thanks to all peoples in lisk chat network. In particular to Punkrock & Lemii for their useful notes and Korben3 & Moosty for their blockcahin explorers.

# Links

## Documentation

* [Lisk.io - Lisk-Core Documentation](https://lisk.io/documentation/lisk-core/v3/index.html)
  * [Lisk-Core CLI](https://lisk.io/documentation/lisk-core/v3/reference/cli.html)
  * [Lisk-Core API](https://lisk.io/documentation/lisk-core/v3/reference/api.html)
* [Lisk.io - Lisk-SDK Documentation](https://lisk.io/documentation/lisk-sdk/)

## Faucet

* [Lisk.io - BetaNet 5 Faucet](https://betanet5-faucet.lisk.io/)

## Explorer

* [Moosty - LiskScan Beta Explorer](https://explorer.moosty.com/)
* [Korben3 - Mini-Explorer](http://liskminiexplorer.korben3.com/)

## Guides

* [Punkrock - Install Lisk Betanet v5](https://punkrock.github.io/lisk-betanet-v5-tutorial.html)
* [Lemii - Securing a Lisk Node with Nginx and Certbot](https://github.com/Lemii/guides/blob/master/securing-a-lisk-node-with-nginx-and-certbot.md)
* [Lemii - Managing the Lisk Core process with PM2](https://github.com/Lemii/guides/blob/master/managing-the-lisk-core-process-with-pm2.md)

## Public API Endpoints

* [Lemii - lisktools.eu](https://betanet5-api.lisktools.eu/)

# Tools

[lisk-forging-enable.sh](./Tools/lisk-forging-enable.sh)


# Install Lisk-Core 3 Beta 5


## Install Base

```shell
sudo apt-get -y install wget tar zip unzip ufw htop npm git curl bash jq nodejs npm
```

## Install Lisk-Core Using Binary Method

```shell
curl https://downloads.lisk.io/lisk/betanet/3.0.0-beta.5/lisk-core-v3.0.0-beta.5-linux-x64.tar.gz -o lisk-core.tar.gz
tar -xf ./lisk-core.tar.gz
rm -f ./lisk-core.tar.gz
echo 'export PATH="$PATH:$HOME/lisk-core/bin"' >> ~/.bashrc
source ~/.bashrc
```

## Create your account

```shell
lisk-core account:create
```

## Copy/save account output
*Refered as ##Account-XXX## for the rest of these notes.*

Example:
```json
[
 {
  "passphrase": "useless liberty page arctic depend salt smoke chair unhappy art lecture nut",
  "privateKey": "abe2b8622f33e185c2d9635db8fea1e0c0a1408e7389e34c663a50e73d4121f433267f3bdc32124cf28016707136bcbdc9dc8033a45aefa41974f9071fca306d",
  "publicKey": "33267f3bdc32124cf28016707136bcbdc9dc8033a45aefa41974f9071fca306d",
  "binaryAddress": "2cdc32bc5df0d8a62d9808894ed07b4d791d3be5",
  "address": "lskmt7cm8vhfco6o5o2xvpkhkcs4qjyd7gm3wn7xj"
 }
]
```

## Fund the account

https://betanet5-faucet.lisk.io/

Or ask Shuse2 at Lisk's Discord using binaryAddress.

## Create 'Encryption Passphrase' using a random 12-word passphrase

```shell
lisk-core account:create
```

## Save only the passphrase value. (Refered as ##EncryptionPassword## for the rest of these notes.)


lisk-core passphrase:encrypt

Please enter your secret passphrase:    ##Account-passphrase##
Please re-enter your secret passphrase: ##Account-passphrase##
Please enter your password:             ##EncryptionPassword## 
Please re-enter your password:          ##EncryptionPassword##

## Save Command Output. (Refered as ##EncryptedPassphrase## for the rest of these notes.)

## Generate Hash onion

```shell
lisk-core hash-onion -o ~/hash_onion.json
```

## Install & Configure PM2

TODO

## Create Lisk-Core PM2 config file

## Install & Configure PM2 LogManager

TODO

## Nginx & SSL Notes

*TODO*

## API Notes

TODO
