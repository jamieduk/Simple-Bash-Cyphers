#!/bin/bash
# (c) J~Net 2024
#
# https://jnet.forumotion.com/t2083-bash-auto-rot13-cracker#3220
#
# ./auto-crack-rot13.sh "alza"
#
#
# Script to auto-crack ROT13 or Caesar cipher using ciphertext.
# Finds the shift that yields the most English-like text.

# Function to count English words in a given string.
count_english_words() {
  local text="$1"
  local words_file="/usr/share/dict/words" # Path to a dictionary file
  local count=0

  # Split the text into words and count matches in the dictionary
  for word in $text; do
    if grep -iwq "^$word$" "$words_file"; then
      ((count++))
    fi
  done

  echo "$count"
}

# Check if ciphertext is provided.
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <ciphertext>"
  exit 1
fi

ciphertext="$1"
best_shift=0
max_words=0
decrypted_text=""

# Loop through all 26 possible shifts.
for shift in {0..25}; do
  # Generate shifted alphabet for decryption.
  upper_alphabet=$(echo {A..Z} | tr -d ' ')
  lower_alphabet=$(echo {a..z} | tr -d ' ')
  shifted_upper=$(echo "$upper_alphabet$upper_alphabet" | cut -c$((shift+1))-$((shift+26)))
  shifted_lower=$(echo "$lower_alphabet$lower_alphabet" | cut -c$((shift+1))-$((shift+26)))

  # Decrypt by shifting characters.
  shifted_text=$(echo "$ciphertext" | tr "A-Za-z" "$shifted_upper$shifted_lower")

  # Count English words in the shifted text.
  word_count=$(count_english_words "$shifted_text")

  # Update the best shift if this one has more English words.
  if [ "$word_count" -gt "$max_words" ]; then
    max_words=$word_count
    best_shift=$shift
    decrypted_text="$shifted_text"
  fi
done

# Output the results.
echo "Decrypted Text: $decrypted_text"
echo "UnShift Used: $best_shift"
echo "Original Shift Used: $((26 - best_shift))"

