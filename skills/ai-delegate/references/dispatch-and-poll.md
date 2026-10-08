# Dispatch and poll

Every executor has a wrapper in `scripts/` with the same shape: `--brief <file> --cd <repo>`, a
quota check before sending, a quota measurement after, and one line appended to a cost log. Always
dispatch through the wrapper, never through the raw CLI (or `node relay.mjs` for Kimi), otherwise the
threshold and the measurement disappear.

| Wrapper | Executor | Details |
| --- | --- | --- |
| `scripts/glm-run` | GLM via Z.ai Coding Plan | [glm.md](glm.md) |
| `scripts/agy-run` | Antigravity `agy` | [agy.md](agy.md) |
| `scripts/kimi-run` | Kimi Code CLI via `relay.mjs` | [kimi.md](kimi.md) |

`<skill-dir>` below means the folder that contains this skill's `SKILL.md`; call `<skill-dir>/scripts/...`
or put `scripts/` on your `PATH`.

## Dispatch in the background

A wrapper blocks until the executor finishes (often 1 to 10 minutes). Run it with your harness's
background-command facility (in Claude Code: `Bash` with `run_in_background: true`) so you are
notified on exit instead of polling. Without a background facility, run it in a shell with `&` and
redirect the output to a file.

```bash
<skill-dir>/scripts/glm-run --brief brief.txt --cd /repo
```

The run is done only when the process exits. The wrapper's stdout then holds the executor's report,
the touched files (`git status --porcelain`), a `result:` line with the path of the raw `result.json`
and the session id, and a final cost line.

## Common flags

| Flag | Effect |
| --- | --- |
| `--brief <file>` | Brief path (required for GLM and Agy; Kimi's relay can also read stdin). |
| `--cd <dir>` | Repo to work in (default: current directory). |
| `--model <name>` | Executor model. Defaults are in each reference. |
| `--timeout <seconds>` | GLM and Agy: alarm timeout, default 1800 (Kimi: `--timeout 20m` style duration). |
| `--mode impl\|scout\|tests` | GLM and Agy only. `impl` writes code; `scout` answers a question read-only; `tests` runs gates and reports. |
| `--resume-last` / `--resume <id>` | Send a delta brief into an earlier session (Kimi: `--resume-last` / `--session <id>`). |

## Wrapper exit codes

| Code | Meaning |
| --- | --- |
| 0 | Executor finished (still review it). |
| 1 | Agy reported an error (for example an unknown model); read the message. |
| 2 | Usage error (missing brief, unknown flag or mode, no session to resume). |
| 3 | Quota unreadable: GLM key missing, Agy or Kimi logged out. |
| 4 | Quota below the safety threshold, nothing was sent. Tell the human the state and propose another executor. |
| 5 | A `scout` or `tests` run changed the working tree. Inspect `git status` and the diff. |
| 124 / 127 | Kimi relay only: version preflight timeout / `kimi` not installed. |
| 142 | Timeout (alarm). The tree may be half-modified; inspect before doing anything. |

## Where things are written

- Cost logs: `$AI_DELEGATE_HOME` (default `~/.config/ai-delegate`): `glm-cost-log.jsonl`,
  `agy-cost-log.jsonl`, `kimi-cost-log.jsonl`. `--resume-last` for GLM and Agy takes the session id of
  the last log line, so do not interleave unrelated runs of the same executor between a task and its
  rework.
- Raw output: a temp directory printed in the `result:` line (`result.json`, `stderr.txt`; Kimi also
  `events.jsonl`, `brief.txt`, `final.txt`).
- Report: `scripts/delegation-report` summarises the logs per day, executor and mode.

## Reading the result

Process state and the working tree are the source of truth. Take the report as a set of claims.
Then go to [review-and-land.md](review-and-land.md).

## When a run misbehaves

- **Empty report:** inspect the touched files and the diff, then read `stderr.txt`. Add a
  `<structured_output_contract>` to the next brief.
- **Exit 142 / timeout:** increase `--timeout` or split the task. Inspect the tree first; do not reset it.
- **The host killed the process (SIGKILL, OOM):** not an executor error; check memory, re-dispatch or
  split the task.
- **Executor exited, tree looks messy:** treat it as evidence. See the commit boundary section of
  review-and-land.md.

## Recovering lost work

The raw event or result files in the run directory record what the executor did. If finished work is
lost (the run killed late, or the tree damaged afterwards), read them before re-dispatching: they show
which files and commands were involved and so scope what needs redoing. Treat any reconstruction as
unverified until it matches a working-tree diff. When the tree still holds the work, preserve the tree
rather than replaying a log.

## The commit boundary

No wrapper ever commits. The executor edits the working tree; the orchestrator reviews, re-runs the
gates, and commits. See [review-and-land.md](review-and-land.md).
