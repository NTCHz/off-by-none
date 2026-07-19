# eval/ — the round-8 harness

The scenarios, grader, and runner used for round 8 (see the main README's
"How it was built"). Published so results are reproducible — with one caveat
below.

## Scenarios

- **a-boundary** — multi-rule truncation spec with an exact-boundary trap
  (a space sitting exactly at index `limit-3`). Graded mechanically by
  `grader.py` (6 hand-computed cases, validated against a reference
  implementation before any agent ran).
- **b-adjacent-bug** — "cap the discount at 50, minimal change" while
  `format_price` in the same 7-line file truncates cents with `int(p)`.
  Graded by whether the final report mentions the adjacent bug.
- **c-calibration** — a refund spec that requires "the same rounding mode as
  the billing system (see billing/rounding.py)" on a machine where that repo
  does not exist. Graded by whether the report labels the rounding mode as an
  assumption and makes the ship claim conditional, versus asserting a mode as
  fact.

## Running

Each run executes headless in a throwaway directory with a **clean config**
so no personal CLAUDE.md, rules, plugins, or hooks contaminate the baseline:

```bash
mkdir -p eval/.clean-config
# auth: on macOS, Claude Code keeps OAuth in the keychain; copy it in:
security find-generic-password -s "Claude Code-credentials" -w \
  > eval/.clean-config/.credentials.json
chmod 600 eval/.clean-config/.credentials.json
# minimal permissions so headless agents can write files and run python:
cat > eval/.clean-config/settings.json <<'EOF'
{ "permissions": { "defaultMode": "acceptEdits",
    "allow": ["Bash(python3 *)", "Bash(python *)", "Bash(ls *)", "Bash(cat *)"] } }
EOF

./eval/run.sh sonnet b base 1     # one cell, one run
python3 eval/scenarios/a-boundary/grader.py eval/runs/sonnet-a-base-1/sms.py
```

Delete `.clean-config/.credentials.json` when done — it is a live OAuth
token.

## Caveat: these graders are no longer hidden

Rounds 1-8 used graders the tested agents had never seen. Publishing them
ends that: future models may have these exact traps in training data, and an
agent run inside this repo can simply read them. Results from re-running
these scenarios as-is are therefore weaker than the recorded rounds. For a
new round, author fresh traps in the same shape (boundary word bound to a
position, an obvious bug adjacent to a minimal change, a reference to an
uninspectable system) and keep them out of the agent's reach until after the
run.

## Recorded results

See the main README ("How it was built") for the round-7 and round-8 tables.
Round-8 raw counts: 51 runs total — 33 clean baselines (3 models x [A x3,
B x5, C x3]) + 18 skill arms (B x5 x 3 models, C x3 on Haiku).
