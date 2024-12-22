#!/bin/bash
# (c) J~Net 2024
#
# XOR Cipher Creator - Takes input text and applies XOR cipher
#
# Usage: ./xor-creator.sh "plain-text here to encrypt"
#

# Function to apply XOR cipher to a string
xor_cipher() {
  local input="$1"
  local key="$2"
  local output=""
  
  # Iterate through each character in the string
  for ((i = 0; i < ${#input}; i++)); do
    char="${input:$i:1}"
    
    # XOR each character with the key
    xor_result=$(printf "%d" "'$char")
    xor_result=$((xor_result ^ key))
    
    # Convert the result back to a character
    output+=$(printf \\$(printf '%03o' $xor_result))
  done
  
  echo "$output"
}

# Check if an argument is passed
if [ -z "$1" ]; then
  echo "Usage: $0 <text>"
  exit 1
fi

# Prompt for the key if not provided
echo "Enter a key for encryption (between 1 and 255):"
read -r key
while [[ ! "$key" =~ ^[0-9]+$ ]] || [ "$key" -lt 1 ] || [ "$key" -gt 255 ]; do
  echo "Invalid key. Please enter a number between 1 and 255:"
  read -r key
done

# Encrypt the text
encrypted_text=$(xor_cipher "$1" "$key")
echo "Encrypted text saved to encrypted_output.txt"

# Save the encrypted text to a file (encoded in base64)
echo "$encrypted_text" | base64 > encrypted_output.txt

echo "Key used for encryption: $key"

