#!/bin/bash

# Languages codes and labels:
# BG - Bulgarian
# CS - Czech
# DA - Danish
# DE - German
# EL - Greek
# EN - English
# ES - Spanish
# ET - Estonian
# FI - Finnish
# FR - French
# HU - Hungarian
# ID - Indonesian
# IT - Italian
# JA - Japanese
# LT - Lithuanian
# LV - Latvian
# NL - Dutch
# PL - Polish
# PT - Portuguese (all Portuguese varieties mixed)
# RO - Romanian
# RU - Russian
# SK - Slovak
# SL - Slovenian
# SV - Swedish
# TR - Turkish
# UK - Ukrainian
# ZH - Chinese

source ./config.sh
source ./check.sh

function translate() {
  text=$1
  lang=$2
  prompt="You are TranslateGPT, an AI assistant to translate text. You follow this instructions: - Do not print any explanation or additional text rather than the translated text. - You keep in the translated text special symbol combinations common in translation software, such as %1, $1, %d, %s, $s, etc. - You use the same voice and tone. - You use the same punctuation marks as the ones provided in the original text, no other punctuation mark should be printed. - Try to keep the same text length with your translation, make use of synonymous to achieve it when needed. - You always try to refer to the user in a close and natural language. - You don't end your response with a full-stop (.) if the original does not have it. - If the translation text is the same, print it anyway. - Translate from EN to $lang. Now translate: '$text'"

  # Use printf to format the JSON payload with the variable
  payload=$(printf '{"model": "gpt-3.5-turbo-instruct", "prompt": "%s", "max_tokens": 250, "temperature": 0 }' "$prompt")

  # Make the API call using the formatted payload
  response=$(curl https://api.openai.com/v1/completions \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $OPENAI_KEY" \
    -d "$payload")

  # Prevent %s characters to be skipped on print and remove line breaks to work with a valid json
  printf "$response" "%s" | tr -d '\n' | jq '.choices[0].text'
}

echo -e "\nParsing csv file with latest locales..."
echo "-------------------------------------------------------"


# Store csv raw headers
while read -r line; do

  if [ $HEADER_INDEX -le $CSV_HEADERS_INDEX ]; then
    dbuffer="$line\n"
    BUFFER=$BUFFER$dbuffer
  fi

  HEADER_INDEX=$((HEADER_INDEX+1))
done < $CSV_FILE

# Store the rest of the file
total_progress=$(wc -l < $CSV_FILE)
while read -r line; do

  # Calculate and output progress bar
  percent=$(( 100 * (++count) / total_progress ))
  printf "["
  for (( j=1; j<=50; j++ ))
  do
      if [ $j -le $(( percent / 2 )) ]
      then
          printf "="
      else
          printf " "
      fi
  done
  printf "] %d%%\r" $percent

  # Prepare substitution vars
  key=`echo $line | csvquote | cut -d ',' -f 1 | csvquote -u`
  ES=`echo $line | csvquote | cut -d ',' -f 2 | csvquote -u`
  EN=`echo $line | csvquote | cut -d ',' -f 3 | csvquote -u`
  PT=`echo $line | csvquote | cut -d ',' -f 4 | csvquote -u`
  FR=`echo $line | csvquote | cut -d ',' -f 5 | csvquote -u`
  context=`echo $line | csvquote | cut -d ',' -f 6 | csvquote -u`
  notes=`echo $line | csvquote | cut -d ',' -f 7 | csvquote -u`

  if [ $BODY_INDEX -gt $CSV_HEADERS_INDEX ]; then

    # Store default columns content on buffer
    dbuffer="$key,$ES,$EN,$PT,$FR,$context,$notes\n"

    # clean double quotes
    ckey=`echo $key | sed 's/^"\(.*\)"$/\1/'`
    cES=`echo $ES | sed 's/^"\(.*\)"$/\1/'`
    cEN=`echo $EN | sed 's/^"\(.*\)"$/\1/'`
    cPT=`echo $PT | sed 's/^"\(.*\)"$/\1/'`
    cFR=`echo $FR | sed 's/^"\(.*\)"$/\1/'`
    ccontext=`echo $context | sed 's/^"\(.*\)"$/\1/'`
    cnotes=`echo $notes | sed 's/^"\(.*\)"$/\1/'`

    # Do not process excluded keys
    for ekey in "${EXCLUDED_KEYS[@]}"; do
      # Check which languages has empty assets in the current key
      if [ "$ekey" != "$ckey" ]; then

          translationES=$ES
          if [ "$cES" = "" ]; then
            echo "  Requesting ES translation for $key..."
            translationES=$(translate "$cEN" "ES")
            echo "  Writting $ckey: $translationES"
            symbols_check "$cEN" "$translationES"
            echo "-------------------------------------------------------"
          fi

          translationPT=$PT
          if [ "$cPT" = "" ]; then
            echo "  Requesting PT translation for $key..."
            translationPT=$(translate "$cEN" "PT")
            echo "  Writting $ckey: $translationPT"
            symbols_check "$cEN" "$translationPT"
            echo "-------------------------------------------------------"
          fi

          translationFR=$FR
          if [ "$cFR" = "" ]; then
            echo "  Requesting FR translation for $key..."
            translationFR=$(translate "$cEN" "FR")
            echo "  Writting $ckey: $translationFR"
            symbols_check "$cEN" "$translationFR"
            echo "-------------------------------------------------------"
          fi

          dbuffer="$key,$translationES,$EN,$translationPT,$translationFR,$context,$notes\n"

      fi
    done
    BUFFER=$BUFFER$dbuffer
  fi

  BODY_INDEX=$((BODY_INDEX+1))
done < $CSV_FILE

# Write buffer on original file using escape characters (-e)
echo -e $BUFFER > $CSV_FILE

# Finish translations script
echo -e "\n✅ Translations processed locally. Now review your your file $CSV_FILE before submitting it."
