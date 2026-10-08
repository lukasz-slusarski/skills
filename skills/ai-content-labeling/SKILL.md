---
name: ai-content-labeling
description: Decide whether content must be labeled as AI-generated or AI-altered under EU AI Act Article 50 and platform rules (Meta, LinkedIn, TikTok, YouTube, X). Use when asked "do I have to label this as AI", "AI label", "AI disclosure", "AI info", "deepfake", "AI Act Article 50", or before publishing a social media post, image, video, audio, web text or ad made or altered with AI, especially with a real person's face or voice. Returns a verdict, the legal basis, the label text and where to place it. EU and Poland focus.
license: MIT
metadata:
  author: Łukasz Ślusarski
  version: "0.2.0"
---

# AI content labeling

The result is a **verdict** for one specific piece of content: whether to label it, on what basis (law and platform assessed separately), what the label says and where to put it. The skill helps with the assessment and is not legal advice.

**Language:** answer in the user's language. Give the label texts in the language of the publication (the audience's language); see [references/labels.md](references/labels.md).

Sources verified: **8 October 2026**. If today is more than 3 months later, tell the user and point to [references/sources.md](references/sources.md) for re-verification.

## Step 1. Establish the facts

Collect six facts. Ask for whatever is not visible in the material or the conversation in one combined question:

1. **Form**: text, image, audio, video, or several at once (assess each separately).
2. **Role of AI**: generated the whole thing; generated an element (background, person, voice, face); altered existing material (editing, swap, dubbed words, voice clone, changed location); improved it technically (retouching, colors, denoising, proofreading, translation).
3. **What it shows**: real people (who: the author, a client, an employee, a public figure, a stranger), realistic AI-invented characters, products, places, companies, events; or things impossible in reality.
4. **Realism**: photorealistic, realistic voice, or clearly stylized (illustration, cartoon, obvious convention).
5. **Purpose**: advertising or product description (and whether it contains claims about health, safety, ecology), brand image, information on public matters, satire or creative work, private post.
6. **Channel and human**: where it is published (platform, website, newsletter, intranet), who publishes (company, agency, freelancer, private person), whether a person with subject-matter knowledge checked the facts and who is responsible for the content.

The step ends when every fact is known or recorded as "unknown, assumption: ...".

## Step 2. Law: AI Act Article 50(4)

Go through the decision tree for each form. Verbatim provisions: [references/ai-act-texts.md](references/ai-act-texts.md). Commission interpretations and examples: [references/guidelines-and-code.md](references/guidelines-and-code.md).

**A. Professional activity?** A company, agency, freelancer, a creator who regularly earns from the profile, an organization: yes, it is a **deployer**. An agency that uses AI when producing for a client is a deployer itself; a client who only commissioned the work and did not decide about AI is not. A purely private post by a natural person: the AI Act imposes no obligation, go to step 3.

**B. Image, audio, video: deepfake?** Four conditions, all together (Article 3(60), guidelines points 113-116):
1. AI generated the content or altered a significant element of it.
2. The content clearly resembles a person, object, place, animal or event that **exists, could exist or could have existed**. An invented but realistic person (avatar, an "ad customer", persona) counts too. Impossible things do not count: dragons, flying people, talking mice.
3. A recipient could take it for authentic or true. You assess the whole: realism, message, publication context and the real audience, including children and older people. Intent is irrelevant. Photorealism makes it more likely but does not settle it alone.
4. It is not a minor edit: color and light correction, cosmetic retouching, removing passers-by, denoising, upscaling, or an extended or aesthetic replacement of the background behind a real product do not make a deepfake, as long as they do not change what the recipient takes to be true.

All met: **label** (Article 50(4) first subparagraph). At least one not met: no AI Act obligation for this form.

Milder regime: the deepfake is part of an **evidently** artistic, creative, satirical or fictional work. The obligation stays, but the label may sit next to the frame, in the description or in the credits, as long as it is visible without clicking. The guidelines read this narrowly: purely commercial or informational content does not benefit, and where the character is mixed, the informational one prevails. An ordinary ad is not a work, however witty.

**C. Text: matters of public interest?** The obligation applies only when text generated or altered by AI is (guidelines point 131):
- published to a wide, undefined audience (not an email, a closed group, an intranet),
- informing (conveying knowledge, opinions, facts),
- about public matters: politics, administration, law and courts, security, public health, environment, consumer safety, economic, financial, scientific or cultural developments worth public debate.

Advertising text and product descriptions are out of scope, **unless** they contain claims about health, consumer safety or sustainability.

If the obligation applies, it falls away when two conditions are met together (points 133-138): (1) a person with subject-matter knowledge examined the content, **at minimum fact-checked it**, or exercised editorial control with the power to change and reject; spell checking, a cursory approval and review by another AI are not enough; (2) a named person or company bears editorial responsibility and their details are publicly and easily available (footer, "about us" page, byline). A substantive change by AI after verification voids the exception.

**D. AI corrections to human text.** Proofreading, improving style without changing the meaning, translation: this is editing, not generating. Where AI added substantive content, summarized or paraphrased with a change of meaning, it counts as generating.

The step ends when every form has an answer: "obligation", "obligation softened (work)", "no obligation, because [condition]" or "uncertain, because [what]".

## Step 3. Platform rules

Assess the law and the platform terms separately: a platform may require a switch where the AI Act requires nothing, and the other way round. Criteria, switches and exceptions for Meta, LinkedIn, TikTok, YouTube, X and ads: [references/platforms.md](references/platforms.md). Website, newsletter, print: only the law remains.

The step ends when for each channel you know: whether to turn on the platform switch or label, whether the platform will apply it itself, and whether it is an ad with separate rules.

## Step 4. Verdict

```
Verdict: LABEL / LABEL (softened, work) / NO NEED / UNCERTAIN
Law (AI Act Article 50(4)): [form] → [result], because [condition that decided]
Platform [name]: [turn on X / not required / applies it itself] (one line per channel)
Label: [ready text] | Placement: [where]  (for NO NEED: "none; optional: ...")
Assumptions: [what you assumed without confirmation]
Risks beyond labeling: [consent to likeness, misleading; or "none"]
Note: Assessment aid, not legal advice. Sources as of 8.10.2026.
```

Several forms in one piece of content (e.g. a video with an AI voice-over and text): one verdict, a "Law" line for each form.

Label format and placement: [references/labels.md](references/labels.md). A platform switch and invisible metadata (C2PA) do not replace the visible label required by the AI Act. When the law and the platform give different results, apply the stricter one and say so plainly. For **UNCERTAIN**, recommend labeling: a label costs little, while the fine under Article 99(4) reaches EUR 15 million or 3% of turnover.

For the "Risks" line: where the content shows or imitates a real person other than the publisher, the label does not replace consent to likeness and voice (recital 137; Article 81 of the Polish Copyright Act; personal rights). For advertising, add: labeling does not protect against a charge of misleading the consumer.

Deadlines, content from before 2 August 2026, the Polish supervisory authority: [references/deadlines-and-enforcement.md](references/deadlines-and-enforcement.md).

## Borderline examples

Before issuing a verdict in a case similar to a typical one (own face in a stylized and in a photorealistic graphic, AI headshot, retouching, AI editing of own recording, voice clone, avatar, product on an AI background, improving the style of a text, expert post, satire), check the ruling in [references/examples.md](references/examples.md).
