#!/bin/bash

INIT_REPO=""
USER_NAME=""
USER_EMAIL=""
CREDENTIAL_HELPER=""

while getopts ":in:e:ch" OPT; do
	case $OPT in
	"i")
		INIT_REPO="TRUE"
		;;
	"n")
		USER_NAME="$OPTARG"
		;;
	"e")
		USER_EMAIL="$OPTARG"
		;;
	"c")
		CREDENTIAL_HELPER="TRUE"
		;;
	"h")
		echo "Usage: $0 [OPTIONS]" 1>&2
		echo "OPTIONS" 1>&2
		echo "  -i Initialize repository" 1>&2
		echo "  -n User Name" 1>&2
		echo "  -e User Email" 1>&2
		echo "  -c Credential Helper Store" 1>&2
		echo "EXAMPLE" 1>&2
		echo "$0 -ic -n \"John Doe\" -e \"johndoe@example.com\"" 1>&2
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

if [ -n "$INIT_REPO" ] && [ ! -d ".git" ]; then
	echo "--- Initializing repository"
	git init
fi

if [ -n "$USER_NAME" ]; then
	echo "--- Configuring user.name \"$USER_NAME\""
	git config user.name "$USER_NAME"
fi

if [ -n "$USER_EMAIL" ]; then
	echo "--- Configuring user.email \"$USER_EMAIL\""
	git config user.email "$USER_EMAIL"
fi

if [ -n "$CREDENTIAL_HELPER" ]; then
	echo "--- Configuring credential.helper"
	git config credential.helper store
fi
