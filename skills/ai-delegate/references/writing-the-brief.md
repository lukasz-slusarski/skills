# Writing the brief

A brief is the entire task as the executor will see it. It runs in a separate session with **no memory
of your conversation, no access to prior notes, and no shared context**: only the text you send and
whatever it can inspect in the workspace. If a constraint is not in the brief or discoverable in the
repo, it does not exist for the executor.

The worker rules (`scripts/worker-rules.md`) are attached automatically by the wrappers: red, green,
gates, step economy, no commits, fixed report format. The brief does not repeat them.

## Resumed sessions

A resumed run keeps the session context. Send only the delta brief (what is still wrong), with
`--resume-last` or `--resume <id>` (`--session <id>` for the Kimi relay).

## The shape that works

Use a compact, block-structured brief. State the task, what done means, the few constraints that
matter, and the report the executor must return.

```xml
<task>
One or two sentences: the concrete job and where it lives. Then the specifics: current state, what to
change, and explicitly what to leave untouched. The leave-untouched list prevents unrelated refactors.
</task>

<verification_loop>
Run these before finishing and fix anything they surface, do not just report it:
  <the project's real test command>
  <the project's real lint/format command>
  <the project's real build/typecheck command>
Confirm the working tree shows only the intended changes afterward.
</verification_loop>

<action_safety>
Keep changes scoped to the task. No unrelated refactors, renames, or cleanup unless required for
correctness. Do NOT run git add or git commit; the orchestrator commits after reviewing. Leave the
work uncommitted in the working tree.
</action_safety>

<structured_output_contract>
End with a report in this exact shape:
  1. What changed and why
  2. Files touched
  3. Gate outcomes (include test/lint counts)
  4. Anything you deviated on, left open, or want a decision on
</structured_output_contract>
```

Add extra blocks only when the task needs them:

- **Debugging or open-ended fixes**: add `<completeness_contract>` (resolve fully, not just the first
  plausible cause) and `<missing_context_gating>` (find missing repo facts or state what is unknown).
- **Research or recommendations**: add `<research_mode>` (separate observed facts, inferences, and
  open questions).

## You search, the executor writes

Every step the executor takes (read, grep, command) spends quota. Put paths, line ranges, pasted code
and the exact gate commands in the brief. Broad tasks ("review everything", "find and fix") you do
yourself or split into concrete points. For cheap exploration use `--mode scout` (GLM, Agy) and paste
its answer into the brief after opening the cited lines yourself.

## Always ask for the report explicitly

Without a closing summary the edits may exist but the result is hard to review. The
`<structured_output_contract>` block makes the expected report explicit.

## Discover the real gates

Read the repo's `AGENTS.md`, `CLAUDE.md`, `Makefile`, `package.json`, or equivalent first and copy the
actual commands into `<verification_loop>`. A brief that says only "run the tests" makes the
implementer guess or skip them.

## Honor repo conventions

Restate the load-bearing house rules in the brief. The executor can inspect the workspace, but the
important constraints should be directly in front of it.

## One task per brief

Keep each brief bounded (1 to 3 files). One brief, one run, one reviewed commit keeps the diff and
rollback clean. Split mixed implementation, review, documentation, and roadmap requests into separate
dispatches.

## Premises freeze at dispatch

The implementer starts from the brief's facts and there is no steering channel mid-run. Audit the
fact block before sending: ownership, target branch, constraints, anything a judgment call rests
on. If a premise turns out wrong while the run is live, stop the run and re-dispatch a corrected
brief rather than discounting the output afterward; for a write-capable run, inspect the working
tree and reconcile any partial or premise-contaminated edits (keep or revert them) before the
re-dispatch.

## A worked example

```xml
<task>
In the payments service at services/billing/, the refund path double-charges when a refund is retried
after a network timeout. Make refund submission idempotent: check for an existing refund by idempotency
key before creating a new one. Touch only services/billing/refund.py and its tests. Leave the charge
path, API routes, and data models untouched.
</task>

<verification_loop>
Run and make green before finishing:
  pytest tests/billing/ -q
  ruff check services/billing/
Confirm git status shows only refund.py and its test file changed.
</verification_loop>

<action_safety>
Scope strictly to the refund idempotency fix. No unrelated refactors. Do NOT git add or commit; leave
changes in the working tree for review.
</action_safety>

<structured_output_contract>
Report: (1) the root cause and fix, (2) files touched, (3) pytest and ruff outcomes with counts,
(4) anything left open or needing a decision.
</structured_output_contract>
```

## Secrets and size

Kimi and Agy receive the brief as a command-line argument, so it is visible in the host process list.
Keep secrets out of briefs; reference workspace files or environment variables instead. The Kimi relay
rejects briefs over 120 KB (OS argument limit): put large context in the workspace and tell the
executor which file to read. GLM reads the brief from stdin.

Dispatch with [dispatch-and-poll.md](dispatch-and-poll.md), then review and commit with
[review-and-land.md](review-and-land.md).
