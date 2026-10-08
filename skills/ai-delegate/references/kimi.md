# Kimi Code CLI

Executor: the Kimi Code CLI in headless mode, driven by `scripts/relay.mjs` and dispatched with
`scripts/kimi-run`. The loop, brief and review are the shared ones from `SKILL.md`.

`relay.mjs` and the relay-related parts of this file derive from
[amElnagdy/delegate-skills](https://github.com/amElnagdy/delegate-skills) (MIT); see
`THIRD_PARTY_NOTICES.md`. `relay.mjs` makes no network calls and has no dependencies; it shells out
only to `kimi` and `git`. Read it before you run it.

## Setup

- Install: `brew install kimi-code` (macOS/Linux) or a native installer from the
  [Kimi Code documentation](https://moonshotai.github.io/kimi-code/en/). Verify with `kimi --version`.
  Needs `node`, `jq`, `python3` too.
- Login: `kimi login --region global` (kimi.ai; kimi.com is the Chinese edition). It uses a device-code
  flow without opening the TUI. When the token expires the human types `! kimi login --region global`.
- `kimi-limit` reads the token that `kimi login` stored under `$KIMI_HOME/credentials` (default
  `~/.kimi-code`) and uses it only for the quota request.
- Worker rules: the headless run does not take a system-prompt file, so keep a copy of
  `scripts/worker-rules.md` where Kimi picks up project or user rules (an `AGENTS.md`, see Kimi's
  documentation for the exact location). Without it Kimi works without the red/green/gates loop, so
  put those requirements into the brief.
- Config worth setting (author's example, check Kimi's documentation for key names): a step ceiling of
  30, 3 attempts per step, the sub-agent tool disabled, thinking on high, and your other agents' skills
  kept out of Kimi's prompt.

## Budget: steps, not tasks

Example plan (Kimi Plus): **100 requests per 5 h**, and every Kimi step (read, grep, command) is a
request. A small, well-described task costs 3 to 4 requests; a whole-repo review ate 94. Hence:

- **You search, Kimi writes.** The brief gives paths, line ranges, pasted code and the exact gate
  commands. Broad tasks ("do a review", "find and fix") you do yourself or split.
- **One small task per brief** (1 to 3 files). Split a batch of fixes into separate dispatches.
- Current state: `scripts/kimi-limit`. Cost of earlier tasks: `tail $AI_DELEGATE_HOME/kimi-cost-log.jsonl`
  (the `requests` field is reliable; the monthly counter can lag).

## Dispatch

```bash
kimi-run --brief brief.txt --cd /repo --timeout 20m
kimi-run --brief delta.txt --cd /repo --resume-last     # correction in the same session
```

`kimi-run` refuses to send below 30 requests left (`KIMI_MIN`, exit 4), forces the model
`kimi-code/kimi-for-coding` unless you pass `--model`, and appends the cost to the log. When it
refuses, give the human the remaining count and the reset time and propose another executor. Other
flags are `relay.mjs` flags (below); call them through `kimi-run`, not `node relay.mjs`, otherwise the
threshold and measurement vanish.

Headless Kimi always runs in auto permission mode and has no read-only mode, so the diff is the record
of what changed. There are no `scout` or `tests` modes for Kimi; use GLM or Agy for those.

## Models

`kimi-code/kimi-for-coding` for everyday work. `kimi-code/k3-256k` only for a hard task, after asking
the human. `highspeed` (about 3x the price) and `k3` (1M context, about 2x k3-256k) not worth it.
Pass `--model <alias from your kimi config>` only when the human wants a configured alias; do not
invent one.

## Relay flags

| Flag | Effect |
| --- | --- |
| `--brief <file>` | Brief path. Omit it to read the brief from stdin. |
| `--cd <dir>` | Working root and child process cwd (default: current directory). |
| `--model <alias>` | Kimi model alias (default: Kimi's own `default_model`; `kimi-run` sets one). |
| `--session <id>` | Resume a specific Kimi session; send only the delta brief. |
| `--resume-last` | Resume the most recent Kimi session for this cwd (`kimi --continue`). |
| `--add-dir <dir>` | Extra workspace directory. Repeatable. Edits there are not reported in `touchedFiles`. |
| `--timeout <dur>` | Relay watchdog (default `30m`; h/m/s strings). Kimi has no timeout flag. |
| `--out-dir <dir>` | Artifact directory (default: a fresh directory under the system temp dir). |
| `--lane <name>` | Optional fleet lane; requires the separate `delegate-setup` skill from the upstream project. Ignore otherwise. |

`--session` and `--resume-last` are mutually exclusive. The relay passes the brief as
`--prompt=<brief>` on the command line: it is visible in the process list, and briefs over 120 KB are
rejected before launch (OS argument cap). Put large context in the workspace.

The relay runs the equivalent of:

```bash
kimi --output-format stream-json [--model <alias>] [--session <id> | --continue] \
  [--add-dir <dir> ...] --prompt=<brief>
```

## Artifacts and result fields

Artifacts live outside the repo by default: `brief.txt`, `events.jsonl` (raw stdout events),
`final.txt`, `stderr.txt`, and `result.json` (schema `delegate-relay.result.v1`).

`result.json` fields: `status` (`completed` | `failed` | `timeout` | `aborted` | `kimi_unavailable`),
`exitCode`, `signal`, `workdir`, `model`, `resumed`, `kimiVersion`, `sessionId`, timestamps, artifact
paths, `finalMessage` (assistant text, tool calls excluded), `touchedFiles` (`git status --porcelain` of
the final tree under `--cd`; anything already dirty before dispatch shows up too, so dispatch from a clean
tree; `null` = git could not report, `[]` = clean), `stderrTail` (last 20 lines on a non-completed run),
`error` (launch failure, watchdog, abort). Kimi's stream has no token usage.

Exit codes: usage error 2 (no result written), `kimi` missing 127 (`kimi_unavailable`), otherwise
Kimi's own code; a signal gives 128 plus the signal number.

## When a run misbehaves

- **`kimi_unavailable` (127):** install Kimi Code, `kimi login`, re-dispatch.
- **`error` mentioning `version preflight`:** `kimi --version` failed or hung (10 s cap), so nothing
  was dispatched. Run `kimi --version` yourself.
- **`failed`:** read `stderrTail`, `stderrPath`, the tail of `events.jsonl`. A common cause is an
  unconfigured model alias (`config.invalid: Model "<x>" is not configured`).
- **`aborted`:** the relay itself was killed (parent timeout, closed terminal) and forwarded the kill
  to Kimi. Inspect the working tree before re-dispatching.
- **`failed` with `signal: "SIGKILL"`:** the host killed it (OOM killer, supervisor); check memory,
  re-dispatch or split the task.
- **`timeout`:** the watchdog fired (SIGTERM, 10 s grace, SIGKILL). Raise `--timeout` or split.
- **Empty `finalMessage`:** inspect `touchedFiles` and the diff; add a `<structured_output_contract>`.
- **Lost work:** `events.jsonl` records what the run did; use it to scope redoing, but trust a
  working-tree diff over any reconstruction.

## Review and land

As in the shared loop: [review-and-land.md](review-and-land.md). A report of `blocked` caused by the
step ceiling, or a new test that is green without a source change, calls for a delta brief with
`--resume-last` that says only what is left.
