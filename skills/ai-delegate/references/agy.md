# Antigravity (agy)

Executor: Antigravity CLI `agy` on a Google AI plan (Claude Sonnet/Opus 5.5, Gemini, GPT-OSS),
dispatched with `scripts/agy-run`. The loop, brief and review are the shared ones from `SKILL.md`.

## Setup

- Install: `brew install --cask antigravity-cli` (see Antigravity's own docs for other platforms).
  Needs `jq`, `perl`, `git`, `python3` too.
- Login: run `agy` once in a terminal and choose Google OAuth. The plan is shared with the Antigravity
  IDE. If a run reports logout (exit 3), the human must log in again; you cannot do it for them.
- Models: `agy models` lists them; the list changes with releases. State at Oct 2026: Claude 5.5
  (`claude-sonnet-5-5-low|medium|high`, `claude-opus-5-5-low|medium|high`), Gemini
  (`gemini-3.1-pro-high|low`, `gemini-3.6/3.7/3.8-flash-*`), `gpt-oss-120b-medium`.
- `agy-run` default model is `claude-sonnet-5-5-medium`; override with `AGY_MODEL` or `--model`. An
  unknown model name ends `agy-run` with exit 1 and a message (without that check, agy silently
  burned 0 tokens and returned nothing).
- The worker rules are prepended to the prompt, because agy has no flag for an extra system prompt.

## Budget: two separate groups

The quota has two groups, each with a 5 h window and a weekly window, consumed in proportion to token
price: **Claude/GPT** (Sonnet, Opus, GPT-OSS) and **Gemini** (Flash, Pro). Exhausting one leaves the
other untouched, so Gemini is the reserve when the Claude group is spent.

- Current state: `scripts/agy-limit` (reads `/usage`, spends no tokens). `--json` gives remaining
  fractions per group and window.
- Example measurement (27 Sept 2026, Sonnet 4.6 at the time, figures indicative for 5.5), three small
  tasks, both models 3/3: `claude-sonnet-4-6` about 3% of the 5 h window and 1.1% of the week per task
  (roughly 90 a week); `gemini-3.1-pro-high` about 0.7% of the window and 0.12% of the week (roughly
  650 a week), but 49 to 108 s instead of about 55 s.
- `/usage` occasionally returns an empty answer once; `agy-limit` retries 3 times. An exit 3 from
  `agy-run` after such a reply is not a logout: run `agy-limit` by hand.
- Opus costs more of the quota than Sonnet; use it for a hard task and only after asking the human.

## Dispatch

```bash
agy-run --brief brief.txt --cd /repo                               # claude-sonnet-5-5-medium
agy-run --brief brief.txt --cd /repo --model gemini-3.1-pro-high   # Gemini group
agy-run --brief delta.txt --cd /repo --resume-last                 # correction in the same conversation
agy-run --brief question.txt --cd /repo --mode scout               # scout, maps to agy --mode plan
```

Flags: `--model`, `--timeout <seconds>` (default 1800), `--mode impl|scout|tests`,
`--resume <conversation_id>`, `--resume-last`.

Exit codes: 1 agy error (for example unknown model), 2 usage, 3 quota unreadable (usually logged
out), 4 less than 30% left in the group's 5 h window (`AGY_MIN_PCT`), 5 `scout`/`tests` changed the
tree, 142 timeout.

## Modes

| Mode | Rules file | agy flags |
|---|---|---|
| `impl` (default) | `worker-rules.md` | `--dangerously-skip-permissions` |
| `scout` | `scout-rules.md` | `--mode plan` |
| `tests` | `tests-rules.md` | `--dangerously-skip-permissions` |

Write protection in `--mode plan` was not verified by a test, so the safeguard is the tree comparison
(exit 5). Because `impl` and `tests` skip permissions, the diff is the record of what changed.

## Output and logs

Stdout: the report (`.response`), touched files, a `result:` line with the raw `result.json` path and the
conversation id, and a cost line (`+x% of the 5 h window and +y% of the week`, tokens, turns, seconds).
Cost log: `$AI_DELEGATE_HOME/agy-cost-log.jsonl` (default `~/.config/ai-delegate/`).

## Review and land

As in the shared loop: [review-and-land.md](review-and-land.md).
