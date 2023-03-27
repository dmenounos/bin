#!/bin/bash

init() {

	# Require arguments

	if [ ! "$#" -eq "1" ]; then
		echo "Usage: $0 <Target Directory>"
		exit 1
	fi

	TARG=$1

	if [ ! -d "$TARG" ]; then
		echo "Directory $TARG does not exist. Operation aborted."
		exit 1
	fi

	# Calculate the maximum file name length

	PATH_MAX_LENGTH="0"

	for ITEM in $TARG/*; do

		if [ -d "$ITEM" ] || [[ "$ITEM" == *.sha256 ]]; then
			# echo "Skipping \"$ITEM\""
			continue
		fi

		if [ "${#ITEM}" -gt "$PATH_MAX_LENGTH" ]; then
			PATH_MAX_LENGTH="${#ITEM}"
		fi

	done
}

main() {
	init "$@"

	for ITEM in $TARG/*; do

		ITEM_FOLD=$(dirname "$ITEM")
		ITEM_BASE=$(basename "$ITEM")

		if [ -d "$ITEM" ] || [[ "$ITEM" == *.sha256 ]]; then
			# echo "Skipping \"$ITEM\""
			continue
		fi

		if [ -f "$ITEM_FOLD/$ITEM_BASE.sha256" ]; then
			# echo "Checking hash for \"$ITEM\""
			sha256sum -c "$ITEM_FOLD/$ITEM_BASE.sha256" &>/dev/null
			[ "$?" -eq "0" ] && RES="OK .." || RES="KO <-"
			printf "%-${PATH_MAX_LENGTH}s : %s\n" "$ITEM" "$RES"
		else
			# echo "Creating hash for \"$ITEM\""
			printf "%-${PATH_MAX_LENGTH}s : %s\n" "$ITEM" "Creating hash"
			sha256sum "$ITEM_FOLD/$ITEM_BASE" > "$ITEM_FOLD/$ITEM_BASE.sha256"
		fi

	done
}

main "$@"
