# Contributing to off-by-none

Issues and PRs are welcome.

## Changing the skill

`off-by-none/SKILL.md` is guidance, not code, but it follows the same
discipline as the workflow it prescribes: **TDD-for-skills**.

Before adding or changing any rule in `SKILL.md`:

1. Demonstrate a **baseline failure** — run a subagent without the proposed
   guidance against a spec-implementation task (a hidden grader, a real spec
   with known edge cases, etc.) and show it actually fails.
2. Add the minimal guidance that fixes that specific failure.
3. Re-run the baseline case to confirm the guidance closes the gap.
4. Don't add speculative rules for failures you haven't observed — every
   line in `SKILL.md` should trace back to an observed baseline failure.

PRs that add guidance without a demonstrated baseline failure will be asked
to show one first.

## Other changes

For `install.sh` / `update.sh` changes: keep them portable (no hardcoded
paths, no assumptions about the user's shell beyond bash), and test both the
"install all" and "install named skill" paths.

## Reporting issues

Open a GitHub issue with:

- What you expected the skill to do
- What actually happened
- The spec/task text that triggered the gap, if applicable
