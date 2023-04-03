#!/usr/bin/env bash

# Get the root directory of the current git project
ROOT_DIR=$(git rev-parse --show-toplevel)

# Check if the root directory exists
if [ ! -d "$ROOT_DIR" ]; then
  echo "Error: Not inside a git repository"
  exit 1
fi

awk '
BEGIN { count = 0 }
/^(\[\[[-_a-zA-Z0-9]+\]\])+$/ {
    gsub(/[\[\]]/, "", $0)
    split($0, ids, " ")
    for (i in ids) {
        if (ids[i] == "") {
            continue
        }
        if (!match(ids[i], /^[-_a-zA-Z0-9]+$/)) {
            print "Invalid ID format: " ids[i]
            exit 1
        }
        file_path = "'$ROOT_DIR'/" ids[i] ".adoc"
        if (!system("[ -f \"" file_path "\" ]")) {
            continue
        }
        print "File not found: " file_path
        exit 1
    }
}' "$1"
