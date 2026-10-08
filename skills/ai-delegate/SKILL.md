---
name: ai-delegate
description: >-
  Delegate a bounded coding task to an external CLI agent (Antigravity agy, GLM via Z.ai Coding Plan,
  Kimi Code CLI) as a background implementer, then review its diff and land it yourself. Use when the
  user says "delegate to GLM", "delegate to Kimi", "run it through agy", "let Gemini implement this",
  "save Claude limits", "use my Antigravity/GLM/Kimi quota", or wants a queue of coding tasks run
  through a cheaper model while you stay the reviewer. Also covers read-only scouting and test-running
  by GLM or agy to keep raw files and logs out of your context. Skip for tasks small enough to do inline.
license: MIT
metadata:
  author: "Łukasz Ślusarski"
  version: "0.1.0"
---

# AI Delegate

You are the **orchestrator**: you write the brief, an external CLI agent (the **executor**) writes the
code in its own session, you verify and commit. Report the executor's result to the user in the
user's language, as claims you checked, not as facts.

Three executors share one loop and one set of worker rules. The user needs only one of them.

| Executor | Wrapper | Setup and details |
|---|---|---|
| GLM (Z.ai Coding Plan, via headless Claude Code) | `scripts/glm-run` | [references/glm.md](references/glm.md) |
| Antigravity `agy` (Google AI plan: Claude, Gemini) | `scripts/agy-run` | [references/agy.md](references/agy.md) |
| Kimi Code CLI | `scripts/kimi-run` | [references/kimi.md](references/kimi.md) |

Which one for which task: [references/choosing-an-executor.md](references/choosing-an-executor.md).
`<skill-dir>` below is the folder that contains this file; call `<skill-dir>/scripts/<wrapper>` or put
`scripts/` on `PATH`.

## First use

1. Pick the executor(s) the user has a subscription for and read its reference: install, login, and for
   GLM the `GLM_API_KEY` environment variable. Never print or paste a key.
2. Requirements for the scripts: `bash`, `jq`, `git`, `perl`, `python3`; `node` for Kimi.
3. Check what is left: `scripts/ai-limits` (all executors) or `scripts/<name>-limit` (one). These calls
   spend no tokens.
4. Setup is done once; revisit it only when a run fails with exit 3 (quota unreadable, usually a
   missing key or a logged-out CLI). Login is interactive, so the user does it (in Claude Code:
   `! agy`, `! kimi login --region global`).

## The loop, per task

1. **Brief** into a file: goal, current state (paths, line ranges, pasted code), what to change, what
   not to touch, the project's real gate commands, the report shape. The executor sees only the brief
   and the repo, never this conversation. Details:
   [references/writing-the-brief.md](references/writing-the-brief.md).
2. **Dispatch in the background** through the wrapper, never through the raw CLI:

   ```bash
   <skill-dir>/scripts/glm-run  --brief brief.txt --cd /repo
   <skill-dir>/scripts/agy-run  --brief brief.txt --cd /repo
   <skill-dir>/scripts/kimi-run --brief brief.txt --cd /repo --timeout 20m
   ```

   The wrapper refuses to send when the quota is low (exit 4), runs the executor with the worker rules
   attached, and logs the cost. Flags, exit codes and polling:
   [references/dispatch-and-poll.md](references/dispatch-and-poll.md).
3. **Read the result**: the wrapper's stdout has the executor's report, touched files and a cost line.
   Process state and the working tree are the source of truth, not the report.
4. **Review with a red check.** The report is a set of claims. Re-run the gates yourself, read the
   diff against the brief, and prove the new tests bite:
   `git stash push -- <source files>`, the new tests must fail, `git stash pop`. A test that is green
   without the source change, or a report of `blocked`, means a delta brief with `--resume-last` that
   says only what is left. Checklist: [references/review-and-land.md](references/review-and-land.md).
5. **Land**: you commit, after green gates and a diff you read. The executor never commits.

## Choosing an executor and the budget rule

- Default to the executor with the largest budget that is not near its limit; see the comparison in
  [references/choosing-an-executor.md](references/choosing-an-executor.md). Run `scripts/ai-limits`
  first when more than one is available.
- **Budget rule: you search, the executor writes.** Every executor step spends quota (Kimi counts
  requests per step, GLM credits per turn, Agy a percentage of a window). Put paths, line ranges, pasted
  code and exact gate commands in the brief. Broad tasks ("review the repo", "find and fix") you do
  yourself or split. One small task (1 to 3 files) per brief.
- When a wrapper exits 4, tell the user the remaining quota and the reset time, and propose the next
  executor. Do not override the threshold without asking.
- Hard tasks that need a bigger model (Opus on Agy, Kimi k3) cost much more: ask first.

## Modes (GLM and Agy)

`--mode impl` (default) writes code. `--mode scout` answers a question about the code read-only with
`path:line` and gates, so you do not read raw files; open the cited places before building on them.
`--mode tests` runs the gates from the brief and returns only failing tests, so you do not read long
logs; a green summary suffices, a red one you verify yourself. A `scout` or `tests` run that changes
the tree exits 5. Kimi has no such modes.

Typical queue for one task: `scout` → you write the brief → `impl` → review → optional `tests` on the
full gate set.

## Queues

Several tasks: sequential, one commit each, dependency order, a progress file, a coherence check at the
end. See [references/multi-task-queues.md](references/multi-task-queues.md). Use `scripts/delegation-report`
for what a queue cost.

## Safety

- The executors run with permissions skipped (GLM, Agy) or in auto mode (Kimi), so the **diff is the only
  record** of what changed. Dispatch from a clean tree; inspect the tree before any `checkout`,
  `reset` or `clean` after an interrupted run.
- Executors work only in the working tree and are told not to commit, push, deploy or message anyone.
  Check the diff for anything outside the brief.
- The user enabling delegation ("run the queue", "go ahead") authorizes committing verified work. Report
  design decisions and unrequested changes in your summary. If correct completion needs going beyond the
  brief, ask before expanding scope. Do not push unless the user asked.
- Keys: only via environment variables (`GLM_API_KEY`). Keep secrets out of briefs; Kimi and Agy receive
  the brief as a command-line argument, visible in the process list.

## Files and environment

- `scripts/`: wrappers (`glm-run`, `agy-run`, `kimi-run`), quota readers (`glm-limit`, `agy-limit`,
  `kimi-limit`, `ai-limits`), `delegation-report`, `relay.mjs` (Kimi relay), `glm-key-helper.sh`, and the
  rule files `worker-rules.md`, `scout-rules.md`, `tests-rules.md`.
- `AI_DELEGATE_HOME` (default `~/.config/ai-delegate`): cost logs. `AI_DELEGATE_RULES_DIR` (default: the
  scripts directory): where the rule files are read from, so you can customise them.
- Thresholds: `GLM_MAX_PCT` (70), `AGY_MIN_PCT` (30), `KIMI_MIN` (30). Model default for Agy: `AGY_MODEL`.
- `relay.mjs` derives from an MIT-licensed project: see [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).
