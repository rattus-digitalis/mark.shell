#!/bin/bash

# --- Initialization ---
WORK_DIR="work_temp"
EXECUTABLE="factorielle"
SCRIPT_DIR="$(pwd)"
USE_PROJECT_DIR=false
USE_ZIP=false
note=0
malus=0
details=()
nom="Unknown"
prenom="Unknown"

# --- Detect project source ---
if [ -d "projet" ]; then
    USE_PROJECT_DIR=true
    PROJECT_DIR="$SCRIPT_DIR/projet"
    echo "Directory 'projet/' found. Using it for correction."
else
    if [ $# -eq 1 ] && [[ "$1" == *.zip ]]; then
        USE_ZIP=true
        ZIP_FILE="$1"
        echo "No 'projet/' directory found. Using provided zip file: $ZIP_FILE"
    elif [ $# -eq 0 ]; then
        echo "Warning: No argument given. Searching for a zip file..."
        ZIP_FILE=$(find "$SCRIPT_DIR" -maxdepth 1 -type f -name "*.zip" | head -n 1)
        if [ -n "$ZIP_FILE" ]; then
            echo "Found zip file: $ZIP_FILE. Using it."
            USE_ZIP=true
        else
            echo "Error: No zip file found in the current directory."
            exit 1
        fi
    else
        echo "Error: Argument must be a .zip file."
        echo "Usage: $0 [project.zip]"
        exit 1
    fi
fi

# --- Prepare project ---
if $USE_ZIP; then
    rm -rf "$WORK_DIR"
    mkdir "$WORK_DIR"
    unzip -q "$ZIP_FILE" -d "$WORK_DIR"
    PROJECT_DIR=$(find "$WORK_DIR" -type f -name "main.c" -exec dirname {} \; | head -n 1)
    if [ -z "$PROJECT_DIR" ]; then
        echo "Error: No main.c found inside the archive."
        rm -rf "$WORK_DIR"
        exit 1
    fi
fi

cd "$PROJECT_DIR" || exit 1

# --- Functions ---
add_note() {
    note=$(echo "$note + $1" | bc)
}

apply_malus() {
    malus=$(echo "$malus + $1" | bc)
}

add_detail() {
    details+=("$1")
}

# --- Security check on Makefile ---
if [ ! -f Makefile ]; then
    echo "Error: No Makefile found."
    exit 1
fi

echo "Performing security check on Makefile..."

# Check for dangerous commands except standard 'rm -f <file>'
if grep -E 'rm[[:space:]]+-rf|rm[[:space:]]+-fr|wget|curl|nc|bash|python|chmod|chown|mkfs|shutdown|reboot' Makefile > /dev/null; then
    echo "Security Alert: Dangerous commands detected in Makefile!"
    echo "Forbidden content detected."
    grep -E 'rm[[:space:]]+-rf|rm[[:space:]]+-fr|wget|curl|nc|bash|python|chmod|chown|mkfs|shutdown|reboot' Makefile
    exit 1
fi

echo "Makefile security check passed."

# --- Clean previous executable if exists ---
rm -f "$EXECUTABLE"

# --- Compilation ---
make
if [ ! -f "$EXECUTABLE" ]; then
    note=0
    echo "Compilation failed. Score: 0."
    add_detail "## Compilation\nFailed (0 points)"
else
    echo "Compilation succeeded (+2 points)."
    add_note 2
    add_detail "## Compilation\nSucceeded (+2 points)"

    # --- Functional tests ---
    result=$(./$EXECUTABLE 5)
    if [ "$result" = "120" ]; then
        echo "Factorial of 5 OK (+5 points)."
        add_note 5
        add_detail "Factorial of 5 OK (+5 points)"
    fi

    result0=$(./$EXECUTABLE 0)
    if [ "$result0" = "1" ]; then
        echo "Factorial of 0 OK (+3 points)."
        add_note 3
        add_detail "Factorial of 0 OK (+3 points)"
    fi

    no_arg=$(./$EXECUTABLE 2>&1)
    if [ "$no_arg" = "Erreur: Mauvais nombre de parametres" ]; then
        echo "Handling of missing parameters OK (+4 points)."
        add_note 4
        add_detail "Handling of missing parameters OK (+4 points)"
    fi

    neg_arg=$(./$EXECUTABLE -5 2>&1)
    if [ "$neg_arg" = "Erreur: nombre negatif" ]; then
        echo "Handling of negative numbers OK (+4 points)."
        add_note 4
        add_detail "Handling of negative numbers OK (+4 points)"
    fi

    # --- Check for correct function signature ---
    if grep -q "int factorielle( int number )" main.c; then
        echo "Correct function signature found (+2 points)."
        add_note 2
        add_detail "Correct function signature (+2 points)"
    fi

    # --- Style checks ---
    if grep -q '.\{81,\}' main.c header.h 2>/dev/null; then
        echo "Line longer than 80 characters found (-2 points)."
        apply_malus 2
        add_detail "Line longer than 80 characters (-2 points)"
    fi

    if grep -P '^( {1}| {3,}|\t)' main.c header.h 2>/dev/null; then
        echo "Bad indentation found (-2 points)."
        apply_malus 2
        add_detail "Bad indentation (-2 points)"
    fi

    if [ ! -f header.h ]; then
        echo "Missing header.h file (-2 points)."
        apply_malus 2
        add_detail "Missing header.h file (-2 points)"
    fi

    make clean
    if [ -f "$EXECUTABLE" ]; then
        echo "make clean did not remove executable (-2 points)."
        apply_malus 2
        add_detail "make clean did not remove executable (-2 points)"
    fi
fi

# --- Final score calculation ---
note=$(echo "$note - $malus" | bc)
if (( $(echo "$note < 0" | bc -l) )); then
    note=0
fi

echo "Final Score: $note/20."
add_detail "## Final Score\n**$note/20**"

# --- Extract student's name ---
if [ -f readme.txt ]; then
    nom=$(awk '{print $1}' readme.txt)
    prenom=$(awk '{print $2}' readme.txt)
fi

# --- Return to script folder ---
cd "$SCRIPT_DIR" || exit 1

# --- Define output filenames ---
CSV_FILE="note.${nom}.csv"
ERROR_FILE="error.${nom}.md"

# --- Write CSV file ---
echo "Name,First Name,Score" > "$CSV_FILE"
echo "'$nom','$prenom',$note" >> "$CSV_FILE"

# --- Write Markdown report ---
{
    echo "# Correction Report"
    echo ""
    for line in "${details[@]}"; do
        echo -e "$line"
        echo ""
    done
} > "$ERROR_FILE"

# --- Cleanup ---
if $USE_ZIP; then
    rm -rf "$WORK_DIR"
fi

exit 0
