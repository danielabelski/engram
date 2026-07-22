# The Problem Grammar (procedure nodes — read when a node or due item carries `node_kind: "procedure"`)

Engram stays a general learn-anything system: this file activates **per node**, only when the
curriculum architect declared that node a `procedure` (a skill executed on instances — a git
workflow, a statistical test choice, an integral — as against a `concept`, which keeps the
ordinary dialogue grammar untouched). Theory: `docs/11-the-procedure-gap.md`. Everything in
the dialogue grammar still binds here — confidence integrity, stash-immediately, menus-never-
for-knowledge, the oath. This file changes only *what the practice act is*.

## Encoding a procedure node (replaces beats 2–4; beats 1 and 5–8 unchanged)

The **ladder** (worked example → solving, faded by measured competence — never by vibes):

- **L1 · worked example.** Show a complete worked solution to ONE instance (the node's
  `probe` is the canonical instance). At each step, the learner explains *why that step*
  (“what licenses this move?”) before seeing the next. Prediction-before-resolution survives
  in miniature: “what's the next move?” is asked, cheaply, before each reveal.
- **L2 · completion.** A fresh instance, worked until the last step(s); the learner executes
  the ending.
- **L3 · faded.** A fresh instance with the *principle-bearing* interior step(s) blank — the
  blank is where the encoding happens, so fade the step that carries the idea, not the
  arithmetic.
- **L4 · cold solve.** A fresh instance, nothing given.

**Rung selection** = the worked-drive signals (docs/06): failed/skipped pretest or weak
`requires` → start L1; comfortable prior exposure → start L3; a lapse at any rung drops one
rung on the next instance; a clean fast solve climbs. Never hold a competent learner at L1 —
assistance flips harmful with expertise (expertise reversal). The concept node that
*licenses* the procedure keeps the native PREDICT→STRUGGLE opening (attempt-first is for
ideas; the ladder is for execution).

**VERIFY** for a procedure node = a fresh-instance solve at the highest rung reached,
stashed verbatim as the production (their steps, their answer — note omissions factually).
The rubric in the stash entry is the node's step rubric, as authored.

## Fresh instances (the algorithmic-variant rule)

- **The unit of novelty is the ALGORITHMIC VARIANT: change the values, keep the structure
  and cover story.** At review, and from L2 up, generate from `practice.problem_frame` a
  variant whose numbers/surface values are new but whose problem class and framing are the
  node's own — that is the configuration where retrieval practice measurably beats
  re-studying examples (Yeo & Fazio 2019 exp 2, d = .89 at a week; Lyle 2022's calculus
  variants). Do NOT wander the cover story at ordinary reviews: fully re-clothed isomorphs
  erase the retention advantage and cost time — **far-transfer clothing is the
  `transfer_probe`'s job, at maturity, exactly as Engram already does it.** Never re-serve
  the stored numbers verbatim (nothing supports answer-recall as practice).
- **Compute the answer key by EXECUTION before presenting** — run the arithmetic/code
  (`python3 -c …`), never trust your own inspection; generated problems carry a measured
  ~3–5% wrong-key rate even in execution-checked pipelines, and a wrong key here becomes a
  false lapse on the learner's schedule. If the frame's `verify` says how, use it. If the
  content genuinely cannot be executed, solve it once fully in your own working notes before
  serving, and keep the instance close to the frame's bounds.
- **Stay inside the frame's bounds** — they exist to hold difficulty roughly fixed;
  difficulty drift is real and text-judged difficulty is unreliable. If the learner's lapse
  pattern says instances are drifting hard, say so and regenerate closer to the canonical
  instance.

## The discrimination beat (interleaving's active ingredient)

When a due procedure node has `practice.discriminates_from` siblings that are also due (or
mature), open the item with the **naming step**: present the fresh instance and ask *“which
technique applies here — and what in the problem tells you?”* — then the solve. Blocked
practice tells the learner the strategy; a real problem arrives unlabeled. Never turn the
naming step into a menu (it is knowledge; menus are for navigation). Two conditions carry
the effect, so honor both: **only confusable siblings** (that is what `discriminates_from`
declares — interleaving dissimilar content buys nothing), and **juxtaposition** — serve the
confusable items adjacently in the *same* session (the contrast collapses when the pair is
scattered across days; discrimination is a within-session lever, spacing a between-session
one).

## Grading a procedure production (tutor at /review; assessor everywhere else)

Before any rating: **verify the answer and every checkable intermediate by execution.**
Then locate the controlling error:

| Observed | grade | rating | `--error-class` |
|---|---|---|---|
| Method right, execution right | `recalled` | `good`/`easy` | — |
| Method right, arithmetic/transcription slip only | `partial` | `hard` | `slip` |
| **Right answer, wrong/absent method** | at best `partial` | `hard` | `conceptual` |
| Method wrong or missing, wherever the answer landed | `lapsed` | `again` | `conceptual` |

A slip is not a memory lapse — it is priced gentler (`partial`/`hard`) and never logged as a
misconception; a *recurring* slip pattern (same sign error thrice) is its own misconception
entry. Right-answer-wrong-method is the trap the grader must not fall for: the answer is not
the knowledge (the derivable-owes-a-why rule, transposed to execution). When torn between
`slip` and `conceptual`, choose `conceptual` — the flattering read (“you knew it, you just
slipped”) is the direction the schedule cannot afford.

## The erroneous-example rung (after instruction, scaffolded, never a default)

Never before the node's RESOLVE — error-finding without any instruction is where it harms.
After instruction, any learner may get one, **always in the interactive find → explain →
fix shape with feedback** (the scaffolding is what removed the prior-knowledge gate in the
replication evidence): present a worked solution seeded with ONE bug — from
`practice.error_bank` or, better, from the learner's own misconception log — and ask them
to find it, explain *why* it's wrong, and fix it. Grade the find-and-fix as an ordinary
production. Expect the payoff on *later* reviews, not this session — and expect the moment
to feel worse than it works (error-hunting measurably raises confusion while still helping
delayed learning), so frame it and don't stack two in a session. It is also the preferred
re-encode move on a second lapse. A targeted tool for misconception repair — never the
default diet (on average performance, correct examples beat error-seeded ones).

## Session shape

Procedure items cost more minutes than recall items. In Sprint mode, one procedure item is a
full session; never stack three solves to “catch up” — the two-minute floor and the mode
budget outrank completeness, exactly as everywhere else in Engram.
