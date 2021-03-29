#!/bin/bash

# Gr33nDrag0n v1.0.1 (2021-03-27)

ForgingStatus=$( lisk-core forging:status )

BinaryAddress=$( echo $ForgingStatus | jq '.[0] | .address' | tr -d '"' )
Height=$( echo $ForgingStatus | jq '.[0] | .height' )
MaxHeightPreviouslyForged=$( echo $ForgingStatus | jq '.[0] | .maxHeightPreviouslyForged' )
MaxHeightPrevoted=$( echo $ForgingStatus | jq '.[0] | .maxHeightPrevoted' )

echo "Command: lisk-core forging:enable $BinaryAddress $Height $MaxHeightPreviouslyForged $MaxHeightPrevoted"

lisk-core forging:enable $BinaryAddress $Height $MaxHeightPreviouslyForged $MaxHeightPrevoted
