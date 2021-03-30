
Lisk-Core API Configuration

- [Basic Configuration](#basic-configuration)
  - [Enable HTTP API plugin](#enable-http-api-plugin)
  - [Configure API whitelist](#configure-api-whitelist)
- [Advanced Configuration](#advanced-configuration)
  - [Configure UFW firewall](#configure-ufw-firewall)
  - [Configure DNS 'A Record'](#configure-dns-a-record)
    - [Test & Wait](#test--wait)
  - [Install Nginx & Certbot](#install-nginx--certbot)
  - [Create SSL cert.](#create-ssl-cert)
  - [Configure Nginx](#configure-nginx)
  - [Update Certificate](#update-certificate)

# Basic Configuration

## Enable HTTP API plugin

By default, with lisk-core 3, the HTTP API is disabled.
To enable it, the lisk-core process need to be started with the `--enable-http-api-plugin` parameter.
If you use my PM2 configuration file to manage the process, it's enabled by default.

Test the local API is functional:
```shell
```

## Configure API whitelist

The config.json file you are using should have the following configuration in it.
If not present, add it now and restart the lisk-core process.
```json
{
    "plugins": {
        "httpApi": {
            "whiteList": [
                "127.0.0.1"
            ]
        }
    }
}
```

The main idea here is to make sure that any API calls made on default communication ports (5000, 5001) that are not coming from local server will be blocked.

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
