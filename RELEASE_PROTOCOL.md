# Release Protocol

The repeatable checklist for shipping an Engram version. Follow every step, in order.

**Every gate in this document was added because it caught a real bug that the gate before it
could not see.** None of them is theoretical, and none of them is optional. The three that
people most want to skip — the fuzz, the user session, the post-release review — are the three
that found bugs in code that had already shipped.

**Rule of thumb for the number** (semver): user-visible feature → **minor** (`0.7.0`); bug fix,
doc, or polish → **patch** (`0.6.3`); a breaking change to state schema or the skill/CLI contract
→ **major**. When unsure, patch. A process-doc-only change (like this file) ships no version.

---

## The bug classes this repo cannot ship

Read this before you read anything else. Every gate below exists to catch one of these, and the
ordering of the list is the ordering of the harm.

| # | Class | Why it's fatal here | The one that taught us |
|---|---|---|---|
| **1** | **A wrong number — especially one that is wrong in the *flattering* direction** | Engram's entire value is that its numbers are true. A crash gets fixed because you see it. **A flattering number gets believed.** | `loop_closure` reported `1.0 · "the loop is closing"` for a learner who had never come back once (v0.6.1). `retention` reported *"100% recall, 0 unmeasured"* while the engine's own `decay` put the same concepts at **56% and falling** (v0.6.2). |
| **2** | **Silent data loss** | The learner's production is the only thing they actually made. Destroying it, silently, is unforgivable. | The normal settle path called `drop_stash(topic, node)` — draining **every** entry for that node — so settling one production destroyed a second, never-graded one (v0.6.2). |
| **3** | **Dead code shipped as a feature** | The CHANGELOG becomes a lie and the guard you're relying on isn't there. | Issue #3's `sid` idempotency guard never fired in production: the assessor's strict output schema didn't carry `sid`, so `apply_item` never saw one (v0.6.0 → fixed in the same release only because a review caught it). |
| **4** | **A guard nobody reads** | A tripwire that nothing consumes cannot trip. | `retention.coverage` was computed, stored in a nested key, and read by no runtime surface. |
| **5** | **A metric that silently drops evidence** | Survivorship bias with a progress bar. | Disjoint retention windows swallowed a real day-11 review while reporting *"no reviews yet"*. `unmeasured` exempted any node reviewed even once, ever. |
| **6** | **A read path that bricks** | `doctor` reports corruption; `stats` is not allowed to *die* of it. | 259 unhandled crashes in 300 fuzzed states. Several predated the release that surfaced them. |

> **The single sentence to keep:** *a number that is wrong in the direction that reassures the
> learner is worse than a crash.*

---

## 0 · Preconditions

```bash
cd ~/Documents/Github/engram
git checkout -b release/vX.Y.Z          # never work on main directly
python3 scripts/engram.py selftest      # must already be green before you start
```

The default branch is what a fresh `claude plugin install` pulls, so it must never be
half-broken. Decide the version number now; it appears in several files (step 2).

## 1 · Land the work

Make the change. **If it touches `scripts/engram.py`, it MUST be covered by a new `selftest`
check** — no engine behavior ships untested. Update the affected docs and skill files in the
same branch.

**If it adds or changes a NUMBER, go read §4.8 before you write the code.** That section is the
spec, not the audit.

## 2 · Bump the version — EVERY location

The single most error-prone step. There is no central version constant; these must move together.

```bash
grep -rnE '"version"|version-[0-9]|selftest-[0-9]|[0-9]+ checks|[0-9]+/[0-9]+ checks' \
  .claude-plugin .codex-plugin README.md INSTALL-CODEX.md
```

| File | What to change |
|---|---|
| `.claude-plugin/plugin.json` | `"version"` |
| `.codex-plugin/plugin.json` | `"version"` (lockstep with the Claude one) |
| `README.md` | version badge (`badge/version-X.Y.Z` **and** its `alt`) |
| `README.md` | selftest badge (`badge/selftest-N%2FN`) **if the count changed** |
| `README.md` | CLI table `selftest` row **if the count changed** |
| `INSTALL-CODEX.md` | selftest count comment **if the count changed** |

Re-run the grep after editing — **zero stale hits, or the badge lies.**

## 3 · Write the CHANGELOG

New section at the **top**:

```
## X.Y.Z — YYYY-MM-DD · <one-line theme>

<grouped: Theory / Engine / Behavior / Packaging. Trace each user-visible change to WHY.
 Note the selftest delta, e.g. "110 -> 119".>
```

**Write the bugs honestly, including the embarrassing ones.** The v0.6.2 entry says out loud
that survivorship bias was reproduced *inside the block written to prevent it*. That is the
entry a reader learns from. A CHANGELOG that only lists wins is marketing.

Release notes are generated from this section (step 6), so write it for a reader, not a git log.

---

# THE GATES

## 4 · The selftest gate

```bash
python3 scripts/engram.py selftest      # must end "N/N passed" — N == the badge
```

Red here stops the release. No exceptions.

**And then distrust it.** A green selftest means only that the checks you wrote pass. It says
nothing about the checks you didn't think to write, and — see next — nothing about whether the
checks you *did* write are real.

## 4.5 · Mutation-test every new check ⚠ NEW

**A check that still passes when you revert its fix is theatre.** Three of the checks written
during v0.6 were exactly that, and they looked identical to the real ones.

For each new check: revert the fix it guards, run the selftest, confirm **that specific check
fails**. Then restore.

```bash
cp scripts/engram.py /tmp/e.bak
# … revert ONE fix …
python3 scripts/engram.py selftest | grep "^FAIL"    # must name YOUR check
cp /tmp/e.bak scripts/engram.py
```

The two ways a check turns out fake, both seen in v0.6:

- **It asserts a constant, not a behavior.** `check(BUCKETS["30d"] == (15,59))` proves nothing;
  it just restates the source. Exercise the behavior — feed it a day-20 review and demand the
  funnel counts it.
- **The fixture makes old and new agree by coincidence.** One fixture had two nodes where the
  old (`>= 25`) and new (`[15,59]`) definitions *both* yielded 1. Build the fixture so the two
  definitions genuinely **diverge**, or the check cannot see the regression.

## 4.6 · The adversarial review (never skip; green tests are not evidence)

```bash
/code-review high        # against `git diff main...release/vX.Y.Z`
```

Name the diff, the risk areas (concurrency, back-compat with older state, path handling, **and
every new number**), and say prose files matter only for cross-file consistency.

**Three rules learned the hard way:**

1. **A green selftest means nothing about the design.** This review found **10 confirmed defects
   behind 79 passing checks** (v0.5.0), and **9 behind 110** (v0.6.0) — including a concurrency
   race and a headline feature that was dead code.
2. **Never trust a review whose agents errored.** A run once died on a session limit (5 of 7
   agents failed) and cheerfully reported *"no findings survived verification."* **Check the
   failure list before you believe the verdict.**
3. **Feed the reviewer the shipped contract, not just the diff.** v0.6's `sid` guard was dead
   because the *assessor's agent spec* — a file not in the diff — didn't carry the field.
   A reviewer looking only at the diff cannot see that. Point it at the whole round-trip.

Every confirmed finding gets a fix **and** a check that fails without it (§4.5).

## 4.7 · The fuzz gate ⚠ NEW — read paths degrade, never brick

State files are **hand-editable JSON**, and a file can be perfectly valid JSON with the *wrong
types*: `nodes` as a string, `fsrs` as a list, an unhashable `topic`, a `rating` that is a dict.
Fuzzing found **259 unhandled crashes in the first 300 states** — and several predated the
release that surfaced them.

Throw randomized garbage at **every read command** and demand each one **returns**:

```python
# throwaway ENGRAM_HOME; randomize every field to every JSON type; 500+ states, 2+ seeds
for fn in (compute_stats, cmd_adherence, cmd_retention, cmd_decay,
           cmd_topics, cmd_due, cmd_session_start, cmd_report, cmd_doctor):
    fn(...)          # SystemExit (a guarded die()) is fine. An exception is a defect.
```

**The doctrine, and it is already written in `iter_graphs`' docstring:** aggregate/read-only
views must degrade gracefully — never brick. `doctor` is the thing that **reports** corruption
and must **never die of what it exists to find**.

Fix at the **gate**, not the call site. Twenty guards smeared across twenty functions is how
this bug class survives; one shape-check in `iter_graphs` — which every read path funnels
through — is how it dies.

Target: **0 crashes / 500 states**. Lock it in with a selftest that feeds every read path a
deliberately type-corrupt state.

## 4.8 · The numbers audit ⚠ NEW — the most important gate in this file

**This is the gate that exists for bug class #1**, and it is the one this repo most needs,
because Engram's entire value proposition is that its numbers are true.

For **every number the release adds or changes**, answer all five in writing:

### 1. Is it cross-consistent with every other number the engine computes?

The engine has several ways to say related things. **They must agree.** In v0.6.2 they did not:

```
retention  →  "measured over 10 retrievals · 100% recall · unmeasured 0"
decay      →  "10 concepts due · mean current recall 56%"
```

Two commands, one state, contradictory stories, shipped. **Nobody had ever run them side by side.**

> **Do it now.** Build one state, run every command that touches the new number, and put their
> outputs next to each other. If any two disagree, one of them is lying and you do not yet know
> which.

### 2. Which direction does it fail in?

Enumerate the ways it can be wrong, and for each, ask: **does this reassure the learner?**

A number that can only fail *pessimistically* (says you're worse off than you are) is annoying.
A number that can fail *optimistically* — *"the loop is closing"*, *"100% recall"* — **gets
believed, and stops them reviewing.** Optimistic failure modes are release-blocking; pessimistic
ones are bugs. Treat them differently.

### 3. What is its denominator, and does it say so?

Every rate silently drops something. Name it, count it, and **publish it beside the rate.**

`retention` computed over completed reviews drops exactly the concepts the learner abandoned —
which are, definitionally, the ones that decayed. That is survivorship bias with a progress bar,
and Engram shipped it *twice* (once via disjoint buckets, once via an `unmeasured` scoped to
never-reviewed nodes).

### 4. Does anything actually READ it?

A guard nobody consumes is not a guard. `coverage` was computed, stored, and read by nothing —
so the anti-data-loss tripwire could not trip.

**Rule: a number's failure state must reach the NARRATOR** — the `read` string, the skill prose,
the dashboard — not sit in a nested key that only a test ever opens.

### 5. Can it be reached from the CLI in a way the skills never take?

The skills always pass explicit flags. **The CLI has defaults, and they bite.** `rate --kind`
defaults to `"review"`, so a bare `rate` wrote a node's only receipt as a review — and
`loop_closure` reported a perfect score for a learner who never returned.

Every metric keys off exact literals. **Validate them** (`choices=`, a `KINDS` constant, a check
in `validate_item`) so a typo dies before any write — receipts are append-only, so a bad one can
never be corrected.

---

## 5 · The live test (drive the engine — never skip)

Selftest proves the units; this proves a learner's *experience*. Drive the real engine end to
end in a throwaway state dir, exercising everything the release touched.

```bash
export ENGRAM_HOME=$(mktemp -d); export ENGRAM_TODAY=2026-01-01
```

Exercise: `init` → `add-topic` → `topic-status` → `artifact set` → `rate` (encode) →
time-travel → `rate` (review) → `stats` → `adherence` → `retention` → `decay` → `commit` →
`focus`/`visuals` round-trip → `artifact list` → `report` → `doctor`.

**Confirm with your own eyes** that `s_after > s_before`, the receipt carries its medium stamp,
`momentum` is populated, `modality` carries its caveat, `retention` carries its `unmeasured`,
the dashboard writes, and `doctor` is `ok=true`.

**This step earned its place:** it caught disjoint retention windows silently eating a real
day-11 review — a bug no selftest could see, because the selftest fixture used day 7 and day 30
and never landed in the gap.

Then **read-only against the real state** (`~/.claude/learning`) and hash the directory before
and after. A read command that writes is a defect (three of them were).

## 5.5 · The agent dogfood — **UNCONTAMINATED** (required when skills, agents, or the Contract change)

The engine can be green while the *prose* regresses — and prose is where most of this plugin's
behavior lives. Steps 4–4.8 cannot see it.

```bash
export ENGRAM_HOME=$(mktemp -d)     # NEVER ~/.claude/learning — a dogfood receipt would
                                    # poison the learner's real schedule and telemetry
```

### ⚠ The rule that makes this test real, learned the expensive way

> **Give each agent EXACTLY what the real skill gives it. Not one word more.**

v0.6 shipped issue #3's fix as dead code. The dogfood *certified* it — because the prompt
written for the dogfood **told the assessor to pass the `sid` through**, an instruction the real
`/learn` skill never gives. The real assessor, following its own strict output schema, dropped
the field every time.

**A test that hands the subject the answer is not a test.** If you catch yourself adding a hint,
an explanation, or a "remember to…" to a dogfood prompt, **stop** — you have just discovered a
gap in the *real* contract. Fix the contract; don't patch the prompt.

Concretely: paste the literal output of `stash list`. Nothing else.

### The loop

1. **curriculum-architect** on a small real topic (5 nodes). Did it honor the current spec?
2. `add-topic` → `next`. Does the frontier node arrive with what the skills expect?
3. **artifact-smith** on the frontier node, given only what `/learn` would give it. Did it read
   the Contract, obey each clause, and **register itself**?
4. **Audit the artifact independently — never trust the agent's own QA report.** Grep it: no
   external refs, both themes, `prefers-reduced-motion`, the prediction gate hides content, the
   worked drive precedes free manipulation, both retrieval prompts, the blank-page ending, the
   header comment. Open it and click through.
5. `stash add` a plausible production → **assessor** (blind; stash contents only, verbatim) →
   `receipt` → `stash clear`. Did it round **down** on a gapped production and cite the rubric?
   **Did every field of the contract survive the round-trip?**
6. **Settle the same file twice.** The second must be a true no-op — and the stash must still
   contain any *other* ungraded production for that node.
7. Read the resulting telemetry (`stats`, `adherence`, `retention`, `doctor`, `report`) as a
   learner would.

Write down what surprised you. **A surprise here is not a reason to skip the release. It is the
release.**

## 5.6 · THE USER SESSION ⚠ NEW — the "user ready" gate

Everything above proves the system is *correct*. **Nothing above proves it is usable.** This
step is the only one that asks the question the 500 people who installed it actually care about:
*would a stranger get through this?*

**Be a learner. Not a tester. Actually try to learn something you don't know.**

```bash
export ENGRAM_HOME=$(mktemp -d)     # throwaway, always
```

Rules, and they are what make it worth doing:

- **Pick a topic you genuinely do not understand.** Not a demo topic. Not something you can fake.
  If you already know it, you cannot feel where the tutor is confusing.
- **Answer honestly.** Do not perform competence. Give the terse, half-right answer you would
  actually give at 11pm. That is the production the assessor has to handle, and the one that
  found the *terse-production* rule in the first place.
- **Do not fix anything while you are inside the session.** Write it down and keep going. The
  moment you start debugging, you have stopped being a user.
- **Then time-travel the sandbox and run `/review`.** The retention half is the half that has
  never run — you do not get to ship a release that touches it without running it.

### The report (paste it into the PR / release notes — it is required output)

```
## User session report — vX.Y.Z
topic: <what you tried to learn>      mode: <sprint|standard|deep>
real minutes: <n>                     nodes encoded: <n>      reviews cleared: <n>

WHAT WORKED
- …

WHAT CONFUSED ME
- …

WHAT ANNOYED ME — and what I would have quit over
- …

WHAT IT TOLD ME vs WHAT WAS TRUE
- <every number it showed me. was each one right? did any of them flatter me?>
- <run the other commands on the same state. do they agree?>       ← §4.8.1, by hand

WOULD A STRANGER GET THROUGH THIS?   yes / no — and why

VERDICT:   ship / do not ship
```

**The verdict is binding.** If you would not hand this to a stranger, it does not ship, no matter
how green the tests are. The whole point of the project is a tool a human keeps using; a release
that is correct and unusable has failed at the only thing that matters.

**And the honest note:** the *feel* of returning after three days cannot be faked with
`ENGRAM_TODAY`. When a release changes the retention loop, the amnesty protocol, or the ambient
surface, **use it for real, across real days, before the next release.** The founder's own
account — 7 encoded, 0 reviewed — is what this entire release existed to fix, and no sandbox
would ever have shown it.

---

## 6 · Merge, tag, release (the step that was once missed)

```bash
V=X.Y.Z
git add -A && git commit    # "release: vX.Y.Z — <theme>" (+ Co-Authored-By trailer)
git checkout main && git pull origin main
git merge --no-ff release/v$V -m "Merge: vX.Y.Z — <theme>"
git push origin main

python3 - "$V" > /tmp/relnotes.md <<'PY'
import sys; V=sys.argv[1]; on=False; out=[]
for ln in open("CHANGELOG.md").read().splitlines():
    if ln.startswith("## "+V): on=True; continue
    if on and ln.startswith("## ") and not ln.startswith("## "+V): break
    if on: out.append(ln)
open("/dev/stdout","w").write("\n".join(out).strip()+"\n")
PY

git tag -a "v$V" -m "v$V — <theme>" && git push origin "v$V"
gh release create "v$V" --title "v$V — <theme>" --notes-file /tmp/relnotes.md --latest
```

`--latest` is what flips the badge off the previous version. **Without the tag + release, `main`
has the new version and the world still sees the old one.**

## 7 · Verify the release is real

```bash
gh release list -L 3                       # the new vX.Y.Z must show "Latest"
git describe --tags --abbrev=0 origin/main # == vX.Y.Z
```

## 7.5 · The post-release review ⚠ NEW — because two HIGH bugs were found *after* shipping

Every gate above is run by the person who wrote the code, on the code they believe is right.
**They confirm what you already believe. That is their structural limit.**

The two worst bugs in v0.6 were found by an **independent reviewer reading the shipped code**,
after release:

- the "honest denominator" exempted anyone who reviewed once, ever — so the dashboard reported
  *100% recall, nothing unmeasured, loop closing* while the engine's own `decay` said 56%;
- the **normal** settle path (not the rare one already fixed) destroyed a learner's second,
  ungraded production, on every single settle.

So, **after every release that touches the engine**, spawn a reviewer against `main` with:

- the shipped code, **not** the diff (the diff hides what a contract file elsewhere fails to do);
- the list of what the pre-release review already found, so it does not re-report;
- a standing instruction: **"find a number that is wrong, especially one that is wrong in the
  direction that reassures the learner."**

If it finds something, **ship the patch immediately** and say so plainly in the CHANGELOG. Three
releases in an hour is not a failure; a wrong number left standing is.

## 8 · Tell existing users how to update

New installs pull `main` and are fine. Existing users must run:

```
claude plugin marketplace update engram && claude plugin update engram@engram
```

then restart (or `/reload-plugins`). Mention this in the release notes — a plain `plugin update`
before the marketplace refresh reports "already current" against the stale cache.

Then, per the repo's habit: **close the issues this release fixes, with a real reply** — what
shipped, what the wrinkle was, and how to get it.

---

### One-glance checklist

- [ ] on a `release/` branch; selftest green to start
- [ ] work landed; **every engine change has a selftest**
- [ ] version bumped in **all** grep locations (re-grep: zero stale)
- [ ] CHANGELOG written — including the embarrassing parts
- [ ] **§4** selftest → N/N, N == the badge
- [ ] **§4.5** every new check **mutation-tested** (revert the fix → that check fails)
- [ ] **§4.6** `/code-review high`; **no agent errored**; every finding fixed + checked
- [ ] **§4.7** fuzz: **0 crashes / 500 garbage states**; read paths degrade, `doctor` survives
- [ ] **§4.8** numbers audit — all five questions answered **in writing** for every new number
- [ ] **§5** live test driven; real state read-only and **hash-identical** after
- [ ] **§5.5** agent dogfood — **uncontaminated** (agents got exactly what the skill gives them)
- [ ] **§5.6** **USER SESSION run; report written; verdict = ship**
- [ ] **§6** merged `--no-ff`; annotated tag; `gh release create … --latest`
- [ ] **§7** `gh release list` shows it as Latest
- [ ] **§7.5** post-release independent review scheduled/run
- [ ] **§8** update line published; fixed issues closed with a real reply

---

### Why each gate exists — the actual bug, in one line each

| Gate | The bug it caught |
|---|---|
| **4** selftest | the ordinary stuff — and nothing else |
| **4.5** mutation test | **3 of our own checks were theatre** (one asserted a constant; one had a fixture where old and new agreed by coincidence) |
| **4.6** adversarial review | 10 defects behind 79 green checks (v0.5); 9 behind 110 (v0.6) — incl. a concurrency race and a **headline feature that was dead code** |
| **4.7** fuzz | **259 crashes in 300 states**; several predated the release that found them; a hand-edited file could brick `/coach` |
| **4.8** numbers audit | `retention` said **100%** while `decay` said **56%** — two commands, one state, contradictory stories, shipped |
| **5** live test | disjoint buckets **silently ate a real day-11 review** while reporting "no reviews yet" |
| **5.5** dogfood | the pipeline held — and the *first* dogfood **certified a dead feature**, because the prompt handed the assessor the answer |
| **5.6** user session | the founder encoded 7 concepts and reviewed **0**. Every test was green. The product had already failed. |
| **7.5** post-release review | **2 HIGH bugs in shipped code** — the honest denominator wasn't honest; the normal settle path destroyed the learner's work |

**The pattern, stated once:** *every test you write confirms what you already believe. The things
that found real bugs were the ones you did not control — a fuzzer, a reviewer, and a real session
with a real human who did not come back.*
