# CLAUDE.md

Claude Code skill (plain markdown, no code) that improves spec-implementation fidelity: spec-derived tests, mandatory boundary-value coverage, and an evidence-gated done-report.

## Commands

- `./install.sh` — copy all skills in this repo into `~/.claude/skills/` (or `./install.sh <name>`; `--list` shows installable skills)
- `./update.sh` — git pull (if a clone) then reinstall/overwrite into `~/.claude/skills/`
- No build/test/lint — there is no package manifest; content is markdown plus two bash scripts.

## Architecture

- `skills/off-by-none/SKILL.md` — the skill itself and the source of truth; README only summarizes it.
- `docs/FABLE5-THINKING.md` — untested reference protocol the skill's round-6 scenarios were drawn from; explicitly NOT TDD-validated guidance.
- `install.sh` defines a skill as a real directory (not symlink) under `skills/` containing `SKILL.md` — the repo can host multiple skills. `.claude-plugin/` makes the repo installable as a plugin/marketplace.

## Conventions

- Every line of `SKILL.md` was added via TDD-for-skills: guidance goes in only when a baseline subagent actually failed a hidden grader without it. Do not add speculative rules — that process is the project's core contract (see README "How it was built").
