# Kimi, GLM or Antigravity

All executors get the same briefs and the same worker rules (`scripts/worker-rules.md`).

## Example measurement (Sept 2026)

Three small tasks (1 to 2 files each) with hidden acceptance tests and a red check, each task run once.
This is an order of magnitude on one author's plans, not a benchmark: plan sizes, model versions and
prices change, so re-measure with `scripts/delegation-report` on your own work.

| | Kimi (kimi-for-coding) | GLM-5.3 | GLM-5.3-flash | agy Sonnet 5.5 | agy Gemini 3.1 Pro |
|---|---|---|---|---|---|
| Passed (hidden tests + red check) | 3/3 | 3/3 | 3/3 | 3/3 | 3/3 |
| Time per task | 35 to 51 s | 58 to 70 s | 76 to 81 s, once 7 min | 51 to 58 s | 49 to 108 s |
| Cost per task | 3 to 4 requests of 100 / 5 h | 4 to 6 credits of 2000 / 5 h | 1 to 2 credits | 2.9 to 3.5% of the 5h window, 1 to 1.2% of the week | 0.55 to 0.93% of the 5h window, 0.1 to 0.15% of the week |
| Small tasks per 5 h window | ~25 | ~300 | more | ~30 | ~100 to 180 |
| Small tasks per week | monthly limit | ~2000 (10 000 credits) | more | ~90 | ~650 |

Antigravity has two separate quota groups (Claude/GPT and Gemini), so Sonnet and Gemini do not eat
each other's budget. The GLM usage counter lags: in the measurement the per-task credits summed to 22
while the counter dropped by 28.

Not measured: large changes (many files, refactors). The measurement covered small tasks only.

## Selection rule

- **Default GLM-5.3** (`glm.md`): same quality in the measurement, the biggest budget (5 h and week).
- **Gemini 3.1 Pro through Antigravity** (`agy.md`) as the second choice: large weekly budget,
  separate from everything else, but the slowest and with the widest spread of run time.
- **Kimi** (`kimi.md`) when time matters (fastest in the measurement) or GLM is near its limit.
- **Sonnet through Antigravity**, sparingly (~90 small tasks a week). Good when the task wants a
  Claude model and your own Claude accounts are near their limit.
- **Flash** (GLM-5.3-flash) is not a default: cheaper, but one task took 7 minutes instead of one.
- GLM peak hours count extra against the quota (the plan documented Monday to Friday mornings in one
  region, off-peak at half rate; check Z.ai's current rules). Run big GLM queues off-peak.

You only need one executor. If you have only one subscription, use that one; the loop is identical.
Run `scripts/ai-limits` to see what is left before choosing.
