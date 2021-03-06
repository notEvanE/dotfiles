#!/bin/bash
set -e # exit script if control-c is used
USAGE="Usage: convert_to_96_aac.sh source_dir destination_dir"
# --- Options processing -------------------------------------------
if [ $# == 0 ] ; then
    echo $USAGE
    exit 1;
fi
# Convert relative path to absolute. Also remove trailing slash
SOURCE_DIR="$(cd "$(dirname "$1")"; pwd)/$(basename "$1")"
SOURCE_DIR=$(dirname "$SOURCE_DIR/temp") # this fixes . and ./
DESTINATION_DIR="$(cd "$(dirname "$2")"; pwd)/$(basename "$2")"
DESTINATION_DIR=$(dirname "$DESTINATION_DIR/temp") # this fixes . and ./
find "$SOURCE_DIR" \( -iname '*.flac' -or -iname '*.m4a' \) -type f -print | while read -r FILE
do
  ORIG_DIR=$(dirname "$FILE")
  # Get basename and remove extension
  BASE=$(basename "$FILE") # get filename
  BASE=${BASE%.*} # remove extension from filename
  NEW_DIR=${ORIG_DIR/$SOURCE_DIR/$DESTINATION_DIR}
  mkdir -p "$NEW_DIR"
  NEW_FILE="$NEW_DIR/$BASE.m4a"
  if [ ! -f "$NEW_FILE" ]; then
    echo "Converting $FILE to $NEW_FILE"
    afconvert "$FILE" -o "$NEW_FILE" -q 127 -b 96000 -f m4af -d aac
  fi
done
