# mark.sh

Script to automatically correct simple C projects (factorial calculator).

## How it works

- Use the `projet/` folder if it exists.
- Otherwise, unzip a `.zip` file and correct it.
- Compiles, tests, checks style, and generates:
  - A CSV file with the score
  - A Markdown report with details

## Usage

```bash
./mark.sh
