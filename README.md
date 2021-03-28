Misc. stuff related to lisk-core beta network.

- [Disclaimer](#disclaimer)
- [Links](#links)
  - [Documentation](#documentation)
  - [Faucet](#faucet)
  - [Explorer](#explorer)
  - [Guides](#guides)
  - [Public API Endpoints](#public-api-endpoints)
  - [Tools](#tools)
- [Install Lisk-Core 3 Beta 5 on Ubuntu](#install-lisk-core-3-beta-5-on-ubuntu)
  - [Install Base](#install-base)
  - [Configure UFW firewall](#configure-ufw-firewall)
  - [Install Lisk-Core Using Binary Method](#install-lisk-core-using-binary-method)
  - [Create your account](#create-your-account)
  - [Fund the account](#fund-the-account)
  - [Create an 'Encryption Password'](#create-an-encryption-password)
  - [Create the encrypted version of your Account Passphrase](#create-the-encrypted-version-of-your-account-passphrase)
  - [Generate hash onion](#generate-hash-onion)
  - [Create custom 'config.json' file](#create-custom-configjson-file)
  - [Install & Configure PM2](#install--configure-pm2)
    - [Install NodeJS, NPM & PM2](#install-nodejs-npm--pm2)
    - [Install PM2 Max Log Size Manager](#install-pm2-max-log-size-manager)
    - [Create lisk-core start configuration file for PM2](#create-lisk-core-start-configuration-file-for-pm2)
  - [Create Forging Enable script and make it executable](#create-forging-enable-script-and-make-it-executable)
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

## Tools

* [Gr33nDrag0n - Enable Delegate Account Forging Bash Script](./Tools/lisk-forging-enable.sh)

# Install Lisk-Core 3 Beta 5 on Ubuntu

## Install Base

```shell
sudo apt-get -y install wget tar zip unzip ufw htop npm git curl bash jq nodejs npm
```

## Configure UFW firewall

**Important:** To not get locked out of your server, make sure your management IP is static to use 'Allow From' command. If you are not sure of what to do, don't use 'Allow From' and just open port 22 (SSH) with `sudo ufw allow '22/tcp'`.

```shell
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Static Management IP
sudo ufw allow from "100.150.200.250/32"

# DNS
sudo ufw allow "53/udp"

# NTP (Optional)
sudo ufw allow "123/udp"

# Mail Server (Optional)
sudo ufw allow "25/tcp"

# Nginx (Lisk-Core API, Optional)
sudo ufw allow "80/tcp"
sudo ufw allow "443/tcp"

# Lisk-Core
sudo ufw allow "5000/tcp"
sudo ufw allow "5001/tcp"

sudo ufw --force enable
sudo ufw status
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

Save the output to a safe place. *Refered as:**##AccountProperty** for the rest of these notes.*

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

Or ask Shuse2 at Lisk's Discord using account BinaryAddress.

## Create an 'Encryption Password'

```shell
lisk-core account:create
```

Save the dummy account passphrase to a safe place. *Refered as:**##EncryptionPassword##** for the rest of these notes.*

Example:
```txt
Encryption Password:

minimum effort act inspire convince student interest borrow loan radar lab depart
```

## Create the encrypted version of your Account Passphrase

```shell
lisk-core passphrase:encrypt

Please enter your secret passphrase:    ##AccountPassphrase##
Please re-enter your secret passphrase: ##AccountPassphrase##
Please enter your password:             ##EncryptionPassword## 
Please re-enter your password:          ##EncryptionPassword##
```

Save the json output to a safe place. *Refered as:**##EncryptedAccountPassphrase##** for the rest of these notes.*

Example:
```json
{
    "encryptedPassphrase":"iterations=1000000&cipherText=fc9375fa0bd91efe168c517bdc2fbab79506afe8dddc30253a48641c3e692801cfd049cc13a925439d36635fbcb255880c64975127b9abd65ba10be978d010c6b685b2fd9c11554ec02343&iv=26ebd88e23e999044b0f943b&salt=478843d5df5b6984d07324161d612243&tag=0dfc78bf05ba48774a87790e6a42798b&version=1"
}
```

## Generate hash onion

```shell
lisk-core hash-onion -o ~/hash_onion.json
```

## Create custom 'config.json' file

TODO

## Install & Configure PM2

### Install NodeJS, NPM & PM2

```shell
sudo apt-get -y install nodejs npm
sudo npm i -g pm2
```

### Install PM2 Max Log Size Manager

pm2 install pm2-logrotate
pm2 set pm2-logrotate:max_size 100M

### Create lisk-core start configuration file for PM2

```shell
curl https://raw.githubusercontent.com/Gr33nDrag0n69/LiskBeta/main/Tools/lisk-core.pm2.json -o ~/lisk-core.pm2.json
```

## Create Forging Enable script and make it executable

```shell
curl https://raw.githubusercontent.com/Gr33nDrag0n69/LiskBeta/main/Tools/lisk-forging-enable.sh -o ~/lisk-forge-enable.sh
chmod 700 ~/lisk-forging-enable.sh
```

## Nginx & SSL Notes

*TODO*

## API Notes

TODO
