# Codex CLI calls

Model and effort come from `~/.codex/config.toml`. Always pass `-o <file>`: read only the final message into the Claude context, not the whole stream. Run in the background with stdin closed (`< /dev/null`).

## Read only (research, plan, review, diagnosis, repo scouting)

```bash
codex exec -s read-only --skip-git-repo-check -C <dir> -o <scratchpad>/codex-<topic>.md \
  "<brief: goal, context, numbered questions, format, word limit>.
Do not modify files." < /dev/null
```

## Diff review (second opinion)

Run inside the repo (`exec review` has no `-C`). Scope: `--uncommitted`, `--base <branch>` or `--commit <sha>`.

```bash
cd <repo> && codex exec review --uncommitted -o <scratchpad>/codex-review.md \
  "Look for bugs, regressions, security issues. Format: 'file:line, severity, what, why'.
No praise. Max 300 words." < /dev/null
```

## Implementation (writes to the repo)

```bash
codex exec -s workspace-write -C <repo> -o <scratchpad>/codex-impl.md \
  "<brief from the SKILL.md template>. Do not commit. At the end: status DONE/BLOCKED,
changed files, test result, max 150 words." < /dev/null
```

Afterwards: `git diff --stat`, read the diff yourself, run the tests, only then commit.
To continue the same work: `codex exec resume --last "<review fixes>"` (cheaper than a new brief).
