# Locolize

A set of shell scripts designed to automate the localization process for iOS and Android projects. These scripts facilitate the downloading, translation, and management of localized strings using the Loco API and OpenAI's GPT model for translations.

## Features

- Download latest locales from Loco in various formats (CSV, iOS strings, Android XML)
- Translate missing strings using OpenAI's GPT model
- Upload translated strings back to Loco
- Generate localized files for iOS and Android projects
- Clean up temporary files

## Prerequisites

Before using these scripts, ensure you have the following:

1. Bash shell
2. curl
3. jq (for JSON processing)
4. An account with Loco (for API access)
5. An OpenAI API key (for translations)

### Installing jq

`jq` is a lightweight command-line JSON processor. To install it using Homebrew:

```
brew install jq
```

## Setup

1. Clone this repository to your local machine.
2. Duplicate the `example.env` file and rename it to `.env`:

   ```
   cp example.env .env
   ```

3. Open the `.env` file and fill in your specific details:

   ```
   # Loco API Key
   LOCO_API_KEY=your_loco_api_key_here

   # OpenAI API Key
   OPENAI_API_KEY=your_openai_api_key_here

   # Supported locales (comma-separated)
   LOCALES=es,pt,fr

   # Other configuration variables...
   ```

4. Make sure all scripts are executable:

   ```
   chmod +x *.sh
   ```

## Usage

The main script that orchestrates the entire process is `localize.sh`. To run it:

```
cd Locolize
./localize.sh [ios|android]
```

This script will:

1. Pull the latest locales from Loco
2. Allow you to edit the CSV file if needed
3. Translate missing strings
4. Push the updated strings back to Loco
5. Generate localized files for your iOS or Android project
6. Clean up temporary files

## Individual Scripts

To run any of the scripts you need to first enter in the Locolize directory:

```
cd Locolize
./[pull|translate|push|generate|clean].sh
```

- `pull.sh`: Downloads the latest locales from Loco in CSV format
- `translate.sh`: Translates missing strings using OpenAI's GPT model
- `push.sh`: Uploads the updated CSV file back to Loco
- `generate.sh`: Generates localized files for iOS or Android projects
- `clean.sh`: Removes temporary files and directories

## Configuration

The `config.sh` file contains various configuration settings used across the scripts. Modify this file if you need to change paths, file names, or other settings.

## Supported Languages

To add or modify supported languages, update the `LOCALES` variable in your `.env` file.

## Caution

- Always review the generated translations before pushing them to production.
- Be mindful of API usage limits for both Loco and OpenAI.

## Contributing

Contributions to improve these scripts are welcome. Please submit a pull request or open an issue to discuss proposed changes.
