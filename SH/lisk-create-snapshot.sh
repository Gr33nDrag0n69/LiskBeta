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

OUTPUT_DIRECTORY="/opt/nginx/betanet-snapshot.lisknode.io"
OUTPUT_GZIP_FILENAME="blockchain.db.tar.gz"
OUTPUT_GZIP_FILEPATH="${OUTPUT_DIRECTORY}/${OUTPUT_GZIP_FILENAME}"
OUTPUT_HASH_FILEPATH="${OUTPUT_DIRECTORY}/${OUTPUT_GZIP_FILENAME}.SHA256"

DAYS_TO_KEEP="5" # Use 0 to disable the feature
PM2_CONFIG="~/lisk-core.pm2.json"

### Function(s) #######################################################################################################

now() {
    date +'%Y-%m-%d %H:%M:%S'
}

### MAIN ##############################################################################################################

echo -e "\\n$(now) Get Blockchain Height"

NODEINFO_JSON=$( lisk-core node:info )

if [ -z "${NODEINFO_JSON}" ]; then
    echo  -e "\\n$(now) ERROR: Node Info is invalid. Aborting..."
    exit 1
fi

HEIGHT=$( echo $NODEINFO_JSON | jq '.height' )
echo -e "\\n$(now) Blockchain Height: ${HEIGHT}"

echo -e "\\n$(now) Stop Lisk-Core & Wait 3 seconds"
pm2 stop lisk-core --silent && sleep 3

echo -e "\\n$(now) Get Blockchain SHA256 Hash"
HASH=$( lisk-core blockchain:hash )

echo -e "\\n$(now) Create ${OUTPUT_GZIP_FILENAME}"
lisk-core blockchain:export --output "${OUTPUT_DIRECTORY}"

echo -e "\\n$(now) Create ${OUTPUT_GZIP_FILENAME}.SHA256"
echo -e "${HASH}  ${OUTPUT_GZIP_FILENAME}" > "$OUTPUT_HASH_FILEPATH"

echo -e "\\n$(now) Start Lisk-Core"
pm2 start ~/lisk-core.pm2.json --silent

OUTPUT_GZIP_COPY_FILENAME="blockchain-${HEIGHT}.db.tar.gz"
OUTPUT_GZIP_COPY_FILEPATH="${OUTPUT_DIRECTORY}/${OUTPUT_GZIP_COPY_FILENAME}"
OUTPUT_HASH_COPY_FILEPATH="${OUTPUT_DIRECTORY}/${OUTPUT_GZIP_COPY_FILENAME}.SHA256"

echo -e "\\n$(now) Create ${OUTPUT_GZIP_COPY_FILENAME}"
cp "${OUTPUT_GZIP_FILEPATH}" "${OUTPUT_GZIP_COPY_FILEPATH}"

echo -e "\\n$(now) Create ${OUTPUT_GZIP_COPY_FILENAME}.SHA256"
echo -e "${HASH}  ${OUTPUT_GZIP_COPY_FILENAME}" > "$OUTPUT_HASH_COPY_FILEPATH"

echo -e "\\n$(now) Update new files permissions"
chmod 644 "$OUTPUT_GZIP_FILEPATH"
chmod 644 "$OUTPUT_HASH_FILEPATH"
chmod 644 "$OUTPUT_GZIP_COPY_FILEPATH"
chmod 644 "$OUTPUT_HASH_COPY_FILEPATH"

if [ "$DAYS_TO_KEEP" -gt 0 ]; then
    echo -e "\\n$(now) Deleting snapshots older then $DAYS_TO_KEEP day(s)"
    mkdir -p "$OUTPUT_DIRECTORY" &> /dev/null
    find "$OUTPUT_DIRECTORY" -name "blockchain-*.db.tar.gz*" -mtime +"$(( DAYS_TO_KEEP - 1 ))" -exec rm {} \;
fi

exit 0
