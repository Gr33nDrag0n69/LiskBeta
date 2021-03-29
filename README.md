Misc. stuff related to lisk-core beta network.

- [Disclaimer](#disclaimer)
- [Links](#links)
  - [Documentation](#documentation)
  - [Faucet](#faucet)
  - [Explorer](#explorer)
  - [Guides](#guides)
  - [Public API Endpoints](#public-api-endpoints)
  - [Scripts](#scripts)
- [Install Lisk-Core 3 Beta 5 on Ubuntu](#install-lisk-core-3-beta-5-on-ubuntu)
  - [Install Base](#install-base)
  - [Configure UFW firewall](#configure-ufw-firewall)
  - [Install Lisk-Core Using Binary Method](#install-lisk-core-using-binary-method)
  - [Install & Configure PM2](#install--configure-pm2)
  - [Create Bash Alias](#create-bash-alias)
  - [Start Lisk](#start-lisk)
  - [Download & Execute Delegate Account Creation Script](#download--execute-delegate-account-creation-script)
  - [Copy Auto Config.json to Production Path](#copy-auto-configjson-to-production-path)
  - [Restart PM2 (Reload Lisk on production config.)](#restart-pm2-reload-lisk-on-production-config)
  - [Fund the account](#fund-the-account)
  - [Wait for funds](#wait-for-funds)
  - [Register Delegate Name](#register-delegate-name)
  - [Download Forging Enable Script](#download-forging-enable-script)
  - [Activate Forging](#activate-forging)
  - [Self-Vote your delegate account](#self-vote-your-delegate-account)
- [Configure HTTPS API Endpoint](#configure-https-api-endpoint)
  - [Configure UFW firewall](#configure-ufw-firewall-1)
  - [Configure DNS 'A Record'](#configure-dns-a-record)
    - [Test & Wait](#test--wait)
  - [Install Nginx & Certbot](#install-nginx--certbot)
  - [Create SSL cert.](#create-ssl-cert)
  - [Configure Nginx](#configure-nginx)
  - [Update Certificate](#update-certificate)
- [API](#api)

# Disclaimer

Valid for Lisk Betanet ONLY!

**For most questions, take the time to read official Lisk-Core & Lisk-SDK documentation! [Links below](#documentation)**

This page is not intended to be a dummy proof guide, it's a guide based on my configuration and tools created by reading others guides and official documentation.

Thanks to all peoples in lisk chat network. In particular to Punkrock & Lemii for their useful notes and Korben3 & Moosty for their blockchain explorers.

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

* [Punkrock - Install Lisk BetaNet v5](https://punkrock.github.io/lisk-betanet-v5-tutorial.html)
* [Lemii - Securing a Lisk Node with Nginx and Certbot](https://github.com/Lemii/guides/blob/master/securing-a-lisk-node-with-nginx-and-certbot.md)
* [Lemii - Managing the Lisk Core process with PM2](https://github.com/Lemii/guides/blob/master/managing-the-lisk-core-process-with-pm2.md)

## Public API Endpoints

* [Lemii - lisktools.eu](https://betanet5-api.lisktools.eu/)

## Scripts

* [Gr33nDrag0n - Create Delegate Account Bash Script](./SH/lisk-create-account.sh)
* [Gr33nDrag0n - Enable Delegate Account Forging Bash Script](./SH/lisk-enable-forging.sh)

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

## Install & Configure PM2

```shell
# Install NodeJS, NPM & PM2
sudo apt-get -y install nodejs npm
sudo npm i -g pm2

# Install PM2 Max Log Size Manager
pm2 install pm2-logrotate
pm2 set pm2-logrotate:max_size 100M

# Download lisk-core configuration file for PM2
curl https://raw.githubusercontent.com/Gr33nDrag0n69/LiskBeta/main/PM2/lisk-core-first-start.pm2.json -o ~/lisk-core-first-start.pm2.json
curl https://raw.githubusercontent.com/Gr33nDrag0n69/LiskBeta/main/PM2/lisk-core.pm2.json -o ~/lisk-core.pm2.json

```

## Create Bash Alias

```shell
cat > ~/.bash_aliases << EOF_Alias_Config 
alias lisk-firststart='pm2 start ~/lisk-core-first-start.pm2.json'
alias lisk-start='pm2 start ~/lisk-core.pm2.json'
alias lisk-stop='pm2 stop lisk-core'
alias lisk-logs='tail -f ~/.lisk/lisk-core/logs/lisk.log'
alias lisk-pm2logs='pm2 logs'
alias lisk-lastblocks='tail -n 1000 ~/.lisk/lisk-core/logs/lisk.log | grep "Forged new block"'
alias lisk-forge='~/lisk-enable-forging.sh'
EOF_Alias_Config

source ~/.bashrc
```

## Start Lisk

```shell
lisk-firststart

# Verify Lisk-Core Logs (Optional)
lisk-logs

# Verify PM2 Logs (Optional)
lisk-pm2-logs
```

## Download & Execute Delegate Account Creation Script

All-in-one script tasks:
* Create Account
* Create Encryption Password
* Create Encrypted Passphrase
* Create Auto Hash-Onion File to ~/lisk-auto-onion.json
* Create Auto Config.json File to ~/lisk-auto-config.json

```shell
curl https://raw.githubusercontent.com/Gr33nDrag0n69/LiskBeta/main/SH/lisk-create-account.sh -o ~/lisk-create-account.sh
chmod 700 ~/lisk-create-account.sh
~/lisk-create-account.sh
```

## Copy Auto Config.json to Production Path

```shell
cp ~/lisk-auto-config.json ~/lisk-core/config.json
```


## Restart PM2 (Reload Lisk on production config.)

```shell
lisk-stop
lisk-start
```

## Fund the account

1. Using [Lisk.io Faucet](https://betanet5-faucet.lisk.io/) with 'Account Address'.
2. Asking Shuse2 in Lisk's Discord using 'Account BinaryAddress'.

## Wait for funds
*Edit ##AccountBinaryAddress##*

```shell
lisk-core account:get ##AccountBinaryAddress##
```

## Register Delegate Name
*Edit ##DelegateName## & ##AccountPassphrase##*

```shell
# Create Tx

lisk-core transaction:create 5 0 1100000000

? Please enter username:      ##DelegateName##
? Please enter passphrase:    ##AccountPassphrase##
? Please re-enter passphrase: ##AccountPassphrase##

# Save Output

{"transaction":"0805...005"}

# Broadcast Tx

lisk-core transaction:send 0805...005

# Should output

Transaction with id: 'a3d...5b0' received by node.
```

## Download Forging Enable Script

```shell
curl https://raw.githubusercontent.com/Gr33nDrag0n69/LiskBeta/main/SH/lisk-enable-forging.sh -o ~/lisk-enable-forging.sh
chmod 700 ~/lisk-enable-forging.sh
```
## Activate Forging

```shell
lisk-forge
```
## Self-Vote your delegate account

*TODO*


# Configure HTTPS API Endpoint

## Configure UFW firewall

```shell
sudo ufw allow "80/tcp"
sudo ufw allow "443/tcp"

sudo ufw status
```

## Configure DNS 'A Record'

Using your domain name DNS manager, create a 'A Record'.

Example:
```txt
100.150.200.250/32      beta.domain.com
```

### Test & Wait

Before you can continue, you must make sure the DNS record is working.
Best way to test it is to ping the A record address and wait for the IP to resolve correctly.

## Install Nginx & Certbot

```shell
sudo apt-get -y install nginx certbot python-certbot-nginx
```

## Create SSL cert.
*Edit DomainName & Email*

```shell
sudo certbot --nginx -d beta.domain.com --email forgetit@notstupid.com --agree-tos
```

## Configure Nginx

*TODO*

## Update Certificate

*TODO*

# API

*TODO*
