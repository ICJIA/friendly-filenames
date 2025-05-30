# Friendly Filenames

A bash script to normalize file names by converting them to lowercase, replacing spaces and special characters with your choice of separator, and preserving file extensions.

## Features

- **Smart renaming**: Only renames files that need it - files already properly named are left unchanged
- **Multiple case styles**: Choose between snake_case, kebab-case, or slug-case
- **Recursive processing**: Handles files in subdirectories
- **Extension preservation**: Maintains file extensions in lowercase
- **Safe operation**: Copies files to a new directory, leaving originals untouched

## Installation

No installation required. Simply ensure you have bash available (standard on Linux/macOS).

## Usage

1. Place your files in the `./files` directory (or specify a different source directory)
2. Run the script:
   ```bash
   ./normalize_filenames.sh
   ```
3. Follow the prompts to:
   - Choose source directory (defaults to `./files`)
   - Select naming convention:
     - 1) snake_case (underscores)
     - 2) kebab-case (hyphens)  
     - 3) slug-case (hyphens, same as kebab)

The script will create a `./files-renamed` directory with your normalized files.

## Example

**Before:**
- `My Document.txt`
- `Photo 2024-05-30.jpg`
- `UPPERCASE FILE.DOC`
- `Project_Final-Version (2).pdf`

**After (snake_case):**
- `my_document.txt`
- `photo_2024_05_30.jpg`
- `uppercase_file.doc`
- `project_final_version_2.pdf`

## Sample Files

The `./files` directory contains sample files with various naming issues for testing purposes. **Delete these sample files before adding your own files to rename.**

To clear sample files:
```bash
rm -rf ./files/*
```

## What Gets Normalized

- **Uppercase letters** → lowercase
- **Spaces** → replaced with chosen separator (_ or -)
- **Special characters** → replaced with chosen separator
- **File extensions** → converted to lowercase
- **Multiple separators** → consolidated to single separator

## What Stays the Same

Files that are already properly named (lowercase, using only letters/numbers/chosen separator) are copied as-is without renaming.