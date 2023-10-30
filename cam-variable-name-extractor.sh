#!/bin/bash

# Store the original working directory
original_directory=$(pwd)
output_directory=$original_directory/output
output=$output_directory/everything.txt

# Clear the output file
cat /dev/null > "$output"

while read line; do

    # Use the full path to the "forms" directory
    forms_directory="$original_directory/src/main/webapp/forms/"

    # Change to the "forms" directory
    cd "$forms_directory" || (echo "Error: Directory '$forms_directory' not found." && exit 1)

    # Use the "find" command to locate files that match the specified pattern
    find . -type f -name "$line" -printf '%P\n' | while read file; do
        echo "Reading file: $file"
        cat "$file" | grep -oP '(?<=cam-variable-name=").*?(?=")' | grep -v 'readonly' | while read variables; do
            
            # Create the output file and append data to it
            touch "$output"
            if ! grep -q ".*$variables.*" "$output"; then
                echo "$variables" >> "$output" || (echo "Error: Failed to write to the '$output' file." && exit 1)
            fi            
            # Return to the original working directory
            cd "$original_directory" || (echo "Error: Failed to return to the original directory." && exit 1)
        done
    done

    # Restore the working directory for the next iteration
    cd "$original_directory" || (echo "Error: Failed to return to the original directory." && exit 1)

done < "$output_directory/html-forms.txt"
