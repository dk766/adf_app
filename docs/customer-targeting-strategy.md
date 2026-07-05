# ADF ArhivaDeFacturi — Customer Targeting Strategy & Plan

## 1. Executive summary

ADF bundles four things SMEs in Romania usually buy separately: (1) automated e-Factura archiving, (2) encrypted document storage, (3) alerting on invoice events, and (4) a lightweight sales CRM. That bundle is the core of the targeting thesis: **the best customers are companies that feel real pain across at least two of those four needs and currently patch the gap with spreadsheets, email, or several disconnected tools.**

The plan below defines the Ideal Customer Profile (ICP), a lead-scoring rubric, a realistic data-sourcing path using Romanian public records, and a phased go-to-market plan. No code — this is a decision framework and execution plan.

## 2. Why this matters strategically

Romania's e-Factura mandate (B2B e-invoicing reporting through ANAF's SPV, phased in 2024–2025 for VAT payers) created a **forcing function**: every VAT-registered company must now generate/receive structured e-invoices and is legally required to archive fiscal documents for 10 years (Codul de procedură fiscală). That turns "invoice archiving" from a nice-to-have into a compliance necessity for a huge base of companies — but compliance alone doesn't make someone a *good* customer. Good customers are the ones where the pain is big enough, and the willingness/ability to pay is real enough, to convert and stick. That's what the ICP below tries to isolate.

*(Verify current mandate thresholds/dates against ANAF before using them in outbound messaging — e-Factura rules have been rolled out in stages and I'd rather flag that than assert a specific date with false confidence.)*

## 3. Ideal Customer Profile (ICP)

### 3.1 Primary segment — direct SME buyers

| Dimension | Target criteria | Why it matters |
|---|---|---|
| Legal form | SRL (occasionally SA for larger) | PFAs rarely have multi-user or CRM needs |
| VAT status | Registered VAT payer (plătitor de TVA) | e-Factura obligation = compliance urgency |
| Size | ~10–250 employees, turnover roughly €200k–€15M | Big enough to have real invoice volume and a sales team; small enough to lack an ERP/CRM suite already |
| Invoice volume | 50+ invoices/month (issued + received) | Below this, manual handling or the free ANAF portal is "good enough" |
| Supplier/customer base | Multiple suppliers and customers, some turnover in that base | Makes "new supplier" and "amount threshold" alerts genuinely useful |
| Org structure | More than one person touches invoices/documents (owner + bookkeeper, or finance + admin) | Multi-user access is a differentiator only if there's more than one user |
| Sales motion | Has a small sales team or owner-led sales process, no CRM or using spreadsheets/WhatsApp | Makes the kanban/pipeline feature a real reason to buy, not filler |
| Existing stack | Uses a billing/accounting SaaS (SmartBill, FGO, Oblio, SAGA) but no document archiving or CRM layered on top | Whitespace — not displacing an incumbent, filling a gap |
| Industry (CAEN) | Distribution/wholesale, manufacturing, construction, professional services, import-export, e-commerce, IT services, transport/logistics | High invoice + supplier churn, multiple stakeholders per deal |

### 3.2 Secondary segment — channel multiplier (high leverage)

**Accounting and bookkeeping firms (cabinete de contabilitate) and outsourced CFO providers.** Romania has thousands of small accounting practices, each serving 20–150 client companies. One partnership can distribute ADF to dozens of end-customers at once, and accountants are a trusted advisor for exactly the compliance pain ADF addresses (archiving, retention, alerts on anomalies). This segment should get disproportionate attention early because CAC-per-end-customer is far lower than direct SME acquisition.

### 3.3 Anti-ICP — deprioritize or disqualify

- **Large enterprises** already running SAP/Oracle/Dynamics with built-in DMS and CRM modules — long procurement cycles, and ADF's CRM/DMS will lose feature-for-feature against Salesforce/SharePoint-class tools.
- **Micro/PFA with very low invoice volume (<10/month), single user** — free ANAF SPV portal is sufficient; low willingness to pay.
- **Non-VAT-registered micro-enterprises with no growth trajectory** — no compliance urgency, unlikely to value multi-user/CRM.
- **Sectors with heightened regulatory/data requirements** (banking, healthcare, public sector) — likely need compliance certifications ADF doesn't yet have; long sales cycles.
- **Companies outside Romania** — e-Factura is Romania-specific; out of scope until/unless you track EU e-invoicing mandate expansion elsewhere.

## 4. Lead-scoring rubric (for prioritizing outbound once you have a target list)

Score 0–100, weighted:

| Criterion | Weight | Signal source |
|---|---|---|
| Compliance urgency (VAT-registered, e-Factura obligation active) | 25% | ANAF registries |
| Invoice/document volume proxy (turnover band, employee count) | 20% | Public financial statements (bilanț) |
| Multi-user likelihood (employee count ≥ 10) | 15% | ONRC / financial statements |
| Sales-team signal (job postings for sales roles, LinkedIn headcount in sales) | 15% | LinkedIn, job boards |
| No existing ERP/CRM suite detected | 15% | Website/tech signals, direct outreach discovery |
| Reachability (identifiable decision-maker, active digital presence) | 10% | LinkedIn, company website |

This rubric is a starting hypothesis — Phase 0 below is designed to calibrate the weights against your actual best customers before you scale spend against it.

## 5. Data sources to build the target list

There are two distinct jobs here, and it matters which one each source solves:

- **Enrichment**: you already have a CUI (fiscal ID) and want its current details (VAT status, CAEN, e-Factura status, address).
- **Universe-building**: you *don't* have a list yet — you need to discover which CUIs match your ICP (industry, size, turnover) in the first place.

No single free official source solves universe-building well on its own; it has to be assembled. Here's the concrete source inventory:

### 5.1 Source inventory

| Source | Solves | Access | Cost | Notes |
|---|---|---|---|---|
| **ANAF `PlatitorTvaRest` web service** | Enrichment | Official REST API, POST a batch of CUIs + date | Free | Given a CUI, returns VAT-payer status, CAEN code, address, inactive-taxpayer flag, split-VAT-payment flag, **and RO e-Factura registration status** — all in one call. Batchable (historically ~a few hundred CUIs per call; confirm the current cap in ANAF's own docs before relying on a number). ANAF now has a separate "Înregistrare pentru API-uri" registration page for some services — check whether this specific endpoint still works key-less or now needs registration, since that's changed over time. |
| **Ministry of Finance "Situații financiare" datasets on data.gov.ro** | Universe-building | Free bulk download, one dataset per fiscal year (e.g. `situatii_financiare_2024`) | Free | This is the closest thing to a free full-population dump: turnover, profit, employee-count indicators per CUI, sourced from filed annual financial statements. Lags reality by ~1 year (companies file the following year) and the file format is a flat/text extract, not a clean queryable API — needs a parsing step. This is your best free lever for the "invoice volume proxy" and "ability to pay" scoring criteria at population scale. |
| **ONRC (Trade Registry) / RECOM online** | Universe-building (CAEN, legal status) + enrichment | Official, but subscription/contract-based for bulk; free single lookups on the ONRC portal | ~9 RON per company record for the bulk information service, plus a contract with ONRC | Authoritative source for CAEN code and company status (active/dissolved/etc.), but not a free open API — budget for it if you go the DIY route. Note: full ONRC extracts also include the administrator's/legal representative's personal name — that field is personal data under GDPR even though the rest of the record is company data. |
| **Insolvency register (Buletinul Procedurilor de Insolvență)** | Negative filter | Public portal/dataset | Free | Use to exclude companies in insolvency from outreach — cheap sanity filter, avoid wasting sales time and avoid a bad look. |
| **Third-party aggregators** (listafirme.ro, termene.ro, risco.ro, and similar) | Universe-building + enrichment, pre-joined | Commercial API/export subscriptions | Paid (get quotes) | These have already done the CUI-based join across ANAF + ONRC + MF financials into one searchable/API-accessible database. Given Phase 1 only needs a few hundred to low-thousands of companies, pricing these out is very likely faster and cheaper than building the DIY pipeline below. |
| **LinkedIn (Sales Navigator or manual)** | Enrichment (decision-maker, hiring signal) | Native tool, no scraping | Free–paid tier | Covers the "sales-team signal" and "reachability" scoring criteria; doesn't cover financials. See prior message for the compliant-use boundary. |
| **Your own product data** | Ground truth | Internal | Free | Once you have paying customers, "who actually renews/expands" is the highest-signal input and should eventually override the public-data heuristics above. |

### 5.2 Recommended extraction sequence (DIY path)

If you go the build-it-yourself route rather than an aggregator, the join key across every *official* source above is the **CUI** — it's consistent everywhere, so no fuzzy matching is needed until you cross into LinkedIn company names.

1. **Build the universe**: pull the relevant year's "Situații financiare" dataset from data.gov.ro, filter to your turnover band and (if the dataset includes it) CAEN prefixes matching Section 3.1's target industries. Output: a CUI list.
2. **Enrich in real time**: batch that CUI list through the free ANAF `PlatitorTvaRest` service to pull current VAT status, CAEN, e-Factura status, and the inactive-taxpayer flag. This step is worth doing regardless of which universe-building route you pick, since it's free, official, and real-time.
3. **Exclude**: drop inactive taxpayers (flagged directly in step 2's response), insolvent companies (cross-reference the insolvency register), and anything matching the anti-ICP in Section 3.3 (e.g. very large taxpayers).
4. **Score**: apply the rubric in Section 4 to what's left.

### 5.3 CAEN codes to anchor the industry filter

CAEN (Clasificarea Activităților din Economia Națională) is a static public reference table from INS — embed it once, it doesn't need "extraction." Indicative divisions matching the Section 3.1 target industries:

- **Wholesale/distribution** — Section G, division 46
- **Manufacturing** — Section C, divisions 10–33
- **Construction** — Section F, divisions 41–43
- **Transport & logistics** — Section H, divisions 49–53
- **IT services** — Section J, division 62
- **Professional services (accounting/consulting — also your channel segment)** — Section M, divisions 69–70
- **E-commerce/retail** — division 47.91 and related retail codes

### 5.4 Build vs. buy — recommendation

Given Phase 1 only needs a few hundred to low-thousands of scored companies, **get quotes from 2–3 aggregators (listafirme, termene, risco) before building the DIY pipeline in 5.2.** The DIY path is free-ish but has real costs: the MF bulk files need parsing, ONRC bulk lookups are billed per record, and none of it is a live API you can query on demand. The one piece worth doing yourself regardless of the aggregator decision is step 2 (ANAF VAT/e-Factura enrichment) — it's free, official, and useful as an ongoing verification layer even on top of aggregator-sourced lists.

**Caveat to flag now, not later:** once you're pulling named individuals (decision-maker names from ONRC extracts, personal emails) rather than company-level data, GDPR applies even in a B2B context. Keep a documented legitimate-interest basis for outbound prospecting and an easy opt-out, and check the ToS of any aggregator before bulk-scraping their data.

## 6. Go-to-market plan

**Phase 0 — Calibrate against reality (2–3 weeks)**
Interview 15–20 existing users across your current customer base. Segment them by industry, size, invoice volume, and which features they actually use (archiving vs. CRM vs. alerts). Identify who renews, who expands, who churns. Use this to sanity-check or adjust the ICP table and scoring weights in Sections 3–4 *before* spending on list-building.

**Phase 1 — Build the scored target list (3–4 weeks)**
Decide build-vs-buy on data (custom ANAF/ONRC pull vs. a paid aggregator like termene.ro/risco.ro). Produce a first list of a few hundred companies scored per Section 4, plus a shortlist of 10–20 accounting firms for the channel play.

**Phase 2 — Channel pilot (parallel with Phase 1, 4–6 weeks)**
Approach 5–10 accounting/bookkeeping firms with a referral or white-label offer. This is the highest-leverage, lowest-cost test you can run before committing to paid data infrastructure.

**Phase 3 — Direct outbound + content (ongoing)**
Outbound (email/LinkedIn) to the highest-scored direct segment; SEO/content targeted at compliance search intent (e.g., "arhivare obligatorie facturi e-Factura", "păstrare documente fiscale 10 ani").

**Phase 4 — Feed back and refine (recurring, monthly/quarterly)**
Track conversion and retention by segment and CAEN code. Feed that back into the scoring weights — the model should get sharper over time, not stay static.

## 7. Success metrics

- Conversion rate by ICP score band (validates whether the rubric predicts anything)
- CAC and payback period, direct vs. channel-sourced customers
- Feature adoption breadth (archiving-only vs. archiving+CRM+alerts) as a leading indicator of retention
- Channel partner economics: end-customers per accounting-firm partnership, referral CAC vs. direct CAC

## 8. Open decisions for you

- Build vs. buy on company data (custom ANAF/ONRC pipeline vs. paid aggregator subscription) — recommend pricing out aggregators first given the small scale of Phase 1.
- Whether the channel (accounting firms) or direct SME outbound gets first budget/headcount — recommend channel first given the leverage.
- Whether current paying customers have already been segmented anywhere (CRM, spreadsheet) that Phase 0 can start from immediately.
