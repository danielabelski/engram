# 11 · Math & STEM: The Procedure Gap, Audited

> **Status: theory first.** This document is the audit and the design; no machinery ships with it.
> It was built the way `docs/05` and `docs/06` were built — question → literature → verdict →
> design consequences traced to numbers — with one honesty difference stated up front in
> §Method. Implementation is specified in §6 and gated in §7.

The founder's question, verbatim-ish: *"Math and STEM are incredibly important and will only
grow in importance. Is Engram braced for math & STEM learning as-is? If not — is there room to
add that specialization? Should we? How? On which grounding studies?"*

The verdict, stated up front so the rest can be checked against it:

> **Engram is braced for the *conceptual* half of STEM and structurally blind to the other
> half.** Its encoding grammar — chain-of-necessity derivation, prediction-before-resolution,
> self-explanation — is close to optimal for *why-knowledge* in derivational domains; the
> founding documents said so and the strongest external validation (Kestin 2025) is literally
> a physics tutor. But STEM mastery is half *procedure* — differentiate the function, balance
> the equation, size the resistor — and Engram's ontology has no such kind. Every node is a
> declarative claim, every probe is verbal free recall, every receipt grades prose. The
> literature is blunt about what that trains: retrieval transfers at **d = 0.58 when practice
> format matches use format and d = 0.28 when it doesn't** (Pan & Rickard 2018, already
> load-bearing in `docs/07` §8). A learner who *recites how* integration by parts works has
> practiced reciting, not integrating. The fix is not a "math mode" — it is a third knowledge
> kind, `procedure`, with its own encoding ladder (worked example → completion → faded → solve)
> and its own retrieval format (fresh problem instances, spaced and interleaved, step-graded).
> Both are among the most-replicated results in all of learning science, several from
> preregistered classroom RCTs. **There is room** — the `viz` hint proved the extension
> pattern (architect declares per-node metadata, engine stores it opaquely, skills own the
> semantics) — and the same pattern carries the whole layer with near-zero engine change.
> **And we should**: Engram's audience — self-directed adults learning technical material —
> lives disproportionately in exactly the domains this gap touches.

---

## Method — and the one honesty difference

`docs/05` and `docs/06` were built with a fan-out adversarial pass: independent refute-first
voters per load-bearing claim. This document's evidence went through a lighter gauntlet:
**16 sources newly verified this session against their published abstracts, reported Ns and
effect sizes** (each flagged below as *search-verified*), plus the claims already
adversarially verified by earlier audits (flagged *house-verified*, with the doc that owns
them). Three design judgments have **no direct literature** and are labeled as engineering
inferences, not findings. Before the machinery in §6 ships, the new load-bearing claims
should get the full three-voter treatment (§7, gate G1) — the same discipline that caught
five bad gold adjudications in v0.7 applies to the theory that will justify new code.

---

## 1 · The audit: what is already braced (more than expected)

The honest starting point is that the founding documents anticipated much of this. `docs/01`
names math, physics, CS, and engineering as the home turf of chain-of-necessity encoding, and
several Tier-1 citations (Rohrer & Taylor 2007; Rohrer, Dedrick & Stershic 2015) *are* math
studies. What exists and holds:

| Capability | STEM relevance | Where it lives |
|---|---|---|
| Derivation-first encoding (`derives_from`, `why_chain`, PREDICT→STRUGGLE→RESOLVE) | The native grammar of proof and mechanism | `docs/01` P5/P8; dialogue grammar beats 1–8 |
| `arbitrary: true` → mnemonic + spacing | Notation, constants, conventions, unit systems | architect spec; grammar beat 2 |
| Threshold concepts + explorables | Limits, superposition, conjugate priors — and the sims meta-analysis (g+ = 0.62, D'Angelo/SRI 2014) is *science* simulations | `docs/06` P15 (house-verified) |
| Concreteness fading; scaffolding dial | New formalisms enter concrete-first | `docs/01` P7 |
| Pretesting; productive failure | Attempt-before-instruction is PS-I's core | `docs/01` P5 |
| Hint ladder H4 ("worked step") | A completion problem in embryo | dialogue grammar |
| Interleaved due queue across topics | The spacing half of Rohrer's program | `engram.py due` |
| Transfer probes at maturity (v0.8) | "Same idea, different clothes" | `/review` ⭐; `docs/07` §8 |
| Misconception log + hypercorrection | STEM has *canonical* misconception catalogs to feed it | grammar; `misconception add` |
| The strongest external result is a physics course | Kestin et al. 2025: ~2× active-classroom gains, AI tutor, this dialogue grammar | README (house-verified) |

None of this needs replacing. The gap is one level down.

## 2 · The gap: Engram knows two kinds of knowledge; STEM runs on three

Constitution article 5: *"Derive the derivable; memorize only the arbitrary — and the DAG
knows which is which."* Two kinds: derivable claims, arbitrary facts. The
**Knowledge-Learning-Instruction framework** (Koedinger, Corbett & Perfetti 2012, *Cognitive
Science* 36, 757–798 — *search-verified*) is the standard taxonomy here, distilled from the
same ITS tradition Engram already cites (VanLehn 2011; ALEKS), and it counts **three**:
facts, concepts, and **skills/procedures** — each with different optimal learning processes
(memory & fluency building · understanding & sense-making · **induction & refinement**) and,
critically, *different optimal instructional treatments*. Spacing-and-testing is optimal for
facts; self-explanation and sense-making for concepts; **worked examples, practice with
feedback, and refinement for procedures**. Engram implements the first two treatments
superbly and routes *everything* through them.

The cost is not hypothetical:

- **Response-format congruence.** Pan & Rickard 2018 (house-verified, `docs/07` §8): transfer
  of retrieval practice is d = 0.58 when the final test's response format matches practice,
  d = 0.28 when it doesn't. Every current probe is verbal free recall; the STEM learner's
  criterion task is solving. `docs/07` conceded this is "the sharpest critique of Engram's
  core loop" and answered with the v0.8 transfer probe — one harder question per node, *at
  maturity*. That is the right instinct applied at the wrong dose: for procedures, format
  congruence is a property every retrieval event needs, not a graduation exam.
- **The element-interactivity dispute — stated, not hidden.** van Gog & Sweller (2015)
  argued the testing effect *shrinks or disappears* as material complexity (element
  interactivity) rises; Karpicke & Aue (2015) disputed the coding and showed retrieval
  effects on complex texts (both *search-verified*; the dispute is live, and honest people
  cite both). Engram need not adjudicate it, because both camps agree on the design that
  matters here: **for high-element-interactivity procedural material, the effective
  "retrieval event" is solving the problem, and novices acquire the schema from examples
  first** (the worked-example effect is Sweller's own flagship; the retrieval-practice camp's
  own math studies — Rohrer's program, Lyle's — use *problem-solving* as the practiced act,
  never recitation). The dispute is about the wrong retrieval format. Engram currently ships
  only the wrong format for this material.
- **Skill decays *worse*, not better.** Arthur, Bennett, Stanush & McNelly 1998 (*Human
  Performance*; 189 data points — *search-verified*): substantial skill loss with nonuse,
  reaching **d ≈ −1.4 past 365 days**, and *cognitive, accuracy-based* tasks (exactly:
  procedures executed correctly) decay **more** than physical/speed tasks. A scheduler is not
  optional for procedures; Engram has the scheduler and doesn't aim it at them.

So the specialization is **not domain-flavored content** ("math mode") — it is a missing
knowledge kind. `procedure` covers `git rebase` workflows, statistical test selection, and
Vietnamese tone-mark placement exactly as it covers integration by parts. Math and STEM are
simply where its absence bites hardest, because their mastery criterion is overwhelmingly
*can-do*. This keeps the layer inside Willingham's rule as `viz` did: **the content declares
its kind; no learner label, no domain toggle.**

---

## 3 · Pillar 16 — The third kind of knowing: procedures enter by the example ladder

**Claim.** A procedure is encoded by *studying and progressively completing worked solutions*,
with self-explanation at every step, sliding to independent solving as competence is
measured — not by deriving prose about the procedure, and not by unaided solving from zero.

**Evidence — the license.**
- **Worked-example effect:** novices learn more from studying solutions than from solving
  the same problems cold — Sweller & Cooper 1985, the founding result (house-cited in
  `docs/06`); **g = 0.48** meta-analytically in mathematics (Barbieri et al. 2023,
  house-verified in `docs/06`).
- **Completion & fading beat example-problem pairs:** gradually removing worked steps
  (backward fading, completion problems) outperforms alternating full examples with full
  problems (Renkl, Atkinson, Maier & Staley 2002; Renkl & Atkinson 2004, *Instructional
  Science* — *search-verified*). The mechanism finding matters for the design: **learners
  learn most about precisely the step that was faded** — the blank is where the encoding
  happens. Adding principle-oriented self-explanation prompts to faded steps produced
  medium-to-large gains on near *and* far transfer with no extra time on task.
- **The ladder must retract on schedule:** expertise reversal is disordinal — assistance
  helps novices at **+0.505** and *harms* knowledgeable learners at **−0.428** (Tetzlaff
  et al. 2025, house-verified in `docs/06`). A ladder that never fades becomes the harm.
- **Attempt-first survives, in its lane:** problem-solving-before-instruction beats
  instruction-first for *conceptual understanding and transfer* at **g = 0.36** [0.20, 0.51]
  (53 studies, 166 comparisons; fidelity to PS-I design pushes it toward d ≈ 0.58) —
  **without cost to procedural knowledge** (Sinha & Kapur 2021, *RER* — *search-verified*).
  So the node that *introduces the concept behind* a procedure keeps Engram's native
  PREDICT→STRUGGLE grammar; the nodes that build the *skill* open with the ladder. The two
  sequences are complements, not rivals — which is exactly Yeo & Fazio's crossover
  (2019, *JEP* — *search-verified*): retrieval practice wins for stable facts/verbatim
  content, worked-example study wins for acquiring flexible procedures tested on *novel*
  problems at a delay.
- **The top rung is error-finding — gated by competence:** studying *erroneous* examples
  ("find the bug in this solution") benefits learners with prior knowledge, on far transfer,
  and harms true novices (Große & Renkl 2007 — *search-verified*); interactive find-explain-fix
  erroneous examples produced **delayed**-test advantages in the McLaren program (Adams et al.
  2014; replication n = 390 — *search-verified*). Engram already owns the perfect fuel: the
  learner's own `misconceptions.json`, plus each domain's documented error catalog (§6.7).

**Evidence — the leash.**
- Fading is titrated by *measured* state (pretest, lapses, node state) — never by "seems
  smart." The signals already exist; `docs/06`'s worked-drive gate uses them today.
- Erroneous examples come only after first independent success on the node — the Große &
  Renkl novice harm is a cliff, not a slope.
- The dispute in §2 caps the claim: we do not assert that retrieval practice is useless for
  procedures (Karpicke & Aue would object) — we assert the *acquisition* phase belongs to
  examples and the *retention* phase to solving, which both camps' own studies instantiate.

**Design consequence.** For `kind: "procedure"` nodes the dialogue grammar gains a second
opening, the **problem ladder**, replacing beats 2–4 (PREDICT/STRUGGLE/RESOLVE) when the
node's practice state is novice: (L1) worked example, learner self-explains each step's
*why*; (L2) completion — learner executes the final step(s); (L3) faded — learner fills
interior steps, chosen to be the principle-bearing ones; (L4) full solve, cold. Beats 5–8
(SELF-EXPLAIN → CONNECT → VERIFY → CLOSE) are unchanged — VERIFY's production for a
procedure node is a *worked solution to a fresh instance*, stashed and blind-graded like any
production. Concept nodes keep today's grammar byte-for-byte, including its PS-I opening.

## 4 · Pillar 17 — The problem is the probe: procedural retrieval is solving, fresh and mixed

**Claim.** A procedure node's review is *solving a novel isomorphic instance* — never
re-reciting, never the same numbers — spaced by FSRS as usual, interleaved so the learner
must *choose* the technique before executing it, and graded at step level.

**Evidence — the license.**
- **Interleaved problem practice, preregistered RCT:** Rohrer, Dedrick, Hartwig & Cheung
  2020 (*J. Educational Psychology* — *search-verified*): 787 students, 54 classes, cluster
  randomized, one-month-delayed test: interleaved 61% vs blocked 37%, **d = 0.83**
  [0.68, 0.97]. The proposed mechanism is the design rule: blocked practice *tells* you the
  strategy; interleaving forces **strategy discrimination** — which is precisely the skill
  the criterion task (a real problem, arriving unlabeled) demands. Earlier lab/classroom
  results agree (Rohrer & Taylor 2007; Rohrer, Dedrick & Stershic 2015 — house-cited).
- **Spaced retrieval in real STEM coursework:** the Lyle–Ralston program in engineering
  precalculus (Hopkins et al. 2016; Lyle et al. 2020, *Ed. Psych. Review* — *search-verified*):
  spacing the retrieval of course objectives raised long-term retention and carried into the
  *next course* (calculus); increasing the *amount* of practice without spacing did not.
  Direct license for pointing FSRS — already fitted per learner — at problem-solving events.
- **Fresh instances, not verbatim repeats:** Yeo & Fazio 2019 (*search-verified*): with
  *identical* problems, repeated solving wins (you are memorizing an answer — a fact, by
  KLI's own taxonomy); with *novel* problems at a delay, example-schema learning wins. A
  review queue that re-serves last month's exact integral is quietly converting a procedure
  back into a fact. Isomorph generation is the LLM's cheapest genuine contribution here.
- **Step-level tutoring is the ITS result:** VanLehn 2011's d ≈ 0.76 (house-cited) is
  *step-based* systems; the one large-scale effectiveness RCT of a mature math ITS (Cognitive
  Tutor Algebra I: Pane et al. 2014, RAND — *search-verified*) found **≈ +0.20** (8 percentile
  points) in year two at scale — sobering against lab numbers, and the honest ceiling to
  quote for "an ITS at scale," which is what this layer makes Engram.

**Evidence — the leash.**
- **The grader is the weak joint, and it is measurable.** LLMs are unreliable at spotting
  the *earliest wrong step* in mathematical solutions — ProcessBench (3,400 human-annotated
  cases — *search-verified*) exists because even strong models miss process errors while
  liking fluent final answers. Two consequences: (1) every deterministically checkable claim
  in a production (arithmetic, substitution-back, dimensions/units, limiting cases) must be
  checked by *execution*, not by reading — the assessor has tools; the engine stays
  network-free and math-free as constituted; (2) the v0.7 gold set must gain
  procedure-production items (right-answer-wrong-method; slip-vs-conceptual-error;
  fluent-but-wrong-step — the existing `right-answer-wrong-reason` category, transposed)
  **before** procedure receipts count toward audited retention (§7, gate G2).
- **Slip ≠ lapse — an engineering inference, labeled as such.** A wrong final answer from a
  correct method with one arithmetic slip is not the memory event FSRS's `again` models; a
  correct answer from a wrong method is worse than its grade looks. Proposed mapping
  (no direct literature located; n-of-1-testable): method absent/wrong → `lapsed`; method
  right + execution slip → `partial`, misconception log untouched; slip *pattern* recurring →
  its own log entry. This inference is consistent with Arthur et al.'s task taxonomy
  (accuracy-based cognitive skill is what decays; a transcription slip is not skill decay)
  but is not *demonstrated* by it.
- **Discrimination needs contrast, not chaos:** interleaving works where problem *types are
  confusable* (Rohrer's algebra tasks). The architect's existing `contrasts_with` edges name
  exactly these sibling sets; interleaving within a topic follows edges, not shuffling for
  its own sake.

**Design consequence.** For `kind: "procedure"` nodes, `/review` serves a **fresh instance**
generated from the node's `practice.problem_frame` (§6.2) instead of re-showing `probe`
verbatim; when two-plus due (or mature) nodes share a `contrasts_with`/`discriminates_from`
set, the session opens those items with the **naming beat**: *"which technique, and why —
then solve."* Productions are step-graded (§6.5); confidence-before-reveal, stash, blind
assessor, FSRS scheduling all unchanged. Concept and fact nodes review exactly as today.

---

## 5 · What this deliberately does not build

- **A "math mode" or domain toggle.** Kinds are declared per node by the architect from the
  content, exactly as `viz` affordance is. A domain switch would be the learning-styles
  shape wearing a lab coat.
- **MCQ problem banks.** Recognition stays banned (Constitution art. 1). A problem is free
  production *par excellence*; the one sanctioned choice-shaped beat is the discrimination
  *naming* step, which is immediately followed by open-form solving and graded on the solve.
- **CAS/SymPy in the engine.** `engram.py` stays stdlib-only, network-free, and does no
  mathematics. Verification-by-execution is the *assessor's* job with its own tools, and the
  receipts record what was executed.
- **Proof-assistant integration** (Lean/Coq). Genuinely promising for proof-based nodes,
  genuinely a different project. Proofs are graded (for now) as step productions under P17's
  leash, with the grader-reliability caveat stated at double volume.
- **Timed fluency drills.** Speed is a real dimension of fluency (KLI's memory-and-fluency
  process) but FSRS has no speed input, latency telemetry is noisy in chat, and gamified
  speed pressure collides with `docs/05`'s evidence. Logged as open, not shipped.
- **K-12 arithmetic pedagogy** (manipulatives, CRA sequences, number-sense curricula). The
  audience is self-directed adults on technical material; the K-12 literature is vast and
  mostly out of population. Nothing here claims it.
- **A math-anxiety accommodation layer.** The correlation is real (r ≈ −0.25…−0.34 across
  five meta-analyses; Barroso et al. 2021 — *search-verified*) and one cheap intervention
  (pre-test expressive writing — Ramirez & Beilock 2011) has classroom RCT support, but this
  belongs to `docs/05`'s affective machinery and deserves its own audited pass, not a rider
  on an encoding document. Open, with the citations parked.

## 6 · The machinery (proposed — nothing here ships with this doc)

The `viz` pattern, reapplied. Each piece traces to its pillar; engine involvement is listed
honestly.

| Piece | What it is | Traces to | Engine touch |
|---|---|---|---|
| **6.1 `kind` on nodes** | Architect declares `"kind": "concept" \| "procedure" \| "fact"` per node. Absent → `concept` (byte-compatible). `fact` formalizes today's `arbitrary: true` (which remains honored as an alias). | KLI (§2) | None — stored opaquely like `viz`; skills own semantics |
| **6.2 `practice` block** | On procedure nodes only: `problem_frame` (what varies / what stays across instances — the isomorph recipe), `steps` (the canonical step rubric: setup → method choice → execution → verification), optional `discriminates_from` (confusable siblings), optional `verify` (how to check an answer by execution), optional `error_bank` (seeded bugs, each tagged with its misconception). | P16, P17 | None (opaque) |
| **6.3 The problem ladder** | Grammar extension (new `_shared` section): L1 worked + self-explain → L2 completion → L3 faded (principle-bearing blanks) → L4 cold solve; rung chosen from pretest/lapses/state, faded on measured competence; erroneous-example rung unlocks after first clean solve. | P16; Tetzlaff gate; Große & Renkl gate | None |
| **6.4 Problem-as-probe at review** | `/review` on a procedure node: generate fresh instance from `problem_frame`; discrimination naming beat when a `contrasts_with`/`discriminates_from` sibling is co-due; production = the worked solution. | P17 | None (probe text is tutor-side) |
| **6.5 Step-graded receipts** | Assessor input gains `steps` as rubric; assessor must execute every checkable computation before grading; output gains `error_class: conceptual \| slip` per missed step; grade map: method-wrong → `lapsed`, slip-only → `partial`; right-answer-wrong-method capped at `partial` (mirror of the existing derivable-owes-a-why rule). | P17 leash; ProcessBench | Small: `receipt` passes `error_class` through to the receipt log (whitelist addition) |
| **6.6 Gold-set extension** | ≥ 20 adversarial procedure items in `gold/assessor-gold.jsonl`: right-answer-wrong-method, slip-vs-conceptual, fluent-wrong-step, terse-but-correct-solution. **Procedure receipts are `grader_unvalidated` until the audit passes on them** — v0.7's machinery, new rows. | P17 leash; v0.7 doctrine | `gold` command already exists; items are data |
| **6.7 Misconception seeding** | For domains with documented error catalogs (mechanics force-motion confusions; natural-number bias over fractions/decimals; sign errors in algebra), the architect (which already has WebSearch) seeds `error_bank` from the literature instead of inventing bugs. Physics grounding: misconception-confronting interactive engagement doubles FCI normalized gain (0.48 vs 0.23, n = 6,542 — Hake 1998, *search-verified*; instrument: Hestenes et al. 1992). | P16 top rung | None |
| **6.8 Kind-split telemetry** | `stats` learns `by_kind` (retention & lapse rate: concept vs procedure vs fact), same shape and same honesty rules as `stats.modality` — including the non-randomized-arms caveat *inside the payload*. Commons export whitelist gains node `kind` (one field, still no text). | Constitution art. 10 | Small: one stats block + one whitelist field + selftests |
| **6.9 Concept↔procedure pairing** | Guidance, not schema: architect links each procedure to its licensing concept via existing `requires`/`derives_from`; when both are due, `/review` serves the pair adjacently (concept recall, then the solve). | Rittle-Johnson, Schneider & Star 2015; Rittle-Johnson & Koedinger 2009 (iterating beats blocking — *search-verified*) | None |

**Invariants** (checkable, in the `docs/06` discipline):

1. **A v1.0.8 topic replays byte-identically.** No `kind` → `concept` → today's behavior,
   every beat, every payload.
2. **FSRS is untouched.** Procedure nodes carry the same state machine; what changes is what
   the *retrieval event is*, never how it schedules. (Whether fitted forgetting curves for
   procedures diverge from concepts is measurable with 6.8 — see Open.)
3. **The blind stays blind.** The assessor gains a rubric shape and an execution duty, never
   sight of the ladder rung or the tutoring dialogue.
4. **The content declares, the learner dials, receipts arbitrate** — the `viz` covenant,
   verbatim, applied to kinds.
5. **No unaudited number reaches the learner.** Procedure retention reports carry
   `grader_unvalidated` until 6.6 passes — the same gate that governs everything else.

## 7 · What remains honestly open (with its gate or its instrument)

1. **G1 — adversarial verification of this document.** The *search-verified* claims above
   (16 sources) need the three-voter refute-first pass `docs/05`/`docs/06` got before any
   code lands. A claim that dies takes its design consequence with it.
2. **G2 — the grader on procedures.** Gold extension (6.6) passes `assessor-audit`
   thresholds on procedure items, or procedure receipts stay unvalidated. Non-negotiable;
   this is v0.7's whole lesson.
3. **Does FSRS fit skills?** Arthur et al. 1998 says cognitive skill decays steeply; whether
   its curve shape matches FSRS's declarative fit is unknown. Instrument: 6.8's kind-split
   plus `refit` — the answer is in the learner's own receipts.
4. **Isomorph drift.** LLM-generated "fresh instances" can wander in difficulty, silently
   moving the ~85% setpoint. Mitigations: `problem_frame` constrains what varies; lapse-rate
   monitoring by kind (6.8). Open until measured.
5. **Slip-vs-lapse mapping** (the labeled inference in §4). Testable n-of-1 once
   `error_class` exists in receipts.
6. **Proof-grading reliability**, **timed fluency**, **math-anxiety micro-interventions** —
   parked with citations in §5, each wanting its own pass.

## 8 · The founding question, answered

**Is Engram braced for math & STEM as-is?** Half of it, genuinely: the conceptual half —
derivation chains, threshold explorables, misconception hunting, pretesting — is not just
compatible with STEM, it was *designed on* STEM examples and validated by a physics study.
The procedural half is a structural gap: there is no knowledge kind for *can-do*, so the
system converts every skill into an essay about the skill, and the congruence literature
prices that conversion at roughly half the transfer effect.

**Is there room?** Yes, by construction. The `viz` hint established the extension pattern —
architect-declared, engine-opaque, skill-owned, receipt-measured — and §6 rides it wholesale:
seven of nine pieces need zero engine change; the two that touch `engram.py` are a
pass-through field and a stats block, both selftest-sized.

**Should we?** Yes — and *bounded*. The audience is self-directed adults on technical
material; the founder's own topics (transformer internals, system design) are STEM; the
strongest effects newly verified here (d = 0.83 preregistered classroom interleaving;
g = 0.48 worked examples; spacing that carries into the next course) sit exactly on this
layer. Declining would leave Engram a system that schedules what STEM learners *say* and
never what they *do*. But bounded: no math mode, no new pedagogy, no fourth verb — one new
kind, two new pillars, the same constitution.

**How, on which grounding?** Pillar 16 (acquisition: the example ladder) on Sweller & Cooper
1985 / Barbieri 2023 / Renkl-Atkinson fading / Tetzlaff reversal / Sinha-Kapur PS-I /
Große-Renkl + McLaren erroneous examples. Pillar 17 (retention: fresh, mixed,
step-graded solving) on Rohrer 2020 / Lyle 2020 / Yeo-Fazio 2019 / Pan-Rickard congruence /
VanLehn-Pane ITS results / ProcessBench's warning about the grader. In one sentence, the
slogan gains a clause: **derive what can be derived, memorize only the arbitrary — and
practice what must be *performed*, on problems it has never seen, until the schedule says
it holds.**
