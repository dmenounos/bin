#!/bin/bash

init() {

	SOURCE_DIR=""
	TARGET_DIR=""

	while getopts ":s:t:h" OPT; do
		case $OPT in
		"s")
			SOURCE_DIR="$OPTARG"
			;;
		"t")
			TARGET_DIR="$OPTARG"
			;;
		"h")
			echo "Usage: $0 [OPTIONS]" 1>&2
			echo "OPTIONS" 1>&2
			echo "  -s source directory" 1>&2
			echo "  -t target directory" 1>&2
			exit 1
			;;
		":")
			echo "Option -$OPTARG requires an argument" 1>&2
			exit 1
			;;
		"?")
			echo "Invalid option: -$OPTARG" 1>&2
			exit 1
			;;
		esac
	done

	if [ "$#" -eq "0" ]; then
		$0 -h
		exit 1
	fi

	SOURCE_DIR=${SOURCE_DIR%/}

	if [ ! -d "$SOURCE_DIR" ]; then
		echo "Source directory $SOURCE_DIR does not exist. Operation aborted."
		exit 1
	fi

	TARGET_DIR=${TARGET_DIR%/}

	if [ ! -d "$TARGET_DIR" ]; then
		echo "Target directory $TARGET_DIR does not exist. Operation aborted."
		exit 1
	fi
}

main() {
	init "$@"

	echo "Synchronizing \"$SOURCE_DIR\" to \"$TARGET_DIR\""
	rsync -avz --delete --exclude="lost+found" $SOURCE_DIR/ $TARGET_DIR/
}

main "$@"

# rsync options:
# -a equals -rlptgoD
# -r recursive
# -l links
# -p permissions
# -t times
# -g group
# -o owner
