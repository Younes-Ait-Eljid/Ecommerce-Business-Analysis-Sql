# Olist Marketplace — Final Business Insights

## Executive Summary

The analysis shows a marketplace with strong revenue expansion, a major customer-retention opportunity, meaningful differences in customer value, and a close relationship between commercial performance, payments, sellers, products, and delivery execution.

### Key findings

* **2017 delivered-order revenue:** R$5,962,902.01
* **January–August 2018 delivered-order revenue:** R$7,218,125.12
* **Cumulative revenue through August 2018:** R$13,221,498.11
* **Strongest observed revenue month:** November 2017 — R$987,765.37
* **Repeat customers:** 2,801, representing **3.00%** of customers
* **Average repeat-customer revenue:** R$260.05
* **Average one-time-customer revenue:** R$137.96
* **Highest-value customer:** R$13,440
* **Highest-revenue product:** approximately R$63,560
* **Highest-volume product:** 520 units / R$37,104.30
* **Installment customers:** 48,208 / average value R$204.40
* **Non-installment customers:** 45,149 / average value R$123.34
* **Highest average payment-method value:** credit card — R$168.01
* **Lowest average payment-method value:** voucher — R$95.52

> Revenue is consistently defined as revenue from \*\*delivered orders\*\* in the business-analysis SQL. The month-over-month revenue analysis starts in January 2017 because 2016 is partial and sparse.

\---

# 1\. Business Overview

Olist should be evaluated as a multi-sided marketplace rather than only as a revenue-generating business. The analysis covers customers, orders, products, sellers, payments, delivery and reviews.

The most important management perspective is therefore the interaction between:

* customer acquisition and retention,
* order and revenue growth,
* product/category performance,
* seller performance,
* payment behavior,
* delivery execution,
* customer satisfaction.

### Business insight

The marketplace's long-term opportunity is to turn transaction growth into **repeat purchasing and higher customer lifetime value**.

\---

# 2\. Time \& Order Analysis

## Revenue growth

Delivered-order revenue reached:

|Period|Revenue|
|-|-:|
|2017|R$5,962,902.01|
|Jan–Aug 2018|R$7,218,125.12|
|Cumulative Aug 2018|R$13,221,498.11|

A particularly strong signal is that **January–August 2018 already generated more revenue than the entire 2017 period**.

## Revenue volatility

Growth was not uniform:

* November 2017: **+52.37% MoM**
* December 2017: **-26.50% MoM**

This indicates meaningful month-to-month demand volatility.

## Highest revenue months

|Month|Revenue|
|-|-:|
|November 2017|R$987,765.37|
|May 2018|R$977,544.69|
|April 2018|R$973,534.09|

### Business implication

Peak periods should be used for planning seller capacity, inventory, logistics, customer support and promotional activity. Strong demand is valuable only if the operational system can absorb it without damaging customer experience.

\---

# 3\. Customer Analysis

## Repeat customers

Only **2,801 customers**, or **3.00%**, were repeat customers.

This is one of the most important findings in the entire analysis.

The marketplace is generating transactions, but the share of customers returning for another purchase is relatively small.

## Repeat vs one-time customer value

|Customer Type|Average Revenue|
|-|-:|
|Repeat Customer|R$260.05|
|One-Time Customer|R$137.96|

Repeat customers generate approximately **1.88×** the average revenue of one-time customers, or roughly **88.5% more**.

### Business implication

Customer retention represents a major growth opportunity. Increasing the number of customers who make a second purchase could materially increase customer lifetime value.

The analysis should therefore be used to investigate what differentiates repeat buyers from one-time buyers, especially:

* product category,
* order value,
* payment method,
* delivery experience,
* seller,
* time between purchases.

## High-value customers

The highest-value customer generated **R$13,440**.

This confirms that customer value is highly uneven and supports value-based customer segmentation.

### Strategic takeaway

High-value customers should be analyzed separately from the general customer base because retaining a small number of highly valuable customers can have a disproportionate revenue impact.

\---

# 4\. Product \& Category Analysis

The product analysis evaluates catalog size, products by category, category revenue, sales volume and revenue efficiency.

## Product performance

The highest-revenue individual product generated approximately **R$63,560**.

The highest-volume product sold **520 units**, generating **R$37,104.30**.

These two results demonstrate why product performance should not be evaluated using volume alone.

A product can lead in units sold while another leads in revenue because of differences in price.

## Category strategy

The category analysis combines:

* number of products,
* items sold,
* total revenue,
* average revenue per item,
* review performance.

### Business implication

The strongest category is not necessarily the category with the largest catalog.

Management should distinguish between:

* **high-demand categories** — strong sales volume,
* **high-value categories** — strong revenue,
* **high-efficiency categories** — high revenue per item,
* **high-satisfaction categories** — strong reviews.

A category-level strategy should consider all four dimensions.

\---

# 5\. Seller Analysis

Seller performance should be evaluated through several dimensions:

* total revenue,
* items sold,
* orders fulfilled,
* average revenue per order,
* geographic location,
* revenue concentration.

## High-performing sellers

The analysis identifies sellers whose delivered-order revenue is above the marketplace-wide seller average.

These sellers represent an important commercial segment because they contribute more than the typical seller.

## Revenue per order

Seller revenue per order adds another dimension to seller performance.

A seller with fewer orders can still be commercially important if each order has a high monetary value.

## Seller concentration

The analysis calculates the percentage of marketplace revenue generated by the top 10 sellers.

### Business implication

High seller concentration creates a trade-off:

* high-performing sellers are valuable and should be protected;
* excessive dependence on a small group creates platform risk.

Olist should therefore support top sellers while continuing to diversify the seller ecosystem.

\---

# 6\. Revenue Analysis

The revenue analysis confirms strong marketplace expansion.

## Main finding

The first eight months of 2018 generated **R$7.22M**, compared with **R$5.96M during all of 2017**.

This indicates strong year-over-year commercial momentum.

## Revenue peaks

The strongest observed months were:

1. **November 2017 — R$987,765.37**
2. **May 2018 — R$977,544.69**
3. **April 2018 — R$973,534.09**

### Business implication

Revenue planning should account for both long-term growth and monthly demand volatility.

Operational capacity must grow alongside sales volume.

\---

# 7\. Payment Analysis

## Installment vs non-installment customers

|Customer Type|Count|Average Value|
|-|-:|-:|
|Installment Customer|48,208|R$204.40|
|Non-Installment Customer|45,149|R$123.34|

Installment customers have an average value approximately **65.7% higher** than non-installment customers.

### Business insight

Higher-value purchasing is strongly associated with installment usage in the supplied results.

This suggests that payment flexibility may help customers complete larger purchases by reducing the immediate financial burden.

This is an **association**, not proof that installments cause customers to spend more.

## Payment method customer value

|Payment Method|Records|Average Value|
|-|-:|-:|
|Credit Card|72,027|R$168.01|
|Boleto|18,717|R$147.99|
|Debit Card|1,470|R$141.78|
|Voucher|3,591|R$95.52|

Credit card transactions have the highest average value.

Voucher transactions have the lowest average value.

The credit-card average is approximately **75.9% higher** than the voucher average.

### Business implication

Payment flexibility should be considered part of the commercial strategy, not simply a technical checkout feature.

Priority areas include:

* reliable credit-card processing,
* reliable installment functionality,
* monitoring payment conversion,
* understanding whether payment method affects repeat purchasing.

\---

# 8\. Customer Satisfaction \& Reviews

The review analysis examines:

* review-score distribution,
* overall average review score,
* category satisfaction,
* seller satisfaction,
* delivery time vs review score,
* delivery status vs review score.

## Delivery and customer satisfaction

Orders are classified as:

* delivered early,
* delivered on time,
* delivered late.

The analysis then compares average review scores between these groups.

### Business insight

This creates a direct connection between operational performance and customer experience.

If late-delivered orders receive lower ratings, delivery should be treated as a commercial KPI rather than only a logistics KPI.

## Category satisfaction

Category review scores are compared with the marketplace-wide average.

This allows the business to identify categories that significantly outperform or underperform overall customer satisfaction.

### Business implication

Low category satisfaction should be investigated together with:

* delivery performance,
* seller performance,
* product expectations,
* product quality,
* order characteristics.

\---

# 9\. Delivery \& Operational Performance

Late delivery is defined as:

> Actual customer delivery date later than the estimated delivery date.

The analysis evaluates late delivery:

* overall,
* by state,
* over time,
* against customer review scores.

## Geographic delivery performance

Ranking states by late-delivery rate allows Olist to identify regions where logistics performance is weaker.

Potential operational explanations include:

* transportation constraints,
* geographic distance,
* carrier performance,
* regional fulfillment capacity,
* demand spikes.

## Delivery performance over time

Monthly late-delivery rates help determine whether poor performance is structural or associated with specific periods.

### Business implication

Delivery performance should be monitored alongside revenue and customer satisfaction.

A useful management framework is:

**Revenue Growth → Delivery Capacity → Customer Satisfaction → Repeat Purchase**

Growth that causes delivery deterioration can undermine future retention.

\---

# 10\. Cross-Section Business Insights

## 10.1 Growth is strong, but retention is the major opportunity

Revenue expanded strongly, but only **3.00% of customers were repeat customers**.

This means the next growth phase should not rely exclusively on acquiring new customers.

**Strategic takeaway:** improve the conversion from first purchase to second purchase.

## 10.2 Repeat customers are substantially more valuable

Repeat customers average **R$260.05**, compared with **R$137.96** for one-time customers.

That makes retention commercially attractive.

**Strategic takeaway:** increasing repeat purchase frequency can increase customer lifetime value without requiring the same level of new-customer acquisition.

## 10.3 Payment flexibility is associated with higher customer value

Installment customers average **R$204.40**, compared with **R$123.34** for non-installment customers.

Credit cards also have the highest average payment-method value at **R$168.01**.

**Strategic takeaway:** payment flexibility appears to be closely associated with higher-value purchasing behavior.

## 10.4 Delivery is part of the revenue engine

As order volume increases, logistics becomes increasingly important.

Poor delivery performance can reduce:

* review scores,
* customer satisfaction,
* repeat purchasing,
* marketplace reputation.

**Strategic takeaway:** logistics quality must scale with revenue growth.

## 10.5 High-value customers and sellers deserve differentiated management

The analysis identifies unusually valuable customers and above-average sellers.

**Strategic takeaway:** value-based segmentation should be applied to both sides of the marketplace.

\---

## Methodology Notes

* Revenue is based on **delivered orders only**.
* Month-over-month revenue growth begins in **January 2017** because 2016 contains partial/sparse observations.
* A repeat customer is a `customer\_unique\_id` associated with more than one delivered order.
* Late delivery means the actual delivery date is later than the estimated delivery date.
* The payment results in this report use the final payment tables supplied for the analysis.
* Payment-method counts should be interpreted according to the underlying query's unit of analysis; they are not automatically unique customers.
* The payment relationships are associations and should not be interpreted as causal without additional analysis.

