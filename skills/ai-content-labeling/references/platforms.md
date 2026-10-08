# Platform rules

Checked 8.10.2026 on official pages (without logging in). The platform terms work independently of the AI Act: meeting one does not release you from the other. Quotes are verbatim; where I did not confirm something at the source, I write "unconfirmed".

## Quick comparison

| Platform | Creator obligation | Tool | No obligation |
|---|---|---|---|
| Meta (FB, IG, Threads) | photorealistic video, realistic-sounding audio digitally created or altered | disclosure tool when posting; "AI info" label | images (Meta labels them itself from C2PA/IPTC metadata) |
| LinkedIn | synthetic content showing a person saying or doing something they did not | in select countries a "created using AI" option; C2PA icon automatically | the rest (no general obligation) |
| TikTok | AI-generated or significantly edited content with realistic scenes or people | AIGC label, own caption, sticker, watermark | minor edits, artistic style, ordinary TTS |
| YouTube | meaningfully altered or generated photorealistic content | "AI use: Yes" in YouTube Studio | unrealistic content, minor edits, cloning own voice for voice-over |
| X | no labeling obligation; ban on misleading media | no switch | manipulation done in a non-deceptive way |

The most important difference from the law: **YouTube does not require disclosing a clone of your own voice**, while the AI Act does (it is the voice of an existing person, the recipient will take the recording to be real). Meta does not require labeling images, while the AI Act requires it for a photorealistic deepfake. Always apply the stricter result.

## Meta (Facebook, Instagram, Threads)

Sources: https://about.fb.com/news/2024/02/labeling-ai-generated-images-on-facebook-instagram-and-threads/ , https://about.fb.com/news/2026/02/meta-prepares-for-2026-us-midterms/

- Obligation: "We require people to use this disclosure and label tool when they post organic content with a photorealistic video or realistic-sounding audio that was digitally created or altered, and we may apply penalties if they fail to do so."
- Images: Meta labels them itself when it detects AI signals ("industry standards and technology (such as C2PA)"), with an "AI info" label, and shows whether the label comes from signals or from the author's declaration.
- A missing label does not by itself cause removal; with a high risk of misleading, Meta may add a more prominent label.
- Ads: the AI disclosure obligation applies to ads about social issues, elections and politics ("in certain cases"). Detailed criteria for ads: unconfirmed at the source.
- Unconfirmed: the exact name of the switch in the app (the help page loads via scripts), the kind of penalties.

## LinkedIn

Sources: https://www.linkedin.com/legal/professional-community-policies , https://www.linkedin.com/help/linkedin/answer/a6282984

- Rule: "Do not share synthetic or manipulated media that depicts a person saying something they did not say or doing something they did not do without clearly disclosing the fake or altered nature of the material."
- Switch: "In select countries, when you upload media that does not already have valid authenticity information, you will have the option to self-attest that the media was created using AI." Whether it works in Poland: unconfirmed. When it is not there, disclose in the post text or on the graphic.
- Files with a C2PA signature get the icon automatically (also single graphics and videos in Sponsored Content ads).

## TikTok

Sources: https://www.tiktok.com/community-guidelines/en/integrity-authenticity (in force from 24.09.2026), https://ads.tiktok.com/resources/help/article/add-disclaimers-to-ads

- Obligation: "we require creators to label AI-generated or significantly edited content that shows realistic-looking scenes or people. Unlabeled content may be removed, restricted, or labeled by our team".
- How: own caption, sticker or watermark, and for AI content also the AIGC label (the "AI-generated content" switch in the posting settings; the path comes from search results, unconfirmed on the page).
- Required among others when: a face is replaced with someone else's; AI makes someone say something they did not say; a background, object or person is added or removed in a misleading way; AI audio imitates the voice of a real person.
- Not required: "small edits like color correction, reframing, or cropping", "artistic styles, like anime", "generic text-to-speech (TTS) narration, when the TTS isn't a recognizable voice of a known individual".
- Banned even with a label (among others): the likeness of private persons without consent (private persons are everyone under 18 and adults who are not public figures); a public figure endorsing products or taking a position they did not take.
- Ads (except Spark Ads): the "This ad contains AI-generated content" switch in Ads Manager for image, video or audio fully generated or significantly altered by AI. Spark Ads are subject to the organic rules.

## YouTube

Source: https://support.google.com/youtube/answer/14328491

- Obligation: "we require creators to disclose when they use AI to meaningfully alter or generate photorealistic content", when the content: shows a real person saying or doing something they did not; alters footage of a real event or place; generates a realistic scene that did not happen; creates music that is the main element of the video.
- How: YouTube Studio, Attributes section, "AI use": Yes.
- No obligation: unrealistic content, minor aesthetic edits (beauty filters, colors, background blur), production assistance (script, thumbnail, title, infographic), captions, improving image and sound quality, "Cloning one's own voice to create voice overs or dubs", a generated background behind a moving car.
- YouTube may apply the label itself (own tools, C2PA, internal detection). Consequences of persistent failure to disclose: a label applied manually, removal of the content, suspension from the Partner Program. Disclosure does not limit reach or monetization.

## X

Source: https://help.x.com/en/rules-and-policies/authenticity (the page returns 403 to automated tools; content from an archive.org copy of 27.07.2026)

- No obligation and no switch for labeling AI.
- Ban: "You may not share inauthentic media, including, manipulated, or out-of-context media that may result in widespread confusion on public issues, impact public safety, or cause serious harm", including "media depicting a real person that has been fabricated or simulated, especially through use of algorithms or broader artificial intelligence".
- Allowed: "Sharing manipulated or out-of-context media in non-deceptive ways." Practical conclusion: on X disclose the AI in the post text, because it is the only way to show that the manipulation is not misleading.

## Website, newsletter, print, radio

No platform rules, only the AI Act remains. Label according to [labels.md](labels.md).
