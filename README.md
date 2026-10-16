# Magist x Eniac: Should Eniac Partner with Magist for Its Brazil Expansion?

A data analytics case study completed as a team project during a data analytics bootcamp. Using a snapshot of Magist's marketplace database, we assessed whether Magist is the right logistics and marketplace partner for Eniac's entry into the Brazilian market, and presented our recommendation to Eniac's leadership.

---

## Business Context

**Eniac** is an online store founded in Spain that sells Apple products (iPhone, Mac, iPad) along with curated, high-priced Apple-compatible accessories and personalized tech support. Eniac wants to expand into Brazil.

**Magist** is a Brazilian software-as-a-service company that offers a centralized order management system connecting small and medium businesses to large marketplaces. It also provides warehousing, shipment-related after-sales support, and existing contracts with the Brazilian Post Office.

Eniac was considering a **3-year contract** with Magist. Our job was to answer:

> **Is Magist a good fit for Eniac's high-end tech products?**

### Eniac benchmark (Apr 2017 – Mar 2018)
| Metric | Value |
|---|---|
| Revenue | €14M |
| Average order price | €710 |
| Average item price | €540 |

---

## Key Questions

The team split the analysis into three areas:

1. **Product fit:** Does Magist sell enough tech, and at the right price level, for Eniac's high-end products?
2. **Delivery and logistics:** Are Magist's delivery times and reliability good enough for premium products?
3. **Seller ecosystem:** How many tech sellers are on the platform, and how much do they earn?

---

## Tools

- **MySQL**: data exploration and analysis queries
- **Tableau Public (desktop)**: data visualization
- **Canva and Google Workspace (Docs, Sheets, Drive)**: team meeting notes and progress tracking
- **Google Slides**: final presentation

---

## Data

The Magist database snapshot contains tables covering orders, order items, products, product categories (with English translations), sellers, customers, payments, reviews and geolocation.

> The raw database is not included in this repository.

---

## Methodology and Definitions

- **Tech categories (9):** `eletronicos`, `informatica_acessorios`, `pcs`, `telefonia`, `tablets_impressao_imagem`, `audio`, `pc_gamer`, `consoles_games`, `telefonia_fixa`
- **"Sold"** = order status `delivered` or `shipped` (used for product and revenue figures)
- **Price brackets:** cheap < 100, mid 100–500, expensive > 500
- **Currency:** treated as euros, as stated in the case
- **Time window:** the full Magist window was used to stay consistent across the team (the first and last months have very few sales). The Apr 2017 – Mar 2018 window was also checked and gave the same conclusions.
- **Tech seller:** any seller with at least one order containing a tech item, regardless of order status. Revenue figures still count only delivered or shipped orders.
- **Reviews:** all order statuses included, since reviews from undelivered or cancelled orders still reflect real customer experience. Review scores were deduplicated per order.

---

## Key Findings

### 1. Product fit (my part)

**Magist is a generalist marketplace, not a tech store.**
- Tech makes up about **15%** of items sold on Magist (16,969 tech items), compared to Eniac's **100%** tech focus.

**Magist's tech is much cheaper than Eniac's.**
- Average tech item price on Magist: **€109**
- Average price across all items: **€120**
- Eniac's average item price: **€540**

**Expensive tech barely sells.**
| Price bracket | Tech items sold | Tech revenue (Apr 2017 – Mar 2018) |
|---|---|---|
| Cheap (< €100) | 12,140 | €328,717 |
| Mid (€100–500) | 4,283 | €532,127 |
| Expensive (> €500) | 546 | €352,356 |

Only about 3% of tech items sold are over €500.

**Customer satisfaction is fine.**
| Group | Avg review score (out of 5) |
|---|---|
| All products | 4.12 |
| Tech products | 4.06 |
| Tech orders with items over €500 | 3.97 |
| Tech orders with items €500 or below | 4.06 |

### 2. Seller ecosystem
- **486 of 3,095 sellers (15.7%)** have sold at least one tech item; **170** sell only tech.
- Total earned (delivered or shipped): **€13.37M** across all sellers, of which **€1.85M** came from tech items.
- Average monthly income per seller (25 months): **€172.82** for all sellers vs **€152.38** for tech sellers from tech items.

### 3. Delivery and logistics
| Segment | Avg delivery time | Delayed orders |
|---|---|---|
| All orders | 12.5 days | 6.9% |
| All tech | 13.1 days | 7.0% |
| High-value tech (> €500) | 15.5 days | 8.7% |

- Delivery time breaks down into about 3.2 days of preparation and 9.3 days in transit.
- Same-state deliveries take **7.8 days**; cross-state deliveries take **15.0 days**.
- **Late deliveries hurt satisfaction:** on-time or early orders average **4.29** stars, while delayed orders average **2.33**.

---

## Recommendation: Opportunity with Limits

Magist's customers are generally satisfied, and Magist offers real operational advantages (warehousing, after-sales support, Post Office contracts and a fast start in Brazil). However:

- Its tech offering is small and low-priced compared with Eniac's premium range
- High-value tech has the slowest deliveries and the highest delay rate
- Late deliveries strongly reduce review scores

**We recommended against committing to a 3-year contract right away.** Instead, Eniac should run a **limited pilot** (for example, a 1-year agreement) with clear performance targets, such as delivery time and delay rate for high-value products, and review the partnership after the pilot.

---

## Repository Structure

```
├── README.md
├── LICENSE
├── presentation/
│   └── Team flux presentation.pdf   # Final slide deck
├── schema/
│   └── magist_schema.pdf               # Database tables and relationships
├── sql/                                # SQL queries by topic
│   ├── 01_product_tech_analysis.sql
│   ├── 02_seller_analysis.sql
│   └── 03_reviews.sql
└── images/                             # Charts used in the presentation
```

---

## My Contribution

- Product and tech analysis: defining tech categories, price comparison, price brackets, revenue by bracket and review scores
- Seller KPIs: tech seller counts, total earnings and average monthly income
- Tableau visualizations: tech categories, price gap, price brackets and reviews by category
- Product slides and the product conclusion in the final presentation

---

## What I Learned and Next Steps

Seeing other teams' presentations showed me where this analysis could go deeper. Planned extensions:

- [ ] Translate and analyse Portuguese review text to understand *why* customers rate tech products the way they do
- [ ] Map regional risk for high-end products (where expensive tech sells and how delivery performs there)
- [ ] Analyse late delivery against ratings specifically for high-value tech
- [ ] Look at payment behaviour (installments) for expensive tech orders
- [ ] Add high-end tech earnings to the product story
- [ ] Clean and comment SQL queries for reproducibility

---

## Team

- Sahana Varadharajan – Product and seller analysis
- Ali D – Delivery and logistics
- Prajakta Joshi – Seller ecosystem

---

## Project Files

- [Final presentation](presentation/Team_flux_presentation.pdf)
- [Database schema](schema/magist_schema.pdf)
- [SQL queries](sql/)
