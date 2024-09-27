#!/bin/bash

source ./config.sh

# Prompt warning overwrite file
echo -e "\nThe script will write several temporal files under $TMP_DIR\nDo you want to continue? (it will overwrite any existing files with the same name and location)\n"
optionss1=("Continue" "Exit")
select option in "${optionss1[@]}"; do
  case $option in
    "Continue")
      break
      ;;
    "Exit")
      exit
      break
      ;;
    *)
      echo "Invalid option"
      exit
      break
      ;;
  esac
done

source ./pull.sh

# Prompt to edit file
echo -e "\nYou can make changes now on $CSV_FILE. Select Continue to resume de script.\n"
optionss1=("Continue" "Exit")
select option in "${optionss1[@]}"; do
  case $option in
    "Continue")
      break
      ;;
    "Exit")
      exit
      break
      ;;
    *)
      echo "Invalid option"
      exit
      break
      ;;
  esac
done

source ./translate.sh

# Allow to select next steps
echo -e "\nWhat do you want to do now?\n"
optionss1=("Upload csv file to Loco and run swiftgen" "Exit and keep $CSV_FILE")
select option in "${optionss1[@]}"; do
  case $option in
    "Upload csv file to Loco and run swiftgen")
      break
      ;;
    "Exit and keep $CSV_FILE")
      exit
      break
      ;;
    *)
      echo "Invalid option"
      exit
      break
      ;;
  esac
done

source ./push.sh
source ./generate.sh $1
source ./clean.sh
