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

You said you're not sure what's available yet — here's the realistic menu for the Romanian market, roughly in order of ease of access:

1. **ANAF open data** — VAT payer registry (Registrul persoanelor impozabile înregistrate în scopuri de TVA) and the public e-Factura registry (companies enrolled in RO e-Factura). Free, but raw and requires cleaning.
2. **ONRC (Trade Registry)** — legal form, CAEN code, registration status. Some free lookups, bulk access typically paid.
3. **Ministry of Finance public financial statements (bilanțuri)** — annual turnover, profit, employee count per company (filed yearly, public). Best proxy you'll get for size/invoice volume without asking the company directly.
4. **Third-party aggregators** (listafirme.ro, termene.ro, risco.ro, and similar) — package the above into searchable/API form, usually paid subscriptions but save significant scraping effort. Worth pricing out before building anything custom.
5. **LinkedIn (Sales Navigator or manual)** — headcount trends, sales-role hiring, decision-maker identification. Useful for the "sales team signal" and "reachability" scoring criteria.
6. **Your own product data** — once you have a meaningful customer base, the highest-signal source is "who are our best customers today" (retention, expansion, invoice volume actually processed). This should feed back into and eventually override the public-data heuristics.

**Caveat to flag now, not later:** once you're pulling named individuals (decision-maker names, personal emails) rather than company-level data, GDPR applies even in a B2B context. Keep a documented legitimate-interest basis for outbound prospecting and an easy opt-out, and check the ToS of any aggregator before bulk-scraping their data.

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
