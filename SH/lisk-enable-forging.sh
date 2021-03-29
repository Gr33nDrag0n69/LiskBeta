#!/bin/bash

# Gr33nDrag0n v1.1.0 (2021-03-29)

ForgingStatus=$( lisk-core forging:status )

BinaryAddress=$( echo $ForgingStatus | jq '.[0] | .address' | tr -d '"' )

Height=$( echo $ForgingStatus | jq '.[0] | .height' )
if [ "$Height" = "null" ]
then
      Height="0"
fi

MaxHeightPreviouslyForged=$( echo $ForgingStatus | jq '.[0] | .maxHeightPreviouslyForged' )
if [ "$MaxHeightPreviouslyForged" = "null" ]
then
      MaxHeightPreviouslyForged="0"
fi

MaxHeightPrevoted=$( echo $ForgingStatus | jq '.[0] | .maxHeightPrevoted' )
if [ "$MaxHeightPrevoted" = "null" ]
then
      MaxHeightPrevoted="0"
fi

echo "Command: lisk-core forging:enable $BinaryAddress $Height $MaxHeightPreviouslyForged $MaxHeightPrevoted"

lisk-core forging:enable $BinaryAddress $Height $MaxHeightPreviouslyForged $MaxHeightPrevoted
