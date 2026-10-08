#!/usr/bin/env bash
# Claude Code `apiKeyHelper` for glm-run: prints the Z.ai key taken from the GLM_API_KEY environment variable.
# Claude Code runs the helper as a child process, so it inherits the environment that glm-run exported.
# Claude Code then sends the printed value in the headers Z.ai expects. The key never appears in argv.
printf '%s\n' "${GLM_API_KEY:-}"
