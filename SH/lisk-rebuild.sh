#!/bin/bash

# Gr33nDrag0n v1.0.0 (2021-04-04)

lisk-core blockchain:download --url https://betanet-snapshot.lisknode.io/blockchain.db.tar.gz --output ~/
pm2 stop lisk-core --silent && sleep 3
lisk-core blockchain:import ~/blockchain.db.tar.gz --force
pm2 start ~/lisk-core.pm2.json --silent
rm -f ~/blockchain.db.tar.gz
rm -f ~/blockchain.db.tar.gz.SHA256
