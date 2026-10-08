---
name: mac-clipboard
description: Put text the agent wrote (an email, post, message, snippet) straight into the macOS clipboard, ready for Cmd+V, with clean formatting instead of terminal copy-paste. Use only when the user explicitly asks, e.g. "copy to clipboard", "to clipboard", "give me something to paste", "I want to paste this", "/mac-clipboard".
license: MIT
metadata:
  author: Łukasz Ślusarski
  version: "0.1.0"
---

# Mac Clipboard

Copying from a terminal breaks line wrapping and formatting, so the user asks the agent to put the text into the clipboard instead. The user presses Cmd+V wherever they need it.

## Only on request

The clipboard holds one entry, so every copy overwrites what the user had there. Copy only when the user names the clipboard or pasting: "copy to clipboard", "to clipboard", "give me something to paste", "I want to paste this", `/mac-clipboard`, or the same in their language.

"Save" means a file, not the clipboard: "save it", "save and send", "save to a file" go to a drafts folder or the project. When unsure, save a file and say where it is in one sentence.

## Steps

1. **Pick the content.**
   - No argument: the last longer piece of text you produced in this conversation.
   - With a description ("copy that email"): that piece.
   - Several candidates and no clear choice: ask in one sentence. A wrong copy overwrites the right one.
2. **Write it to a file**, then copy the file. Writing first keeps a copy on disk and avoids shell quoting problems:
   ```bash
   mkdir -p ~/clipboard
   # write the text to ~/clipboard/<descriptive-name>.txt with the Write tool, then:
   pbcopy < ~/clipboard/<descriptive-name>.txt
   ```
   Name: descriptive kebab-case, `.txt` or `.md`, e.g. `email-supplier-questions.txt`, `linkedin-post-hooks.txt`.
3. **Confirm in one sentence**: what is in the clipboard and how long it is. Do not repeat the text; the user has just read it.

## Formatting

- Format for the destination, not the terminal: plain text without Markdown symbols, unless the destination renders Markdown (a blog editor, GitHub).
- Keep the user's language and its diacritics. Strip them only when the destination breaks them, and say so.

## Several pieces in a row

The clipboard holds one entry. When the user has to paste several things in order:

- Save each as its own file in `~/clipboard/`.
- Copy the first one and list the order.
- When the user asks for the next one, run `pbcopy < <next file>`.

## When pasting gives something else

Check `pbpaste | head` to see what the system clipboard holds and tell the user. Usual causes: tmux (use `reattach-to-user-namespace pbcopy` on old setups) or an SSH session (`pbcopy` runs on the remote machine; use an OSC 52 escape sequence instead). `pbcopy` exists only on macOS; on Linux use `wl-copy` or `xclip -selection clipboard`.

## Optional: automatic copy hook (Claude Code)

[scripts/copy-to-clipboard.sh](scripts/copy-to-clipboard.sh) copies a file to the clipboard right after the agent writes it, so step 2 needs only the Write tool. It reacts only to files in `~/clipboard/` (or `$CLIPBOARD_DIR`) and files with `.copy.` in the name, up to 1 MB. It needs `jq`. Register it in `~/.claude/settings.json`:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit|MultiEdit",
        "hooks": [{ "type": "command", "command": "~/.claude/skills/mac-clipboard/scripts/copy-to-clipboard.sh" }]
      }
    ]
  }
}
```

Adjust the path to where the skill is installed. With the hook active, write the file with Write or Edit; shell commands such as `cp` or `mv` do not trigger it.
