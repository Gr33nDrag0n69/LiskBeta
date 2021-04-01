# Download & Import Latest Snapshot

1. Stop Lisk-Core
2. Download and validate latest snapshot:
  * Using Lisk.io Server:
    `lisk-core blockchain:download --url https://snapshots.lisk.io/betanet/blockchain.db.tar.gz --output ~/`
  * **SOON™** Using LiskNode.io Server:
    `lisk-core blockchain:download --url https://betanet-snapshot.lisknode.io/blockchain.db.tar.gz --output ~/`
3. Import to DB:
   `lisk-core blockchain:import ~/blockchain.db.tar.gz --force`
4. Delete downloaded files
   `rm -f ~/blockchain.db.tar.gz*`
