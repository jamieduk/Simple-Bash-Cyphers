#!/bin/bash
# (c) J~Net 2024
#
# Substitution Cipher Encryption Test
#
# ./Simple-Substitution-Cipher-Creator.sh "test12345 this is a test"
#
#
#

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <plaintext>"
  exit 1
fi

plaintext="$1"
alphabet="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
# Define your custom cipher (this can be any substitution cipher)
custom_cipher="ZYXWVUTSRQPONMLKJIHGFEDCBA"  # Reverse alphabet cipher (A->Z, B->Y, C->X, etc.)

# Function to encrypt plaintext using substitution cipher
encrypt_text() {
  input="$1"
  encrypted=""
  
  # Loop through each character of the input text
  for (( i=0; i<${#input}; i++ )); do
    char="${input:$i:1}"

    if [[ "$char" =~ [A-Za-z] ]]; then
      # Find the index of the character in the alphabet and map it to the custom cipher
      if [[ "$char" =~ [A-Z] ]]; then
        idx=$(expr index "$alphabet" "$char")
        encrypted="$encrypted${custom_cipher:$((idx-1)):1}"
      elif [[ "$char" =~ [a-z] ]]; then
        idx=$(expr index "${alphabet,,}" "${char,,}")
        encrypted="$encrypted${custom_cipher:$((idx-1)):1}"
      fi
    else
      # If the character is not a letter, add it unchanged (e.g., numbers, spaces)
      encrypted="$encrypted$char"
    fi
  done

  echo "$encrypted"
}

# Encrypt the plaintext
encrypted_text=$(encrypt_text "$plaintext")
echo "Encrypted Text: $encrypted_text"

# Display the Substitution Key (Alphabet Mapping)
echo "Substitution Key:"
echo "Original Alphabet:  $alphabet"
echo "Custom Cipher:      $custom_cipher"

