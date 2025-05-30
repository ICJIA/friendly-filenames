# Friendly Filenames

A comprehensive bash script to normalize file names with multiple case style options, smart defaults, and extensive commenting for future developers.

## Features

- **8 Case Styles Available**: snake_case, kebab-case, camelCase, PascalCase, UPPER_SNAKE, flatcase, UPPERCASE, slug-case
- **Smart Defaults**: Press ENTER to accept sensible defaults for quick operation
- **Intelligent Renaming**: Only renames files that need it - properly named files are left unchanged
- **Always Lowercase Extensions**: File extensions are always normalized to lowercase regardless of case style
- **Target Directory Control**: Choose your output directory with default handling for existing directories
- **Comprehensive Comments**: Extensively documented code for future developers
- **Recursive Processing**: Handles files in subdirectories (flattened to output directory)
- **Safe Operation**: Copies files to a new directory, leaving originals untouched
- **Git Integration**: Output directory automatically ignored via .gitignore

## Installation

No installation required. Simply ensure you have bash available (standard on Linux/macOS).

**Tested on:** Ubuntu 22.04

## Usage

### Quick Start (Using Defaults)
For fastest operation, simply run the script and press ENTER for all prompts to use defaults:

```bash
./normalize_filenames.sh
```

**Default settings:**
- Source directory: `./files`
- Target directory: `./files-renamed` 
- Case style: `snake_case`
- Existing directory handling: Delete and recreate

### Custom Configuration
Follow the interactive prompts to customize:

1. **Source Directory**: Where your files are located (default: `./files`)
2. **Target Directory**: Where normalized files will be saved (default: `./files-renamed`)
3. **Existing Directory Handling**: 
   - Option 1 (default): Delete existing target directory and start fresh
   - Option 2: Preserve existing directory and add files to it
4. **Case Style Selection**:
   - 1) **snake_case** (my_file_name.txt) - DEFAULT
   - 2) **kebab-case** (my-file-name.txt)
   - 3) **slug-case** (my-file-name.txt) - same as kebab
   - 4) **camelCase** (myFileName.txt)
   - 5) **PascalCase** (MyFileName.txt)
   - 6) **UPPER_SNAKE** (MY_FILE_NAME.txt)
   - 7) **flatcase** (myfilename.txt)
   - 8) **UPPERCASE** (MYFILENAME.txt)

## Examples

### Input Files
- `My Document.txt`
- `Photo 2024-05-30.jpg`
- `UPPERCASE FILE.DOC`
- `Project_Final-Version (2).pdf`
- `Budget Analysis FINAL.XLS`

### Output by Case Style

**snake_case (default):**
- `my_document.txt`
- `photo_2024_05_30.jpg`
- `uppercase_file.doc`
- `project_final_version_2.pdf`
- `budget_analysis_final.xls`

**camelCase:**
- `myDocument.txt`
- `photo20240530.jpg`
- `uppercaseFile.doc`
- `projectFinalVersion2.pdf`
- `budgetAnalysisFinal.xls`

**PascalCase:**
- `MyDocument.txt`
- `Photo20240530.jpg`
- `UppercaseFile.doc`
- `ProjectFinalVersion2.pdf`
- `BudgetAnalysisFinal.xls`

**UPPER_SNAKE:**
- `MY_DOCUMENT.txt`
- `PHOTO_2024_05_30.jpg`
- `UPPERCASE_FILE.doc`
- `PROJECT_FINAL_VERSION_2.pdf`
- `BUDGET_ANALYSIS_FINAL.xls`

## Sample Files

The `./files` directory contains sample files with various naming issues for testing purposes. **Delete these sample files before adding your own files to rename.**

To clear sample files:
```bash
rm -rf ./files/*
```

## Important Rules

### File Extensions
- **Always lowercase**: Extensions are normalized to lowercase regardless of case style
- Examples: `.TXT` → `.txt`, `.PDF` → `.pdf`, `.JPG` → `.jpg`

### Processing Logic
- **Smart detection**: Files already properly named are copied as-is
- **Safe operation**: Original files are never modified, only copied
- **Recursive flattening**: Subdirectory files are copied to the target directory root

### Case Style Rules
Each case style has specific character and formatting requirements:

- **snake_case / UPPER_SNAKE**: Letters, numbers, underscores only
- **kebab-case / slug-case**: Letters, numbers, hyphens only  
- **camelCase**: Starts lowercase, mixed case, no separators
- **PascalCase**: Starts uppercase, mixed case, no separators
- **flatcase**: All lowercase, no separators
- **UPPERCASE**: All uppercase, no separators

## Developer Notes

The script is extensively commented for future developers:
- Function documentation with parameters and return values
- Section headers explaining each part of the script
- Inline comments for complex operations
- Clear variable naming and logical flow

## Git Integration

- Output directory (`files-renamed/`) is automatically ignored via `.gitignore`
- Comprehensive `.gitignore` includes Node.js, OS-specific, and development tool files
- Claude Code files (`.claude`) are also ignored