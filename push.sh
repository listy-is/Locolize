#!/bin/bash

source ./config.sh

function import() {
  LOCALE=$1
  CSV_FILE_CONTENTS=`cat $CSV_FILE`

  csvupload=$(curl --progress-bar -X POST "https://localise.biz/api/import/csv?key=$LOCO_KEY&index=id&locale=$LOCALE" -d "$CSV_FILE_CONTENTS")
  echo "Result: `printf "$csvupload" | jq '.message'`"
}

# to-do upload csv and import locales per language
echo -e "\n Importing csv file in Loco..."
import "en-EN"
import "es-ES"
import "pt-PT"
import "fr-FR"
