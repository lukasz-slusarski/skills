# Recommended skills

A curated list of community skills I recommend to clients and use myself. These skills live in their authors' repositories. Install them from there, so you always get the current version and the author's licence.

How I picked them: they are widely used (GitHub stars, installs on [skills.sh](https://skills.sh)), actively maintained, they have a clear licence, and they do one useful job well. Last reviewed: October 2026.

Install any of them with:

```
npx skills add <owner>/<repo>
```

Claude Code also accepts most of them as plugins (`/plugin marketplace add <owner>/<repo>`). Every repository's README has the details.

## Marketing and content

| Skill | What it does | Licence |
|---|---|---|
| [Marketing Skills](https://github.com/coreyhaines31/marketingskills) | 70 skills for marketers. Start with `seo-audit`, `copywriting`, `copy-editing`, `content-strategy`, `ai-seo`, `cro` and `schema`. | MIT |
| [Humanizer](https://github.com/blader/humanizer) | Removes typical AI writing patterns from a text before you publish it. Works best in English. | MIT |
| [PM Skills](https://github.com/phuryn/pm-skills) | Product and go-to-market work: briefs, PRDs, competitor analysis, market research. | MIT |
| [brand-guidelines](https://github.com/anthropics/skills/tree/main/skills/brand-guidelines), [theme-factory](https://github.com/anthropics/skills/tree/main/skills/theme-factory) | Apply brand colours and fonts to anything the agent makes. Anthropic's examples, easy to adapt to your brand. | Apache-2.0 |
| [ai-content-labeling](skills/ai-content-labeling) | Do I have to label this as AI? EU AI Act Article 50 plus platform rules. (mine) | MIT |

## Design and UI

| Skill | What it does | Licence |
|---|---|---|
| [frontend-design](https://github.com/anthropics/skills/tree/main/skills/frontend-design) | Distinctive interfaces instead of generic "AI look". The most installed design skill. | Apache-2.0 |
| [Impeccable](https://github.com/pbakaus/impeccable) | Design quality commands: critique, audit, polish, animate. | Apache-2.0 |
| [Taste Skill](https://github.com/Leonxlnx/taste-skill) | Design presets (minimalist, high-end, redesign of an existing site). | MIT |
| [UI UX Pro Max](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) | A library of UI styles, colour palettes and font pairings to pick from. | MIT |
| [Emil Kowalski's skills](https://github.com/emilkowalski/skills) | Design engineering and animation polish from the author of Sonner and Vaul. | MIT |
| [canvas-design](https://github.com/anthropics/skills/tree/main/skills/canvas-design) | Posters and visual pieces as PNG or PDF. | Apache-2.0 |

## Office documents

Anthropic's document skills. They ship with the Claude apps and are free to use, but their licence is proprietary: install them from the source, do not copy them.

| Skill | What it does |
|---|---|
| [docx](https://github.com/anthropics/skills/tree/main/skills/docx) | Create and edit Word documents. |
| [xlsx](https://github.com/anthropics/skills/tree/main/skills/xlsx) | Spreadsheets with formulas and formatting. |
| [pptx](https://github.com/anthropics/skills/tree/main/skills/pptx) | PowerPoint presentations. |
| [pdf](https://github.com/anthropics/skills/tree/main/skills/pdf) | Read, fill, merge and create PDFs. |

## Websites and WordPress

| Skill | What it does | Licence |
|---|---|---|
| [WordPress Agent Skills](https://github.com/WordPress/agent-skills) | Official skills from the WordPress project: plugins, block themes, REST API, performance, WP-CLI. | GPL |
| [playwright-cli](https://github.com/microsoft/playwright-cli) | Lets the agent open and click through a website, from Microsoft. | Apache-2.0 |
| [webapp-testing](https://github.com/anthropics/skills/tree/main/skills/webapp-testing) | Test a local web app with Playwright. | Apache-2.0 |
| [Playwright Best Practices](https://github.com/currents-dev/playwright-best-practices-skill) | Writing reliable Playwright tests. | MIT |
| [shadcn](https://github.com/shadcn-ui/ui/tree/main/skills/shadcn) | Using shadcn/ui components correctly. | MIT |

## Working with agents

| Skill | What it does | Licence |
|---|---|---|
| [Superpowers](https://github.com/obra/superpowers) | The most recommended workflow pack: brainstorm, plan, test-driven development, debugging, verification. For developers. | MIT |
| [Matt Pocock's skills](https://github.com/mattpocock/skills) | Start with `grill-me` (the agent interviews you before building), `tdd` and `handoff`. | MIT |
| [skill-creator](https://github.com/anthropics/skills/tree/main/skills/skill-creator) | Write, test and improve your own skills. | Apache-2.0 |
| [find-skills](https://github.com/vercel-labs/skills/tree/main/skills/find-skills) | Search for skills and install them from the agent. | MIT |
| [ai-routing](skills/ai-routing), [ai-delegate](skills/ai-delegate) | Hand work to cheaper models and agents (Codex, Gemini, GLM, Kimi) to save limits. (mine) | MIT |

## Before you install anything

- A skill is instructions plus scripts that your agent will follow and run. Read the `SKILL.md` and look at `scripts/` before installing, the way you would check a browser extension.
- Install counts on skills.sh can be inflated. A repository with a huge install count and a few dozen stars is a warning sign. Prefer known authors and organisations.
- Be careful with skills that send email, post to social media, drive a logged-in browser or upload files. Keep them behind a confirmation step.
- skills.sh shows security audits (Gen, Socket, Snyk) on each skill's page. Check them for anything that runs code.

Want help choosing or building skills for your team? [Book a 30 min call](https://cal.com/lukasz-important/spotkanie-30-minut) or visit [important.is](https://important.is).
