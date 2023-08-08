#!/bin/bash

set -e

create_key() {
	local NAME="$1"; local EMAIL="$2";

	if [ -z "$NAME" ] || [ -z "$EMAIL" ]; then
		echo "Invalid parameters" 1>&2
		exit 1
	fi

gpg --batch --gen-key <<EOF
Key-Type: 1
Key-Length: 4096
Subkey-Type: 1
Subkey-Length: 4096
Name-Real: $NAME
Name-Email: $EMAIL
Expire-Date: 0
EOF
}

delete_key() {
	local EMAIL="$1";

	if [ -z "$EMAIL" ]; then
		echo "Invalid parameters" 1>&2
		exit 1
	fi

	gpg --delete-secret-keys "$EMAIL"
	gpg --delete-keys "$EMAIL"
}

export_pub_key() {
	local EMAIL="$1"; local FILE="$2";

	if [ -z "$EMAIL" ] || [ -z "$FILE" ]; then
		echo "Invalid parameters" 1>&2
		exit 1
	fi

	gpg -a --export "$EMAIL" > "$FILE"
}

export_pri_key() {
	local EMAIL="$1"; local FILE="$2";

	if [ -z "$EMAIL" ] || [ -z "$FILE" ]; then
		echo "Invalid parameters" 1>&2
		exit 1
	fi

	gpg -a --export-secret-keys "$EMAIL" > "$FILE"
}

export_main_key() {
	local EMAIL="$1"; local FILE="$2";

	if [ -z "$EMAIL" ] || [ -z "$FILE" ]; then
		echo "Invalid parameters" 1>&2
		exit 1
	fi

	gpg -a --export-secret-keys "$EMAIL" | \
	gpg -a --symmetric --cipher-algo aes256 > "$FILE"
}

export_data_key() {
	local PRI_EMAIL="$1"; local EMAIL="$2"; local FILE="$3";

	if [ -z "$PRI_EMAIL" ] || [ -z "$EMAIL" ] || [ -z "$FILE" ]; then
		echo "Invalid parameters" 1>&2
		exit 1
	fi

	gpg -a --export-secret-keys "$EMAIL" | \
	gpg -a --sign --local-user "$PRI_EMAIL" --encrypt --recipient "$PRI_EMAIL" > "$FILE"
}

import_pri_pub_key() {
	local FILE="$1"; local EMAIL="$2";

	if [ -z "$FILE" ] || [ -z "$EMAIL" ]; then
		echo "Invalid parameters" 1>&2
		exit 1
	fi

	gpg --import < "$FILE"

	echo
	echo "Set key trust level manually:"
	echo "gpg --edit-key $EMAIL"
	echo "trust / 5 = I trust ultimately / quit"
	echo
}

import_main_data_key() {
	local FILE="$1"; local EMAIL="$2";

	if [ -z "$FILE" ] || [ -z "$EMAIL" ]; then
		echo "Invalid parameters" 1>&2
		exit 1
	fi

	gpg --decrypt < "$FILE" | \
	gpg --import

	echo
	echo "Set key trust level manually:"
	echo "gpg --edit-key $EMAIL"
	echo "trust / 5 = I trust ultimately / quit"
	echo
}

main() {
	SCRIPT=$(basename $0)

	ACTION=""

	if [ "$#" -ge 1 ]; then
		ACTION="$1"
		shift
	fi

	case "$ACTION" in
	"--create")
		create_key "$@"
		;;
	"--delete")
		delete_key "$@"
		;;
	"--export-pub")
		export_pub_key "$@"
		;;
	"--export-pri")
		export_pri_key "$@"
		;;
	"--export-main")
		export_main_key "$@"
		;;
	"--export-data")
		export_data_key "$@"
		;;
	"--import-pri-pub")
		import_pri_pub_key "$@"
		;;
	"--import-main-data")
		import_main_data_key "$@"
		;;
	*)
		echo 1>&2
		echo "Usage: $SCRIPT [OPTIONS]" 1>&2
		echo "OPTIONS" 1>&2
		echo "  --create NAME EMAIL" 1>&2
		echo "  --delete EMAIL" 1>&2
		echo "  --export-pub EMAIL FILE" 1>&2
		echo "  --export-pri EMAIL FILE" 1>&2
		echo "  --export-main EMAIL FILE" 1>&2
		echo "  --export-data PRI_EMAIL EMAIL FILE" 1>&2
		echo "  --import-pri-pub FILE EMAIL" 1>&2
		echo "  --import-main-data FILE EMAIL" 1>&2
		echo "EXAMPLES" 1>&2
		echo "  Create key" 1>&2
		echo "    $SCRIPT --create \"John Doe\" \"jdoe@example.com\"" 1>&2
		echo "  Delete key" 1>&2
		echo "    $SCRIPT --delete \"jdoe@example.com\"" 1>&2
		echo "  Export public key" 1>&2
		echo "    $SCRIPT --export-pub \"jdoe@example.com\" \"com_example_jdoe.pub.gpg\"" 1>&2
		echo "  Export private key" 1>&2
		echo "    $SCRIPT --export-pri \"jdoe@example.com\" \"com_example_jdoe.pri.gpg\"" 1>&2
		echo "  Export private key and double encrypt symmetricaly with password" 1>&2
		echo "    $SCRIPT --export-main \"jdoe@example.com\" \"com_example_jdoe.gpg\"" 1>&2
		echo "  Export private key and double encrypt asymmetricaly with main key" 1>&2
		echo "    $SCRIPT --export-data \"jdoe@example.com\" \"jane@example.com\" \"com_example_jane.gpg\"" 1>&2
		echo "  Import private or public key" 1>&2
		echo "    $SCRIPT --import-pri-pub \"com_example_jdoe.pri.gpg\" \"jdoe@example.com\"" 1>&2
		echo "    $SCRIPT --import-pri-pub \"com_example_jdoe.pub.gpg\" \"jdoe@example.com\"" 1>&2
		echo "  Import double encrypted private key" 1>&2
		echo "    $SCRIPT --import-main-data \"com_example_jane.gpg\" \"jane@example.com\"" 1>&2
		echo 1>&2
		exit 1
		;;
	esac
}

main "$@"
