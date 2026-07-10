# Release Protocol

The repeatable checklist for shipping an Engram version. It exists because a version
can be bumped in the files and still ship "0.3.0" to the world if the **git tag and
GitHub release** are never cut — the marketplace badge and any tag-pinned resolver read
the *release*, not `main`. Follow every step, in order. Do not skip the live test.

**Rule of thumb for the number** (semver): user-visible feature → **minor** (`0.4.0`);
bug fix, doc, or polish → **patch** (`0.4.1`); a breaking change to state schema or the
skill/CLI contract → **major**. When unsure, patch.

---

## 0 · Preconditions

```bash
cd ~/Documents/Github/engram
git checkout -b release/vX.Y.Z          # never work on main directly
python3 scripts/engram.py selftest      # must already be green before you start
```

- Work on a branch. The default branch is what fresh `claude plugin install` pulls, so it
  must never be half-broken.
- Decide the version number `X.Y.Z` now; it appears in several files (step 2).

## 1 · Land the work

Make the change. If it touches the deterministic core (`scripts/engram.py`), it MUST be
covered by a new `selftest` check — no engine behavior ships untested. Update the affected
docs (`docs/`, skill files) in the same branch.

## 2 · Bump the version — EVERY location

The single most error-prone step. There is no central version constant; these must move
together. Find them all first, then edit:

```bash
grep -rnE '"version"|version-[0-9]|selftest-[0-9]|[0-9]+ checks|[0-9]+/[0-9]+ checks' \
  .claude-plugin .codex-plugin README.md INSTALL-CODEX.md
```

Canonical locations (as of v0.4.1):

| File | What to change |
|---|---|
| `.claude-plugin/plugin.json` | `"version"` |
| `.codex-plugin/plugin.json` | `"version"` (keep in lockstep with the Claude one) |
| `README.md` | version badge (`badge/version-X.Y.Z` **and** its `alt`) |
| `README.md` | selftest badge (`badge/selftest-N%2FN`) **if the check count changed** |
| `README.md` | CLI table `selftest` row (`N checks over…`) **if the count changed** |
| `INSTALL-CODEX.md` | selftest count comment **if the count changed** |

Re-run the grep after editing — zero stale hits, or the badge lies.

## 3 · Write the CHANGELOG

Add a new section at the **top** of `CHANGELOG.md`:

```
## X.Y.Z — YYYY-MM-DD · <one-line theme>

<what changed, grouped: Theory / Engine / Behavior / Packaging. Trace each user-visible
change to why. Note the selftest count delta, e.g. "68 -> 70".>
```

The release notes are generated from this section (step 6), so write it for a reader, not
a git log.

## 4 · The gate: selftest

```bash
python3 scripts/engram.py selftest      # must end "N/N checks passed" — N == the badge
```

Red here stops the release. No exceptions.

## 4.5 · The adversarial review (never skip; green tests are not evidence)

```bash
/code-review high        # in Claude Code, against `git diff main...release/vX.Y.Z`
```

Name the diff, the risk areas (concurrency, backward compatibility with older state,
path handling), and say prose files matter only for cross-file consistency.

**Two rules learned the hard way (v0.5.0):**

1. **A green selftest means nothing about the design.** This review found **10 confirmed
   defects behind 79 passing checks**, including a last-writer-wins race between the
   background artifact-smith and the tutor's `rate`, and a v0.4-compat bug that would
   have permanently mis-stamped receipts.
2. **Never trust a review whose agents errored.** A first run died on a session limit
   (5 of 7 agents failed) and cheerfully reported *"no findings survived verification."*
   Check the failure list before you believe the verdict.

Every confirmed finding gets a fix **and** a selftest that fails without it.

## 5 · The live test (dogfood — never skip)

Selftest proves the units; this proves a learner's *experience*. Drive the real engine
end-to-end in a throwaway state dir, exercising anything the release touched.

```bash
export ENGRAM_HOME=$(mktemp -d); export ENGRAM_TODAY=2026-01-01
E="python3 scripts/engram.py"
$E init >/dev/null
# hand-author a tiny topic so you don't need the curriculum agent / network:
cat > "$ENGRAM_HOME/t.json" <<'JSON'
{"topic":"demo","title":"Demo","order":["a","b"],
 "nodes":{"a":{"claim":"A","probe":"State A.","rubric":["a"]},
          "b":{"claim":"B","probe":"State B.","rubric":["b"],"edges":{"requires":["a"]}}}}
JSON
$E add-topic --file "$ENGRAM_HOME/t.json" >/dev/null
$E topic-status --topic demo                       # map renders
mkdir -p "$ENGRAM_HOME/artifacts/demo"; echo "<!doctype html>" > "$ENGRAM_HOME/artifacts/demo/a.html"
$E artifact set --topic demo --node a --path "$ENGRAM_HOME/artifacts/demo/a.html"   # validated, home-relative
$E rate --topic demo --node a --rating good --grade recalled --confidence 80 --kind encode --production x >/dev/null
ENGRAM_TODAY=2026-01-12 $E rate --topic demo --node a --rating good --grade recalled --confidence 75 --kind review --production x  # growth: s_before -> s_after; stamp: artifact=true
ENGRAM_TODAY=2026-01-12 $E stats | python3 -c 'import json,sys;s=json.load(sys.stdin);print("momentum:",s["momentum"]);print("modality:",s["modality"]["read"],"| caveat:","caveat" in s["modality"])'
$E focus on && $E focus status && $E focus off       # ADHD profile toggles cleanly
$E visuals eager && $E visuals threshold && $E visuals status   # visuals dial round-trips
$E artifact list                                     # registration visible, exists=true
$E report >/dev/null && echo "dashboard ok"
$E doctor | python3 -c 'import json,sys;d=json.load(sys.stdin);print("doctor ok=",d.get("ok"),"notes:",d.get("notes"))'
rm -rf "$ENGRAM_HOME"; unset ENGRAM_HOME ENGRAM_TODAY
```

Confirm with your own eyes: the review's `s_after` really exceeds `s_before` and the
receipt carries `artifact: true`, the `momentum` block is populated, `modality` carries
its `caveat`, `focus` round-trips to `null` (not the string `"null"`), `visuals` settles
back to `threshold-only`, `artifact list` shows `exists: true`, the dashboard writes, and
`doctor` is `ok=true`. Anything off → fix, back to step 4.

## 5.5 · The agent dogfood (required when skills, agents, or the Contract change)

The engine can be green while the *prose* regresses — and prose is where most of this
plugin's behavior lives. Steps 4 and 4.5 cannot see it. **Run the real loop, with the
real subagents, in a sandbox.**

```bash
export ENGRAM_HOME=$(mktemp -d)          # NEVER the real ~/.claude/learning:
                                         # a dogfood receipt would poison the learner's
                                         # own schedule, calibration, and telemetry
```

Then, in Claude Code, drive one full acquisition loop — **pointing every agent at this
dev clone, not the installed plugin** (the installed copy is the previous version, and
you will "verify" last release's prose otherwise):

1. **curriculum-architect** on a small real topic (5 nodes). Did it honor the new spec?
   (v0.5: every node carries a `viz` hint; affordance is honest, not inflated.)
2. `add-topic` → `next`. Does the frontier node arrive with what the skills expect?
3. **artifact-smith** on the frontier node, given only what `/learn` would give it.
   Did it read the Contract, obey each clause, and **register itself** (`artifact set`)?
4. **Audit the artifact independently — never trust the agent's own QA report.** Grep it:
   no external refs, both themes, `prefers-reduced-motion`, the prediction gate hides
   content, the worked drive precedes free manipulation, both retrieval prompts present,
   the blank-page ending, the header comment. Open it and click through.
5. `stash add` a plausible learner production → **assessor** (blind, stash contents only)
   → `receipt` → `stash clear`. Did it round *down* on a gapped production and cite the
   rubric criterion? Did the receipt land with the right medium stamp?
6. Read the resulting telemetry (`stats`, `doctor`, `report`) as a learner would.

Write down what surprised you. **This step exists because it works:** the v0.5.1 release
came entirely from doing it — the pipeline passed, and the session exposed that
`stats.modality`'s two arms are confounded by construction (explorables are routed to the
hardest concepts, so the comparison carries material as well as medium). No selftest and
no code review could have found that. Only using the thing did.

A surprise here is not a reason to skip the release. It is the release.

## 6 · Merge, tag, release (the step that was once missed)

```bash
V=X.Y.Z
git add -A && git commit    # message: "release: vX.Y.Z — <theme>" (+ the repo's Co-Authored-By / Session trailers)
git checkout main && git pull origin main
git merge --no-ff release/v$V -m "Merge: vX.Y.Z — <theme>"
git push origin main

# extract this version's CHANGELOG section as the release body:
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

`--latest` is what flips the "Latest" badge off the previous version. Without the tag +
release, `main` has the new version but the world still sees the old one.

## 7 · Verify the release is real

```bash
gh release list -L 3                       # the new vX.Y.Z must show "Latest"
git describe --tags --abbrev=0 origin/main # == vX.Y.Z
```

## 8 · Tell existing users how to update

New installs pull `main` and are fine. Users who already installed must run:

```
claude plugin marketplace update engram && claude plugin update engram@engram
```

then restart Claude Code (or `/reload-plugins`). Mention this in the release notes / any
announcement, because a plain `plugin update` before the marketplace refresh can report
"already current" against the stale cache.

---

### One-glance checklist

- [ ] on a `release/` branch, selftest green to start
- [ ] work landed; new engine behavior has a selftest
- [ ] version bumped in **all** grep locations (re-grep: zero stale)
- [ ] CHANGELOG section written
- [ ] `selftest` → N/N passed, N matches the badge
- [ ] `/code-review high` run on the branch diff; **no agent errored**; every confirmed
      finding fixed *and* covered by a new selftest
- [ ] live test run, output eyeballed (growth, artifact stamp, momentum, modality caveat,
      focus, visuals, artifact list, dashboard, doctor)
- [ ] **agent dogfood** run in a sandbox `ENGRAM_HOME` if skills/agents/Contract changed:
      architect → smith (registers itself; artifact audited independently) → assessor
      (blind, rounds down) → receipt → telemetry read as a learner
- [ ] merged to main with `--no-ff`, pushed
- [ ] annotated tag pushed **and** `gh release create … --latest`
- [ ] `gh release list` shows the new version as Latest
- [ ] update instructions noted for existing users

### Why the two new steps exist (v0.5.x, in one line each)

- **4.5 adversarial review:** 79 passing selftests, 10 confirmed defects — including a
  concurrency race the tests were structurally unable to see.
- **5.5 agent dogfood:** the code review was clean, and the first real session found a
  design flaw in the release's headline feature. Shipping without using it is guessing.
