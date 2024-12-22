#!/bin/bash
# (c) J~Net 2024
#
# Vigenère Cipher Creator
# Encrypts the input plaintext using a Vigenère cipher with the given key.

# Function to generate a random key
generate_key() {
  local length=$1
  tr -dc 'A-Za-z' </dev/urandom | head -c $length
}

# Function to encrypt using Vigenère cipher
vigenere_encrypt() {
  local plaintext="$1"
  local key="$2"
  local ciphertext=""
  local i
  local key_length=${#key}
  local text_length=${#plaintext}

  # Loop through each character of the plaintext
  for ((i=0; i<text_length; i++)); do
    # Get the current character in plaintext and key
    p_char="${plaintext:i:1}"
    k_char="${key:$((i % key_length)):1}"
    
    # Convert to ASCII values and apply Vigenère cipher
    p_ascii=$(printf "%d" "'$p_char")
    k_ascii=$(printf "%d" "'$k_char")

    # Only encrypt alphabetic characters
    if [[ "$p_char" =~ [a-zA-Z] ]]; then
      if [[ "$p_char" =~ [a-z] ]]; then
        # Lowercase letter
        p_offset=97
      else
        # Uppercase letter
        p_offset=65
      fi

      # Adjust key ASCII based on whether it's lowercase or uppercase
      if [[ "$k_char" =~ [a-z] ]]; then
        k_offset=97
      else
        k_offset=65
      fi

      # Encrypt character and append to result
      encrypted_char=$(printf "\\$(printf '%03o' $(((p_ascii - p_offset + k_ascii - k_offset) % 26 + p_offset)))")
      ciphertext+="$encrypted_char"
    else
      # Non-alphabetic characters remain the same
      ciphertext+="$p_char"
    fi
  done
  echo "$ciphertext"
}

# Check if plaintext argument is provided
if [ -z "$1" ]; then
  echo "Please provide a plaintext to encrypt."
  exit 1
fi

plaintext="$1"

# Prompt for a key if not provided as argument
echo "Please enter a key (or press Enter to generate a random key):"
read -r key

if [ -z "$key" ]; then
  echo "No key provided. Generating a strong key."
  key=$(generate_key 12)  # Generate a random key of length 12
  echo "Generated Key: $key"
else
  echo "Using provided key: $key"
fi

# Encrypt the plaintext
encrypted_text=$(vigenere_encrypt "$plaintext" "$key")
echo "Encrypted Text: $encrypted_text"

