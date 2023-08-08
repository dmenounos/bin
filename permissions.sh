#!/bin/bash

if ([ "$#" -ne "1" ]); then
	echo "Usage: $0 <Target Directory>"
	exit 1
fi

TARG=$1

if ([ ! -d $TARG ]); then
	echo "ERROR: Directory $TARG does not exist. Operation aborted."
	exit 1
fi

echo -n "Confirm the target directory $TARG (y/n) "
read CONFIRM

if ([ ! $CONFIRM = "y" ]); then
	exit 0
fi

echo "RWX RWX R-X for all directories"
find $TARG -type d -print0 | xargs -0 -r -L 1 chmod 775 

echo "R-- R-- --- for all files"
find $TARG -type f -print0 | xargs -0 -r -L 1 chmod ug+r 

echo "RWX RWX R-X for script files"
find $TARG -type f -name "*.sh" -print0 | xargs -0 -r -L 1 chmod 775

LIST=""
LIST="$LIST css html java js jsp properties sql txt xml c cpp h hpp rar zip tar gz 7z"
LIST="$LIST docx xlsx doc xls odt ods pdf gif jpg png mp3 mp4 webm"
echo "RW- RW- R-- for: $LIST"

for NAME in $LIST; do
	find $TARG -type f -name "*.$NAME" -print0 | xargs -0 -r -L 1 chmod 664
done
