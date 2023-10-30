#!/bin/bash
# Store the current working directory in a variable
original_directory=$(pwd)

# Define the output directory path
output_directory="$original_directory/output"

# Create the output directory if it doesn't exist
mkdir -p "$output_directory"

# Change the permissions of the output directory to allow all users to read, write, and execute
chmod 777 "$output_directory"

# Extract form keys from the BPMN file, sort them, remove duplicates, and write them to a file in the output directory
cat src/main/resources/loanApproval.bpmn | grep -oP '(?<=formKey="embedded:app:).*?(?=")' | sort | uniq > $output_directory/html-forms.txt

# Create an empty file named 'everything.txt' in the output directory
touch $output_directory/everything.txt