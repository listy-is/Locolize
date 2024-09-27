#!/bin/bash

# Load environment variables from .env file
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
fi

# Config
TMP_DIR=./tmp_locales
CSV_FILE=$TMP_DIR/locales.csv
ZIP_FILE=$TMP_DIR/strings.zip
ROOT_PROJECT="${ROOT_PROJECT}"
IOS_LPROJ_FILES="${ROOT_PROJECT}${IOS_LPROJ_FILES}"
ANDROID_PROJ_FILES="${ROOT_PROJECT}${ANDROID_PROJ_FILES}"
LOCO_KEY="${LOCO_KEY}"
OPENAI_KEY="${OPENAI_KEY}"
IFS=',' read -ra LOCALES <<< "$LOCALES"
CSV_HEADERS_INDEX=6
EXCLUDED_KEYS=("empty")
HEADER_INDEX=0
BODY_INDEX=0
BUFFER=""