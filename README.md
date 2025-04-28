# Mark.sh

Automated correction script for C projects (Factorial program) - 2025

---

## 📚 Project description

This Bash script (`mark.sh`) automatically analyzes, compiles, tests, and grades C projects designed to compute factorials.  
It provides a CSV summary of the score and a detailed Markdown correction report.

Created to simplify and accelerate the correction process for multiple student projects.

---

## ⚙️ How it works

- If a `projet/` folder is found, it is used automatically.
- If not, the script searches for a `.zip` file to extract and correct.
- Generates two output files:
  - `note.<StudentName>.csv`
  - `error.<StudentName>.md`

---

## 📦 Expected project structure

Each C project must contain:
- `main.c`
- `header.h`
- `Makefile`
- `readme.txt` (with the student's first and last name)

---

## 🛡️ Security checks

Before compilation, the script analyzes the Makefile to detect any dangerous commands.  
If unsafe operations like `rm -rf`, `wget`, `curl`, `bash`, `python`, etc. are found, the project is rejected.

---

## 🛠️ Requirements

- Bash (5+)
- unzip
- gcc (GNU Compiler)
- make (GNU Make)

---

## 👤 Author

- [rattus-digitalis](https://github.com/rattus-digitalis)

---
