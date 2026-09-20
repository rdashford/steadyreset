**PRODUCT REQUIREMENTS DOCUMENT**

**Steady Reset**

*Steady Reset is a native iPhone and Apple Watch app that helps a person
steady themselves in the 90 seconds after they get flooded, so they
respond instead of react.*

**Version:** v4 (post design and engineering review)

**Date:** September 16, 2026

**Owner:** Robert Ashford, PhD, MSW

**Status:** Draft v4 — design, iOS/watchOS, clinical, AI/backend, and
privacy review findings incorporated; ready for build planning

**Audience:** Product, design, iOS engineering, clinical content
reviewer, legal/privacy

**Contents**

*Right-click and choose Update Field (or press F9) to refresh page
numbers in Word.*

**1. Executive Summary**

Most people know what they should do when an argument with a partner
turns hot or an unanswered text sends their anxiety spiking: pause,
breathe, don't fire off the message. Almost no one can do it in the
moment, because the part of the brain that plans and reasons is exactly
the part that goes offline once the body is flooded. Existing wellness
apps assume a calm, seated user with five spare minutes. That is the
wrong moment and the wrong user.

Steady Reset is built for the other moment: heart pounding, thumbs
already typing, partner still talking. It gets the user from a Lock
Screen, Action Button, or Watch press into a body-first down-regulation
sequence in under two seconds, requires no reading or decision-making
while flooded, and only introduces words, naming, and perspective once
arousal has begun to fall. It then does the one thing most self-help
tools skip: it scripts the return. A time-out without a committed return
is avoidance; Steady Reset treats the pause and the return as one unit.

This document specifies a full-featured launch rather than an MVP. The
real-time intervention remains the product's center of gravity, and it
is surrounded by features that make the app worth opening between
crises: an AI companion you can talk to during a break and afterward, a
research-grounded daily check-in (ecological momentary assessment),
wearable biosignals via HealthKit (Apple Watch, Oura, WHOOP, Garmin and
others), partner pairing over CloudKit, hard-conversation rehearsal, and
a weekly tune-up that keeps the user's personal plan sharp. iPhone and
Apple Watch are specified side by side for launch.

The evidence base is strong for the physiological layer (exhale-emphasis
breathing, cold, paced breathing, the ~20-minute recovery window), solid
for affect labeling and self-distancing once arousal drops, and thinner
for the specific claim that a phone app delivers those benefits at the
peak of a live conflict. Section 4 grades that evidence honestly;
Section 15 commits to a post-launch outcomes study to close the gap.

> **One-line thesis:** Interrupt fast, regulate the body before the
> mind, name the feeling, reorient, and always come back.

**2. Name, Brand, and Voice**

**2.1 The name**

Steady Reset. Two plain words that describe what the user does and what
they get. 'Steady' is the verb we want in their mouth ('I need to
steady'); 'Reset' is the promise. It is approachable, memorable, and
says nothing clinical. The Siri phrase is natural ('Hey Siri, Steady
Reset'). Short forms in copy: 'Steady' as the verb, 'a reset' as the
session.

**2.2 Preliminary clearance (September 2026)**

A web-indexed search found no App Store app named 'Steady Reset' and no
'Steady Reset' mark in indexed USPTO records. Adjacent marks to be aware
of: Steady: For Parents (emotional-anchor app for hard parenting
moments, closest in concept); Steady (Steady Platform Inc., gig-work
app, registered); The Reset Button and Reset – Timer for Calm (small
somatic-calming apps); Reset4 (workday breathing resets); and a UK
coaching program called Ready Steady Reset. None is a direct collision.
Action: counsel to run a formal Class 9 and Class 42 clearance search
and file an intent-to-use application before public announcement. Secure
steadyreset.app or equivalent domain and the App Store name at first
TestFlight upload.

**2.3 Brand tone**

Steady Reset sounds like a friend who is steady when you are not. Plain
speech, second person, present tense, short sentences. It never performs
calm; it is calm.

| **We do**                                           | **We don't**                                                                   |
|-----------------------------------------------------|--------------------------------------------------------------------------------|
| Say what to do in one line: 'Long slow out.'        | Explain physiology mid-session                                                 |
| Use everyday words: hot, flooded, settle, come back | Use clinical words in the moment: dysregulated, attachment, distress tolerance |
| Praise coming back regulated                        | Praise leaving, streaks, or time in app                                        |
| Stay inside the user's body and choices             | Characterize the partner or the relationship                                   |
| Ask, when we notice a pattern                       | Diagnose or interpret                                                          |
| Use periods.                                        | Use exclamation points, emoji, or affirmations                                 |
| Tell the truth about what the evidence supports     | Say 'clinically proven' or 'treats anxiety'                                    |

**2.4 Vocabulary**

- **A reset** — any in-the-moment session.

- **Steady** — the verb; also the default down-regulation sequence.

- **A break** — the structured time-out with a return time. Never
  'time-out' in UI copy (it reads as punishment).

- **Hold** — holding a message before sending.

- **How hot** — the 1–10 arousal slider.

- **Your plan** — everything set up when calm.

- **The companion** — the AI assistant. Not 'coach,' not 'therapist,'
  not a human name.

- **Check-in** — the brief daily EMA prompt.

**3. Problem Statement and Opportunity**

**3.1 The moment we are designing for**

Three situations define the product's scope for v1. All share the same
physiology (acute sympathetic activation) and the same failure mode (an
action taken while flooded that damages a relationship the person cares
about).

- **Live disagreement with a partner or close person.** Voices rising,
  the user is about to say something they will regret or is about to
  shut down and walk out without explanation.

- **Anxiety about connection.** Unanswered message, ambiguous tone,
  perceived withdrawal. The urge is to send another text, call
  repeatedly, or demand reassurance. This is protest behavior in
  attachment terms and it is highly repetitive.

- **Personal emotional charge without a present other.** Shame spiral
  after criticism, anger after a slight, dread before a hard
  conversation. The user is alone and needs to get their footing before
  acting.

**3.2 Why existing tools miss**

- Meditation and breathing apps are designed for planned practice, not
  for a user whose working memory is gone. Onboarding, menus, and
  choices are barriers at the moment they matter most.

- Couples apps focus on communication skills taught in calm conditions;
  almost none intervene during the fight.

- Journaling and CBT apps lead with words. Reappraisal does not work
  while the body is in alarm; it works after.

- None script the return. The break becomes stonewalling, and the
  partner experiences it as abandonment.

**3.3 Opportunity**

A single-purpose, deeply native iOS app that owns one job — get
regulated and come back — can be faster, simpler, and more trustworthy
than general wellness products. iPhone and Apple Watch offer exactly the
surfaces this moment needs: the Action Button, Lock Screen and Control
Center entry points, haptics that guide breathing without looking, Live
Activities that hold a timer on the Lock Screen and in the Dynamic
Island, and opt-in heart rate from the Watch. No competitor uses these
surfaces coherently for this job, and none pairs them with wearable
biosignals, a conversational companion, and a research-grade daily
check-in.

**4. Evidence Review: What Works in the Moment**

This section summarizes the practices with the best evidence for
reducing acute emotional arousal quickly, notes how strong that evidence
is, and identifies what should not be built. The ordering matters:
interventions are grouped by when in the arousal curve they work,
because a technique that is excellent at moderate arousal can be useless
or counterproductive at peak.

**4.1 The physiology of flooding**

Gottman's couples research observed that when heart rate exceeds roughly
100 beats per minute during a relational interaction, the person enters
diffuse physiological arousal and higher-order functions — listening,
empathy, perspective-taking, problem-solving — degrade sharply. In his
lab, pausing a flooded couple for 20 to 40 minutes while they read
magazines reliably produced calmer, more respectful resumption; some
couples could not remember what they had been arguing about. The
threshold is individual (some people flood well below 100 bpm), but the
pattern is robust: reasoning while flooded produces reaction, not
response.

Two consequences drive the entire design:

1.  The user cannot be asked to think, choose, or read at the peak. The
    first intervention must act on the body.

2.  Recovery is not instant. Stress hormones take on the order of 20
    minutes to clear. A 90-second breathing exercise reduces the peak;
    it does not finish the job. The product must therefore hold a longer
    container (the time-out) and protect it from rumination, which keeps
    arousal elevated.

**4.2 Tier 1 — Body-first interventions (work at peak arousal)**

**Exhale-emphasis breathing (cyclic sighing / physiological sigh)**

A 2023 Stanford randomized controlled study (Balban et al., Cell Reports
Medicine, n≈108–114) compared three five-minute breathwork protocols
with mindfulness meditation over one month. Cyclic sighing — a full
inhale, a second short inhale to top off, then a slow extended exhale —
produced the greatest improvement in positive affect and the largest
reduction in respiratory rate, with effects growing with adherence. A
2023 meta-analysis of 26 RCTs (n=785) found breathwork reduced
self-reported stress, anxiety, and depression versus controls.
Mechanism: extended exhalation increases vagal tone and slows heart
rate; the double inhale reinflates collapsed alveoli and offloads CO2.

> **Evidence grade: Strong for daily practice; moderate for
> single-episode acute use.** The Stanford trial measured cumulative
> effects of daily practice. The acute effect of one to three
> physiological sighs is well supported mechanistically and clinically
> but has less RCT weight. The app should lead with it because it is
> fast, needs no equipment, and is safe for everyone.

**Paced (resonance) breathing, ~5–6 breaths per minute**

Slow breathing near six breaths per minute maximizes heart-rate
variability and baroreflex engagement. It is the P in DBT's TIPP skill
and the basis of HRV biofeedback, which has meta-analytic support for
stress and anxiety. Best used after the first few sighs, for two to five
minutes, as the 'settle' phase.

**Cold on the face / dive reflex (DBT TIPP — Temperature)**

Cold water on the face (or a cold pack over eyes and upper cheeks) while
holding the breath triggers the mammalian dive reflex, which rapidly
slows heart rate via vagal activation. It is a core DBT
distress-tolerance skill for exactly the 'cannot think clearly' state.
Standard clinical cautions: avoid water below ~50°F, and people with
cardiac conditions or cold sensitivity should consult a clinician first
because heart rate drops quickly.

> **Evidence grade: Strong clinical consensus, moderate trial
> evidence.** Include it as a guided option with a one-line safety gate
> in onboarding. Do not make it the default because it requires leaving
> the room and finding water; the app should treat that as a feature
> when the user is in a live conflict (it is a natural, non-hostile
> exit) and as an alternative when they are alone.

**Intense movement (TIPP — Intense exercise)**

Sixty to ninety seconds of hard movement (stairs, fast walk, wall push,
squats) burns off adrenaline and gives the fight-or-flight energy
somewhere to go. Useful when the user is alone or has already stepped
away; not the first move inside an argument.

**Orienting and sensory grounding (5-4-3-2-1, feet on floor, look around
the room)**

Grounding techniques direct attention outward to the present environment
and interrupt the threat-focused attentional narrowing. Evidence is
largely clinical (trauma-informed care, DBT, somatic approaches) rather
than RCT-based, but they are safe, fast, and work without reading: a
voice prompt to 'find something blue in the room' engages orienting
without requiring cognition.

**4.3 Tier 2 — Word-based interventions (work once arousal is falling)**

**Affect labeling ('name it to tame it')**

Putting a feeling into a word reduces amygdala activity and increases
right ventrolateral prefrontal engagement (Lieberman et al., 2007), and
labeling during exposure improved outcomes more than reappraisal in a
spider-phobia study (Kircanski et al., 2012). Naming should be
low-effort — tapping a word or saying it aloud — not journaling.
Offering a short, differentiated emotion vocabulary (hurt, scared,
ashamed, unseen, trapped) outperforms 'angry/sad' because granularity
itself predicts better regulation.

**Self-distancing**

Referring to oneself in the third person or by name ('Robert is feeling
shut out right now') and imagining the situation from a fly-on-the-wall
view reduces emotional reactivity and rumination (Kross & Ayduk). It is
cheap to implement as a scripted prompt and pairs naturally with affect
labeling.

**Cognitive reappraisal**

Reframing the meaning of the situation is among the best-supported
regulation strategies in the lab, but it is effortful and fails at high
arousal. It belongs late in the sequence, in the form of two or three
pre-written reframes the user chose while calm ('They pull away when
overwhelmed; it is not about my worth'). Do not generate novel
reappraisals in the moment.

**Values and intention anchoring**

A single question — 'What kind of partner do you want to be in the next
ten minutes?' — recruits prefrontal goals against the impulse. ACT and
DBT both use this; it is most effective as the final step before
returning to the conversation.

**4.4 Relationship-specific evidence**

**Time-outs must be structured**

Gottman and Terry Real converge on the same protocol: agree a signal or
code word in advance; announce the break rather than leaving; make it at
least 20 minutes and not more than about 24 hours; do something
genuinely calming (no rehearsing the argument, no cataloguing the other
person's faults); and return at a stated time. Unstructured exits read
as stonewalling — one of the four behaviors most predictive of
relationship dissolution — and escalate the partner.

**Repair attempts**

Small bids ('Can we start over?', 'I'm sorry, that was harsh')
de-escalate conflict, and the ability to receive them matters as much as
making them. The app should make repair language available at the return
step.

**Attachment anxiety and protest behavior**

Anxiously attached people under connection threat show a characteristic
cascade: hypervigilance to cues, catastrophic interpretation, and
protest behaviors (repeated texting, calling, demanding reassurance,
threats to leave). The behaviors relieve anxiety briefly and damage the
relationship reliably. Evidence-informed responses: delay the action
(urge surfing — urges crest and fall within roughly 15–30 minutes),
self-soothing with a rehearsed 'secure base' script, and drafting the
message without sending it. Security priming — briefly recalling a
person or memory associated with feeling safe — reduces
attachment-related distress in lab studies.

**4.5 What not to build**

- **Expressive suppression as a goal.** 'Just hold it in' increases
  physiological arousal and impairs memory of the conversation. The
  product regulates; it does not suppress.

- **Venting.** Cathartic venting (rage typing, punching pillows framed
  as release) increases anger. Movement is fine; movement framed as
  aggression is not.

- **Rumination disguised as reflection.** Open-ended journaling during
  the time-out keeps the argument alive. Any writing in the break is
  structured and brief.

- **Reasoning at peak.** No CBT thought records, no 'what's the evidence
  for this thought?' until arousal has fallen.

- **Anything that reads as blaming the partner.** Content stays inside
  the user's own body and choices.

**4.6 Ecological momentary assessment (the daily check-in)**

EMA captures experience in the moment, repeatedly, in the person's
natural environment, rather than asking them to remember a week later
(Shiffman, Stone & Hufford, 2008). Retrospective mood reports are
systematically distorted by peak and recent moments; momentary reports
are not. EMA is the research standard for studying emotion regulation in
daily life and is increasingly used inside consumer apps as a brief,
timed check-in. Design conventions with the best compliance and data
quality: two to four prompts per day at semi-random times within
user-set windows (signal-contingent), plus optional prompts tied to
events (event-contingent, e.g., after a reset); three to six items per
prompt, answerable in under 30 seconds; momentary wording ('right now'),
not 'today'; a short response window (15–30 minutes) after which the
prompt expires; and visible value back to the user, because compliance
decays fast when the data disappears into a void.

> **Evidence grade: Strong as a measurement method.** EMA's value here
> is twofold: it makes the daily check-in scientifically defensible
> rather than a mood-emoji gimmick, and it produces the data the pattern
> insights and the outcomes study depend on. Items should be drawn from
> validated short scales where possible (e.g., single-item affect grid
> or PANAS-short items, a one-item connection/closeness rating, a
> one-item urge rating).

**4.7 Wearable biosignals**

Heart rate and heart-rate variability are the best-validated wearable
markers of acute sympathetic activation; resting heart rate, overnight
HRV, sleep, and skin temperature are validated markers of recovery and
baseline load. Apple Watch, Oura, WHOOP, Garmin, Polar, and Withings all
write these data types to Apple HealthKit, which makes HealthKit the
single integration surface for a wide range of wearables without vendor
APIs. Live streaming during a session is only available from Apple Watch
(via a workout session); other wearables contribute background and
baseline data. Evidence caution: consumer HRV is noisy and
person-specific; it supports personal baselines and trends, not
thresholds applied across people, and it should never be used to tell a
user what they are feeling.

**4.8 Evidence summary**

| **Intervention**                    | **When it works**           | **Evidence strength**                               | **Role in app**                     |
|-------------------------------------|-----------------------------|-----------------------------------------------------|-------------------------------------|
| Cyclic sighing / physiological sigh | Peak arousal, first 60–90 s | Strong (RCT for daily practice); moderate for acute | Default first step                  |
| Paced breathing ~6/min              | Falling arousal, 2–5 min    | Strong (HRV biofeedback meta-analyses)              | Settle phase                        |
| Cold face / dive reflex             | Peak arousal, needs exit    | Strong clinical consensus                           | Guided alternative with safety gate |
| Intense movement                    | Peak, when alone            | Moderate                                            | Alternative                         |
| Sensory orienting                   | Peak to falling             | Clinical consensus                                  | Voice-led, no reading               |
| Affect labeling                     | Falling arousal             | Strong (neuroimaging + behavioral)                  | Tap-a-word step                     |
| Self-distancing                     | Falling arousal             | Strong (lab studies)                                | Scripted prompt                     |
| Pre-written reappraisal             | Low arousal, before return  | Strong in lab; effortful                            | User-authored when calm             |
| Structured time-out ≥20 min         | Live conflict               | Strong observational (Gottman)                      | Core container                      |
| Repair attempts                     | Return                      | Strong observational                                | Return step                         |
| Urge delay / draft-don't-send       | Connection anxiety          | Moderate (urge surfing, attachment lit.)            | Hold-the-text flow                  |
| Security priming                    | Connection anxiety          | Moderate (lab)                                      | Secure-base card                    |

**5. Operationalizing the Evidence: Design Principles**

These principles are binding on every screen and interaction. Where a
feature request conflicts with a principle, the principle wins unless
this document is revised.

**5.1 The regulation sequence**

Every in-the-moment session follows the same five-stage arc. Stages are
ordered by what the nervous system can do at each point; the app never
skips ahead.

| **Stage**         | **Goal**                              | **Duration** | **What the user does**                                                    | **What the app does**                                                                                                                                         |
|-------------------|---------------------------------------|--------------|---------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 1\. Interrupt     | Break the action chain                | 0–2 s        | One press (Action Button, Lock Screen, Watch)                             | Opens directly into Stage 2. No menu, no question.                                                                                                            |
| 2\. Down-regulate | Lower heart rate and respiratory rate | 60–120 s     | Follows haptic + voice-guided sighs, then paced breathing                 | Full-screen, dark, one instruction, large type, haptics lead. The user's chosen alternate technique sits as one visible secondary button; no hidden gestures. |
| 3\. Name          | Engage prefrontal cortex              | 15–30 s      | Taps one or two feeling words; optional third-person line                 | Shows 8–10 granular emotion words. No typing required.                                                                                                        |
| 4\. Reorient      | Widen perspective, recall intention   | 30–60 s      | Reads one pre-written reframe and one intention                           | Surfaces the user's own calm-state content. Offers secure-base card.                                                                                          |
| 5\. Return        | Re-engage or act well                 | Variable     | Chooses: return to conversation, start a timed break, or hold the message | Scripts the announcement, runs the timer, protects the break, schedules the return.                                                                           |

**5.2 Speed and zero-decision entry**

- Time from trigger to first haptic breath cue: under 2 seconds on a
  cold launch. This is a hard performance requirement, not a target.

- The default entry point launches straight into Stage 2 with the user's
  preferred technique. No 'how are you feeling?' screen first.

- Every entry surface is one physical or one on-screen action: Action
  Button, Lock Screen widget, Control Center control, Watch
  complication, Siri phrase, Back Tap (via Shortcuts).

- The app works offline entirely. No network call is on the critical
  path.

**5.3 Body before words**

- Stages 1–2 require no reading. Guidance is haptic (inhale/exhale
  patterns) plus an optional calm voice. Text is a single short line in
  very large type for users who look.

- The user can complete the entire down-regulation with the phone
  face-down in their pocket, guided by haptics alone, or on the wrist
  via the Watch. This matters in a live argument, where staring at a
  phone reads as dismissive.

- Words appear only at Stage 3 and are tap-selected, not typed.

**5.4 The pause and the return are one unit**

- Choosing 'take a break' always produces three things: a spoken or sent
  announcement to the partner, a timer of at least 20 minutes, and a
  stated return time. The user cannot start a break without a return
  commitment.

- The announcement template is pre-agreed in calm conditions and
  editable: 'I'm flooded and I'm going to take 20 minutes so I don't say
  something I don't mean. I'll be back at 7:40.' It can be spoken, or
  sent as a text or shared Watch tap if the partner has the app.

- During the break the app protects against rumination: it offers a
  calming activity, can switch on a user-created 'Break' Focus mode (iOS
  lets an app turn a Focus on via Shortcuts, but only the user can
  decide which people and apps that Focus silences, so onboarding walks
  them through creating it once), and checks in at three-quarters of the
  way through.

- At the return, the app offers repair language and a one-line
  intention. It then gets out of the way.

**5.5 Not an avoidance tool**

- Breaks are capped in the flow at 24 hours; the app schedules the
  return and nudges.

- If a user runs three or more breaks with the same person in a week
  without completing a return, the weekly reflection surfaces it
  neutrally ('You've paused four conversations with Sam this week and
  returned to one. Want to look at what's making the return hard?').

- Language never praises leaving; it praises coming back regulated.

**5.6 Sensing without diagnosing**

Steady Reset reads biosignals through HealthKit so that any wearable
that writes to Apple Health — Apple Watch, Oura, WHOOP, Garmin, Polar,
Withings and others — contributes without vendor integrations. Live
in-session heart rate comes from Apple Watch only; other devices supply
background and baseline data (resting HR, overnight HRV, sleep, skin
temperature).

- Opt-in biosignals are used for four things only: (a) showing the user
  their own live heart rate during a session (Watch); (b) optionally
  suggesting a reset when heart rate rises well above the user's own
  baseline with no motion, which the user can dismiss (Watch); (c) a
  'load today' context line built from overnight HRV, resting HR and
  sleep relative to the user's own baseline, shown in the daily check-in
  and the weekly view; and (d) before/after heart-rate change in the
  session record. The app never labels a state, never says 'you are
  flooded,' never infers mood, and never compares the user to population
  norms.

- Self-report is a single one-to-ten 'how hot' rating at Stage 3 and at
  the end, rendered as ten large tap targets (or the Digital Crown on
  Watch), not a slider, because fine motor control degrades under
  arousal. It exists for the user's own before/after, and for the
  product's core outcome metric. Biosignals sit beside it, never replace
  it.

- No passive sensing of messages, keyboard, or partner behavior. Ever.

**5.7 Pre-commitment when calm**

The app's power comes from work done before the moment. Onboarding and a
weekly five-minute 'when I'm calm' session build the personal plan the
flooded user will lean on:

- Preferred down-regulation technique and voice/haptics preference.

- Personal early-warning signs (jaw tight, going quiet, typing fast).

- Time-out announcement script and default duration.

- Two or three reframes and one intention, in the user's own words.

- Secure-base card: a person, memory, photo, or line that reliably makes
  them feel safe.

- Optional partner pairing: shared code word, partner-side 'I need a
  pause' receipt, agreed return norms.

**5.8 Connection-anxiety flow specifics**

- **Hold the text.** A drafting space that looks like Messages but
  cannot send. The draft is held for a user-set delay (default 20
  minutes). At the end, the user sees the draft alongside their 'how
  hot' score then versus now and decides: send, edit, or delete. Most
  drafts are deleted; the design should make that feel like a win.

- **Urge timer.** A visible wave that crests and falls over 15–30
  minutes, with the message 'urges peak and pass; you don't have to act
  at the peak.'

- **Secure-base priming.** One tap surfaces the user's chosen safe
  memory or person.

- **Pattern reflection.** Weekly, not in the moment: how many holds, how
  many sends, how the user felt afterward.

**5.9 Safety boundaries**

- The product is not a crisis tool and says so. If the user types or
  selects language indicating thoughts of harming themselves or fear for
  their physical safety, the app stops the regulation flow and surfaces
  the 988 Suicide and Crisis Lifeline (call/text 988) or the National
  Domestic Violence Hotline (1-800-799-7233, text START to 88788) with
  one-tap dialing, plus 911. It does not attempt to regulate through
  those moments.

- Time-out scripting assumes a relationship where a stated break is
  safe. Onboarding includes a plainly worded check ('Is it safe for you
  to say you need a break?') and routes to DV resources if the answer is
  no, without storing the answer.

- Cold-water guidance carries a cardiac and cold-sensitivity caution and
  is off by default until the user acknowledges it once.

- No clinical claims. Language is 'steady yourself,' not 'treat
  anxiety.'

**5.10 Tone and copy**

- Second person, present tense, short sentences. One instruction per
  screen.

- No cheerleading, no exclamation points, no streaks or guilt mechanics.
  A missed day is not a failure; the app is used when needed.

- Never characterizes the partner. Never uses diagnostic words (anxious
  attachment, dysregulated) in the in-the-moment flow.

**5.11 AI: useful, bounded, never on the critical path**

AI makes Steady Reset feel personal and gives users a reason to come
back, and it must never make the flooded moment slower or riskier.
Rules:

- Nothing in Stages 1–2 depends on a model call. Haptics, breathing, and
  voice guidance for fixed scripts are pre-rendered and on device.

- Where a model runs matters. Prefer on-device (Apple Foundation Models
  / Core ML) for short tasks; use private cloud inference with no
  training on user data for the companion; state which is which in the
  privacy screen.

- The companion talks like the brand: short, plain, curious. It asks
  more than it tells. It does not diagnose, does not name attachment
  styles, does not characterize the partner, does not give relationship
  verdicts, and does not tell the user what they feel.

- Crisis language overrides everything: the companion stops, hands off
  to 988 or the DV hotline, and stays quiet.

- The user owns the transcript. Retention is opt-in per conversation,
  deletable in one tap, and never used for model training.

- AI-generated content in the plan (scripts, reframes) is always shown
  as a draft the user edits and approves. Nothing generated is used in
  the moment without the user having accepted it while calm.

**5.12 Notification budget**

Check-ins, debriefs, tune-ups, biosignal suggestions, and return prompts
could add up to eight interruptions a day. They will not. A single
on-device scheduler enforces a daily budget (default four,
user-adjustable), quiet hours, and priority: return prompts and
mid-break check-ins always win; biosignal suggestions are capped at two;
EMA prompts fill what is left; tune-up is weekly. Anything that misses
the budget is dropped, not queued.

**5.13 Retention without manipulation**

The app must give users a reason to open it on an ordinary day without
resorting to streaks, guilt, or engagement bait. Every hook is either
useful information the user cannot get elsewhere (their own patterns,
their own biosignals, their own words) or preparation that makes the
next hard moment easier. The measure of a good hook is that the user
would be glad they opened the app, not that they opened it.

**6. Target Users**

General public, adults 18+, initially US English. Three personas anchor
design decisions; they are archetypes, not segments.

**Maya, 34 — the escalator**

Loves her partner, argues hot, says things she regrets within the hour.
Knows the pattern, hates it, has read the books. Needs a physical
interrupt she can trigger without her partner seeing her 'go to an app,'
and a way to leave the room that doesn't read as storming out.

**Dev, 27 — the checker**

Early in a relationship. An unanswered text at 9 p.m. becomes a
three-message spiral by 9:20 and an apology by 10. Needs something to do
with his hands and a way to delay sending that doesn't feel like
suppression.

**Carla, 51 — the shutter-downer**

Goes silent under conflict, walks away, sometimes for a day. Her partner
experiences it as punishment. She experiences it as survival. Needs a
script for announcing a break, a container for it, and a nudge to come
back.

**7. Jobs to Be Done**

1.  When I feel myself flooding in an argument, help me get my body down
    fast without needing to think, so I don't say the thing.

2.  When I need to step away, help me leave in a way my partner can
    trust, and make sure I come back.

3.  When I'm anxious about someone and want to reach out again, help me
    wait until I can tell whether I mean it.

4.  When I'm calm, help me prepare so future-me has something to grab.

5.  Over time, help me see my own patterns without being judged for
    them.

**8. Core User Flows**

**Flow A — Flooded now (live conflict)**

1.  Trigger: Action Button press, Lock Screen widget tap, Watch
    complication, or 'Hey Siri, I need to steady.'

2.  App opens full-screen into the user's default down-regulation
    (default: three physiological sighs, then 90 seconds of paced
    breathing). Haptics start immediately; voice optional; screen dims
    to a single breathing shape.

3.  One visible secondary button offers the user's pre-chosen alternate
    (cold water, movement, orienting, or sound); the full list is one
    tap further. Nothing is hidden behind a gesture.

4.  At 90 seconds: 'How hot, 1–10?' as ten large tap targets. Then 8–10
    feeling words; tap one or two. Optional: 'Say it in the third
    person' prompt.

5.  Reorient card: one pre-written reframe, one intention, secure-base
    card available.

6.  Decision: Return now (repair line offered) / Take a break (Flow C) /
    I'm okay (end).

7.  End: second 'how hot' rating. Session logged locally.

**Flow B — Anxious about connection (hold the text)**

1.  Trigger: same surfaces, or opened from within the app.

2.  Two-option screen: 'Steady my body' (jumps to Flow A step 2) or
    'Hold a message.'

3.  Hold a message: drafting canvas. User writes the text they want to
    send. Send is not available. Draft is saved and a delay timer starts
    (default 20 min; user-editable in settings, minimum 10).

4.  Urge wave visual with 'how hot' check at start. Offer: breathing,
    secure-base card, or 'do something else — I'll ping you.'

5.  At timer end: notification. Screen shows the draft, hot-then vs.
    hot-now, and three buttons: Delete / Edit / Send (opens Messages
    with draft pre-filled via share sheet; the app itself never sends).

6.  End: one-line reflection tap ('glad I waited' / 'still wanted to
    send it' / 'unsure').

**Flow C — Structured break**

1.  Announce: the user's pre-written break script appears in large type
    to read aloud, with three options: 'Show them' (a clean card the
    user can turn toward the other person: 'Robert is taking 20 minutes.
    Back at 7:40.'), 'Send as text' (opens Messages with the script
    pre-filled), and, if paired, 'Notify partner'. Return time is
    inserted automatically. A 'private break' toggle keeps this one off
    the pair.

2.  Timer starts (default 20 min; the user may shorten to 10 after a
    one-time note that 20 is the evidence-based floor; maximum 24 h).
    Live Activity on Lock Screen and Dynamic Island shows time remaining
    and return time for breaks up to 8 hours (the platform limit);
    longer breaks fall back to scheduled notifications.

3.  Protect: 'What will you do?' with three calming choices (walk,
    breathe, something with hands). Optional: turn on the user's 'Break'
    Focus for the duration. Haptic check-in at three-quarters of the
    break: 'how hot?'

4.  Return prompt at timer end: 'Ready?' with repair lines and the
    intention. 'Not yet' extends by 10 min up to the 24 h cap, and the
    app suggests telling the partner the new time.

5.  Return logged as completed or not.

**Flow D — When I'm calm (planning)**

1.  Onboarding (under 5 min) starts with a 60-second reset in the first
    minute — the user feels the haptics and hears the voice before any
    setup — then: choose default technique and alternate, build the
    break script and pick reframes and an intention (templates;
    companion drafting for Plus), set up a secure-base card, set the
    Action Button, Lock Screen widget and Control Center with guided
    deep links, create the optional 'Break' Focus, safety check,
    wearable connection, Watch pairing.

2.  Weekly 5-minute tune-up (optional notification): revisit reframes,
    add early-warning signs, review the week's sessions.

3.  Partner pairing (P1): share an invite; both agree a code word;
    partner receives break announcements and return times; no other data
    is shared.

**Flow E — Reflection**

1.  Session list with before/after 'hot' scores, feeling words, and
    return completion.

2.  Weekly view: sessions, average hot-drop, holds vs. sends, breaks vs.
    returns. Plain language, no scores or grades.

3.  Pattern note (P1): one observation a week derived from the user's
    own data, phrased as a question.

**Flow F — Talk to the companion (during a break or after)**

1.  Available from the break screen after the first 5 minutes, from the
    return step, and from the home screen. Never offered in Stages 1–2.

2.  Opens with one question, not a greeting, and the question depends on
    context. In a break it is body- and need-focused ('Where are you at,
    1 to 10?' then 'What do you need in the next ten minutes?') because
    'What happened?' invites the rehearsal a break is meant to
    interrupt. 'What happened?' is the debrief opener, after the return.
    Voice or text; voice is transcribed on device and only text is sent
    to a cloud model.

3.  The companion listens, reflects in one line, and asks one question
    at a time. Its goals in a break: keep the user from rehearsing the
    argument, help them name what they need, and help them find one
    sentence to bring back. Its goals after: understand what set them
    off, what went well, what they want next time.

4.  At the end it offers a one-line summary the user can keep, edit, or
    discard, and optionally turns it into a reframe or an early-warning
    sign in the plan.

5.  Crisis or safety language ends the conversation and routes to
    resources.

**Flow G — Debrief after the conversation**

1.  Triggered by a gentle notification about two hours after a return
    (user-adjustable, dismissible). If the user opens it and taps 'still
    talking', it reschedules quietly.

2.  Three taps: How did it go (better / same / worse)? Did you repair?
    What do you want to remember? Optional companion conversation.

3.  Debrief links to the session so the weekly view can show resets that
    led to repaired conversations.

**Flow H — Daily check-in (EMA)**

1.  Two to four prompts per day at semi-random times inside user-set
    windows (default two: late morning and evening). Delivered as a
    notification. On Watch the whole check-in is answered on the wrist
    with the Digital Crown; on iPhone the notification opens straight
    into the check-in screen (iOS notification actions cannot carry a
    1–10 rating without coarsening the data, so the Lock Screen offers
    only 'Answer now' and 'Skip'). Under 30 seconds either way. Expires
    after 20 minutes if unanswered; no nagging.

2.  Items (momentary wording): how hot right now (1–10); one emotion
    word; how connected to the people who matter (1–7); any urge you're
    holding (none / small / strong). Optional fifth item rotates weekly
    (sleep, body tension, sense of control).

3.  A 'load today' line from HealthKit baselines appears after the
    answers, never before, so it doesn't bias the report.

4.  Value back: the weekly view shows how hot and how connected moved
    across the week, when resets happened, and one companion-written
    observation phrased as a question.

**Flow I — Rehearse a hard conversation**

1.  From the home screen when calm: 'Something coming up?' The user
    describes the conversation in a sentence or two.

2.  The companion helps the user write their opening line and the one
    thing they need the other person to understand, then offers to play
    a neutral, non-adversarial counterpart for a two-minute practice. It
    never plays the real partner as hostile.

3.  Ends by saving the opening line and intention to the plan and
    offering to schedule a reset reminder before the conversation.

**Flow J — Partner pairing (CloudKit)**

1.  Invite by link; both must have Steady Reset on iPhone. Agree a code
    word together in the app.

2.  What crosses the pair: break announcements with return time, return
    confirmations, and the code word. Nothing else — no sessions,
    scores, words, transcripts, or biosignals. Stated in one sentence on
    the pairing screen. The partner's receipt ('Sam is taking 20
    minutes. Back at 7:40.') carries a 'Steady yourself too' button,
    because the partner is often flooded as well.

3.  Either partner can unpair in one tap, silently; all shared records
    are deleted. Any break can be marked private before it starts so
    that pairing can never be used to monitor. Pairing is symmetric:
    neither side sees more than the other.

**9. Feature Requirements**

Scope is a full-featured launch. 'Launch' means required for v1.0 on
iPhone and Apple Watch. 'Post-launch' is reserved for items that depend
on external factors (Android partners, additional languages, research
findings). Every requirement carries an acceptance criterion.

**9.1 Entry and launch**

| **ID** | **Requirement**                                                                                                                                                                                                                                                                                                                                                                | **Scope** | **Acceptance criterion**                                                                                                                    |
|--------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------|---------------------------------------------------------------------------------------------------------------------------------------------|
| E1     | Action Button launches directly into the default reset via App Intent (openAppWhenRun); launch path keeps SwiftData, HealthKit and network off the critical path and pre-warms the haptic engine                                                                                                                                                                               | Launch    | Cold launch to first haptic cue ≤ 2.0 s on iPhone 15 Pro or later, measured in Instruments; Back Tap Shortcut documented for non-Pro models |
| E2     | Lock Screen and Home Screen widgets: 'Steady', 'Hold a message', 'Start a break'                                                                                                                                                                                                                                                                                               | Launch    | Single tap opens the correct flow with no intermediate screen                                                                               |
| E3     | Control Center control                                                                                                                                                                                                                                                                                                                                                         | Launch    | Launches Flow A from Control Center                                                                                                         |
| E4     | Siri and App Intents phrases; all intents exposed to Shortcuts (Back Tap, automations)                                                                                                                                                                                                                                                                                         | Launch    | Phrases work with the screen locked                                                                                                         |
| E5     | Apple Watch app: complication, Smart Stack widget, Ultra Action button, full wrist-only reset, break timer, check-in via Digital Crown; single large control per screen                                                                                                                                                                                                        | Launch    | Flow A Stage 2, break start, and Flow H completable on Watch alone; complication tap to first haptic ≤ 2.5 s                                |
| E6     | Heart-rate suggestion: subscribes to HealthKit background delivery of Apple's high-heart-rate events and HR samples; prompts when HR exceeds the personal baseline by a user-set margin with no motion. Honest framing: watchOS samples HR every few minutes when still and Apple's own alert needs ~10 minutes of elevation, so this is a late nudge, never the primary entry | Launch    | Opt-in; dismissible; no state label; suppressed during workouts and sleep; ≤ 2 per day                                                      |
| E7     | Live Activity and Dynamic Island for active reset and break; breaks over 8 hours (the Live Activity limit) fall back to scheduled notifications                                                                                                                                                                                                                                | Launch    | Persists across termination; local updates only                                                                                             |

**9.2 Down-regulation (Stage 2)**

| **ID** | **Requirement**                                                                                                                                                                      | **Scope** | **Acceptance criterion**                                                                               |
|--------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------|--------------------------------------------------------------------------------------------------------|
| D1     | Physiological sigh guide, 3 cycles, haptic-led with optional AI voice                                                                                                                | Launch    | Haptic timing per Appendix A within ±100 ms                                                            |
| D2     | Paced breathing at user-set rate (default 5.5/min), 90 s default, extendable                                                                                                         | Launch    | Runs with screen off and in pocket; on Watch                                                           |
| D3     | Single-instruction UI, dark by default so the phone does not light the room, ≥ 34 pt text, UI dims after 5 s                                                                         | Launch    | 8/10 flooded-simulation participants complete without confusion                                        |
| D4     | Alternate technique as one visible secondary button (user-chosen in onboarding); full list one tap further: cold water, movement, orienting, sound. No hidden gestures in Stages 1–2 | Launch    | Each completes with one line of text at a time; discoverability verified in flooded-simulation testing |
| D5     | Cold-water and movement safety gates acknowledged once                                                                                                                               | Launch    | Hidden until acknowledgment stored locally                                                             |
| D6     | Live heart rate (Watch) shown as a number only; before/after HR saved to session                                                                                                     | Launch    | No interpretation text                                                                                 |
| D7     | Core Haptics patterns with Reduce Motion and voice-only fallbacks                                                                                                                    | Launch    | Works with Reduce Motion on                                                                            |
| D8     | Technique personalization (Plus): default reset adapts to what has produced the largest hot-drop and HR-drop for this user                                                           | Launch    | On-device; user can pin a technique to override                                                        |
| D9     | Technique library browsable when calm, with 'try it now' and 'make this my default'                                                                                                  | Launch    | All techniques have a calm-state explanation page                                                      |

**9.3 Name and reorient (Stages 3–4)**

| **ID** | **Requirement**                                                                                                     | **Scope** | **Acceptance criterion**                         |
|--------|---------------------------------------------------------------------------------------------------------------------|-----------|--------------------------------------------------|
| N1     | 'How hot' 1–10 before naming and at end, as ten large tap targets on iPhone and Digital Crown on Watch (no sliders) | Launch    | Two values per session; targets ≥ 60 pt          |
| N2     | Feeling-word grid, 8–10 shown from ~40, favorites pinned; grid order learns from use                                | Launch    | Tap-select, max two, no keyboard                 |
| N3     | Third-person prompt with on-device voice-to-text                                                                    | Launch    | Skippable                                        |
| N4     | Reorient card from the user's approved reframes and intention                                                       | Launch    | Only user-approved content appears in the moment |
| N5     | Secure-base library: multiple cards (people, photos, memories, a voice note from someone safe)                      | Launch    | One tap from Stage 4, Flow B, and the break      |

**9.4 Return, break, and hold (Stage 5)**

| **ID** | **Requirement**                                                                                                                                                                                                                                                                                              | **Scope** | **Acceptance criterion**                                                                    |
|--------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------|---------------------------------------------------------------------------------------------|
| R1     | Break requires a return time; default 20 min; user may shorten to 10 after a one-time note that 20 is the evidence floor; maximum 24 h                                                                                                                                                                       | Launch    | Return time cannot be skipped                                                               |
| R2     | Break announcement in large type with 'Show them' card (turn the phone toward the other person), 'Send as text' (Messages pre-filled via sms: URL), 'Notify partner' if paired, and a 'private break' toggle                                                                                                 | Launch    | App does not send messages itself                                                           |
| R3     | Break timer Live Activity with return time                                                                                                                                                                                                                                                                   | Launch    | Survives termination                                                                        |
| R4     | Mid-break haptic check-in at 75% of duration                                                                                                                                                                                                                                                                 | Launch    | Time-sensitive local notification; counts against the daily budget but always wins priority |
| R5     | Return prompt with repair lines and intention; 'Not yet' extends and suggests notifying partner                                                                                                                                                                                                              | Launch    | Extensions logged                                                                           |
| R6     | 'Break' Focus: guided one-time creation of a user Focus mode in onboarding; the app turns it on for the break duration via Shortcuts/App Intents and off at return. (iOS Focus Filters only govern an app's own content; no app can hide another app's thread, so the user decides what the Focus silences.) | Launch    | Off by default; user-configured; never required                                             |
| R7     | Hold a message: no-send canvas, delay timer (default 20, min 10), draft + hot then/now at end                                                                                                                                                                                                                | Launch    | Send hands off to Messages only                                                             |
| R8     | 'Say what you mean' rewrite (Plus): companion offers a calmer version of a held draft alongside the original                                                                                                                                                                                                 | Launch    | User chooses; original never altered silently                                               |
| R9     | Urge wave visual                                                                                                                                                                                                                                                                                             | Launch    | Respects Reduce Motion                                                                      |
| R10    | Partner pairing over CloudKit (CKShare + subscriptions for push): code word, break announcements, return confirmations; partner receipt includes 'Steady yourself too'; per-break private toggle; symmetric and silently revocable                                                                           | Launch    | Only those three record types are shared; receipt delivered ≤ 30 s p95                      |
| R11    | Multiple relationship profiles (partner, parent, sibling, coworker) each with own script and reframes                                                                                                                                                                                                        | Launch    | Reset can be tagged to a profile in one tap                                                 |

**9.5 Companion (AI)**

| **ID** | **Requirement**                                                                                                                                                                                                                                | **Scope** | **Acceptance criterion**                                                                                                                        |
|--------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------|-------------------------------------------------------------------------------------------------------------------------------------------------|
| C1     | Conversational companion by voice or text, available after 5 min into a break (need-focused opener), at return, in debrief ('What happened?'), and from home; streaming text replies with optional spoken playback                             | Launch    | Never reachable from Stages 1–2; first token ≤ 1.5 s p95 on cellular                                                                            |
| C2     | Companion behavioral contract per Section 10, enforced by system prompt plus an output check for the 'never' list and an on-device crisis pre-check before any text leaves the device                                                          | Launch    | Red-team suite passes at ≥ 98% on automated judge and 100% on the crisis subset by human review; clinician review of consented beta transcripts |
| C3     | Companion summarizes a conversation into one line the user can keep or turn into a reframe / warning sign                                                                                                                                      | Launch    | Nothing saved without user tap                                                                                                                  |
| C4     | Draft generation in planning: break scripts, reframes, intention, opening lines, in the user's own voice from examples they give                                                                                                               | Launch    | Always shown as editable draft                                                                                                                  |
| C5     | Hard-conversation rehearsal with a neutral counterpart                                                                                                                                                                                         | Launch    | Counterpart never hostile; ends with saved opening line                                                                                         |
| C6     | Weekly observation phrased as a question, computed on device from sessions, check-ins, and biosignal baselines; biosignal values never leave the device, so cloud models only ever see the finished sentence if the user chooses to discuss it | Launch    | No verdicts; user can mute a topic                                                                                                              |
| C7     | AI voice for all guidance; one voice in the free tier, up to three in Plus at launch; voices delivered as on-demand resources so more can be added without an app update; fixed scripts pre-rendered                                           | Launch    | Fixed scripts play offline; Plus voices download on selection; user text rendered at approval time and cached                                   |
| C8     | Transcript controls: per-conversation retention opt-in, one-tap delete, export                                                                                                                                                                 | Launch    | Deleted means gone from device and cloud                                                                                                        |

**9.6 Check-in, biosignals, planning, and reflection**

| **ID** | **Requirement**                                                                                                                                                                                                                                                                                                                           | **Scope**            | **Acceptance criterion**                                               |
|--------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------|------------------------------------------------------------------------|
| K1     | EMA daily check-in: 2–4 semi-random prompts in user windows, 4–5 momentary items, ≤ 30 s, 20-min expiry; answered on the wrist via Digital Crown or on iPhone via a notification that opens straight into the check-in; rolling 7-day schedule refreshed on launch and background refresh to stay under the 64-pending-notification limit | Launch               | Median completion ≤ 25 s; no repeat nags                               |
| K2     | Event-contingent check-in after a reset and after a return                                                                                                                                                                                                                                                                                | Launch               | Optional; one tap to dismiss                                           |
| K3     | HealthKit read: heart rate, HRV (SDNN), resting HR, respiratory rate, sleep, wrist/skin temperature, from any writing source                                                                                                                                                                                                              | Launch               | Works with Oura, WHOOP, Garmin, Polar, Withings data present in Health |
| K4     | Personal baselines (rolling 14- and 28-day) and 'load today' line; no population norms                                                                                                                                                                                                                                                    | Launch               | Computed on device                                                     |
| K5     | Optional HealthKit write: Mindful Session for each reset                                                                                                                                                                                                                                                                                  | Launch               | Off by default                                                         |
| K6     | Onboarding ≤ 5 min: template-based plan setup for all users, companion-drafted plan for Plus, entry-point setup, safety check, wearable connection                                                                                                                                                                                        | Launch               | Median ≤ 5 min in testing; no inference in the free path               |
| K7     | Weekly tune-up (5 min): review week, refresh reframes and warning signs, add secure-base items, rehearse if something's coming                                                                                                                                                                                                            | Launch               | Optional notification                                                  |
| K8     | History and weekly view in plain language: hot-drop, holds vs sends, breaks vs returns, repaired conversations, check-in trends, load                                                                                                                                                                                                     | Launch               | No scores, grades, streaks, badges                                     |
| K9     | Post-conversation debrief (Flow G)                                                                                                                                                                                                                                                                                                        | Launch               | Links to session                                                       |
| K10    | Export (PDF/CSV) of history and check-ins; share with a clinician if the user chooses                                                                                                                                                                                                                                                     | Launch               | User-initiated only                                                    |
| K11    | iCloud sync via private CloudKit database, opt-in                                                                                                                                                                                                                                                                                         | Launch               | Health data excluded from sync                                         |
| K12    | Crisis-language detection in all free-text and voice fields (on-device phrase list for all tiers; on-device model classification added for Plus); soft routing that shows resources and lets the user continue                                                                                                                            | Launch               | On device; runs before any cloud call                                  |
| K15    | Notification budget: single scheduler with daily cap (default 4), quiet hours, and fixed priority (return and mid-break \> biosignal suggestion ≤ 2 \> EMA \> tune-up)                                                                                                                                                                    | Launch               | No day exceeds the cap in testing; dropped prompts are not queued      |
| K16    | Watch–iPhone session reconciliation via WatchConnectivity: a reset started on either device appears once in history with the richer record kept                                                                                                                                                                                           | Launch               | No duplicate sessions in cross-device testing                          |
| K13    | Localization scaffolding; English (US) at launch; Spanish next                                                                                                                                                                                                                                                                            | Launch / Post-launch | Strings externalized                                                   |
| K14    | Android partner app for pairing                                                                                                                                                                                                                                                                                                           | Post-launch          | Requires backend                                                       |

**10. The AI Layer: Features and Guardrails**

**10.1 What AI is for in Steady Reset**

AI does four jobs: it speaks (voice guidance), it listens (the
companion), it drafts (plan content in the user's voice), and it notices
(personalization and weekly observations). It does not decide anything
in the flooded moment, and it does not interpret the user to themselves.

**10.2 Voice**

- All spoken guidance is AI-generated speech. The free tier ships one
  voice; Plus offers up to three at launch, packaged as on-demand
  resources so new voices can be added later without an app update.
  Fixed scripts (techniques, break prompts, safety copy) are rendered at
  build time and bundled so they work offline and instantly.

- User-authored text (reframes, intention, secure-base lines, break
  script) is rendered when the user approves it and cached, so the
  moment never waits on synthesis.

- Voice character: unhurried, low, plain. No performance of warmth.

**10.3 The companion**

A conversational assistant the user can talk to by voice or text. Its
behavioral contract:

- Opens with a question, not a greeting. One question at a time. Short
  reflections.

- Goals by context. In a break: prevent rehearsal of the argument, help
  name the need, find one sentence to bring back. At return: offer a
  repair line. In debrief: what set you off, what worked, what next
  time. When calm: help build the plan and rehearse.

- Never: diagnoses; names attachment styles or disorders; characterizes
  the partner; gives verdicts on the relationship; tells the user what
  they feel; encourages leaving or staying; keeps the user talking when
  they are ready to go back.

- Always: hands off on crisis or safety language and stays quiet
  afterward; says when it doesn't know; treats the user's words as the
  source of truth.

- Implementation: hybrid by default. Short tasks (summaries, rewrites,
  observation sentences) run on device where quality allows; open-ended
  companion conversation uses a cloud model through standard API access
  via the app's backend proxy, under the provider's no-training terms.
  Steady Reset handles general wellness data, not PHI, so no HIPAA
  business-associate arrangement is required; what is required is plain,
  accurate end-user disclosure of what is sent, to whom, and for how
  long (see 10.6). Phase 0 evaluates whether on-device models are good
  enough to carry the companion alone.

- On-device-only mode: a single toggle for privacy-focused users that
  keeps every AI feature on the device. The companion still works with
  reduced range; the app states the trade-off in one sentence when the
  toggle is set.

- Context packet: what the companion is allowed to know. Always: the
  brand contract, the active relationship profile name, the user's plan
  (script, reframes, intention, warning signs), and the current
  session's hot ratings and decision. With consent: one-line summaries
  of the last five sessions and debriefs. Never: raw biosignals,
  check-in histories, transcripts of other conversations, or anything
  about the partner beyond the profile name.

- Fair use: Plus includes a generous daily conversation cap (engineering
  to set from cost modeling; not user-visible unless reached), so cost
  never forces a degraded experience.

- Testing: a red-team suite of at least 200 prompts covering
  diagnosis-seeking, partner-blaming, crisis, manipulation attempts, and
  abuse scenarios, plus clinician review of a consented sample of
  anonymized beta transcripts.

**10.4 Drafting in the user's voice**

- In onboarding and tune-up the companion asks two or three questions
  and drafts a break script, reframes, and an intention in the user's
  own idiom. The user edits and approves. Nothing unapproved reaches the
  moment.

- 'Say what you mean' rewrite of a held message, shown beside the
  original, never replacing it.

- Rehearsal: the companion plays a neutral counterpart, never a
  caricature of the real person, and never escalates.

**10.5 Noticing**

- Technique personalization: on-device ranking of which reset produced
  the largest hot-drop and HR-drop for this user, used to set the
  default. Transparent and overridable.

- Weekly observation: one sentence, phrased as a question, from the
  user's own sessions, check-ins, and baselines. No causal claims. User
  can mute topics.

- EMA prompt windows adapt to when the user actually answers.

**10.6 Guardrails summary**

| **Guardrail** | **Requirement**                                                                                                                                                                        |
|---------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Critical path | No model call in Stages 1–2; fixed voice bundled                                                                                                                                       |
| Data          | No training on user data; transcripts opt-in, deletable, exportable; biosignals never leave the device                                                                                 |
| Behavior      | Contract in 10.3 enforced by system design and tested by red-team suite                                                                                                                |
| Safety        | Crisis routing preempts the companion everywhere                                                                                                                                       |
| Consent       | Every AI feature has a plain-language toggle; on-device-only mode; the app is fully usable with AI off                                                                                 |
| Transparency  | Privacy screen and first-use disclosure state which features run on device, which use a cloud model, what is sent, the provider's retention terms, and how to switch to on-device-only |

**11. Wearables and HealthKit**

**11.1 Integration model**

HealthKit is the single integration surface. Any wearable whose
companion app writes to Apple Health contributes without a vendor API:
Apple Watch (native), Oura, WHOOP, Garmin (via Connect), Polar,
Withings, and others. Fitbit does not write to HealthKit natively and is
out of scope. Live in-session streaming is Apple Watch only, via a
workout session on the Watch app.

**11.2 Data types read (all opt-in, granular)**

| **Type**                          | **Source**                                  | **Used for**                                        |
|-----------------------------------|---------------------------------------------|-----------------------------------------------------|
| Heart rate (live)                 | Apple Watch during a reset                  | Number on screen; before/after; suggestion trigger  |
| Heart rate variability (SDNN)     | Watch, Oura, WHOOP, Garmin, Polar, Withings | Personal baseline; 'load today'; weekly view        |
| Resting heart rate                | Same                                        | Baseline; load                                      |
| Respiratory rate                  | Watch (sleep), some rings                   | Baseline; optional confirmation of slowed breathing |
| Sleep analysis                    | Any                                         | Load; weekly observations                           |
| Wrist / skin temperature          | Watch, Oura                                 | Load (deviation from baseline)                      |
| Mindful Session (write, optional) | Steady Reset                                | Lets the user see resets in Health                  |

**11.3 Rules**

- Baselines are personal (rolling 14- and 28-day medians); no population
  thresholds or scores.

- Biosignals never generate a label. 'Your heart rate is 112' is
  allowed; 'you're anxious' is not.

- Biosignal suggestions are rate-limited (max two per day), suppressed
  during workouts and sleep, and dismissible with a 'not now' that
  teaches the model.

- All computation on device. HealthKit data is excluded from iCloud sync
  of app data.

- Purpose strings and the App Privacy label describe exactly this use;
  no advertising or sale of health data, ever.

**12. iOS and watchOS Architecture**

**12.1 Platform targets**

- iPhone and Apple Watch built and launched side by side. Shared Swift
  package for models, plan logic, technique timing, baselines, and EMA
  scheduling; SwiftUI on both.

- Minimum deployment: current iOS/watchOS major minus one at launch,
  confirmed against Apple's fall 2026 releases. Action Button requires
  iPhone 15 Pro or later; widgets and Control Center are the equivalent
  on other models.

- iPad runs the iPhone layout. No Android or web at launch; Android
  partner pairing is the only planned non-Apple work and requires a
  backend (Post-launch).

**12.2 Frameworks and surfaces**

| **Capability**                                   | **Framework / API**                                                                                                                                                                                                          | **Notes**                                                            |
|--------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------|
| Action Button, Siri, Shortcuts, Control Center   | App Intents, WidgetKit controls                                                                                                                                                                                              | Intents run with device locked                                       |
| Widgets (iPhone, Lock Screen, Watch Smart Stack) | WidgetKit                                                                                                                                                                                                                    | Launch widgets; check-in widget                                      |
| Reset and break on Lock Screen / Dynamic Island  | ActivityKit                                                                                                                                                                                                                  | Local updates only                                                   |
| Haptics                                          | Core Haptics (iPhone); WKInterfaceDevice haptics (Watch)                                                                                                                                                                     | Custom AHAP patterns; fallbacks                                      |
| Voice playback                                   | AVFoundation; bundled AI-rendered audio (one free voice) and on-demand-resource voice packs (Plus); cloud TTS for user text at approval time; AVSpeechSynthesizer fallback in on-device-only mode (lower quality, disclosed) | Ducks other audio                                                    |
| Companion                                        | Cloud model via app backend proxy (App Attest device attestation, StoreKit entitlement check, per-user rate limits and a fair-use daily cap); on-device foundation models for summaries/rewrites; streaming responses        | No API keys in the client; free tier has no route to the proxy       |
| Speech to text                                   | Speech framework, on-device recognition                                                                                                                                                                                      | Transcripts local unless opted in                                    |
| Biosignals                                       | HealthKit read with background delivery (HR, HRV, high-heart-rate events); HKWorkoutSession (mind-and-body type) on Watch for live HR during a reset                                                                         | Granular authorization per type; workout session ends with the reset |
| Screen                                           | idleTimerDisabled during session                                                                                                                                                                                             |                                                                      |
| Check-ins and returns                            | UserNotifications, time-sensitive interruption level; EMA scheduler in shared package                                                                                                                                        | Entitlement required                                                 |
| Message hand-off                                 | Share sheet, Messages URL scheme                                                                                                                                                                                             | App never sends                                                      |
| Partner pairing                                  | CloudKit shared database (CKShare) with CKQuerySubscription for push receipts                                                                                                                                                | Three record types only                                              |
| Persistence and sync                             | SwiftData; private CloudKit database (opt-in)                                                                                                                                                                                | Health data excluded                                                 |
| 'Break' Focus                                    | User-created Focus mode; app toggles it via App Intents / Shortcuts                                                                                                                                                          | Off by default; Focus Filters govern only this app's own content     |
| Purchases                                        | StoreKit 2                                                                                                                                                                                                                   | No prompts in Flows A–C or during a break                            |
| Accessibility                                    | VoiceOver, Dynamic Type, Reduce Motion, Assistive Access                                                                                                                                                                     | Full support at launch                                               |
| Research build                                   | Separate scheme/flag; export of consented, de-identified EMA and session data                                                                                                                                                | See Section 15                                                       |

**12.3 Data model**

- Plan: technique preferences, voice, break defaults, relationship
  profiles\[\] (name, script, reframes\[\], intention, code word),
  secure-base items\[\], warning signs\[\], word favorites\[\], safety
  acknowledgments, wearable authorizations, EMA windows.

- Session: timestamps, entry surface, profile, technique, hot
  before/after, HR before/after, words, third-person line, decision,
  break duration and extensions, return completed, debrief outcome.

- Hold: draft, rewrite (if generated), delay, outcome, reflection.

- CheckIn (EMA): prompt time, response time, items, load-line inputs
  (derived, not raw Health data).

- Conversation (companion): transcript (only if opted in), summary line,
  saved artifacts.

- Baseline: rolling metrics per data type, computed daily on device.

**13. Non-Functional Requirements**

**13.1 Performance**

- Trigger to first haptic cue: ≤ 2.0 s p95, iPhone and Watch.

- Flows A, B, C, H fully functional offline. Companion degrades
  gracefully offline (offers breathing, secure base, and a note to
  self).

- Haptic/audio drift ≤ 100 ms over 5 minutes.

- Companion first response ≤ 2.5 s p95 on cellular.

- 20-minute break with Live Activity and check-in ≤ 2% battery on
  current iPhone; a wrist reset including the live-HR workout session ≤
  1.5% on current Watch.

**13.2 Accessibility**

- Every flow completable with VoiceOver alone, haptics alone, or voice
  alone.

- Largest accessibility text size without truncation in Stages 2–4;
  Reduce Motion alternatives; contrast ≥ 4.5:1; no color-only meaning.

**13.3 Privacy and security**

- Default: data stays on device. iCloud sync opt-in. Companion requests
  go to private inference with no retention beyond the request unless
  the user opts to keep the transcript, which then lives in their
  private CloudKit database.

- No third-party analytics SDKs. First-party, opt-in, aggregate
  analytics with a plain-language toggle.

- App Privacy label: the free tier collects nothing. Because Plus sends
  companion text to a cloud model, the label must declare User Content
  (linked to an account identifier) for that feature; it must never need
  to declare Health data, which is why biosignal values are
  architecturally barred from leaving the device.

- Health data never leaves the device except through the user's own
  Health sync; never used for advertising; never sold.

- Optional Face ID lock for history, transcripts, and check-ins.

- Safety-check answers, crisis-detection events, and deleted drafts are
  never persisted.

- Research participation is a separate, revocable consent (Section 15).

**13.4 Reliability**

- Session and break state survive termination and restart on both
  devices; Watch and iPhone reconcile if both were used.

- Crash-free sessions ≥ 99.8% as a launch gate.

**14. Safety, Clinical Review, and Legal**

- **Not a medical device.** General wellness; no diagnosis or treatment
  claims. Copy reviewed against FDA general wellness guidance and FTC
  substantiation rules. Companion outputs are covered by the same rule
  and tested for it.

- **Clinical content review.** A licensed clinician with DBT or couples
  expertise reviews scripts, technique instructions, safety copy, the
  feeling-word set, EMA items, and a sample of companion transcripts
  before launch and on content changes.

- **Crisis routing.** 988 Suicide and Crisis Lifeline and the National
  Domestic Violence Hotline (1-800-799-7233; text START to 88788)
  reachable within two taps from any screen; on-device crisis-language
  detection in text and voice; the companion stops and routes.

- **Intimate partner safety.** Safety check in onboarding; DV resources
  everywhere; copy never assumes the partner is safe; pairing can be
  dissolved unilaterally and silently by either party.

- **Physical safety.** Cold-water and intense-movement cautions (cardiac
  conditions, cold sensitivity, pregnancy, injury) with one-time
  acknowledgment.

- **AI-specific.** Disclosed as AI on first use; no human name or
  persona; behavioral contract in Section 10.3; red-team suite; user
  controls over transcripts.

- **Age.** 17+ rating; terms require 18+.

- **Trademark and legal.** Formal clearance and intent-to-use filing for
  STEADY RESET (Classes 9, 42); terms, privacy policy, HealthKit purpose
  strings, and research consent drafted with counsel.

**15. Research and Outcomes Study**

The evidence for acute, single-session efficacy of app-delivered
regulation during live conflict is thinner than for daily practice.
Steady Reset will help close that gap and, in doing so, earn stronger
claims.

The study itself is a post-launch activity using existing relationships.
The work at launch is to build so that no refactor is needed when it
starts.

**15.1 Built-in research readiness (Launch)**

- The EMA check-in uses validated single items so its data can serve as
  study outcomes without redesign.

- A research build flag enables a separate, revocable consent flow and
  export of de-identified session, check-in, and baseline data to a
  study partner. Nothing is exported without that consent.

- Session records capture the pre/post measures a study needs: hot
  before/after, HR before/after, return completion, debrief outcome.

- Stable, versioned schemas for Session, CheckIn, Hold, and Baseline,
  with a per-user pseudonymous research ID generated only on consent; an
  append-only event log (reset started, technique changed, break
  started, return, hold outcome, check-in answered) alongside the
  summary records; consent versioning so a protocol change can
  re-consent without migration; and an export format (CSV and JSON with
  a data dictionary) defined now and covered by tests.

- Researcher-facing needs are limited to that export; no in-app study UI
  is built until a protocol exists.

**15.2 Study outline (post-launch, for planning only)**

- Partner: an existing university relationship; IRB through the partner.

- Design: within-person pre/post across real resets (hot-drop, HR-drop,
  return completion) plus a 4-week EMA panel comparing weeks with and
  without app use; optional waitlist-control arm for new users.

- Primary outcomes: change in momentary arousal from reset start to end;
  return completion; conflict outcome in debrief. Secondary: EMA
  connection ratings, hold outcomes, weekly negative affect.

- Timeline: protocol drafted during beta; recruitment from consenting
  users in the first quarter after launch; preprint within a year.

- Use of results: substantiates copy such as 'in a study of N users, a
  reset lowered self-rated intensity by X on average' and informs
  technique defaults.

**16. Success Metrics**

| **Metric**                 | **Definition**                                                           | **Target**               |
|----------------------------|--------------------------------------------------------------------------|--------------------------|
| Time to first cue          | Trigger to first haptic cue                                              | ≤ 2.0 s p95              |
| Down-regulation completion | Stage 2 sessions running ≥ 60 s                                          | ≥ 75%                    |
| Hot drop                   | Median hot-before minus hot-after                                        | ≥ 3 points               |
| HR drop (Watch users)      | Median bpm change start to end of reset                                  | ≥ 10 bpm                 |
| Return completion          | Breaks with logged return in committed window (with extensions)          | ≥ 70%                    |
| Repaired conversations     | Debriefs marked 'better' or 'repaired'                                   | ≥ 50% of debriefs        |
| Hold outcome               | Held messages deleted or edited                                          | ≥ 60%                    |
| Check-in compliance        | EMA prompts answered                                                     | ≥ 60% over first 4 weeks |
| Companion usefulness       | Conversations ending with a saved line or 'that helped' tap              | ≥ 55%                    |
| Return use                 | Users with a real reset or check-in in weeks 2–4 after install           | ≥ 45%                    |
| Pairing adoption           | Users with an active pair at 60 days                                     | ≥ 15%                    |
| Crash-free sessions        | Standard                                                                 | ≥ 99.8%                  |
| Qualitative                | 'I used it in a real fight and it helped' as a recurring interview theme | Before launch            |

*Explicitly not metrics: daily actives, streaks, session length, time in
app, or companion message volume.*

**17. Business Model**

- Free, permanently: every in-the-moment flow (reset, break, hold), the
  default technique set with one voice, one relationship profile,
  template-based plan setup (break script, two reframes, one intention
  chosen and edited from templates), the daily check-in, and full
  history. No model inference runs in the free tier. The moment is never
  paywalled and never interrupted by an offer.

- Steady Reset Plus (annual, monthly, lifetime): everything that uses AI
  — the companion, drafting in your own voice, 'say what you mean'
  rewrites, hard-conversation rehearsal, weekly observations, technique
  personalization — plus up to three voices, unlimited profiles and
  reframes, partner pairing, wearable baselines and 'load today', Focus
  filter, export, and iCloud sync. Features are gated, not degraded: a
  free user sees what Plus does and why.

- No ads. No data monetization. The free tier stays complete enough that
  a user in crisis is never blocked.

**18. Release Plan**

| **Phase**                      | **Scope**                                                                                                                                                                                                              | **Exit criterion**                                                                                                  |
|--------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------|
| 0\. Foundations (weeks 1–5)    | Clinical content drafted and reviewed; haptics and bundled AI voice prototyped on iPhone and Watch; App Intents cold-launch path proven; companion contract and red-team suite written; trademark clearance and filing | ≤ 2 s to first cue on both devices; clinician sign-off; contract and suite approved                                 |
| 1\. Private alpha (weeks 6–12) | Flows A, C, D, H end-to-end on iPhone and Watch; Live Activities; widgets; Control Center; safety routing; HealthKit read and baselines                                                                                | 25 testers with Watch; 8 moderated real-conflict debriefs; no launch-blocking defects                               |
| 2\. Beta (weeks 13–20)         | Flows B, E, F, G, I, J; companion live; drafting and rehearsal; pairing; Break Focus; export; accessibility audit; research consent flow; App Store assets; legal review                                               | TestFlight 300 users; return completion ≥ 60%; check-in compliance ≥ 55%; red-team pass; accessibility audit passed |
| 3\. Launch (weeks 21–23)       | All Launch-scope items; subscription live; research export verified against the data dictionary                                                                                                                        | Section 16 gates met                                                                                                |
| 4\. Post-launch (months 6–12)  | Spanish; study recruitment; Android partner pairing (backend); technique additions from study data                                                                                                                     | Study enrolled; Spanish shipped                                                                                     |

Team: product lead (owner); two iOS engineers (one with watchOS depth)
from week 1; one designer with sound and haptics sensibility; one
AI/backend engineer for the companion proxy and voice pipeline; contract
clinician; counsel. Research partner engaged post-launch.

**19. Risks and Mitigations**

| **Risk**                                                         | **Impact**              | **Mitigation**                                                                                                                  |
|------------------------------------------------------------------|-------------------------|---------------------------------------------------------------------------------------------------------------------------------|
| Users don't remember the app when flooded                        | Core failure            | Physical entry points on both devices; onboarding rehearsal; weekly tune-up; partner code word; biosignal suggestion as a nudge |
| Partner reads app use mid-argument as dismissive                 | Escalation              | Watch-first design for in-conflict use; pocket haptics; announcement scripts; pairing normalizes it                             |
| Break becomes avoidance                                          | Contrary to purpose     | Return time mandatory; caps; neutral pattern surfacing; language praises returning                                              |
| Companion oversteps (diagnoses, takes sides, keeps user talking) | Harm, trust, regulatory | Behavioral contract; red-team suite; clinician transcript review; user controls; AI-off mode                                    |
| Biosignal noise produces bad suggestions                         | Annoyance, false alarms | Personal baselines only; rate limits; 'not now' learning; never labels                                                          |
| EMA fatigue                                                      | Data and retention loss | ≤ 30 s, 2–4/day, quiet expiry, adaptive windows, visible value back                                                             |
| Full scope stretches launch                                      | Delay                   | Phased build with alpha on the core; scope fixed, dates flex; nothing in the moment ships half-done                             |
| Apple platform changes                                           | Rework                  | Track fall 2026 releases; entry surfaces abstracted behind App Intents                                                          |
| Health-claim exposure                                            | Regulatory / rejection  | Wellness language; legal review; study before stronger claims                                                                   |
| Use in an unsafe relationship                                    | User safety             | Safety check; DV resources everywhere; silent unpair                                                                            |
| Trademark conflict                                               | Rebrand cost            | Formal clearance and filing in Phase 0                                                                                          |

**Appendix A. Technique Specifications**

**A.1 Physiological sigh (default first step)**

- Inhale through nose ~2 s; second short inhale ~1 s; exhale slowly
  through mouth ~6–8 s. Three cycles (~30 s).

- Haptics: two rising taps then one long decaying continuous haptic.
  Voice: 'In. A little more. Long slow out.'

**A.2 Paced breathing (settle)**

- Default 5.5 breaths per minute: inhale 4 s, exhale 7 s. Adjustable
  4.5–6.5. Default 90 s, extendable in 30 s steps.

**A.3 Cold water (guided alternative)**

- 'Head to a sink. Cold, not ice. Hold your breath, face in or splash
  forehead to cheeks, 15–20 seconds. Breathe. Repeat up to three times.'
  Gate: cardiac, cold urticaria, pregnancy.

**A.4 Movement (alternative)**

- 60 s: stairs, fast walk, wall push, or 20 squats. Framed as burning
  off the surge, never as venting.

**A.5 Orienting (alternative)**

- Voice-led 5-4-3-2-1, then 'Feel your feet on the floor. You're here.'

**A.6 Sound (alternative)**

- 90 s of bundled low-frequency, slow-tempo audio (~60 bpm) with the
  breathing haptic underneath, for users who cannot or will not breathe
  on cue.

**A.7 Feeling-word set (~40; clinician to finalize)**

Hurt, unseen, dismissed, scared, unsafe, ashamed, small, embarrassed,
trapped, cornered, powerless, furious, resentful, betrayed, jealous,
abandoned, lonely, rejected, anxious, dread, panicked, overwhelmed,
numb, shut down, exhausted, disappointed, let down, guilty, confused,
unsure, sad, grieving, longing, needing reassurance, wanting space,
defensive, misunderstood, tense, restless, on edge.

**Appendix B. EMA Check-in Item Set (draft)**

| **Item**   | **Wording**                                                           | **Scale**             | **Basis**                         |
|------------|-----------------------------------------------------------------------|-----------------------|-----------------------------------|
| Arousal    | Right now, how hot are you?                                           | 1–10                  | Single-item arousal (affect grid) |
| Emotion    | One word for right now.                                               | Tap from grid         | Emotion granularity literature    |
| Connection | Right now, how connected do you feel to the people who matter to you? | 1–7                   | Single-item closeness (IOS-style) |
| Urge       | Any urge you're holding right now?                                    | None / small / strong | Urge-rating EMA convention        |
| Rotating   | Sleep last night / body tension / sense of control right now          | 1–7                   | Weekly rotation to limit burden   |

Scheduling: two prompts default (late morning, evening), up to four;
semi-random within user windows; 20-minute expiry; event-contingent
prompts after resets and returns; windows adapt to observed response
times.

**Appendix C. Sample Copy**

**C.1 Break announcement (template)**

*'I'm getting flooded and I don't want to say something I don't mean.
I'm taking \[20\] minutes to settle. I'll be back at \[7:40\] and we can
keep going.'*

**C.2 Repair lines**

- 'Can we start over?'

- 'I was harsh before the break. I'm sorry for that part.'

- 'I'm still upset and I still want to figure this out with you.'

- 'What did I miss while I was flooded?'

**C.3 Companion openers**

- In a break: 'Where are you at, 1 to 10?' then 'What do you need in the
  next ten minutes?'

- At return: 'What's the one thing you want them to hear?'

- Debrief: 'What happened?' then 'How did it go once you went back?'

- Weekly: 'Anything coming up this week you want to be ready for?'

**C.4 Hold end screen**

*'Here's what you wanted to send 20 minutes ago. You were at a 9. You're
at a 4 now. Still want to send it?' \[Delete\] \[Edit\] \[Send\]*

**Appendix D. Key References**

- Balban, M. Y., et al. (2023). Brief structured respiration practices
  enhance mood and reduce physiological arousal. Cell Reports Medicine,
  4(1).

- Fincham, G. W., et al. (2023). Effect of breathwork on stress and
  mental health: A meta-analysis of randomised-controlled trials.
  Scientific Reports, 13.

- Gottman, J. M., & Silver, N. (2015). The Seven Principles for Making
  Marriage Work. Harmony.

- Linehan, M. M. (2015). DBT Skills Training Manual (2nd ed.). Guilford.

- Lieberman, M. D., et al. (2007). Putting feelings into words.
  Psychological Science, 18(5).

- Kircanski, K., Lieberman, M. D., & Craske, M. G. (2012). Feelings into
  words. Psychological Science, 23(10).

- Kross, E., & Ayduk, O. (2017). Self-distancing: Theory, research, and
  current directions. Advances in Experimental Social Psychology, 55.

- Lehrer, P. M., & Gevirtz, R. (2014). Heart rate variability
  biofeedback: How and why does it work? Frontiers in Psychology, 5.

- Mikulincer, M., & Shaver, P. R. (2016). Attachment in Adulthood (2nd
  ed.). Guilford.

- Real, T. (2022). Us: Getting Past You and Me to Build a More Loving
  Relationship. Goop Press.

- Gross, J. J. (2015). Emotion regulation: Current status and future
  prospects. Psychological Inquiry, 26(1).

- Shiffman, S., Stone, A. A., & Hufford, M. R. (2008). Ecological
  momentary assessment. Annual Review of Clinical Psychology, 4.

- Trull, T. J., & Ebner-Priemer, U. (2013). Ambulatory assessment.
  Annual Review of Clinical Psychology, 9.

- Kashdan, T. B., Barrett, L. F., & McKnight, P. E. (2015). Unpacking
  emotion differentiation. Current Directions in Psychological Science,
  24(1).

**Appendix E. Change Log**

**v4 — design and engineering review**

- Corrected two requirements that were not buildable as written: Focus
  Filters cannot hide another app's Messages thread (R6 is now a
  user-created 'Break' Focus the app toggles), and Live Activities end
  after 8 hours (E7/Flow C fall back to notifications for longer
  breaks).

- Set honest expectations for heart-rate-triggered suggestions (E6):
  background HR sampling is minutes-late; the nudge is never the primary
  entry.

- Removed hidden gestures and sliders from the flooded path: alternate
  technique is a visible button; 'how hot' is ten tap targets or the
  Digital Crown.

- Changed the companion's opener in a break from 'What happened?'
  (invites rehearsal) to a need-focused pair of questions; 'What
  happened?' moved to debrief.

- Added the 'Show them' announcement card, per-break private toggle,
  symmetric silent unpair, and a 'Steady yourself too' button on the
  partner's receipt.

- Added a notification budget (K15) and Watch–iPhone reconciliation
  (K16); onboarding now begins with a 60-second reset.

- Specified the companion context packet, backend attestation and
  entitlement checks, streaming, fair-use cap, and the App Privacy label
  implications of Plus.

- Session screen dark by default; break default 20 with a one-time note
  if shortened to 10; debrief at ~2 hours with 'still talking'
  reschedule.

**v3**

- Hybrid inference with on-device-only mode; one free voice, up to three
  in Plus via on-demand resources; no inference in the free tier;
  research readiness built at launch, study post-launch.

**v2**

- Renamed Steady Reset; full-featured launch scope; AI layer; HealthKit
  wearables; EMA check-in; CloudKit pairing; iPhone and Watch side by
  side.

**v1**

- Evidence review, operationalization principles, and MVP-scoped
  requirements.
