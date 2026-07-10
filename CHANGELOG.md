# Changelog

## 0.5.0 — 2026-07-10 · the visual-encoding layer — explorables audited, adaptive, and measured

The explorable engine grows up. Until now, interactive explorables fired only on
threshold nodes — which conflated *importance* with *visualizability* — the graph never
recorded which artifacts existed (the smith wrote files nothing tracked), and nothing
measured whether the medium actually works for a given learner. v0.5 fixes all three,
under a new adversarially-verified evidence base.

### Theory
- **New: `docs/06-visual-encoding.md`** — the visual-encoding audit, built the same way
  as docs/05: a fan-out research pass (27 primary sources, 135 claims extracted, the 25
  load-bearing ones each verified by three refute-first voters; 23 survived, 2 killed).
  Adds **Pillar 15 — the guided manipulable**: manipulable models carry the largest
  verified interactivity effect (simulations g+ = 0.62), but *guidance inside the
  artifact is the active ingredient* (scaffolded versions of the same simulation
  g+ = 0.60; learner control per se g = 0.05 ≈ nothing; unassisted discovery loses,
  d = −0.38), the payoff concentrates where the dynamics ARE the content
  (representational d = 0.40 vs decorative ≈ −0.05), and expertise reversal is a
  confirmed disordinal crossover (+0.505 novices / −0.428 knowledgeable, Tetzlaff 2025).
  Two refuted claims are recorded as do-not-build-on; four areas that produced no
  verifiable evidence (visual retrieval formats, n-of-1 medium methodology,
  preference-engagement value, LLM-artifact efficacy) are stated as **open questions**
  with deliberately conservative design stances.
- **Explorable Contract v2** (same seven clauses, sharpened by the audit): the
  manipulable is now explicitly *guided* — predict → act → **explain** micro-cycle
  (self-explanation g = 0.46), content-relevant degrees of freedom only, a **worked
  drive** gates the model at novice scaffold (worked examples g = 0.48; "provide
  assistance when in doubt"); no text over motion; learner advances *between* segments,
  dynamics run themselves *within* one; registration is part of clause 7. New widget:
  **feature-space navigator** (several sliders, each a dimension; one holistic output
  morphing live — the founder's draggable-face moment, now in the vocabulary).

### Engine (`scripts/engram.py`) — selftest 70 → 79
- **`artifact set|clear|list`** — explorable registration is now engine-owned like
  `fsrs`/`state`: the file must exist, paths under the state dir are stored
  home-relative, payload-supplied `artifact` values are stripped at `add-topic`, and
  registrations survive `--replace` alongside the schedule. (Fixes a real gap: built
  artifacts were invisible to the graph, so regeneration tracking and Contract clause 7
  had no data trail.)
- **Medium-stamped receipts** — every `rate`/`receipt` stamps whether the node had a
  registered explorable *at grading time*, so evidence of the encoding medium can never
  be rewritten retroactively.
- **`stats.modality`** — the honest per-learner answer to "do explorables work for ME":
  first-review recall of explorable-encoded vs dialogue-only nodes, one datum per node,
  ≥6 per arm (the n-of-1 experiment floor) before any verdict; reads
  `explorable-encoded ahead / dialogue-encoded ahead / indistinguishable /
  insufficient-data`. Also rendered as an "Encoding medium" dashboard section. This is
  the instrument the Phase-2 exit criterion (docs/04) always called for.
- **`visuals eager|threshold|off|status`** — the discoverable dial over
  `settings.artifacts`, sibling to `focus`. `eager` extends explorables beyond threshold
  nodes to any node whose *content* declares high visual affordance. Default remains
  `threshold-only`: existing users see zero behavior change.
- **`viz` node field** — the curriculum architect now declares each node's visual
  affordance (`affordance high|some|none`, `kind`, one-line manipulation `hook`);
  the engine stores it opaquely (object kept, garbage dropped with a warning).
- `due` payload now carries an `artifact` presence flag (review's re-encode path reads
  it); `doctor` notes unregistered artifact files with the exact fix command (non-failing)
  and fails dangling registrations.

### Behavior (skills + agents; defaults unchanged)
- `/learn`: explorables are now **content-triggered and learner-dialed** — threshold
  nodes as before; at `visuals eager`, also `viz.affordance: high` nodes; an explicit
  "make it visual" builds for any node at any level (autonomy override, same shape as
  "just tell me"). One **ask-once-per-topic** offer when a high-affordance node meets the
  default setting (arrow-key; "always" sets `visuals eager` with consent echoed back).
  The smith now runs **in the background** while the dialogue beats continue, registers
  what it builds, and hand-off is an arrow-key choice (open it now / homework — homework
  is the Sprint default; the two-minute floor outranks the medium).
- `/review`: the second-lapse re-encode move now knows whether an explorable already
  exists (regenerate it differently) or not (offer to build one) — background spawn,
  hand-off at the close, never mid-queue.
- `/coach`: narrates the medium comparison when it has a verdict, with its n and the
  explicit honesty that n-of-1 medium measurement is suggestive telemetry, not settled
  methodology; offers the matching `visuals` move arrow-key style, applied only on yes.
- curriculum-architect (both platforms): declares `viz` per node with an evidence leash —
  a false `high` is worse than a false `none`, because decorative interactivity reverses
  the effect (≈ −0.05).
- artifact-smith (both platforms): consumes `viz.kind`/`viz.hook`, applies the novice
  worked-drive gate, registers after writing, echoes the registration JSON in its report.

### Packaging
- Version 0.5.0 everywhere (plugin.json ×2, badges); README: science point 6, visual
  FAQ entry, CLI table rows for `visuals`/`artifact`, docs table row for docs/06,
  Discord community badge (discord.gg/temm1e); INSTALL-CODEX selftest count 79/79.

Existing users: `claude plugin marketplace update engram && claude plugin update
engram@engram`, then restart Claude Code. A v0.4 learner model self-heals; nothing
about your schedule, receipts, or defaults changes until you touch the `visuals` dial.
Optional one-time heal: `doctor` will point out any explorable built before 0.5 so you
can register it (`artifact set …`) and start counting it in the medium comparison.

## 0.4.4 — 2026-07-09 · fix the confidence picker not firing (contradiction in the oath)

0.4.3 added the imperative picker instruction but a stale line survived in the most-obeyed
section — the anti-sycophancy **oath** still read *"Confidence in the same breath as the
probe"*, which tells the tutor to ask for a number inline (the "Answer + 0-100" a user saw
on 0.4.3). It overrode the new rule. The ⚠ section and beats were updated in 0.4.2/0.4.3;
this oath line was missed.

### Behavior (dialogue grammar; no engine change)
- The oath line is replaced with **"Confidence is a picker, never a typed number"**, and
  the **reveal is now gated on it**: no canonical answer until confidence is collected via
  `AskUserQuestion` (or a volunteered number, or dismissed → null). Gating on the reveal —
  an action the tutor always performs — is the most reliable way to make the tool call fire,
  versus a standalone "please call the picker".
- Removed every remaining "answer + 0–100 / gut number" cue from probe-prompt guidance.

## 0.4.3 — 2026-07-09 · make the confidence picker actually fire

0.4.2 described the confidence picker but left the instruction too soft and framed it
as a fallback *after* a text ask — so the tutor kept asking for a typed number instead
of showing the arrow-key box. Fixed by adopting the production-grade pattern: an
imperative MUST, the explicit `AskUserQuestion(...)` call inlined in the dialogue
grammar, and no "give a number" wording left in any probe prompt.

### Behavior (grammar + skills; no engine change)
- The four-band Confidence picker (Certain 90 / Pretty sure 70 / Half unsure 50 /
  Just guessing 25) is now the **primary, mandatory** way confidence is collected —
  before the reveal, every item — with the tool's built-in "Other" for an exact number
  or skip (→ null). The tutor only skips the picker if the learner volunteered a number
  unprompted. Applied to `/learn` encode, the pretest, and `/review`.
- Verified live: the picker renders and a selection round-trips to its number.

## 0.4.2 — 2026-07-09 · confidence UX — pick, don't type

Collecting the 0–100 gut-confidence (which powers calibration and hypercorrection —
kept, because it earns its place) used to force the learner to *type a number* every
item, then nagged with a text re-ask if they skipped it. Friction the data can't afford.

### Behavior (dialogue grammar + skills; no engine change)
- **Confidence is now a one-tap pick, not a typed number.** It's offered as an optional
  add-on in the same breath as the probe (type `…, about 70` if you like). If you give no
  number, a picker (AskUserQuestion) appears **before the reveal** with four bands —
  Certain (90) / Pretty sure (70) / Half unsure (50) / Just guessing (25), plus Other for
  an exact number or skip. Dismiss → `null`, still never estimated.
- **Guardrails made explicit** so the convenience stays honest and bugless: the picker
  fires *before* feedback every time (confidence-after-answer is discarded as null); a
  picked band is the learner's own stated confidence, not an invented one; and confidence
  is *metadata, not knowledge*, so a menu is allowed there while the probe stays open
  free-recall. Applied consistently across `/learn` encode, the pretest, and `/review`.

## 0.4.1 — 2026-07-09 · discoverable Focus mode + release hygiene

Follow-up to 0.4.0: the ADHD Focus profile shipped but was undiscoverable (no README,
no clean command), and one toggle path was buggy.

### Engine
- **`focus on|off|status` command** — a first-class, discoverable wrapper over
  `model --set settings.profile=...`. Turning it on flips the ADHD profile (Sprint
  default, competence growth surfaced every review, always-on amnesty); `status` reports
  without changing anything.
- **Bug fix: `model --set <key>=null` now clears to real `None`**, not the string
  `"null"` — so turning Focus (or any nullable setting) *off* actually works. `null`/`none`
  (any case) are recognized alongside the existing int/float/bool casts.
- Selftests 68 -> **70** (the `focus` on/off round-trip; the `=null` clear).

### Docs
- **README now documents Focus mode** (FAQ entry + CLI table row) with both activation
  paths: say "I have ADHD, turn on focus mode" in `/learn`/`/coach`, or run `focus on`.
  This omission is what prompted the fix — a shipped feature nobody can find isn't shipped.
- **`RELEASE_PROTOCOL.md`** added at root: the repeatable release checklist (version-bump
  locations, selftest gate, a live dogfood test, and the merge → tag → `gh release` steps),
  written after v0.4.0 shipped with its files bumped but no git tag / release cut.
- `INSTALL-CODEX.md` selftest count corrected (68 -> 70).

## 0.4.0 — 2026-07-09 · the affective layers (motivation + wisdom)

Two new layers around the unchanged engine, for the part the first four pillars
implied but never voiced: *why the learner returns tomorrow*, and *how a wise tutor
carries them through the part where learning is supposed to hurt*. Every load-bearing
claim was assembled by an adversarial research pass (100+ searches, primary sources
fetched, each number verified by a voter told to refute it) and is cited in the new
theory doc. The design rule throughout: **surface what is already true; invent nothing.**

### Theory
- **`docs/05-affective-layers.md`** — the constitution extension. Two new pillars:
  **P13 Competence salience** (making *real* progress visible is a reward without
  gamification's risks — Harkin 2016 d=0.40; Deci/Koestner/Ryan 1999 competence
  feedback d=+0.33 for adults, but d=−0.78 when *controlling*) and **P14 The mentor
  stance** (struggle-as-encoding, absolve-don't-pity, self-generated relevance,
  return-after-absence amnesty — Silverman & Barasch 2023; D'Mello 2014; Graham 1984).
  Includes the adversarial backbone (why *not* to gamify: Sailer & Homner 2020;
  Hanus & Fox 2015; over-helpful AI harms — Bastani 2025) and the ADHD resolution.

### Engine (additive, default-safe — the FSRS core is untouched)
- **`stats.momentum`** — the deterministic core (never the model — Article 10) now
  computes a weekly competence-growth block from real receipts: reviews cleared,
  **days of durability added** (`stability_gained_7d`), genuine recalls, and the
  most-durable memory now. Purely additive to the `stats` JSON; ignored safely if unused.
- **Two self-healed settings keys:** `settings.momentum` (`on`/`off`) and
  `settings.profile` (`null`/`adhd`). A pre-0.4 model missing them is repaired on load
  (as every settings key already is) — behavior is byte-for-byte v0.3 with momentum off.
- Selftests 63 → **68** (durability arithmetic in isolation, in-window filtering, the
  no-negative-growth rule, the momentum block in `stats`, and the settings self-heal).

### Behavior (skills & dialogue grammar — prose, no new commands)
- **Naming real growth** (`/learn`, `/review`): on a genuine stability gain, one flat
  informational line from the engine's own `s_before → s_after` ("holds ~9 days now,
  up from ~2") — never a score, streak, or should-statement; silent when
  `settings.momentum=off` or the gain isn't real.
- **The mentor register** (dialogue grammar): a bounded stance fired only at specific
  moments (difficulty, lapse, return-after-absence, sagging motivation), silence by
  default. Two new lines in the anti-sycophancy oath: *encouragement is information,
  never pressure*; *after a lapse, absolve — never pity*.
- **Return-after-absence amnesty** (`/review`): a large post-gap queue is met with
  amnesty + load renegotiation and a capped catch-up choice — the highest-evidence
  Layer-2 move — instead of dumping the debt.
- **Momentum in the coach** (`/coach`): the check-in opens by *reporting* real progress
  (the intervention itself — Harkin 2016), honestly saying so when nothing grew.
- **ADHD Focus profile** (`settings.profile=adhd`): turns up dials the skills already
  read (Sprint default, immediate growth surfacing, earlier boredom response, optional
  if-then plan, always-on amnesty). No new pedagogy, no game; a declared need, honored.
- README: v0.4 science paragraph, new pillar #5, docs table entry, version → 0.4.0.

## 0.3.0 — 2026-07-06 · bulletproof-foundation hardening + Codex support

A deep hardening pass before new features: every reported bug fixed, plus a full
adversarial sweep of the boundary where LLM/human text enters the deterministic
core. Two independent security audits, two code reviews, and a QA pass fed this;
every fix is locked by a selftest (33 → **63 checks**) and re-verified live.

### Fixes for the reported issues (#1, #2)
- **FSRS-4.5 difficulty anchor corrected.** `next_difficulty` mean-reverted toward `D0(4)` (the FSRS-5 rule) under an otherwise-4.5 engine, inflating interval growth ~21% and silently undershooting the 90% retention target. Now reverts toward `D0(3)`, per the open-spaced-repetition reference. Pinned by a fixed-point selftest. (#1)
- **Evidence before state.** `apply_item` now appends the receipt *before* saving the graph, so a crash (or a bad-type confidence that made `make_receipt` throw) can only ever cost a harmless re-review — never advance mastery with no receipt. (#1)
- **`refit --force` on empty data** no longer divides by zero. (#1)
- **Corrupt state is quarantined, not discarded.** A malformed JSON file is renamed to `<file>.corrupt.<date>` and surfaced by `doctor`, instead of being silently overwritten with defaults. (#1)
- **Calibration scores partial credit correctly.** It now reads the assessor `grade` (recalled=1.0 / partial=0.5 / lapsed=0.0), not the scheduler `rating` — a `hard`/`partial` answer was being scored as a total miss, flipping the verdict to "maximally overconfident". Confidence is clamped to 0–100; a min-n floor (10) replaces definitive verdicts on thin data with `insufficient-data`; encode-time confidences are split into their own pool instead of polluting review calibration. (#2)
- **`next` is stash-aware.** It skips a node whose production is already stashed, and treats a stashed-but-ungraded prerequisite as provisionally met — so the batch-graded `/learn` flow keeps advancing instead of re-serving one node or dead-ending on a chain. Payload now carries `pending_verify` and `provisional_requires`. (#2)
- **`--add-goal`** writes the previously orphan `goals` field; long productions carry a `production_truncated` marker instead of clipping silently. (#2)

### Hardening (found in the sweep)
- **Path-traversal / arbitrary-write closed.** Topic slugs and node ids are validated at every ingress (`add-topic`, `receipt`, `--topic`), and all state writes are confined to the state dir (`report --out` too, unless `--allow-outside`); appends refuse to follow symlinks. An absolute/`..` topic could previously write attacker-controlled JSON anywhere — including a malicious `~/.claude/settings.json`.
- **Shell-injection channel removed.** The skills now pass learner text through a file or stdin (`stash add --file`, `rate --production-file`, `--json -`) and never inline it into a command; a hard rule was added to the dialogue grammar. A production (or a document being taught) containing `'` or `$(…)` can no longer execute.
- **`add-topic` no longer trusts LLM-supplied mastery.** Payload `state`/`fsrs` are ignored (the engine owns scheduling — no mastery without receipts); `--replace` now *preserves* surviving nodes' schedule and writes a `.bak` instead of wiping it; `order` is deduped and requires-cycles are flagged.
- **`model --set` can't brick the install** — it refuses to overwrite an object with a scalar and clamps known numerics (a bad `desired_retention` no longer crashes every `rate`); the learner model self-heals a deleted/mistyped subtree on load.
- **Batch receipts are atomic** — every item is validated (and every node confirmed to exist) before any is applied; the stash self-drains as receipts land.
- **Crash-proofing:** malformed dates, unknown node states, ghost `order` ids, and one corrupt graph no longer brick `topics`/`stats`/`report`/`due`/`session-start`; the session hook only ever echoes validated slugs (closing an indirect prompt-injection vector) and degrades to silence on any failure.
- **Report XSS closed** — every interpolated field (incl. `due`/`lapses`) is escaped.
- **Portability:** dropped the hardcoded personal fallback path; cross-platform dashboard open (`open`/`xdg-open`/`explorer.exe`); scoped the "nothing leaves your machine" claim (the engine never egresses; the curriculum architect uses web search on the topic/goal). `doctor` gained checks for bad states, unparseable dates, and quarantined files.

### Codex support (omni-repo)
- Engram now runs on **OpenAI Codex** from the same repo — `skills/` and `scripts/engram.py` are shared verbatim. Added `.codex-plugin/plugin.json`, `.agents/plugins/marketplace.json`, TOML ports of the three subagents (`codex/agents/*.toml`), a self-resolving SessionStart hook, `scripts/install-codex.sh`, and `INSTALL-CODEX.md`. The Claude Code path is unchanged.

### Known limitation
- Re-running the exact same `receipt --file` twice still double-applies (the settle flow clears the stash after, so the documented path is safe; batch *atomicity* is fixed). Full cross-invocation idempotence is deferred — it needs a stash-id threaded through the assessor contract.

## 0.2.0 — 2026-07-05 · release-hardening after first live dogfood

Every change below traces to something observed in a real `/learn` session.

### Integrity
- **Confidence is never invented.** The dialogue grammar and assessor now hard-require: ask in the same breath as the probe, one casual retry, then record `null`. Calibration counts only numbers the learner actually said. (Found: the tutor had estimated confidences during the first session, silently poisoning calibration.)
- **Pending-verification stash** (`engram.py stash add|list|count|clear`): learner productions are persisted to disk the moment they exist. A crashed or compacted session can no longer lose ungraded work; the session-start hook surfaces leftover items. (Found: the tutor was hand-maintaining scratch files.)

### New capabilities
- **`engram.py report`** — deterministic, self-contained HTML dashboard (per-topic mastery maps with progress bars, retention-by-strength vs. the 85% band, honest calibration, open misconceptions, next-7-days forecast; light+dark, no network, no JS). `/coach dashboard` now uses it.
- **`engram.py refit`** — coarse per-user schedule fit (v1): compares predicted vs. observed recall over ≥50 review receipts and rescales intervals via a clamped multiplier along the FSRS forgetting curve. Guarded and honest about thin data; full FSRS parameter optimization remains future work.
- **`engram.py doctor`** — state/environment diagnostics for troubleshooting installs.

### Bug fixes
- `model --add-interest` dropped all but the last value when passed multiple times in one call (argparse `append` missing). Now keeps every value.
- Streak computation returned 0 when yesterday had activity but today didn't (broken grace-day loop). Rewritten and tested.
- Receipt ids could collide within a fast batch (millisecond timestamps). Now suffixed with a monotonic sequence.

### UX
- `topic-status` renders a progress bar and plain-language legend ("retained / learning / untouched").
- Session ticket and receipt-strip display formats standardized in the dialogue grammar; per-item progress markers in `/review` (`[3/6]`).
- Park-and-resume protocol: mid-session subject changes are parked cleanly; re-anchoring is always from disk.
- Pretest capped at 3 probes (a diagnostic, not an exam); unanswered probes stay untouched without nagging.
- Session-start nudge now also surfaces ungraded pending work.

### Packaging
- MIT LICENSE (swap if you prefer another).
- `ENGRAM_ROOT` env var respected as a dev-clone fallback path in all skills.
- Selftest grown from 18 → 33 checks (stash, refit direction+guard+persistence, report self-containment, doctor, streak cases, id uniqueness, interest append, interval multiplier).

## 0.1.0 — 2026-07-05

Initial build: FSRS-4.5 deterministic core (`engram.py`, 18-check selftest), three skills (/learn, /review, /coach), three agents (curriculum-architect, assessor, artifact-smith), SessionStart hook, theory docs (foundations, prior art, architecture, roadmap), Explorable Contract.
