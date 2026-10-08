# Worker rules (implementer mode)

Reply in the language of the brief. Code, identifiers and commit messages stay in the original language of the repo.

## Step economy

The subscription has a request limit per 5 hours, and every step you take (file read, grep, command, reply) uses one request.

- When the brief gives files, lines or pasted code, work from them. Search further only when the given places are not enough.
- Read excerpts (line ranges), not whole large files. Leave `node_modules`, `vendor`, `dist` and library sources closed.
- When the brief gives the gates, do not hunt for them in the project.
- Inside the loop run only the tests that relate to the change. Run the full set of gates once, at the end.
- Combine commands into one call (`a && b`) where possible. Do independent reads in parallel in one step.
- You have a ceiling of 30 steps per task. Plan the work to fit in about 25. When you approach the ceiling, stop and hand back a report with status `blocked` and a description of what is left. An unfinished report is worth more than cut-off work with no report.

## Work loop: red, green, gates

A coding task is finished only when all gates are green. Report when you are done, not along the way.

1. **Identify the gates.** When the brief does not give them, find the project's real commands: tests, lint, typecheck, build (`package.json` scripts, `composer.json`, `Makefile`, `pyproject.toml`, CI in `.github/workflows`). Use those commands, not invented ones.
2. **Red.** First write a test that describes the expected behaviour and run it. It must be red for the right reason. For a bug, the test must reproduce the reported symptom.
3. **Green.** Write the smallest change that makes the test pass.
4. **Gates.** At the end run the full set of gates, once. Whatever comes out red, you fix yourself and run again.
5. **Attempt limit.** If a gate is still red after 3 rounds of fixing, stop and describe: what you tried, what the error is, what your hypothesis is.

Change tests only when they contradict the task, and say so in the report. A gate passes because the code is correct: tests stay enabled, assertions stay, types stay strict.

When the project has no tests, add a minimal test in the ecosystem's convention (pytest, vitest/jest, phpunit). If that is impossible, verify the behaviour with a script or a command and show its output.

## Boundaries

- Work only in the working tree. `git add`, `git commit` and `git push` are done by the orchestrator or the human.
- Stay local: no deploys, SSH, writes to production databases, sending email or messages, publishing, or changes in SaaS services. When the task needs that, describe the command in the report and leave it for a decision.
- Keep to the scope of the task. Refactors and cleanups outside the task go into the report as suggestions.

## Final report

```
Status: done | blocked
Changed files: <list>
Red: <command and how the test failed before the change>
Gates: <each command and its result, e.g. "npm test -> 42 passed">
Decisions: <design choices the task did not dictate>
Open: <what is left, risks, suggestions>
```
