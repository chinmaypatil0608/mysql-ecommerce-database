# MySQL E-commerce Database

## Requirements
MySQL Server 8+ and MySQL Workbench (or MySQL CLI).

## Steps
1. Open MySQL Workbench and connect to your local MySQL server.
2. Open `schema.sql`.
3. Execute the whole script. It creates the database, tables, sample records and queries.
4. Run `USE ecommerce_db;` if needed.
5. Execute each numbered query separately and inspect the result grid.
6. Try inserting another customer and product.
7. Practise changing the sample queries: use a different city, status or stock threshold.

## Schema relationships
- One customer can have many orders.
- One order can have many order items.
- One product can appear in many order items.
- `order_items` connects orders and products (many-to-many relationship).

## Concepts
DDL, DML, primary and foreign keys, unique and check constraints, joins, aggregate functions, GROUP BY, subqueries, views and transactions.

## Caution
The script drops and recreates the four project tables so it can be rerun consistently. Do not run it against a database containing data you need to keep. The stock update is a teaching example; a production system would validate affected row counts and coordinate stock and order updates in one transaction.
