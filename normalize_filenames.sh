#!/bin/bash

is_properly_named() {
    local filename="$1"
    local case_style="$2"
    local name="${filename%.*}"
    local ext="${filename##*.}"
    
    # Check if extension is lowercase (or no extension)
    if [[ "$filename" != "$name" ]]; then
        local ext_lower=$(echo "$ext" | tr '[:upper:]' '[:lower:]')
        if [[ "$ext" != "$ext_lower" ]]; then
            return 1
        fi
    fi
    
    # Check if name is all lowercase
    local name_lower=$(echo "$name" | tr '[:upper:]' '[:lower:]')
    if [[ "$name" != "$name_lower" ]]; then
        return 1
    fi
    
    # Check if name follows the chosen case style (no spaces or special chars)
    case "$case_style" in
        "snake")
            if [[ ! "$name" =~ ^[a-z0-9_]+$ ]]; then
                return 1
            fi
            ;;
        "kebab"|"slug")
            if [[ ! "$name" =~ ^[a-z0-9-]+$ ]]; then
                return 1
            fi
            ;;
        *)
            if [[ ! "$name" =~ ^[a-z0-9_]+$ ]]; then
                return 1
            fi
            ;;
    esac
    
    return 0
}

normalize_filename() {
    local filename="$1"
    local case_style="$2"
    local name="${filename%.*}"
    local ext="${filename##*.}"
    
    if [[ "$filename" == "$name" ]]; then
        ext=""
    else
        ext=".$ext"
    fi
    
    case "$case_style" in
        "snake")
            normalized=$(echo "$name" | sed 's/[^a-zA-Z0-9]/_/g' | sed 's/__*/_/g' | sed 's/^_\|_$//g' | tr '[:upper:]' '[:lower:]')
            ;;
        "kebab")
            normalized=$(echo "$name" | sed 's/[^a-zA-Z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g' | tr '[:upper:]' '[:lower:]')
            ;;
        "slug")
            normalized=$(echo "$name" | sed 's/[^a-zA-Z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g' | tr '[:upper:]' '[:lower:]')
            ;;
        *)
            normalized=$(echo "$name" | sed 's/[^a-zA-Z0-9]/_/g' | sed 's/__*/_/g' | sed 's/^_\|_$//g' | tr '[:upper:]' '[:lower:]')
            ;;
    esac
    
    echo "${normalized}${ext}"
}

# Get source directory (default to ./files)
read -p "Source directory [./files]: " source_dir
source_dir=${source_dir:-./files}

if [[ ! -d "$source_dir" ]]; then
    echo "Error: Directory '$source_dir' does not exist."
    exit 1
fi

# Get case style
echo "Case styles: 1) snake_case 2) kebab-case 3) slug-case"
read -p "Choose [1]: " choice
case "$choice" in
    2) case_style="kebab" ;;
    3) case_style="slug" ;;
    *) case_style="snake" ;;
esac

# Create destination directory
dest_dir="./files-renamed"
rm -rf "$dest_dir"
mkdir -p "$dest_dir"

echo "Processing files from $source_dir to $dest_dir using $case_style..."
echo

# Process all files recursively
find "$source_dir" -type f | while read -r file; do
    filename=$(basename "$file")
    
    if is_properly_named "$filename" "$case_style"; then
        echo "$filename (already properly named, copying as-is)"
        cp "$file" "$dest_dir/$filename"
    else
        new_name=$(normalize_filename "$filename" "$case_style")
        echo "$filename --> $new_name"
        cp "$file" "$dest_dir/$new_name"
    fi
done

echo
echo "Done! Files copied to $dest_dir"