# Simple Bash Ciphers

Simple Bash Ciphers by J\~Net 2024

[GitHub Repository](https://github.com/jamieduk/Simple-Bash-Cyphers)\
[Discussion Forum](https://jnet.forumotion.com/t2083-bash-auto-rot13-cracker#3220)

## Overview

This project includes scripts for working with various ciphers in Bash. Each script demonstrates a specific cipher's encryption and decryption process, as well as methods to crack them.

### 1. Simple Substitution Cipher

- **Description**: A monoalphabetic cipher where each letter is replaced with a unique letter.
- **Cracking Method**: Frequency analysis of letters.

### 2. Atbash Cipher

- **Description**: A substitution cipher where letters are reversed (A ↔ Z, B ↔ Y, etc.).
- **Cracking Method**: Straightforward due to the predictable mapping.

### 3. XOR Cipher

- **Description**: Uses a single character as the key and applies XOR operation.
- **Cracking Method**: Brute-force all possible single-character keys.

### 4. Vigenère Cipher

- **Description**: Uses a keyword to determine letter shifts.
- **Cracking Method**: Brute-force shorter keywords.

### 5. ROT13 Shift (Caesar Cipher)

- **Description**: A Caesar cipher with a fixed shift of 13. Often used in obfuscation.
- **Cracking Method**: Decode with the known shift value.

---

## Usage Examples

### 1. Auto-Crack ROT13

```bash
./auto-crack-rot13.sh "alza"
```

**Expected Output:**

```
Decrypted Text: test
UnShift Used: 19
Original Shift Used: 7
```

### 2. Atbash Cipher Cracker

```bash
./Atbash-Cipher-Cracker.sh "Zgyzhs"
```

**Ciphertext:** `Zgyzhs`
**Expected Output:** `Atbash`

### 3. Simple Substitution Cipher Cracker

```bash
./Simple-Substitution-Cipher-Cracker.sh "GVHG12345 GSRH RH Z GVHG"
```

**Expected Output:** Decrypted text with key mapping provided.

### 4. Vigenère Cipher Cracker

Ciphertext encrypted with keyword "key":

```bash
./Vigenère-Cipher-Cracker.sh "Rijvs"
```

**Expected Output:**

```
Decrypted Text: Hello
```

### 5. XOR Cipher Cracker

Ciphertext in hexadecimal format:

```bash
./XOR-Cipher-Cracker.sh "4c0e0f"
```

**Expected Output:**

```
Decrypted Text: Hello (using key 0x42)
```

### 6. Reverse Caesar Shift

```bash
./unshift.sh "dahhk"
```

**Expected Operation:** Reverse shift to find the plaintext `apple`.

### 7. Caesar Shift

```bash
./shift.sh "apple" 5
```

**Expected Output:**

```
Decrypted Text: fuuqj
```

---

## Cipher Creation Examples

### Create a Substitution Cipher

```bash
./Simple-Substitution-Cipher-Creator.sh "test12345 this is a test"
```

**Expected Output:**

```
Encrypted Text: GVHG12345 GSRH RH Z GVHG
Substitution Key:
Original Alphabet:  ABCDEFGHIJKLMNOPQRSTUVWXYZ
Custom Cipher:      ZYXWVUTSRQPONMLKJIHGFEDCBA
```

### Create an Atbash Cipher

```bash
./Atbash-Cipher-Creator.sh "text here"
```

**Expected Output:**

```
sdws gdqd
```

---

## Notes

- Scripts are designed for educational purposes and demonstrate cipher techniques and their vulnerabilities.
- Extend functionality or contribute by visiting the [GitHub repository](https://github.com/jamieduk/Simple-Bash-Cyphers).

