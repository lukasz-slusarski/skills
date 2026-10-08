---
name: ai-routing
description: >
  Decide who does the work (Claude subagent on Sonnet or Haiku, Codex, Antigravity/Gemini, GLM, Kimi)
  to save Claude usage limits at the same quality. Load before research, repo scouting, planning,
  review, code implementation, test runs with long logs, and when the user says "delegate",
  "hand it off", "let Codex/GLM/Kimi do it".
license: MIT
metadata:
  author: Łukasz Ślusarski
  version: "0.1.0"
---

# AI Routing: who does the work

Goal: spend the least Claude limit at the same quality. The main model (e.g. Opus) thinks, decides and checks; reading, searching, writing code and long logs go to cheaper executors. Delegation costs a brief and reading the result, so it pays off only for work with a lot of noise (files, logs, search results).

## Step 0: do it yourself when

- the change is smaller than the brief (typo, one line, config), or the file is already in context;
- the task needs this conversation's history (the user's decisions) and it cannot be summed up in 5 sentences;
- architecture, security, production migrations: the main model decides (a cheaper model may still write the code);
- the user says "do it yourself", "no routing".

## Step 1: check limits (once per session, or when an executor refuses)

Pick the executor with the **most free weekly limit** among those that fit the task. Skip an executor below 15% of its week. All external executors at their limit: use a Sonnet subagent.

`ai-limits` from the [ai-delegate](../ai-delegate/SKILL.md) skill prints the limits of Codex, Antigravity, GLM and Kimi in one table.

## Step 2: who does what

| Work | First choice | Fallback | How |
|---|---|---|---|
| Internet, facts, documentation | Antigravity (Gemini) or a research subagent | Codex read-only, then WebSearch | brief + word limit |
| Collecting info from many files or tools | subagent with `model: "haiku"` | subagent with `model: "sonnet"` | brief + word limit |
| Repo scouting: where, which lines, which gates | Codex `-s read-only` | GLM scout mode, Haiku subagent | [references/codex.md](references/codex.md) |
| Plan, architecture: second opinion | Codex `-s read-only` | Antigravity in plan mode (Gemini) | main model synthesizes |
| Implementation of 1 to 3 files from a brief | Codex `-s workspace-write` | GLM, Kimi, Antigravity | [ai-delegate](../ai-delegate/SKILL.md) or references/codex.md |
| Many independent coding tasks | split between Codex, GLM, Kimi, Antigravity | Sonnet subagents in worktrees | each on different files |
| Tests, gates, long logs | GLM tests mode | Codex read-only, Haiku subagent | return: failures only |
| Diff review: second opinion | Codex `exec review` | Antigravity (Gemini) | the main model always reads the diff too |
| UI check on more than 2 screenshots | subagent with `model: "sonnet"` takes and views them | | return: verdict + list of defects, no images |
| Client-facing text, emails, actions in external tools | this Claude session | | no external delegation |

**Large files and screenshots in the main session are the biggest cost you can hand off.** For a file over about 400 lines: `Grep` for the function name first, then `Read` with `offset`/`limit`. When you do not know where to look, a scout (Codex read-only or a Haiku subagent) returns paths and line numbers, not content.

**Client data and secrets** do not go to Codex, Gemini, GLM or Kimi: only to Claude subagents. Repository code is fine; key files, passwords, CRM exports and emails are not.

## Step 3: the brief (every executor, subagents too)

The executor does not see this conversation. The brief must be self-contained and short:

```
GOAL: one sentence, what must be true when done.
CONTEXT: repo/dir, stack, what we already know and checked (max 5 sentences, paths instead of pasted content).
SCOPE: files to change; what NOT to touch.
DONE WHEN: test command or a checkable criterion.
RETURN: status DONE / BLOCKED / NEEDS_CONTEXT, changed files, test result, max 150 words.
        Details go to <scratchpad>/<topic>.md; the answer gives only the path.
LIMITS: no commits, no actions outside the repo, no browser.
```

The word limit on the return is mandatory: you pay for every word of the result on every later turn.

## Step 4: Claude subagents

- Always set `model` explicitly: `haiku` for reading and collecting, `sonnet` for code and analysis, `opus` only when the user asks.
- A fork inherits the whole conversation and runs on the main model: use it only when the task truly needs the history. When a brief can describe it, use a regular agent with `model: "sonnet"`.
- Run in parallel only independent tasks (different files, or read only), in one message.
- After the work, check that the agent left no background commands running.

## Step 5: taking the result

1. Read only the result file (`-o`, the report), not the executor's stream.
2. Code: `git diff --stat`, read the diff, run the tests yourself. The executor's claims are not proof.
3. Fixes: continue the same executor session (`codex exec resume --last`, `--resume-last` in ai-delegate scripts) instead of writing a new brief.
4. Two failed rounds: switch to a stronger executor (GLM/Kimi, then Codex, then a Sonnet subagent), never a third round on the same one.
5. You commit. Tell the user in one sentence what you handed to whom.

## Tools

| Executor | Call | Details |
|---|---|---|
| Codex (ChatGPT plan) | `codex exec -s read-only\|workspace-write -o file` | [references/codex.md](references/codex.md) |
| Antigravity (Gemini, Claude) | `agy-run` | [ai-delegate](../ai-delegate/SKILL.md) |
| GLM (Z.ai Coding Plan) | `glm-run --mode impl\|scout\|tests` | [ai-delegate](../ai-delegate/SKILL.md) |
| Kimi Code | `kimi-run` | [ai-delegate](../ai-delegate/SKILL.md) |

Calling an external CLI needs no confirmation from the user; say in one sentence what you handed to whom.
