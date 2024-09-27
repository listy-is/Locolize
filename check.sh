#!/bin/bash

source ./config.sh

function symbols_check() {
  original="$1"
  translation="$2"
  lang="$3"

  # array of special localization characters to check for
  warning_chars=('.')
  error_chars=('%1' '$1' '%2' '$2' '%d' '%s' '$s')


  for char in "${warning_chars[@]}"; do
    if [[ "$original" == *"$char"* && "$translation" != *"$char"* ]]; then
      echo -e "  ⚠️  Warning: Missing '$char' in $translation"
    fi
  done

  for char in "${error_chars[@]}"; do
    if [[ "$original" == *"$char"* && "$translation" != *"$char"* ]]; then
      echo -e "  ❌  Error: Missing '$char' in $translation"
    fi
  done

  for char in "${warning_chars[@]}"; do
    if [[ "$original" == *"$char"* && "$translation" == *"$char"* ]]; then
      echo -e "  ✅  Symbols checked. No warnings."
    fi
  done

  for char in "${error_chars[@]}"; do
    if [[ "$original" == *"$char"* && "$translation" == *"$char"* ]]; then
      echo -e "  ✅  Symbols checked. No errors."
    fi
  done
}
