---
name: off-by-none
description: Use when implementing or fixing code against a written spec, requirements doc, or ticket — especially under time pressure, "quick fix" or "minimal change" requests, or when about to declare work ready to ship.
---

# Spec-Faithful Implementation with Independent Verification

## Overview

Self-written tests inherit the same misreading as your implementation, so they pass while the code is wrong. This skill forces test cases to be derived from the spec's literal wording BEFORE implementing, with mandatory boundary-value coverage.

**Core principle: a test derived from your implementation verifies nothing. Derive every test from the spec's exact words.**

## Workflow

1. **Requirements ledger.** Number every clause of the spec, including sub-clauses hidden inside sentences ("then re-apply rule 6" is its own entry). One checklist item per clause.

2. **Derive tests from the spec text — before writing any implementation code.**
   - For every clause, write at least one case using only the spec's wording, not your planned code.
   - **Boundary rule (mandatory):** every numeric limit or boundary word — "at", "at or before", "exceeds", "up to", "at least", "within" — gets three cases: exactly N-1, exactly N, exactly N+1. Compute the expected outputs by hand from the spec sentence, character by character if needed.
   - **Boundary words bind to what they modify.** "At or before max_len" about a *position* (a delimiter, a marker, a match) requires a test where that thing sits exactly AT position max_len — a test where only the total *length* is at the limit does not cover it. For each boundary phrase, name the noun it modifies (length? index? count? position?) and put the test exactly there.
   - For every "if/when/unless" clause, one case per branch.

3. **Implement.**

4. **Run the tests. Paste actual output.** "I verified" without shown output is not verification.

5. **Adversarial re-read.** Go back to the spec, clause by clause, and for each ask: "is there an input where another literal reading of this sentence gives a different answer than my code?" Ambiguity between two readings = write a test for both readings and pick the one the spec's words actually say.

6. **Claim done only with evidence:** ledger with every item checked + test output shown.

## Quick Reference

| Spec wording | Required test cases |
|---|---|
| "exceeds N" / "up to N" | length N-1, N, N+1 |
| "at or before X" | exactly at X, one before X, one after X |
| "if A, do B" | A true, A false |
| "then re-apply rule K" | case where skipping rule K would show |
| empty/none mentioned | empty input, no-valid-content input |

## Common Mistakes

| Mistake | Reality |
|---|---|
| "I tested it with ~10 cases, all pass" | Cases generated from your own code's logic test your logic, not the spec. |
| "Time pressure — skip the ledger" | The ledger takes 1 minute. A shipped off-by-one costs a rollback. |
| "The boundary case is obvious" | Both baseline failures in testing this skill were exact-boundary off-by-ones that the author's own tests missed. Hand-compute expected values at the boundary. |
| "Minimal change was requested, so minimal checking" | Minimal change refers to the diff, not the verification. |

## Red Flags — STOP

- About to write "ready to ship" without pasted test output
- No test case sits exactly AT a numeric limit from the spec
- Expected values in tests were copied from your function's output
- You read the spec once, at the start, and never re-read it after implementing
