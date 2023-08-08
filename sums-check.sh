#!/bin/bash

init() {

	# Require arguments

	if [ ! "$#" -ge "1" ]; then
		echo "Usage: $0 <Target Directory> [-recursive]"
		exit 1
	fi

	TARG=$1

	if [ ! -d "$TARG" ]; then
		echo "Directory $TARG does not exist. Operation aborted."
		exit 1
	fi

	if [ "$#" -lt "2" ] || [ "$2" != "-recursive" ]; then
		OPTS="-maxdepth 1"
	fi
}

main() {
	init "$@"

	FAILS=""
	NEWLINE=$'\n'
	ITEMS=$(find "$TARG" $OPTS -type f -name "*.sha256" | sort)

	while read ITEM; do
		echo "$ITEM"
		BASE_FILE_PATH=$(dirname "$ITEM")
		BASE_FILE_NAME=$(basename "$ITEM")
		(cd "$BASE_FILE_PATH"; sha256sum -c "$BASE_FILE_NAME" &>/dev/null)
		[ "$?" -ne "0" ] && FAILS+="$ITEM$NEWLINE"
	done < <(echo "$ITEMS")

	echo

	if [ -n "$FAILS" ]; then
		echo "FAILED FILES:"
		echo "$FAILS" | while read FAIL; do
			echo "$FAIL"
		done
		exit 1
	else
		echo "ALL FILES OK"
		exit 0
	fi
}

main "$@"
