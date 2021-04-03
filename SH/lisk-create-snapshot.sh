#!/bin/bash -e
#######################################################################################################################
#
# Compatible/Tested with Lisk-Core v3 Beta 5 ONLY
#
# Gr33nDrag0n69/LiskBeta/lisk-create-snapshot.sh
# Copyright (C) 2021 Gr33nDrag0n
#
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
# warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with this program.
# If not, see <http://www.gnu.org/licenses/>.
#
#######################################################################################################################

# EDIT CONFIGURATION

OUTPUT_DIRECTORY="/opt/nginx/betanet-snapshot.lisknode.io"
DAYS_TO_KEEP="5" # Use 0 to disable the feature
PM2_CONFIG="~/lisk-core.pm2.json"

### Function(s) #######################################################################################################

now() {
    date +'%Y-%m-%d %H:%M:%S'
}

### MAIN ##############################################################################################################

parse_option "$@"

### Get Blockchain Height

echo -e "\\n$(now) Get Blockchain Height"
NODEINFO_JSON=$( lisk-core node:info 2> /dev/null )

if [ -z "${NODEINFO_JSON}" ]; then
    echo  -e "\\n$(now) ERROR: Node Info is invalid. Aborting..."
    exit 1
fi

HEIGHT=$( echo $NODEINFO_JSON | jq '.height' )
echo -e "\\n$(now) Blockchain Height: ${HEIGHT}"

# Stop Lisk-Core

pm2 stop lisk-core

### Export blockchain.db

OUTPUT_GZIP_FILENAME="blockchain.db.tar.gz"
OUTPUT_GZIP_FILEPATH="${OUTPUT_DIRECTORY}/${OUTPUT_GZIP_FILENAME}"
OUTPUT_HASH_FILEPATH="${OUTPUT_DIRECTORY}/${OUTPUT_GZIP_FILENAME}.SHA256"

OUTPUT_GZIP_COPY_FILENAME="blockchain-${HEIGHT}.db.tar.gz"
OUTPUT_GZIP_COPY_FILEPATH="${OUTPUT_DIRECTORY}/${OUTPUT_GZIP_COPY_FILENAME}"
OUTPUT_HASH_COPY_FILEPATH="${OUTPUT_DIRECTORY}/${OUTPUT_GZIP_COPY_FILENAME}.SHA256"

echo -e "\\n$(now) Export blockchain.db to '${OUTPUT_GZIP_FILEPATH}'"

lisk-core blockchain:export --output "${OUTPUT_DIRECTORY}"

HASH=$( lisk-core blockchain:hash )
echo -e "------"
echo -e "$HASH  blockchain-${HEIGHT}.db.tar.gz\n"
echo -e "------"
#pm2 start ~/lisk-core.pm2.json'

#mv -f "$TEMP_FILE" "$OUTPUT_FILE"
#chmod 644 "$OUTPUT_FILE"

#cp -f "$OUTPUT_FILE" "$GENERIC_FILE"
#chmod 644 "$GENERIC_FILE"

### Create Hash File blockchain.db.tar.gz.SHA256


# Start Lisk-Core

echo -e "\\n$(now) Start Lisk-Core"
pm2 start ~/lisk-core.pm2.json

# Make GZip Copy Files



# Old GZip Files Cleanup

if [ "$DAYS_TO_KEEP" -gt 0 ]; then
    echo -e "\\n$(now) Deleting snapshots older than $DAYS_TO_KEEP day(s) in $OUTPUT_DIRECTORY"
    mkdir -p "$OUTPUT_DIRECTORY" &> /dev/null
    find "$OUTPUT_DIRECTORY" -name "blockchain-*.db.tar.gz" -mtime +"$(( DAYS_TO_KEEP - 1 ))" -exec rm {} \;
fi

# Exit

exit 0
