#!/bin/bash

if ([ "$#" -ne "1" ]); then
	echo "Usage: $0 <Target File>"
	exit 1
fi

TARG=$1

if ([ ! -f $TARG ]); then
	echo "ERROR: File $TARG does not exist. Operation aborted."
	exit 1
fi

sed -i -e 's/\r$//' $TARG
