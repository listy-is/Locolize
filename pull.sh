#!/bin/bash

source ./config.sh

# Remove previously created tmp files
if [ -d $TMP_DIR ]; then
  rm -rf $TMP_DIR
fi

echo -e "\nDownloading latest locales in csv ..."
mkdir $TMP_DIR
curl --progress-bar "https://localise.biz/api/export/all.csv?printf=java&key=$LOCO_KEY" -o "$CSV_FILE"
