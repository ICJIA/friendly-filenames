#!/bin/bash

#==============================================================================
# Friendly Filenames - Filename Normalization Script
#==============================================================================
# This script normalizes filenames by converting them to various case styles
# and removing spaces, special characters, and other problematic characters.
# Supports multiple case types with sensible defaults for quick operation.
#==============================================================================

#------------------------------------------------------------------------------
# Function: is_properly_named
# Purpose: Checks if a filename already follows the specified case style
# Parameters:
#   $1 - filename: The filename to check
#   $2 - case_style: The target case style (snake, kebab, camel, etc.)
# Returns: 0 if properly named, 1 if needs normalization
#------------------------------------------------------------------------------
is_properly_named() {
    local filename="$1"
    local case_style="$2"
    
    # Split filename into name and extension
    local name="${filename%.*}"
    local ext="${filename##*.}"
    
    # Check if extension is lowercase (extensions are ALWAYS lowercase regardless of case style)
    # This ensures consistency across all file systems and compatibility
    if [[ "$filename" != "$name" ]]; then
        local ext_lower=$(echo "$ext" | tr '[:upper:]' '[:lower:]')
        if [[ "$ext" != "$ext_lower" ]]; then
            return 1  # Extension not lowercase, needs normalization
        fi
    fi
    
    # Validate the filename against the chosen case style
    # Each case style has specific character and format requirements
    case "$case_style" in
        "snake"|"UPPER_SNAKE")
            # snake_case: lowercase letters, numbers, underscores only
            # UPPER_SNAKE: uppercase letters, numbers, underscores only
            if [[ "$case_style" == "UPPER_SNAKE" ]]; then
                if [[ ! "$name" =~ ^[A-Z0-9_]+$ ]]; then
                    return 1
                fi
            else
                if [[ ! "$name" =~ ^[a-z0-9_]+$ ]]; then
                    return 1
                fi
            fi
            ;;
        "kebab"|"slug")
            # kebab-case/slug-case: lowercase letters, numbers, hyphens only
            if [[ ! "$name" =~ ^[a-z0-9-]+$ ]]; then
                return 1
            fi
            ;;
        "camel")
            # camelCase: starts lowercase, no spaces/special chars, mixed case allowed
            if [[ ! "$name" =~ ^[a-z][a-zA-Z0-9]*$ ]]; then
                return 1
            fi
            ;;
        "pascal")
            # PascalCase: starts uppercase, no spaces/special chars, mixed case allowed
            if [[ ! "$name" =~ ^[A-Z][a-zA-Z0-9]*$ ]]; then
                return 1
            fi
            ;;
        "flat")
            # flatcase: all lowercase, no separators, alphanumeric only
            if [[ ! "$name" =~ ^[a-z0-9]+$ ]]; then
                return 1
            fi
            ;;
        "UPPER")
            # UPPERCASE: all uppercase, no separators, alphanumeric only
            if [[ ! "$name" =~ ^[A-Z0-9]+$ ]]; then
                return 1
            fi
            ;;
        *)
            # Default to snake_case validation
            if [[ ! "$name" =~ ^[a-z0-9_]+$ ]]; then
                return 1
            fi
            ;;
    esac
    
    return 0  # Filename is properly formatted
}

#------------------------------------------------------------------------------
# Function: normalize_filename
# Purpose: Converts a filename to the specified case style
# Parameters:
#   $1 - filename: The original filename to normalize
#   $2 - case_style: The target case style to convert to
# Returns: The normalized filename via echo
#------------------------------------------------------------------------------
normalize_filename() {
    local filename="$1"
    local case_style="$2"
    
    # Split filename into name and extension
    local name="${filename%.*}"
    local ext="${filename##*.}"
    
    # Handle files without extensions
    if [[ "$filename" == "$name" ]]; then
        ext=""
    else
        # Extensions are ALWAYS lowercase regardless of case style
        # This ensures maximum compatibility and consistency
        ext=".$(echo "$ext" | tr '[:upper:]' '[:lower:]')"
    fi
    
    # Apply the specified case transformation
    case "$case_style" in
        "snake")
            # snake_case: Replace non-alphanumeric with underscores, collapse multiple, trim ends, lowercase
            normalized=$(echo "$name" | sed 's/[^a-zA-Z0-9]/_/g' | sed 's/__*/_/g' | sed 's/^_\|_$//g' | tr '[:upper:]' '[:lower:]')
            ;;
        "UPPER_SNAKE")
            # UPPER_SNAKE: Same as snake_case but uppercase
            normalized=$(echo "$name" | sed 's/[^a-zA-Z0-9]/_/g' | sed 's/__*/_/g' | sed 's/^_\|_$//g' | tr '[:lower:]' '[:upper:]')
            ;;
        "kebab"|"slug")
            # kebab-case/slug-case: Replace non-alphanumeric with hyphens, collapse multiple, trim ends, lowercase
            normalized=$(echo "$name" | sed 's/[^a-zA-Z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g' | tr '[:upper:]' '[:lower:]')
            ;;
        "camel")
            # camelCase: Remove spaces/special chars, capitalize after separators, first letter lowercase
            normalized=$(echo "$name" | sed 's/[^a-zA-Z0-9]/ /g' | sed 's/  */ /g' | sed 's/^ *\| *$//g')
            normalized=$(echo "$normalized" | awk '{
                result = tolower(substr($1,1,1)) substr($1,2)
                for(i=2; i<=NF; i++) {
                    result = result toupper(substr($i,1,1)) substr($i,2)
                }
                print result
            }')
            ;;
        "pascal")
            # PascalCase: Remove spaces/special chars, capitalize after separators, first letter uppercase
            normalized=$(echo "$name" | sed 's/[^a-zA-Z0-9]/ /g' | sed 's/  */ /g' | sed 's/^ *\| *$//g')
            normalized=$(echo "$normalized" | awk '{
                result = ""
                for(i=1; i<=NF; i++) {
                    result = result toupper(substr($i,1,1)) substr($i,2)
                }
                print result
            }')
            ;;
        "flat")
            # flatcase: Remove all separators, all lowercase, alphanumeric only
            normalized=$(echo "$name" | sed 's/[^a-zA-Z0-9]//g' | tr '[:upper:]' '[:lower:]')
            ;;
        "UPPER")
            # UPPERCASE: Remove all separators, all uppercase, alphanumeric only
            normalized=$(echo "$name" | sed 's/[^a-zA-Z0-9]//g' | tr '[:lower:]' '[:upper:]')
            ;;
        *)
            # Default: snake_case
            normalized=$(echo "$name" | sed 's/[^a-zA-Z0-9]/_/g' | sed 's/__*/_/g' | sed 's/^_\|_$//g' | tr '[:upper:]' '[:lower:]')
            ;;
    esac
    
    # Return the normalized filename with extension
    echo "${normalized}${ext}"
}

#==============================================================================
# MAIN SCRIPT EXECUTION
#==============================================================================

#------------------------------------------------------------------------------
# Get source directory from user (default: ./files)
# User can simply press ENTER to accept the default
#------------------------------------------------------------------------------
echo "=== Friendly Filenames - Configuration ==="
echo
read -p "Source directory [./files]: " source_dir
source_dir=${source_dir:-./files}

# Validate that the source directory exists
if [[ ! -d "$source_dir" ]]; then
    echo "Error: Directory '$source_dir' does not exist."
    exit 1
fi

#------------------------------------------------------------------------------
# Get target directory from user (default: ./files-renamed)
# User can simply press ENTER to accept the default
#------------------------------------------------------------------------------
read -p "Target directory [./files-renamed]: " dest_dir
dest_dir=${dest_dir:-./files-renamed}

#------------------------------------------------------------------------------
# Handle existing target directory
# Default behavior: DELETE existing directory (safer for clean operations)
# Option: PRESERVE existing directory and add files to it
#------------------------------------------------------------------------------
if [[ -d "$dest_dir" ]]; then
    echo
    echo "Target directory '$dest_dir' already exists."
    echo "Options:"
    echo "  1) Delete existing directory and create fresh (recommended)"
    echo "  2) Preserve existing directory and add files to it"
    echo
    read -p "Choose [1]: " dir_choice
    
    case "$dir_choice" in
        2)
            echo "Preserving existing directory: $dest_dir"
            ;;
        *)
            echo "Deleting existing directory: $dest_dir"
            rm -rf "$dest_dir"
            ;;
    esac
fi

# Ensure target directory exists
mkdir -p "$dest_dir"

#------------------------------------------------------------------------------
# Get case style from user with comprehensive options
# Default: snake_case (option 1) - most common for file systems
#------------------------------------------------------------------------------
echo
echo "Available case styles:"
echo "  1) snake_case       (my_file_name.txt) - DEFAULT"
echo "  2) kebab-case       (my-file-name.txt)"
echo "  3) slug-case        (my-file-name.txt) - same as kebab"
echo "  4) camelCase        (myFileName.txt)"
echo "  5) PascalCase       (MyFileName.txt)"
echo "  6) UPPER_SNAKE      (MY_FILE_NAME.txt)"
echo "  7) flatcase         (myfilename.txt)"
echo "  8) UPPERCASE        (MYFILENAME.txt)"
echo
read -p "Choose case style [1]: " choice

# Map user choice to internal case style identifier
case "$choice" in
    2) case_style="kebab" ;;
    3) case_style="slug" ;;
    4) case_style="camel" ;;
    5) case_style="pascal" ;;
    6) case_style="UPPER_SNAKE" ;;
    7) case_style="flat" ;;
    8) case_style="UPPER" ;;
    *) case_style="snake" ;;  # Default
esac

#------------------------------------------------------------------------------
# Display processing summary before starting
#------------------------------------------------------------------------------
echo
echo "=== Processing Summary ==="
echo "Source:     $source_dir"
echo "Target:     $dest_dir"
echo "Case style: $case_style"
echo
echo "Processing files..."
echo

#------------------------------------------------------------------------------
# Process all files recursively
# Maintains directory structure by flattening to target directory
# Files are copied (not moved) to preserve originals
#------------------------------------------------------------------------------
file_count=0
processed_count=0

find "$source_dir" -type f | while read -r file; do
    filename=$(basename "$file")
    ((file_count++))
    
    # Check if filename already follows the target case style
    if is_properly_named "$filename" "$case_style"; then
        echo "✓ $filename (already properly named, copying as-is)"
        cp "$file" "$dest_dir/$filename"
    else
        # Normalize the filename according to the chosen case style
        new_name=$(normalize_filename "$filename" "$case_style")
        echo "→ $filename --> $new_name"
        cp "$file" "$dest_dir/$new_name"
        ((processed_count++))
    fi
done

#------------------------------------------------------------------------------
# Display completion summary
#------------------------------------------------------------------------------
echo
echo "=== Processing Complete ==="
echo "Files processed and copied to: $dest_dir"
echo
echo "Next steps:"
echo "  - Review the normalized filenames in $dest_dir"
echo "  - Test that your applications work with the new filenames"
echo "  - Replace original files when satisfied with results"
echo