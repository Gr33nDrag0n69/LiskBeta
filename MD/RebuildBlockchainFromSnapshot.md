![##Header##](../PNG/Header.png)

# Download & Import Latest Snapshot

## Automated Script

Install
```shell
curl -s https://raw.githubusercontent.com/Gr33nDrag0n69/LiskBeta/main/SH/lisk-rebuild.sh -o ~/lisk-rebuild.sh && chmod 700 ~/lisk-rebuild.sh
```

Use
```shell
~/lisk-rebuild.sh
```

## Manual Steps

Stop Lisk-Core

Rebuild Blockchain
```shell
# Download snapshot files:

# LiskNode.io:
lisk-core blockchain:download --url https://betanet-snapshot.lisknode.io/blockchain.db.tar.gz --output ~/

# Lisk.io:
lisk-core blockchain:download --url https://snapshots.lisk.io/betanet/blockchain.db.tar.gz --output ~/

# Import to DB:
lisk-core blockchain:import ~/blockchain.db.tar.gz --force

# Delete downloaded files:
rm -f ~/blockchain.db.tar.gz
rm -f ~/blockchain.db.tar.gz.SHA256
```

Start Lisk-Core
