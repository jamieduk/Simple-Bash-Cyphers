#!/bin/bash
# (c) J~Net 2024
#
# Simple Substitution Cipher Cracker for reversed letter mappings (A->Z, B->Y, etc.)
#
# ./Simple-Substitution-Cipher-Cracker.sh "GVHG12345 GSRH RH Z GVHG"

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <ciphertext>"
  exit 1
fi

ciphertext="$1"
dictionary="/usr/share/dict/words" # Path to an English word list

# Ensure dictionary exists
if [ ! -f "$dictionary" ]; then
  echo "Dictionary file not found. Please ensure $dictionary exists."
  exit 1
fi

# Frequency analysis
echo "Letter Frequency Analysis:"
freq=$(echo "$ciphertext" | grep -o . | grep -E '[A-Za-z]' | tr 'a-z' 'A-Z' | sort | uniq -c | sort -nr)
echo "$freq"

# Reverse alphabet substitution (A->Z, B->Y, C->X, ...)
reverse_alphabet="ZYXWVUTSRQPONMLKJIHGFEDCBA"

# Function to decrypt text using the reversed alphabet substitution
decrypt_text() {
  local text="$1"
  decrypted=$(echo "$text" | tr 'A-Z' "$reverse_alphabet")
  echo "$decrypted"
}

# Function to count matching English words in the decrypted text
count_matching_words() {
  local decrypted="$1"
  
  # Remove punctuation and split by spaces
  cleaned_decrypted=$(echo "$decrypted" | tr -d -c '[:alnum:] \n')
  
  # Count words found in dictionary
  matches=0
  for word in $cleaned_decrypted; do
    if grep -iqw "$word" "$dictionary"; then
      ((matches++))
    fi
  done
  echo "$matches"
}

# Start brute-force process
max_matches=0
best_decrypted=""
best_mapping=""
iteration_count=0
max_iterations=100

# First try reverse alphabet substitution
decrypted=$(decrypt_text "$ciphertext")
matches=$(count_matching_words "$decrypted")

# Display and ask user for feedback
echo "Reverse Alphabet Decrypted text: $decrypted"
echo "Number of matching English words: $matches"
echo "Substitution used: $reverse_alphabet"
echo "Do you want to try another substitution alphabet? (y/n): "
read feedback
if [ "$feedback" == "n" ]; then
  echo "Final Decrypted text: $decrypted"
  echo "Final Substitution: $reverse_alphabet"
  exit 0
fi

# If reverse substitution failed, continue with random substitutions (only if needed)
echo "Trying other substitutions..."
while [ "$iteration_count" -lt "$max_iterations" ]; do
  # Here we could generate random substitutions if needed, but in this case, we stick with reverse
  decrypted=$(decrypt_text "$ciphertext")
  
  # Count the number of matching English words
  matches=$(count_matching_words "$decrypted")

  # Increase iteration count
  iteration_count=$((iteration_count + 1))

  # Display current result to the user and ask for feedback
  echo "Current Substitution: $reverse_alphabet"
  echo "Decrypted text: $decrypted"
  echo "Number of matching English words: $matches"
  echo "Do you want to try another substitution alphabet? (y/n): "
  read feedback

  if [ "$feedback" == "n" ]; then
    echo "Final Decrypted text: $decrypted"
    echo "Final Substitution: $reverse_alphabet"
    exit 0
  elif [ "$feedback" == "y" ]; then
    echo "Continuing to try another substitution alphabet..."
  fi
done

# If no substitution was accepted, show final message
echo "No decryption accepted. Please try again with different inputs."

