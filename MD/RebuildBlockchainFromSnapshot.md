![##Header##](../PNG/Header.png)

# Download & Import Latest Snapshot

Stop Lisk-Core

Rebuild Blockchain
```shell
# Download and validate latest snapshot:

# Lisk.io:
lisk-core blockchain:download --url https://snapshots.lisk.io/betanet/blockchain.db.tar.gz --output ~/

# LiskNode.io (SOON™):
lisk-core blockchain:download --url https://betanet-snapshot.lisknode.io/blockchain.db.tar.gz --output ~/

# Import to DB:
lisk-core blockchain:import ~/blockchain.db.tar.gz --force

# Delete downloaded files:
rm -f ~/blockchain.db.tar.gz
rm -f ~/blockchain.db.tar.gz.SHA256
```

Start Lisk-Core
