#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <log_dir> <days>"
  exit 1
fi

LOG_DIR="$1"
DAYS="$2"

if [ ! -d "$LOG_DIR" ]; then
  echo "Directory does not exist: $LOG_DIR"
  exit 1
fi

mapfile -t FILES < <(
  find "$LOG_DIR" -type f -name "*.log" -mtime +"$DAYS" -print
)

if [ "${#FILES[@]}" -eq 0 ]; then
  echo "No log files older than $DAYS days"
  exit 0
fi

echo "Files to delete:"
for f in "${FILES[@]}"; do
  echo "  $f"
done

read -r -p "Delete these files? (y/n): " ANSWER
if [ "$ANSWER" = "y" ]; then
  rm -f "${FILES[@]}"
  echo "Files deleted"
else
  echo "Cancelled"
fi
