Project Overview

The E-Commerce Database Management System is a MySQL-based database project designed to manage products, customers, orders, payments, and product categories.

This project demonstrates important DBMS and SQL concepts such as:

Database and table creation
Primary and foreign keys
select, insert, update, and delete
Joins
Aggregate functions
Stored procedures
Triggers
Constraints
Data manipulation and retrieval
🛠️ Technologies Used
Database: MySQL
Tool: MySQL Workbench
Language: SQL
🗂️ Database Structure

The project contains the following main tables:

1. Customers

Stores customer information.

customer_id
customer_name
email
phone
city
2. Categories

Stores product categories.

category_id
category_name
3. Products

Stores product details.

product_id
product_name
price
stock_quantity
category_id
4. Orders

Stores customer order information.

order_id
customer_id
product_id
quantity
order_date
order_status
5. Payments

Stores payment information.

payment_id
order_id
payment_status
payment_method
⚙️ SQL Features Implemented
Basic Queries

The project includes queries to:

Display products and their prices
Display available stock
Update product prices
Update payment status
Retrieve customer information
Retrieve order information
Aggregate Functions

Examples include:

count()
sum()
avg()
max()
min()

These are used to calculate:

Total products
Average product price
Highest product price
Total sales
Number of orders
🔄 Stored Procedures
1. Low Stock Products

Displays products whose stock is below a given value.

call low_stock(10);
2. Orders by City

Finds the total number of orders placed by customers from a particular city.

call orders_by_city('hyderabad');
3. Order Details

Displays details of a particular order.

call order_details(101);
⚡ Triggers
1. Prevent Negative Stock

The trigger prevents a product's stock quantity from being updated to a negative value.

create trigger check_stock
before update on products
for each row
begin
    if new.stock_quantity < 0 then
        signal sqlstate '45000'
        set message_text = 'stock cannot be negative';
    end if;
end
2. Automatically Reduce Product Stock

Whenever a new order is inserted, the corresponding product stock is automatically reduced according to the ordered quantity.

create trigger reduce_stock
after insert on orders
for each row
begin
    update products
    set stock_quantity = stock_quantity - new.quantity
    where product_id = new.product_id;
end
🎯 Project Objectives
Understand relational database concepts
Practice SQL queries
Implement relationships between tables
Use joins to retrieve related data
Create stored procedures for reusable operations
Use triggers for automatic database actions
Maintain data consistency and integrity
📚 DBMS Concepts Covered
Database Creation
Table Creation
Primary Key
Foreign Key
Constraints
DDL
DML
DQL
Joins
Aggregate Functions
group by
having
Subqueries
Stored Procedures
Triggers
Transactions
🚀 How to Run the Project
Install MySQL Workbench.
Open the SQL project file.
Create the database.
Select the database using:
use e_commerce;
Create the required tables.
Insert sample data.
Execute the SQL queries.
Create the stored procedures and triggers.
Test the procedures using call.


Conclusion

This project provides practical experience in designing and managing an E-Commerce database using MySQL. It demonstrates how SQL queries, stored procedures, and triggers can be used to efficiently manage customers, products, orders, and payments while maintaining database consistency.
