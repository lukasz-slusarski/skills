# Sources and re-verification

All sources checked on **8.10.2026**. Read when more than 3 months have passed since that date or the user asks about currency.

## EU law

| Document | Link | What from it |
|---|---|---|
| AI Act, Regulation (EU) 2024/1689 | http://data.europa.eu/eli/reg/2024/1689/oj | Article 2(10), Article 3(4) and (60), Article 50, recitals 132-137, Article 99, Article 113 |
| Digital Omnibus on AI, Regulation (EU) 2026/1744 (text PE-CONS 30/26 REV 1) | https://data.consilium.europa.eu/doc/document/PE-30-2026-REV-1/en/pdf | transitional period until 2.12.2026 only for Article 50(2) |
| Commission guidelines on Article 50, C(2026) 5054, 20.07.2026 | https://digital-strategy.ec.europa.eu/en/policies/guidelines-ai-transparency-obligations | definitions, examples, editorial exception, form of disclosure |
| Code of Practice, final 10.06.2026 | https://digital-strategy.ec.europa.eu/en/policies/code-practice-ai-generated-content | label format and placement, Annex 1 |
| Commission opinion on the Code, 8.07.2026 | https://digital-strategy.ec.europa.eu/en/library/commission-opinion-assessment-code-practice-transparency-ai-generated-content | status of the Code |
| EU icons for labeling | https://digital-strategy.ec.europa.eu/en/policies/eu-icons-labelling-ai-generated-content | icon files |
| Commission FAQ on Article 50 | https://digital-strategy.ec.europa.eu/en/faqs/transparency-obligations-under-article-50-ai-act | deadlines |

Full PDF links are in [guidelines-and-code.md](guidelines-and-code.md).

## Poland

| Document | Link | What from it |
|---|---|---|
| Act of 3.07.2026 on artificial intelligence systems, Dz.U. 2026 poz. 1003 | https://api.sejm.gov.pl/eli/acts/DU/2026/1003/text.pdf | KRiBSI, penalties, deadlines |
| Recommendations of the President of UOKiK for influencers (2022) | https://uokik.gov.pl/download/26685 | no AI thread |

## Platforms

Links and dates in [platforms.md](platforms.md).

## How to re-verify

1. **AI Act**: check the consolidated version on EUR-Lex (the "Consolidated versions" tab) for changes to Article 50 and Article 113 after the Omnibus and later amendments. When EUR-Lex blocks automated access, the PDF from Cellar: `curl -L -H "Accept: application/pdf" -H "Accept-Language: pol" http://publications.europa.eu/resource/cellar/dc8116a1-3fe6-11ef-865a-01aa75ed71a1` (the original version, without later amendments).
2. **Guidelines and Code**: on the Commission pages check whether there is a new version or an implementing act approving the Code.
3. **Poland**: in the Sejm API (`https://api.sejm.gov.pl/eli/acts/DU/2026/1003`) check the status and amendments; on the KRiBSI, UOKiK and KRRiT sites look for positions on labeling AI content.
4. **Platforms**: open each page from [platforms.md](platforms.md) and compare the quotes; platforms change their rules most often.
5. After checking, change the "Sources verified" date in SKILL.md, the headers of the references files and this file.
