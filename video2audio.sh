#!/bin/bash

if ([ "$#" -ne "1" ]); then
	echo "Usage: $0 <Video File>"
	exit 1
fi

FILENAME="$1"
# echo "FILENAME: $FILENAME"

FILEBASENAME=$(basename ${FILENAME%.*})
# echo "FILEBASENAME: $FILEBASENAME"

DIR=`pwd`
# echo $DIR

FILEPATH="$DIR/$FILENAME"
# echo "FILEPATH: $FILEPATH"

FILEBASEPATH="$DIR/$FILEBASENAME"
# echo "FILEBASEPATH: $FILEBASEPATH"

if ([ ! -f "$FILEPATH" ]); then
	echo "ERROR: File $FILEPATH does not exist. Operation aborted."
	exit 1
fi

echo
echo "Extract the audio without any encoding (raw pcm)."
echo "-------------------------------------------------"
ffmpeg -i "$FILEPATH" "$FILEBASEPATH.wav"

RC=$?

if ([ $RC != 0 ]); then
	echo "ERROR: ffmpeg. Operation aborted."
	exit 1
fi

echo
echo "Encode the audio using stereo mode (-m s), high quality (-h or -q 2) and "
echo "variable (-v or -V 4) 128kb minimum / 320kb maximum rate (-b 128 -B 320)."
echo "-------------------------------------------------------------------------"
lame -m s -h -v -b 128 -B 320 "$FILEBASEPATH.wav" "$FILEBASEPATH.mp3"

RC=$?

if ([ $RC != 0 ]); then
	echo "ERROR: lame. Operation aborted."
	exit 1
fi

rm -f "$FILEBASEPATH.wav"
