# off-by-none

A Claude Code skill that closes the gap between smaller models and frontier
models on spec-implementation tasks. It forces spec-derived tests, mandatory
boundary-value coverage, and an adversarial re-read of the spec before any
work is declared done.

Read [`off-by-none/SKILL.md`](off-by-none/SKILL.md) for the full workflow — this
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

Or install manually — copy the `off-by-none/` folder into `~/.claude/skills/`:

```bash
cp -R off-by-none ~/.claude/skills/off-by-none
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
