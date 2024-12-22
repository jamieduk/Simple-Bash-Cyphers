#!/bin/bash
# (c) J~Net 2024
#
# ./Atbash-Cipher-Creator.sh "text here"
#
# Atbash Cipher Creator - Takes input text and applies the Atbash cipher

# Function to apply the Atbash cipher to a string
atbash_cipher() {
  local input="$1"
  local output=""
  
  # Iterate through each character in the string
  for ((i = 0; i < ${#input}; i++)); do
    char="${input:$i:1}"
    
    # Check if the character is a lowercase letter
    if [[ "$char" =~ [a-z] ]]; then
      # Calculate the Atbash cipher for lowercase letters (a = 97, z = 122)
      ascii=$(printf "%d" "'$char")
      new_char=$(printf \\$(printf '%03o' $((219 - ascii))))
      output+="$new_char"
    
    # Check if the character is an uppercase letter
    elif [[ "$char" =~ [A-Z] ]]; then
      # Calculate the Atbash cipher for uppercase letters (A = 65, Z = 90)
      ascii=$(printf "%d" "'$char")
      new_char=$(printf \\$(printf '%03o' $((155 - ascii))))
      output+="$new_char"
    
    # If it's not a letter, just append the character as is
    else
      output+="$char"
    fi
  done
  
  echo "$output"
}

# Check if an argument is passed
if [ -z "$1" ]; then
  echo "Usage: $0 <text>"
  exit 1
fi

# Call the function and pass the argument
atbash_cipher "$1"

