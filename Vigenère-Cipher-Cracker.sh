#!/bin/bash
# (c) J~Net 2024
#
# Vigenère Cipher Cracker using a brute-force approach with dictionary words.
# It will try cracking the cipher by testing words from the dictionary and checking the decrypted text's word count.
#
# ./Vigenère-Cipher-Cracker.sh "vklbq-rqaz ikqp wj qqiyzvs tqy ougjl"
#
# If no key is provided, the script will try common dictionary words to decrypt the message.

# Function to decrypt using Vigenère cipher
vigenere_decrypt() {
  local ciphertext="$1"
  local key="$2"
  local decrypted=""
  local i j
  local key_length=${#key}
  local text_length=${#ciphertext}

  # Loop through each character of the ciphertext
  for ((i=0; i<text_length; i++)); do
    # Get the current character in ciphertext and key
    c_char="${ciphertext:i:1}"
    k_char="${key:$((i % key_length)):1}"
    
    # Convert to ASCII values and apply Vigenère cipher
    c_ascii=$(printf "%d" "'$c_char")
    k_ascii=$(printf "%d" "'$k_char")

    # Only decrypt alphabetic characters
    if [[ "$c_char" =~ [a-zA-Z] ]]; then
      if [[ "$c_char" =~ [a-z] ]]; then
        # Lowercase letter
        c_offset=97
      else
        # Uppercase letter
        c_offset=65
      fi

      # Adjust key ASCII based on whether it's lowercase or uppercase
      if [[ "$k_char" =~ [a-z] ]]; then
        k_offset=97
      else
        k_offset=65
      fi

      # Decrypt character and append to result
      decrypted_char=$(printf "\\$(printf '%03o' $(((c_ascii - c_offset - (k_ascii - k_offset) + 26) % 26 + c_offset)))")
      decrypted+="$decrypted_char"
    else
      # Non-alphabetic characters remain the same
      decrypted+="$c_char"
    fi
  done
  echo "$decrypted"
}

# Check if ciphertext argument is provided
if [ -z "$1" ]; then
  echo "Please provide a ciphertext to crack."
  exit 1
fi

ciphertext="$1"

# Ask the user for a key or use a dictionary-based approach
echo "Please enter a key (or press Enter to try cracking it with a dictionary):"
read -r key

# If no key is entered, assume key length is that of a typical random key length (e.g., 12 characters)
if [ -z "$key" ]; then
  echo "No key provided, attempting to crack the cipher using dictionary words..."
  
  # Default key length for unknown key case (same length as a randomly generated key)
  key_length=12

  # Check if dictionary is available
  if [ ! -f /usr/share/dict/words ]; then
    echo "Dictionary not found. Please ensure the dictionary file exists at /usr/share/dict/words."
    exit 1
  fi

  # Attempt to crack the cipher with dictionary words
  word_count=0
  found_decryption=false

  # Use a larger portion of the dictionary (1000 words)
  for dict_word in $(cat /usr/share/dict/words | head -n 1000); do
    # Ensure dictionary word matches the expected key length
    if [ ${#dict_word} -eq $key_length ]; then
      decrypted=$(vigenere_decrypt "$ciphertext" "$dict_word")
      
      # Count the number of English words in the decrypted text
      word_count=$(echo "$decrypted" | grep -oE '\w+' | wc -l)

      # Show potential decryption with the word count
      echo "Key: $dict_word -> Decrypted Text: $decrypted"
      echo "Word count: $word_count"

      # If the word count is high, ask the user for feedback
      if [ "$word_count" -gt 3 ]; then
        echo "Does this look correct? (y/n)"
        read -r feedback
        if [ "$feedback" == "y" ]; then
          echo "Decryption successful with key: $dict_word"
          found_decryption=true
          break
        fi
      fi
    fi
  done

  # If no valid key was found
  if [ "$found_decryption" == false ]; then
    echo "No valid decryption found with the dictionary words provided. You may want to try a longer dictionary list or a different key length."
  fi
else
  # If a key is provided, simply decrypt with it
  decrypted_text=$(vigenere_decrypt "$ciphertext" "$key")
  echo "Decrypted Text with provided key ($key): $decrypted_text"
fi

