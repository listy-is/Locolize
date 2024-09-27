#!/bin/bash

source ./config.sh

# Check if a parameter is provided
if [ $# -eq 0 ]; then
    echo "Please provide 'ios' or 'android' as a parameter"
    exit 1
fi

platform=$1

if [ "$platform" = "ios" ]; then
    
    echo -e "\nDownloading latest locales in iOS format ..."
    curl --progress-bar "https://localise.biz/api/export/archive/strings.zip?index=id&fallback=en&order=id&key=$LOCO_KEY" -o "$ZIP_FILE"

    echo "Extracting locales and copying in to $IOS_LPROJ_FILES"
    unzip -q $ZIP_FILE -d $TMP_DIR

    STRINGS_ARCHIVE=$(find . -type d -name "*strings-archive")

    cp -r $STRINGS_ARCHIVE/en.lproj $IOS_LPROJ_FILES
    cp -r $STRINGS_ARCHIVE/es.lproj $IOS_LPROJ_FILES
    cp -r $STRINGS_ARCHIVE/pt-PT.lproj $IOS_LPROJ_FILES
    cp -r $STRINGS_ARCHIVE/fr.lproj $IOS_LPROJ_FILES


     # Default locale is EN
    cp -r $STRINGS_ARCHIVE/en.lproj $IOS_LPROJ_FILES
    
    # Other locales
    for locale in "${LOCALES[@]}"; do
        STRINGS_FILE=$(find "$STRINGS_ARCHIVE" -type f -name ".lproj" | grep -i "$locale")
        echo "Generating locale: $locale from $STRINGS_FILE in $IOS_LPROJ_FILES/$locale.lproj"

        cp $STRINGS_FILE $IOS_LPROJ_FILES"/$locale.lproj"
    done

    cd $ROOT_PROJECT
    swiftgen

elif [ "$platform" = "android" ]; then
    

    if [ ! -d "$TMP_DIR" ]; then
        echo "Creating temporary directory: $TMP_DIR"
        mkdir -p "$TMP_DIR"
    fi
    
    echo -e "\nDownloading latest locales in Android format ..."
    curl --progress-bar "https://localise.biz/api/export/archive/xml.zip?index=id&fallback=en&order=id&key=$LOCO_KEY" -o "$ZIP_FILE"

    echo "Extracting locales and copying in to $ANDROID_PROJ_FILES"
    unzip -q $ZIP_FILE -d $TMP_DIR

    XML_ARCHIVE=$(find . -type d -name "*xml-archive")

    # Default locale is EN
    cp $XML_ARCHIVE"/res/values/strings.xml" $ANDROID_PROJ_FILES"/values/strings.xml"
    cp $XML_ARCHIVE"/res/values/strings.xml" $ANDROID_PROJ_FILES"/values-en/strings.xml"

    # Other locales
    for locale in "${LOCALES[@]}"; do
        STRINGS_XML=$(find "$XML_ARCHIVE" -type f -name "strings.xml" | grep -i "values-$locale")
        echo "Generating locale: $locale from $STRINGS_XML in $ANDROID_PROJ_FILES/values-$locale/strings.xml"

        cp $STRINGS_XML $ANDROID_PROJ_FILES"/values-$locale/strings.xml"
    done

else
    echo "Invalid parameter. Please use 'ios' or 'android'"
    exit 1
fi




