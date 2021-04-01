Install Lisk-Core 3 Beta 5 on Ubuntu using binaries, PM2 & custom scripts

- [Install Base](#install-base)
- [Configure UFW firewall](#configure-ufw-firewall)
- [Install Lisk-Core Using Binary Method](#install-lisk-core-using-binary-method)
- [Install & Configure PM2](#install--configure-pm2)
- [Create Bash Alias](#create-bash-alias)
- [Start Lisk](#start-lisk)
- [Download & Execute Delegate Account Creation Script](#download--execute-delegate-account-creation-script)
- [Copy Auto Config.json to Production Path](#copy-auto-configjson-to-production-path)
- [Restart PM2 with 'Default' config](#restart-pm2-with-default-config)
- [Fund the account](#fund-the-account)
- [Wait for funds](#wait-for-funds)
- [Register Delegate Name](#register-delegate-name)
- [Wait for Delegate Name Registration Confirmed](#wait-for-delegate-name-registration-confirmed)
- [Download Forging Enable Script](#download-forging-enable-script)
- [Activate Forging](#activate-forging)
- [Self-Vote your delegate account](#self-vote-your-delegate-account)
- [Wait for Delegate to be voted in & forge a block](#wait-for-delegate-to-be-voted-in--forge-a-block)

## Install Base

```shell
sudo apt-get update
sudo apt-get upgrade
sudo apt-get dist-upgrade
sudo apt-get autoremove

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

# Mail Server (Optional)
sudo ufw allow "25/tcp"

# Lisk-Core
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

# Download lisk-core configuration files for PM2
curl https://raw.githubusercontent.com/Gr33nDrag0n69/LiskBeta/main/PM2/lisk-core.firststart.pm2.json -o ~/lisk-core.firststart.pm2.json
curl https://raw.githubusercontent.com/Gr33nDrag0n69/LiskBeta/main/PM2/lisk-core.default.pm2.json -o ~/lisk-core.default.pm2.json
curl https://raw.githubusercontent.com/Gr33nDrag0n69/LiskBeta/main/PM2/lisk-core.api.pm2.json -o ~/lisk-core.api.pm2.json

# Install 'FirstStart' PM2 as active configuration for lisk-start alias
cp ~/lisk-core.firststart.pm2.json ~/lisk-core.pm2.json

```

## Create Bash Alias

```shell
cat > ~/.bash_aliases << EOF_Alias_Config 
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
lisk-start

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


## Restart PM2 with 'Default' config

```shell
lisk-stop
cp ~/lisk-core.default.pm2.json ~/lisk-core.pm2.json
lisk-start
```

## Fund the account

Using [Lisk.io Faucet](https://betanet5-faucet.lisk.io/) with 'Account Address'. (Not 'Account BinaryAddress'!)

## Wait for funds
*Edit ##AccountBinaryAddress##*

```shell
lisk-core account:get ##AccountBinaryAddress## --pretty
```

Account should exist & 'token -> balance' should be greater then zero.

## Register Delegate Name
*Edit ##DelegateName## & ##AccountPassphrase##*

```txt
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

## Wait for Delegate Name Registration Confirmed
*Edit ##AccountBinaryAddress##*

```txt
lisk-core account:get ##AccountBinaryAddress## --pretty
```

Account should exist & 'dpos -> delegate -> username' should be set.

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
*Edit ##AccountBinaryAddress##, ##AccountPassphrase## & Vote Amount*

```txt
# Check Balance

lisk-core account:get ##AccountBinaryAddress##

"balance":"148900000000" = 1489 LSK

# Vote myself with 1480 LSK (Amount should be multiple of 10 * 10^8.)

lisk-core transaction:create 5 1 100000000

? Please enter: votes(delegateAddress, amount):        ##AccountBinaryAddress##,148000000000
? Want to enter another votes(delegateAddress, amount) No
? Please enter passphrase:                             ##AccountPassphrase##
? Please re-enter passphrase:                          ##AccountPassphrase##

# Save Output

{"transaction":"080...10e"}

# Broadcast Tx

lisk-core transaction:send 080...10e

# Should output

Transaction with id: 'f0c...da7' received by node.
```

## Wait for Delegate to be voted in & forge a block

1. Use one of the [explorer](https://github.com/Gr33nDrag0n69/LiskBeta#explorer).
2. Use the `lisk-lastblocks` alias command to detect forged block from the local logs. 
