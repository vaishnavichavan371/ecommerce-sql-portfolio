# E-Commerce Sales & Customer Analytics Using SQL
## Project Objective

To analyze e-commerce sales and customer data using SQL to identify revenue trends, top-performing products and categories, customer purchasing behavior, and key business performance metrics.

## Tools Used

- PostgreSQL
- pgAdmin 4
- SQL
- VS Code


## Dataset

This project uses an e-commerce dataset containing:

- 500 customers
- 20 products
- 5,000 orders
- Order dates from January 2025 to December 2025


## Database Structure

The project contains three main tables:

### 1. customers
- `customer_id` — Unique customer ID
- `customer_name` — Customer name
- `city` — Customer city
- `state` — Customer state

### 2. products
- `product_id` — Unique product ID
- `product_name` — Product name
- `category` — Product category
- `price` — Product price

### 3. orders
- `order_id` — Unique order ID
- `customer_id` — Customer who placed the order
- `product_id` — Product ordered
- `quantity` — Number of units ordered
- `order_date` — Date of the order


## Data Quality Checks

Before performing the analysis, I checked the dataset for:

- Total row counts
- Missing values (NULLs)
- Duplicate customer IDs
- Duplicate product IDs
- Duplicate order IDs
- Order date range
- Minimum and maximum order quantity

The data passed these initial quality checks and was suitable for further analysis.

## SQL Analysis

The project uses SQL to analyze:

- Total revenue and total orders
- Average Order Value (AOV)
- Average units sold per order
- Monthly revenue trends
- Revenue by product category
- Units sold by category
- Top-performing products by revenue
- Top-performing products by units sold
- Top customers by revenue
- Top cities by revenue
- Customer order behavior
- Customer purchasing frequency
- Customer retention across different months
- Average revenue and order value per customer

## Key Business Results

- Total revenue: ₹19,893,976
- Total orders: 5,000
- Total units sold: 8,224
- Average Order Value: ₹3,978.80
- Average units per order: 1.64
- Highest-revenue month: August
- Lowest-revenue month: June
- Highest-revenue category: Furniture
- Highest-units category: Electronics
- Top-revenue product: Office Chair
- Top-revenue customer: Priya Nair
- Top-revenue city: Kochi

## SQL Concepts Demonstrated

- SELECT and filtering
- Aggregate functions
- GROUP BY and HAVING
- INNER JOIN
- Subqueries
- Common Table Expressions (CTEs)
- Date and time functions
- CASE statements
- Window functions
- Conditional aggregation
- Sorting and LIMIT
- Data quality checks

## Key Insights

- August generated the highest monthly revenue, while June generated the lowest.
- Furniture generated the highest revenue among product categories.
- Electronics had the highest number of units sold.
- The product generating the highest revenue was Office Chair.
- The customer generating the highest revenue was Priya Nair.
- Kochi was the highest-revenue city.
- Customer purchasing behavior varied across order frequency, total spending, and product variety.
- 99.40% of customers placed orders across at least three different months.

## Project Workflow

1. Imported the e-commerce dataset into PostgreSQL.
2. Performed data quality checks for missing values, duplicates, dates, and quantities.
3. Calculated overall sales and order metrics.
4. Analyzed monthly revenue and category performance.
5. Identified top-performing products, customers, and cities.
6. Analyzed customer purchasing behavior and retention.
7. Used SQL techniques to convert raw data into meaningful business insights.