#!/bin/bash
# Optional Claude Code PostToolUse hook (matcher: Write|Edit|MultiEdit).
# After the agent writes a file meant for pasting, copy its content to the macOS clipboard.
# Only files explicitly marked for pasting are copied:
#   - anything in ~/clipboard/ (override with CLIPBOARD_DIR)
#   - files with a .copy. segment in the name (e.g. offer.copy.txt, mail.copy.md)
# Code, config and other project files never touch the clipboard.

dir="${CLIPBOARD_DIR:-$HOME/clipboard}"
input=$(cat)

f=$(echo "$input" | jq -r '.tool_response.filePath // .tool_input.file_path // empty')
[[ -n "$f" && -f "$f" ]] || exit 0

case "$f" in
  "$dir"/*|*.copy.*) ;;
  *) exit 0 ;;
esac

# Skip files over 1 MB
size=$(wc -c < "$f" | tr -d ' ')
[[ "$size" -le 1048576 ]] || exit 0

pbcopy < "$f" 2>/dev/null || exit 0

lines=$(wc -l < "$f" | tr -d ' ')
printf '{"systemMessage":"Copied to clipboard: %s (%s lines, %s B)."}\n' "$(basename "$f")" "$lines" "$size"
exit 0
