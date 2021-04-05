#!/bin/bash

# Gr33nDrag0n v1.0.0 (2021-04-04)

lisk-core blockchain:download --url https://betanet-snapshot.lisknode.io/blockchain.db.tar.gz --output ~/
lisk-core blockchain:import ~/blockchain.db.tar.gz --force
rm -f ~/blockchain.db.tar.gz
rm -f ~/blockchain.db.tar.gz.SHA256
