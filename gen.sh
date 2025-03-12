#!/bin/bash

# Default password if -p flag is not used
defaultPassword="defaultPassword"

# Function to encode to Base64
encode_base64() {
  printf '%s' "$1" | base64
}

# Initialize variables
email=""
password=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    -p)
      # Make sure there's a value after -p
      if [[ -z "$2" || "$2" == -* ]]; then
        echo "Error: -p option requires a password argument" >&2
        exit 1
      fi
      password="$2"
      shift 2  # Skip both the flag and its value
      ;;
    -p=*|--password=*)
      # Handle -p=password format
      password="${1#*=}"
      shift
      ;;
    -*)
      echo "Invalid option: $1" >&2
      echo "Usage: $0 <email> [-p <password>]" >&2
      exit 1
      ;;
    *)
      # First non-flag argument is the email
      if [[ -z "$email" ]]; then
        email="$1"
      else
        echo "Error: Unexpected argument: $1" >&2
        echo "Usage: $0 <email> [-p <password>]" >&2
        exit 1
      fi
      shift
      ;;
  esac
done

# Check if email is provided
if [[ -z "$email" ]]; then
  echo "Error: Email is required" >&2
  echo "Usage: $0 <email> [-p <password>]" >&2
  exit 1
fi

# Use default password if -p flag was not used
if [[ -z "$password" ]]; then
  password="$defaultPassword"
fi

# DEBUGGING: Verify the password (comment out in production)
echo "Password before encoding: '$password'"

# Construct the string to encode
string_to_encode="$email:$password"

# Encode the string to Base64
encoded_string=$(encode_base64 "$string_to_encode")

# Output the encoded string
echo "$encoded_string"
