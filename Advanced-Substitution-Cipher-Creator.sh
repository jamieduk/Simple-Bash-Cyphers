#!/bin/bash
# (c) J~Net 2024
#
# Advanced Substitution Alphabet Generator and Creator
#
# Usage:
# ./Advanced-Substitution-Cipher-Creator.sh "test12345 this is a test"
#
# This script encrypts plaintext with a substitution cipher. If no substitution alphabet is provided, it will generate one randomly.

# Function to generate a random substitution alphabet
generate_random_substitution() {
  # Create a shuffled alphabet
  local alphabet="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  local shuffled=$(echo $alphabet | tr -d '\n' | fold -w1 | shuf | tr -d '\n')
  echo $shuffled
}

# Function to encrypt the plaintext using the given substitution alphabet
encrypt_text() {
  local plaintext="$1"
  local substitution="$2"
  
  # Create a mapping of plaintext to the substitution alphabet
  local alphabet="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  local encrypted=""
  
  for (( i=0; i<${#plaintext}; i++ )); do
    char="${plaintext:$i:1}"
    if [[ $char =~ [A-Za-z] ]]; then
      char_upper=$(echo $char | tr 'a-z' 'A-Z') # Convert to uppercase for uniform mapping
      index=$(expr index "$alphabet" "$char_upper" - 1)
      if [[ $char =~ [A-Z] ]]; then
        encrypted="$encrypted${substitution:$index:1}"
      else
        encrypted="$encrypted${substitution:$index:1}" # Keep lower case as lower
      fi
    else
      encrypted="$encrypted$char" # Non-alphabetical characters stay the same
    fi
  done
  
  echo "$encrypted"
}

# Main script
if [ -z "$1" ]; then
  echo "Usage: ./Advanced-Substitution-Cipher-Creator.sh \"<plaintext>\""
  exit 1
fi

plaintext="$1"

# Prompt user for substitution alphabet
read -p "Enter substitution alphabet (press Enter to generate random): " custom_substitution

if [ -z "$custom_substitution" ]; then
  # If no substitution alphabet is provided, generate a random one
  custom_substitution=$(generate_random_substitution)
fi

# Show the generated/custom substitution alphabet
echo "Substitution Alphabet: $custom_substitution"

# Encrypt the text
encrypted_text=$(encrypt_text "$plaintext" "$custom_substitution")
echo "Encrypted Text: $encrypted_text"

