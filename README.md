# Olist E-Commerce Business Analysis — SQL

## Project Overview

This project analyzes the **Olist Brazilian e-commerce marketplace** using MySQL and SQL.

The objective is to move from raw transactional data to actionable business insights by following a structured analytical workflow:

**Database Setup → Data Audit → Data Cleaning → Exploratory Data Analysis → Business Analysis → Business Insights → Business Recommendations**

The analysis focuses on the main drivers of marketplace performance: revenue growth, customer retention, products and categories, seller performance, payment behavior, delivery execution, and customer satisfaction.

> \*\*Core business question:\*\* How can Olist convert strong transaction and revenue growth into higher customer lifetime value while maintaining delivery reliability, seller quality, payment flexibility, and customer satisfaction?

\---

## Business Context

Olist operates as a multi-sided marketplace connecting customers and sellers. Because marketplace performance depends on several interconnected components, the analysis does not treat revenue as the only success metric.

The project evaluates the relationship between:

* Customer acquisition and retention
* Order and revenue growth
* Product and category performance
* Seller performance
* Payment behavior
* Delivery performance
* Customer satisfaction

Revenue is consistently defined as **revenue from delivered orders** in the business-analysis stage. The month-over-month revenue analysis begins in January 2017 because the 2016 data is partial and sparse.

\---

## Project Structure

```text
olist-sql-business-analysis/
│
├── 00_dataset_setup.sql
├── 01_data_audit.sql
├── 02_data_cleaning.sql
├── 03_exploratory_data_analysis.sql
├── 04_business_analysis.sql
├── 05_business_insights.md
├── 06_business_recommendations.md
└── README.md
```

\---

## Dataset \& Setup

The project uses the Olist e-commerce dataset and works with the following relational tables:

|Table|Purpose|
|-|-|
|`orders`|Order status, timestamps, delivery dates|
|`customers`|Customer identity and geographic information|
|`order_items`|Products, sellers, prices, and freight|
|`products`|Product and category attributes|
|`payments`|Payment methods, installments, and payment values|
|`reviews`|Customer review scores and comments|
|`sellers`|Seller identity and geographic information|
|`category_translation`|Portuguese-to-English category translation|

**Original dataset:** [Olist Brazilian E-Commerce Public Dataset — Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce/data?utm_source=chatgpt.com)

To reproduce the analysis:

1. **Download the original dataset from the source**  
Download the Olist dataset directly from the Kaggle page linked above.
2. **Place the CSV files in the expected local directory**  
Place all downloaded CSV files in the directory expected by `00_dataset_setup.sql`.  
Update the file paths in the setup script if necessary to match your local environment.
3. **Run `00_dataset_setup.sql`**  
This creates the `e_commerce` database, defines the required tables, and loads the CSV files into MySQL.
4. **Continue through the SQL scripts**  
Execute the remaining scripts in order:

```text
   01_data_audit.sql
   02_data_cleaning.sql
   03_exploratory_data_analysis.sql
   04_business_analysis.sql
   ```

5. **Review the final outputs**  
After completing the analysis, review:

```text
   05_business_insights.md
   06_business_recommendations.md
   ```

\---

### 00 — Dataset Setup

Creates the `e_commerce` database, defines the tables, and loads the Olist CSV datasets into MySQL.

The setup creates eight tables covering customers, orders, order items, products, payments, reviews, sellers, and category translations.

### 01 — Data Audit

Performs the initial quality audit before analysis:

* Row counts
* Primary-key duplicate checks
* Composite-key duplicate checks
* Missing-value checks
* Dataset date range
* Order-status distribution

The audit is designed to verify that the imported data is structurally suitable for analysis.

### 02 — Data Cleaning

Standardizes missing review comments by converting empty strings to `NULL`.

This keeps missing review titles and messages consistent with SQL's representation of missing values.

### 03 — Exploratory Data Analysis

Explores the marketplace across several dimensions:

* Business overview
* Time and order trends
* Order status and fulfillment
* Delivery performance
* Customer geography
* Product categories
* Seller performance
* Payment methods
* Payment installments
* Review scores
* Delivery time and customer satisfaction

### 04 — Business Analysis

Builds the final business-oriented analysis using more advanced SQL techniques, including:

* `CTE`
* `LAG()`
* `SUM() OVER()`
* `NTILE()`
* `DENSE\_RANK()`
* Aggregations
* Multi-table joins
* Conditional logic
* Customer-level segmentation

The business analysis focuses on questions that can directly support management decisions.

### 05 — Business Insights

Documents the final findings from the analysis in business language.

### 06 — Business Recommendations

Translates the findings into prioritized management actions and suggested KPIs.

\---

# Key Business Findings

## 1\. Revenue Growth Is Strong

Delivered-order revenue reached:

|Period|Revenue|
|-|-:|
|2017|R$5,962,902.01|
|Jan–Aug 2018|R$7,218,125.12|
|Cumulative through Aug 2018|R$13,221,498.11|

The first eight months of 2018 generated more revenue than the entire 2017 period.

Revenue also showed meaningful volatility:

* **November 2017:** +52.37% month-over-month
* **December 2017:** -26.50% month-over-month

The strongest observed revenue months were:

1. November 2017 — **R$987,765.37**
2. May 2018 — **R$977,544.69**
3. April 2018 — **R$973,534.09**

### Business meaning

Growth is strong, but peak demand requires sufficient seller capacity, inventory, logistics, customer support, and operational capacity.

\---

## 2\. Customer Retention Is the Biggest Opportunity

Only **2,801 customers**, or **3.00%**, were repeat customers.

However:

|Customer Type|Average Revenue|
|-|-:|
|Repeat Customer|R$260.05|
|One-Time Customer|R$137.96|

Repeat customers generate approximately **1.88×** the average revenue of one-time customers, or roughly **88.5% more**.

The highest-value customer generated **R$13,440**.

### Business meaning

The marketplace is successfully generating transactions, but converting first-time customers into repeat buyers represents a major opportunity to increase customer lifetime value.

\---

## 3\. Product Performance Should Not Be Measured by Volume Alone

The highest-revenue individual product generated approximately **R$63,560**.

The highest-volume product sold **520 units**, generating **R$37,104.30**.

The analysis therefore distinguishes between:

* Sales volume
* Total revenue
* Revenue per item
* Category size
* Customer satisfaction

### Business meaning

A high-volume category is not necessarily the most financially valuable category. Product and category decisions should consider demand, revenue efficiency, and satisfaction together.

\---

## 4\. Seller Performance Is Uneven

The analysis evaluates sellers using:

* Total revenue
* Items sold
* Orders fulfilled
* Average revenue per order
* Geographic distribution
* Revenue concentration

High-performing sellers contribute disproportionately to marketplace performance.

At the same time, excessive dependence on a small number of sellers creates platform risk.

### Business meaning

Olist should protect high-performing sellers while continuing to develop emerging sellers and diversify the seller ecosystem.

\---

## 5\. Payment Flexibility Is Associated With Higher Customer Value

Installment customers:

* **48,208**
* Average value: **R$204.40**

Non-installment customers:

* **45,149**
* Average value: **R$123.34**

Installment customers therefore have an average value approximately **65.7% higher**.

Average customer value by payment method:

|Payment Method|Records|Average Value|
|-|-:|-:|
|Credit Card|72,027|R$168.01|
|Boleto|18,717|R$147.99|
|Debit Card|1,470|R$141.78|
|Voucher|3,591|R$95.52|

Credit-card transactions have the highest average value, while voucher transactions have the lowest.

### Important qualification

These results demonstrate **association, not causation**. The analysis does not prove that installment payments cause customers to spend more.

### Business meaning

Payment flexibility should be treated as part of the commercial strategy, with particular attention to credit-card processing, installment functionality, payment conversion, and the relationship between payment behavior and repeat purchasing.

\---

## 6\. Delivery Performance Is a Customer-Experience Issue

Late delivery is defined as:

> The actual customer delivery date is later than the estimated delivery date.

The analysis evaluates late delivery:

* Overall
* By state
* Over time
* Against customer review scores

The highest observed late-delivery rates included:

|State|Late Delivery Rate|
|-|-:|
|AL|21.41%|
|MA|17.43%|
|SE|15.22%|
|PI|13.87%|
|CE|13.76%|

AL, MA, and SE therefore deserve particular attention.

The supplied satisfaction analysis also showed a substantial difference between early and late delivery:

* **Early delivery:** 4.29 average review
* **Late delivery:** 2.27 average review

### Business meaning

Delivery should not be treated only as a logistics KPI. It is directly connected to customer satisfaction and potentially to retention.

The strategic relationship is:

**Revenue Growth → Delivery Capacity → Customer Satisfaction → Repeat Purchase**

\---

# Cross-Section Business Story

The most important conclusion is not any single metric.

The analysis shows a connected marketplace system:

```text
Revenue Growth
      ↓
More Customers \& Orders
      ↓
Delivery Capacity
      ↓
Customer Experience
      ↓
Customer Satisfaction
      ↓
Repeat Purchase
      ↓
Higher Customer Lifetime Value
```

Payment flexibility and seller quality influence this system as well:

```text
Product
   ↓
Seller
   ↓
Payment
   ↓
Delivery
   ↓
Satisfaction
   ↓
Repeat Purchase
```

The strongest immediate opportunity is the gap between the **3.00% repeat-customer rate** and the substantially higher value generated by repeat customers.

\---

# Business Recommendations

The detailed recommendations are documented separately in `06\_business\_recommendations.md`.

The priority matrix is:

|Priority|Recommendation|Business Impact|Urgency|
|-|-|-|-|
|1|Increase repeat purchases|Very High|Very High|
|2|Protect high-value customers|Very High|High|
|3|Improve delivery reliability|Very High|Very High|
|4|Use payment flexibility strategically|High|High|
|5|Prepare for revenue peaks|High|High|
|6|Optimize product/category mix|High|Medium|
|7|Protect and diversify sellers|High|Medium|
|8|Build cross-functional retention analytics|High|Medium|

\---

# Recommended Management KPIs

The analysis suggests monitoring commercial, customer, product, seller, payment, logistics, and satisfaction metrics together.

### Growth

* Delivered revenue
* Monthly revenue growth
* Orders
* Average order value

### Customers

* Repeat customer rate
* Second-purchase conversion
* Customer lifetime value
* High-value customer retention

### Products

* Revenue by category
* Units sold
* Revenue per item
* Category review score

### Sellers

* Seller revenue
* Revenue per order
* Seller growth
* Top-10 revenue concentration

### Payments

* Payment success rate
* Installment adoption
* Average value by payment method
* Payment conversion

### Logistics

* On-time delivery rate
* Late-delivery rate
* Late-delivery rate by state
* Late-delivery rate by seller/carrier

### Satisfaction

* Average review score
* Review score by delivery status
* Category satisfaction
* Seller satisfaction

\---

# SQL Techniques Demonstrated

This project demonstrates practical SQL skills used in business analysis.

### Core SQL

* `SELECT`
* `WHERE`
* `GROUP BY`
* `ORDER BY`
* `HAVING`
* `CASE`
* Aggregate functions
* Multi-table `JOIN`s
* Subqueries

### Advanced SQL

* Common Table Expressions (`WITH`)
* Window functions
* `LAG()`
* `SUM() OVER()`
* `DENSE\_RANK()`
* `NTILE()`
* Running/cumulative calculations
* Customer-level aggregation
* Ranking and segmentation
* Conditional classification

### Analytical Patterns

Examples include:

* Month-over-month growth
* Year-over-year growth
* Cumulative revenue
* Revenue contribution
* Customer segmentation
* Repeat-customer analysis
* High-value customer identification
* Product revenue vs volume
* Seller concentration
* Delivery-risk analysis
* Review-score comparisons
* Payment-method analysis
* Installment behavior

\---

# Methodology \& Definitions

To keep the analysis consistent, several definitions are applied throughout the project.

### Revenue

Revenue is based on **delivered orders only**.

For product and seller revenue analysis, revenue is calculated from `order\_items.price`.

### Repeat Customer

A repeat customer is a `customer\_unique\_id` associated with more than one delivered order.

### One-Time Customer

A one-time customer has exactly one delivered order.

### Late Delivery

A delivery is classified as late when:

```text
actual customer delivery date > estimated delivery date
```

### High-Value Order

A high-value order is defined as an order in the **top 10% of delivered orders based on total payment value**.

### Payment Analysis

Payment-method and installment results are interpreted as associations. They should not be treated as causal relationships without additional analysis.

Payment counts should also be interpreted according to the unit of analysis used by each query; payment records are not automatically unique customers.

\---

# Limitations

This project is a historical descriptive and diagnostic analysis. It identifies patterns and business opportunities but does not establish causality.

In particular:

* The data represents a historical period rather than current marketplace performance.
* The 2016 period is partial and sparse.
* Payment behavior is observational.
* Higher installment usage does not prove that installments cause higher spending.
* Delivery and review relationships are associations rather than causal estimates.
* Additional analysis would be required to control for customer, product, seller, and order characteristics.

\---

# Next Analytical Steps

The recommendations document proposes a deeper analytical roadmap.

## Phase 1 — Customer Retention

Analyze:

* Time to second purchase
* Repeat rate by category
* Repeat rate by payment method
* Repeat rate by seller
* Repeat rate by delivery status
* Repeat rate by customer state

## Phase 2 — Delivery Drivers

Analyze:

* Seller vs late delivery
* Carrier vs late delivery
* State vs late delivery
* Processing time vs late delivery
* Order volume vs late delivery
* Peak period vs late delivery

## Phase 3 — Payment Behavior

Test whether payment method remains associated with order value after controlling for:

* Product category
* Customer type
* Order characteristics
* Seller
* Purchase period

## Phase 4 — Customer Value

Develop customer segments based on:

* Revenue
* Frequency
* Recency
* Delivery experience
* Satisfaction

This can eventually support an RFM-style customer segmentation model.

\---

# Final Takeaway

> \*\*Olist has strong transaction and revenue growth, but the largest opportunity is converting that growth into repeat customer value while maintaining delivery and marketplace quality.\*\*

The recommended strategic sequence is:

**1. Acquire customers → 2. Deliver a strong first experience → 3. Convert them to a second purchase → 4. Increase customer lifetime value → 5. Protect the operational system that enables retention.**

This project demonstrates how SQL can move beyond querying data to answer real business questions and translate transactional data into **business insights, priorities, and measurable recommendations**.

\---

## Project Deliverables

* `00\_dataset\_setup.sql` — Database creation and dataset loading
* `01\_data\_audit.sql` — Data quality audit
* `02\_data\_cleaning.sql` — Data cleaning
* `03\_exploratory\_data\_analysis.sql` — Exploratory analysis
* `04\_business\_analysis.sql` — Business-focused SQL analysis
* `05\_business\_insights.md` — Final business insights
* `06\_business\_recommendations.md` — Business recommendations
* `README.md` — Project documentation

\---

## Tools

* **MySQL**
* **SQL**
* **Git / GitHub**
* **Markdown**

