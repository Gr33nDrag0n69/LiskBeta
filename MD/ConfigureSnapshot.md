![##Header##](../PNG/Header.png)

Configure automated snapshot & share them using Nginx

- [Configure Automated Snapshot](#configure-automated-snapshot)
- [Configure Nginx](#configure-nginx)
  - [Configure UFW firewall](#configure-ufw-firewall)
  - [Configure DNS 'A Record'](#configure-dns-a-record)
    - [Test & Wait](#test--wait)
  - [Install Nginx & Certbot](#install-nginx--certbot)
  - [Create SSL cert.](#create-ssl-cert)
  - [Configure Nginx](#configure-nginx-1)
  - [Test Website](#test-website)
  - [Manually Update Certificate](#manually-update-certificate)

# Configure Automated Snapshot

**My script use PM2 to manage lisk-core process. If you are not using PM2, please see my other guide for PM2 configuration or edit the `lisk-create-snapshot.sh` script for the Start Lisk & Stop Lisk code blocks.**

**Edit ##Username## & ##OutputPath##**

```shell
# Create Output directory
OutputPath="/opt/nginx/betanet-snapshot.lisknode.io/"
sudo mkdir -p "${OutputPath}"
sudo touch "${OutputPath}### Vote Gr33nDrag0n ###"

sudo chown -R ##Username##:##Username## "${OutputPath}"

# Download `lisk-create-snapshot.sh` script
curl -s https://raw.githubusercontent.com/Gr33nDrag0n69/LiskBeta/main/SH/lisk-create-snapshot.sh -o ~/lisk-create-snapshot.sh && chmod 700 ~/lisk-create-snapshot.sh

# Edit Script Configuration

vi ~/lisk-create-snapshot.sh

# Test Script Manually

~/lisk-create-snapshot.sh

# Create Cronjob

crontab -e
#----------------------------------------
0 */3 * * * /bin/bash ~/lisk-create-snapshot.sh > ~/lisk-create-snapshot.log 2>&1
#----------------------------------------

```

# Configure Nginx


**In the guide I use `betanet-snapshot.lisknode.io` as the domain, `100.150.200.250` as the server IP.
Make sure to adapt the commands to your own specific configuration.**

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
100.150.200.250/32      betanet-snapshot.lisknode.io
```

### Test & Wait

Before you can continue, you must make sure the DNS record is working.
Best way to test it is to ping the A record address and wait for the IP to resolve correctly.

## Install Nginx & Certbot 

```shell
sudo apt-get -y install nginx
sudo apt-get -y install certbot

# Ubuntu 18
sudo apt-get -y install python-certbot-nginx
# Ubuntu 20
sudo apt-get -y install python3-certbot-nginx
```

## Create SSL cert.
*Edit DomainName & Email*

```shell
sudo certbot certonly --nginx -d betanet-snapshot.lisknode.io --email forgetit@notstupid.com --agree-tos
```

## Configure Nginx

**If you are already running Nginx for other purpose, you will need to read config and manually merge config.**

```shell
sudo mkdir -p /etc/nginx/ssl/

sudo openssl dhparam -out /etc/nginx/ssl/dhparam.pem 4096

sudo cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.original

sudo rm -f /etc/nginx/sites-enabled/default

sudo curl -s https://raw.githubusercontent.com/Gr33nDrag0n69/LiskBeta/main/NGINX/snapshot.template.nginx.conf -o /etc/nginx/nginx.conf

sudo sed -i 's/##SNAPSHOT_FQDN##/betanet-snapshot.lisknode.io/g' /etc/nginx/nginx.conf

sudo sed -i 's|##SNAPSHOT_BASEPATH##|/opt/nginx/betanet-snapshot.lisknode.io/|g' /etc/nginx/nginx.conf

sudo systemctl restart nginx

sudo systemctl enable nginx

```

## Test Website

Open website in a browser.

## Manually Update Certificate

```shell
sudo certbot renew --force-renewal

sudo systemctl restart nginx

```

