#!/bin/bash
# (c) J~Net 2024
#
# XOR Cipher Decryptor with Brute Force
#
# Usage: ./XOR-Cipher-Cracker.sh "encrypted_output.txt"
#

# Check if the file argument is provided
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <ciphertext-file>"
  exit 1
fi

ciphertext_file="$1"

# Check if the file exists
if [ ! -f "$ciphertext_file" ]; then
  echo "File not found: $ciphertext_file"
  exit 1
fi

# Read the ciphertext from the file and decode it from Base64
ciphertext=$(base64 -d "$ciphertext_file")

# Prompt for the key if not provided
echo "Enter the key for decryption (leave empty to brute-force):"
read -r key

# If key is not provided, attempt to brute-force all keys
if [ -z "$key" ]; then
  echo "Attempting to brute-force the key..."
  for key in {0..255}; do
    # Apply XOR to each byte of the ciphertext using the current key
    decrypted=""
    for byte in $(echo "$ciphertext" | od -An -t u1); do
      decrypted+=$(printf "\\x$(printf '%02x' "$((byte ^ key))")")
    done

    # Convert the decrypted output back to readable text, removing non-printable characters
    readable_output=$(echo -e "$decrypted" | tr -cd '\11\12\15\40-\176') # Allow tab, newline, carriage return, and printable characters
    if [ -n "$readable_output" ]; then
      echo "Key: $key -> $readable_output"
    fi
  done
else
  # Decrypt using the provided key
  decrypted=""
  for byte in $(echo "$ciphertext" | od -An -t u1); do
    decrypted+=$(printf "\\x$(printf '%02x' "$((byte ^ key))")")
  done

  # Convert the decrypted output back to readable text
  readable_output=$(echo -e "$decrypted" | tr -cd '\11\12\15\40-\176') # Allow tab, newline, carriage return, and printable characters
  echo "Key: $key -> $readable_output"
fi

