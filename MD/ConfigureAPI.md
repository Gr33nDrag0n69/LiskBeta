
Lisk-Core API Configuration (INCOMPLETE - DO NOT USE YET!)

- [Basic Configuration](#basic-configuration)
  - [Enable HTTP API plugin](#enable-http-api-plugin)
    - [PM2](#pm2)
    - [BASH](#bash)
  - [Test the localhost API](#test-the-localhost-api)
- [Advanced Configuration](#advanced-configuration)
  - [Configure UFW firewall](#configure-ufw-firewall)
  - [Configure DNS 'A Record'](#configure-dns-a-record)
    - [Test & Wait](#test--wait)
  - [Install Nginx & Certbot](#install-nginx--certbot)
  - [Create SSL cert.](#create-ssl-cert)
  - [Configure Nginx](#configure-nginx)
  - [Update Certificate](#update-certificate)

# Basic Configuration

By default, with lisk-core 3, the HTTP API is disabled.
Most commands that were requiring API calls in older versions are now available with the `lisk-core` binary directly.
Make sure to give a look to these commands since the best documentation so far for lisk-core binary is the internal help file.
```shell
lisk-core --help
lisk-core start --help
```

## Enable HTTP API plugin

To enable API properly, you need to
* Enable the plugin
* Configure the port
* Configure the whitelist to localhost only

### PM2
*If you are using PM2 configuration file* 

Install 'API' PM2 as active configuration & restart the process.

```shell
lisk-stop
cp ~/lisk-core.api.pm2.json ~/lisk-core.pm2.json
lisk-start
```

### BASH
*If you are NOT using PM2 configuration file* 

Start the lisk-core process using extra parameters

```shell
lisk-core start -n betanet -c ~/lisk-core/config.json --enable-http-api-plugin --http-api-plugin-port 5678 --http-api-plugin-whitelist 127.0.0.1`
```

## Test the localhost API 

```shell
curl -X 'GET' 'http://127.0.0.1:5678/api/node/info' -H 'accept: application/json' | jq '.'
```

**If you only want to use the API Endpoint from/to the same server, you already have completed API configuration.**

# Advanced Configuration

If you want to use the API Endpoint from remote computers (workstation, server, etc.) this guide is for you.
It will allow to encrypt communication between clients and the API endpoint. (More secure)
It will also allow to limit remote IP address(es) that can send API calls to the server. (Even more secure)
If you want to provide a Public API endpoint, it will also be part of this guide.

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
100.150.200.250/32      betanet-api.lisknode.io
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
sudo certbot --nginx -d betanet-api.lisknode.io --email forgetit@notstupid.com --agree-tos
```

## Configure Nginx

*TODO*

## Update Certificate

*TODO*
