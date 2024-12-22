#!/bin/bash
# (c) J~Net 2024
#
# Advanced Substitution Cipher Cracker using Frequency Analysis
#
# Usage:
# ./Advanced-Substitution-Cipher-Cracker.sh "ZGPZ12345 ZWRP RP J ZGPZ"
#
# This script attempts to crack a substitution cipher by analyzing letter frequency and
# generating possible substitutions based on English language letter frequency.

# Default English letter frequency in decreasing order (for frequency analysis)
english_frequency="ETAOINSHRDLCUMWFGYPBVKJXQZ"
wordlist="/usr/share/dict/words"  # Path to wordlist for validation (could vary depending on system)

# Function to analyze frequency of letters in the cipher text
analyze_frequency() {
  echo "$1" | tr -d -c 'A-Za-z' | tr 'a-z' 'A-Z' | fold -w1 | sort | uniq -c | sort -nr | awk '{print $2}'
}

# Function to generate a random substitution alphabet
generate_random_substitution() {
  # Create a shuffled alphabet
  local alphabet="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  local shuffled=$(echo $alphabet | tr -d '\n' | fold -w1 | shuf | tr -d '\n')
  echo $shuffled
}

# Function to count the number of valid English words in the decrypted text (spaces preserved)
count_english_words() {
  local text="$1"
  local valid_words=0
  # Convert to lowercase and split by spaces, checking each word
  for word in $(echo "$text" | tr ' ' '\n' | tr 'A-Z' 'a-z'); do
    if grep -q -i "^$word$" "$wordlist"; then
      ((valid_words++))
    fi
  done
  echo "$valid_words"
}

# Function to crack the cipher using frequency analysis
crack_cipher() {
  local cipher_text="$1"
  local substitution_alphabet="$2"
  
  # Attempt decryption using the provided substitution alphabet
  decrypted_text=$(echo "$cipher_text" | tr "$substitution_alphabet" "ABCDEFGHIJKLMNOPQRSTUVWXYZ")
  
  # Count the number of valid English words in the decrypted text
  valid_word_count=$(count_english_words "$decrypted_text")
  
  # Display the decrypted text, word count, and the used substitution alphabet
  echo "Decrypted Text: $decrypted_text"
  echo "Valid English Words Found: $valid_word_count"
  echo "Substitution Alphabet used: $substitution_alphabet"
  echo "$valid_word_count"
}

# Main script
if [ -z "$1" ]; then
  echo "Usage: ./Advanced-Substitution-Cipher-Cracker.sh <cipher_text>"
  exit 1
fi

# Set the cipher text
cipher_text="$1"

# Initialize skipped variable to track if substitution alphabet has been provided
skipped=false

# Function to ask for substitution alphabet if not skipped
ask_for_substitution_alphabet() {
  if [ "$skipped" = false ]; then
    read -p "Enter substitution alphabet (press Enter to generate random): " custom_substitution
    if [ -z "$custom_substitution" ]; then
      skipped=true
    fi
  else
    custom_substitution=""
  fi
}

# Function to handle the main logic
process_cipher() {
  if [ "$skipped" = false ] && [ -z "$custom_substitution" ]; then
    ask_for_substitution_alphabet
  fi

  if [ -z "$custom_substitution" ]; then
    # If no substitution alphabet is provided, generate random ones and try
    best_word_count=0
    best_substitution=""
    best_decrypted=""
    
    for i in {1..10}; do
      random_substitution=$(generate_random_substitution)
      result=$(crack_cipher "$cipher_text" "$random_substitution")
      
      # Extract the valid word count from the result
      valid_word_count=$(echo "$result" | tail -n 1)
      
      if [ "$valid_word_count" -gt "$best_word_count" ]; then
        best_word_count=$valid_word_count
        best_substitution=$random_substitution
        best_decrypted=$(echo "$result" | head -n 1)
      fi
    done
    
    # Show the best solution
    echo "Most Likely Solution:"
    echo "$best_decrypted"
    echo "Valid English Words Found: $best_word_count"
    echo "Substitution Alphabet used: $best_substitution"
  else
    # Process using the provided or generated substitution alphabet
    result=$(crack_cipher "$cipher_text" "$custom_substitution")
    valid_word_count=$(echo "$result" | tail -n 1)
    
    # Show result and ask for user feedback
    echo "$result"
  fi

  # Ask if user wants to try again
  read -p "Do you want to try another substitution alphabet? (y/n): " response
  case $response in
    [Yy]*)
      skipped=true
      custom_substitution=""
      process_cipher
      ;;
    [Nn]*)
      echo "Decryption complete."
      ;;
    *)
      echo "Please answer y or n."
      process_cipher
      ;;
  esac
}

# Start processing the cipher
process_cipher

