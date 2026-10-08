# GLM (Z.ai GLM Coding Plan)

Executor: GLM models run through headless Claude Code (`claude --bare -p`) pointed at Z.ai's
Anthropic-compatible endpoint, dispatched with `scripts/glm-run`. The loop, brief and review are the
shared ones from `SKILL.md`.

## Setup

- Requirements: Claude Code (`claude`) on `PATH`, `jq`, `perl`, `git`, `python3`, and a Z.ai GLM
  Coding Plan subscription.
- API key: export it as the environment variable **`GLM_API_KEY`** in your shell profile or secret
  manager (never put it in a brief, a log, or the repo). `glm-run` and `glm-limit` read it from the
  environment only.
- `glm-run` runs `claude --bare -p` with `ANTHROPIC_BASE_URL=https://api.z.ai/api/anthropic`. The
  subscription works only on the `/api/anthropic` and `/api/coding/paas/v4` addresses; any other Z.ai
  address is billed as the paid API.
- Key delivery: `--bare` ignores `ANTHROPIC_AUTH_TOKEN` and reads only `ANTHROPIC_API_KEY` or an
  `apiKeyHelper`. `glm-run` passes `scripts/glm-key-helper.sh` as the helper; it prints `$GLM_API_KEY`
  (inherited from `glm-run`'s exported environment), so the key is not on any command line.
- `--bare` disables CLAUDE.md, hooks, plugins, MCP and memory, so GLM is a clean implementer. The
  worker rules are appended as the system prompt.

## Budget: credits

Example plan (GLM Coding Lite, Sept 2026): **2000 credits per 5 h and 10 000 per week**. A small task
costs 4 to 6 credits (glm-5.3). Peak hours were counted double against the quota at the time; check
Z.ai's current rules and run big queues off-peak.

- Current state: `scripts/glm-limit` (`--json`, `--raw`). Cost of earlier tasks:
  `tail $AI_DELEGATE_HOME/glm-cost-log.jsonl`. Daily summary of all executors: `scripts/delegation-report`.
- The Z.ai counter lags, so `glm-run` waits 30 s (`GLM_SETTLE`) before the second reading. Treat the
  `credits` field as an approximation.
- "You search, GLM writes" and "one small task per brief" apply: every turn is a request to Z.ai.

## Dispatch

```bash
glm-run --brief brief.txt --cd /repo                        # glm-5.3, timeout 1800 s
glm-run --brief delta.txt --cd /repo --resume-last          # correction in the last session
glm-run --brief delta.txt --cd /repo --resume <session_id>  # correction in a specific session
```

Run it in the background; it blocks until GLM is done. Flags: `--model glm-5.3|glm-5.3-flash` (flash
only on explicit request), `--timeout <seconds>`, `--mode impl|scout|tests`, `--resume`, `--resume-last`.

- Exit 2: usage error. Exit 3: no key (`GLM_API_KEY`) or the quota could not be read.
- Exit 4: the 5 h window is used above 70% (`GLM_MAX_PCT`). Tell the human the `glm-limit` state and
  propose another executor.
- Exit 5: `scout` or `tests` mode changed the working tree. Inspect `git status` and the diff.
- Exit 142: the timeout alarm fired. The tree may be mid-change.

## Modes: GLM reads and tests instead of you

Raw files and logs eat the most Claude context. Hand them to GLM and read only the summary.

| Mode | Purpose | Permissions | Rules |
|---|---|---|---|
| `--mode impl` (default) | writes code | everything (`--dangerously-skip-permissions`) | `worker-rules.md` |
| `--mode scout` | answers a question about code: `path:line`, excerpts, gates | Read plus Bash read commands (`rg`, `grep`, `ls`, `head`, `tail`, `wc`, `cat`, `git log/show/diff/status/grep/ls-files`), everything else denied | `scout-rules.md` |
| `--mode tests` | runs the gates from the brief, returns only failing tests | Bash, no edits; a tree change is exit 5 | `tests-rules.md` |

Typical queue for one task: `scout` (where the paths, lines and gates are) → you write the brief from
its answer → `impl` → review. After review you can run `tests` on the full gate set when the log would
be long; verify a red result yourself, a green one with the list of tests is enough.

A scout answer is a set of claims: open the places that go into the brief, in the cited line range,
before building on them. Keep the question narrow ("where is the discount computed and how does
`Cart.total` use it"), because it determines answer length.

## Output

Stdout: GLM's report (`.result`), touched files, a `result: <path>/result.json  session: <id>` line,
and the cost. Full output is in `result.json`, errors in `stderr.txt` next to it. Process state and
the working tree are the source of truth. GLM runs with `--dangerously-skip-permissions`, so the diff
is the record of what it changed.

## Review and land

As in the shared loop: [review-and-land.md](review-and-land.md).
