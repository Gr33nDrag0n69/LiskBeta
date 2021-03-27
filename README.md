# LiskBeta
Misc. stuff related to lisk-core beta network.

- [LiskBeta](#liskbeta)
  - [Disclaimer](#disclaimer)
  - [Links](#links)
    - [Documentation](#documentation)
    - [Faucet](#faucet)
    - [Explorer](#explorer)
    - [Guides](#guides)
    - [Public API Endpoints](#public-api-endpoints)
  - [Tools](#tools)
  - [Install/Update Notes](#installupdate-notes)
  - [PM2 Notes](#pm2-notes)
  - [Nginx & SSL Notes](#nginx--ssl-notes)
    - [API Notes](#api-notes)

## Disclaimer

Valid for Lisk Betanet ONLY!

**For most questions, take the time to read official Lisk-Core & Lisk-SDK documentation! [Links below](#documentation)**

This page is not intended to be a dummy proof guide, more a sanitized version of my personnal notes created by reading others guides and official documentation.

Thanks to all peoples in lisk chat network. In particular to Punkrock & Lemii for their useful notes and Korben3 & Moosty for their blockcahin explorers.

## Links

### Documentation

* [Lisk.io - Lisk-Core Documentation](https://lisk.io/documentation/lisk-core/v3/index.html)
  * [Lisk-Core CLI](https://lisk.io/documentation/lisk-core/v3/reference/cli.html)
  * [Lisk-Core API](https://lisk.io/documentation/lisk-core/v3/reference/api.html)
* [Lisk.io - Lisk-SDK Documentation](https://lisk.io/documentation/lisk-sdk/)

### Faucet

* [Lisk.io - BetaNet 5 Faucet](https://betanet5-faucet.lisk.io/)

### Explorer

* [Moosty - LiskScan Beta Explorer](https://explorer.moosty.com/)
* [Korben3 - Mini-Explorer](http://liskminiexplorer.korben3.com/)

### Guides

* [Punkrock - Install Lisk Betanet v5](https://punkrock.github.io/lisk-betanet-v5-tutorial.html)
* [Lemii - Securing a Lisk Node with Nginx and Certbot](https://github.com/Lemii/guides/blob/master/securing-a-lisk-node-with-nginx-and-certbot.md)
* [Lemii - Managing the Lisk Core process with PM2](https://github.com/Lemii/guides/blob/master/managing-the-lisk-core-process-with-pm2.md)

### Public API Endpoints

* [Lemii - lisktools.eu](https://betanet5-api.lisktools.eu/)

## Tools

[lisk-forging-enable.sh](./Tools/lisk-forging-enable.sh)


## Install/Update Notes

```
# Install Base

sudo apt-get -y install wget tar zip unzip ufw htop npm git curl bash jq nodejs npm

# Install Lisk

curl https://downloads.lisk.io/lisk/betanet/3.0.0-beta.5/lisk-core-v3.0.0-beta.5-linux-x64.tar.gz -o lisk-core.tar.gz
tar -xf ./lisk-core.tar.gz
rm -f ./lisk-core.tar.gz
echo 'export PATH="$PATH:$HOME/lisk-core/bin"' >> ~/.bashrc
source ~/.bashrc

# Create your account

lisk-core account:create

# Copy/save account output (Refered as ##Account-XXX## for the rest of these notes.)

# Fund the account

https://betanet5-faucet.lisk.io/

Or ask Shuse2 at Lisk's Discord using binaryAddress.

# Create a random 12-word passphrase

lisk-core account:create

# Save only the passphrase value. (Refered as ##EncryptionPassword## for the rest of these notes.)

lisk-core passphrase:encrypt

Please enter your secret passphrase:    ##Account-passphrase##
Please re-enter your secret passphrase: ##Account-passphrase##
Please enter your password:             ##EncryptionPassword## 
Please re-enter your password:          ##EncryptionPassword##

# Save Command Output. (Refered as ##EncryptedPassphrase## for the rest of these notes.)

# Generate Hash onion

lisk-core hash-onion -o ~/hash_onion.json


INCOMPLETED! (TODO)


```


## PM2 Notes

TODO

## Nginx & SSL Notes

TODO

### API Notes

TODO
