# off-by-none

A Claude Code skill that closes the gap between smaller models and frontier
models on spec-implementation tasks. It forces spec-derived tests, mandatory
boundary-value coverage, and an adversarial re-read of the spec before any
work is declared done.

Read [`skills/off-by-none/SKILL.md`](skills/off-by-none/SKILL.md) for the full workflow — this
README summarizes it, the skill file is the source of truth.

## What it does

When implementing or fixing code against a written spec, the skill requires:

1. **A requirements ledger** — every clause of the spec numbered, including
   sub-clauses hidden inside sentences.
2. **Tests derived from the spec's exact wording, before any implementation
   code is written.** Every numeric limit or boundary word ("at", "up to",
   "exceeds", "at least", "within") gets three cases: N-1, N, and N+1,
   hand-computed from the spec text.
3. **Implementation**, only after the tests above exist.
4. **Actual pasted test output** — "I verified" without shown output doesn't
   count.
5. **An adversarial re-read** of the spec, clause by clause, checking for
   inputs where an alternate literal reading would give a different answer.
6. **A done-claim gated on evidence** — a report with three required
   sections: **Verified** (checked ledger + pasted test output), **Assumed**
   (every spec reference you couldn't inspect — external systems, config
   values, "same as X" — making the ship claim conditional), and **Seen but
   not touched** (observations about surrounding code you read but didn't
   change; never verdicts on code you didn't spec-test).

## Install

### As a plugin (recommended)

```bash
claude plugin marketplace add NTCHz/off-by-none
claude plugin install off-by-none@off-by-none
```

### As a plain skill

Clone and run the installer:

```bash
git clone https://github.com/NTCHz/off-by-none.git
cd off-by-none
./install.sh
```

`install.sh` supports installing everything, or naming specific skills:

```bash
./install.sh              # install all skills in this repo
./install.sh off-by-none    # install only this skill
./install.sh --list        # show what's installable
```

Or install manually — copy the `skills/off-by-none/` folder into `~/.claude/skills/`:

```bash
cp -R skills/off-by-none ~/.claude/skills/off-by-none
```

## Guaranteed triggering (optional)

Installed either way, the skill is model-invoked: Claude reads its
description and applies it when a task looks like spec implementation. If
you want it to fire every time instead of relying on that judgment, add one
line to your own `~/.claude/CLAUDE.md`:

```markdown
When implementing or fixing code against a written spec, requirements doc,
or ticket, ALWAYS invoke the `off-by-none` skill before writing code —
including "quick fix" and "minimal change" requests.
```

## Update

```bash
./update.sh
```

If this directory is a git clone, `update.sh` pulls the latest changes first,
then reinstalls (overwrites) into `~/.claude/skills/`.

## How it was built

Developed via TDD-for-skills: a baseline subagent (no skill guidance) was run
against a set of hidden graders over 5 test rounds. Guidance was only added
to `SKILL.md` when a baseline failure actually existed against those graders
— no speculative rules. The two baseline failures found during testing were
both exact-boundary off-by-ones, which is why boundary-value coverage is
mandatory rather than a suggestion — and where the name comes from: the goal
is to ship off by none.

Tested primarily on Claude Opus. Also reproduced on Claude Haiku: on a
multi-rule spec task, baseline Haiku failed the same exact-boundary trap
(11/12) and passed with the skill (12/12) — one run per arm, so treat it as
a signal, not a benchmark. The skill is plain markdown and model-agnostic.

A sixth round probed three new dimensions with fresh pressure scenarios:
calibration (a spec referencing systems the agent cannot see), adjacent-bug
reporting (an obvious bug next to the requested change), and root-cause
debugging. Baselines failed the first two — Haiku shipped a fabricated
verification checklist over unverifiable references, and both Opus and Haiku
silently omitted a bug sitting in the same 14-line file they edited. That's
where the three-section done-report comes from. Root-cause debugging showed
no baseline failure, so per TDD nothing was added for it. Closing the
reporting gap on Haiku took two wording iterations: a required section alone
produced "None" written without looking, and a look-first rule produced
unearned "works correctly" verdicts — the shipped wording demands
step-by-step observations and bans verdicts on untested code.

A seventh round probed Claude Sonnet with three fresh scenarios (one run per
arm): an exact-boundary truncation trap graded by a hidden 6-case grader, an
obvious bug adjacent to a "minimal change" request, and a spec referencing a
repo not present on the machine. Baseline Sonnet passed the boundary trap
(6/6) and labeled the uninspectable reference as an assumption with a
conditional ship claim — but silently omitted the adjacent bug, the same
reporting gap found on Opus and Haiku in round 6; with the skill it reported
the bug in **Seen but not touched**. Per TDD nothing new was added to
SKILL.md — the failing dimension was already covered. Caveat: round-7
baselines ran with the author's global Claude Code rules in context, so they
measure the skill's marginal value over an already-disciplined setup rather
than over a bare model.

An eighth round removed that caveat and added repetition: the same three
scenarios, run headless via `claude -p` under a clean config (no CLAUDE.md,
no rules, no plugins, no hooks — bare model) on Sonnet 5, Opus 4.8, and
Haiku 4.5, with 3-5 runs per cell. Results:

| clean baseline → with skill | boundary trap | adjacent-bug report | unverifiable-reference calibration |
|---|---|---|---|
| Sonnet 5 | 3/3 | **0/5 → 5/5** | 3/3 |
| Opus 4.8 | 3/3 | **4/5 → 5/5** | 3/3 |
| Haiku 4.5 | 3/3 | **0/5 → 5/5** | **0/3 → 3/3** |

Three findings. (1) The exact-boundary trap no longer catches any current
model at baseline — the weakness that named this skill has largely been
absorbed by the models themselves. (2) The durable gap is silent omission of
adjacent bugs: bare Sonnet and Haiku failed it 0/5 under "minimal change"
pressure, and the skill fixed it 5/5 on every model. (3) Bare Haiku also
fabricated calibration claims (asserting an uninspectable rounding mode
"matches the billing system", 0/3) and the skill fixed that 3/3. Boundary
coverage stays in the skill — it is cheap insurance and the historical
record shows models regress — but the skill's measured value today is the
evidence-gated done-report, not the boundary drill.

## What it does NOT fix

This skill narrows the gap on spec-implementation tasks specifically —
literal-reading errors, missed boundary conditions, and premature "done"
claims. It does **not** close gaps in:

- Deep architectural reasoning or system design tradeoffs
- Novel algorithmic problems with no spec to derive tests from
- Judgment calls where the spec itself is genuinely silent or contradictory

Use it for spec-to-code fidelity, not as a general capability upgrade.

For the broader (untested) behavioral guidance this skill's round-6 scenarios
were drawn from, see [`docs/FABLE5-THINKING.md`](docs/FABLE5-THINKING.md) — a
process-over-IQ protocol you can paste into any agent's context. Unlike
`SKILL.md`, it has not been through per-line TDD; treat it as reference
material, not tested guidance.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

MIT — see [LICENSE](LICENSE).
