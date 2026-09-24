use e_commerce;

#-----------------------------e-commerce project----------------------

create database e_commerce;
use e_commerce;

create table Customers(
customer_id int primary key,
customer_name varchar(100) not null,
email varchar(100) unique not null,
phone varchar(15),
city varchar(255)
);

create table Categories(
category_id int primary key,
category_name varchar(100) not null
);

create table Products(
product_id int primary key,
category_id int,
product_name varchar(100) not null,
price decimal(10,2) not null,
stock_quantity int default 0,
foreign key(category_id) references Categories(category_id)
);

create table Orders(
order_id int primary key,
customer_id int,
product_id int,
quantity int default 0,
order_date date,
order_status varchar(50),
foreign key(customer_id) references Customers(customer_id),
foreign key(product_id) references Products(product_id)
);

create table Payments(
payment_id int primary key,
order_id int,
payment_method varchar(50),
payment_amount decimal(10,2),
payment_status varchar(50),
payment_date date,
foreign key(order_id) references Orders(order_id)
);


#values 1
insert into Customers values
(101,'Aarav Sharma','aarav@gmail.com','9876500001','Hyderabad'),
(102,'Bhavya Reddy','bhavya@gmail.com','9876500002','Vijayawada'),
(103,'Charan Kumar','charan@gmail.com','9876500003','Visakhapatnam'),
(104,'Divya Patel','divya@gmail.com','9876500004','Bengaluru'),
(105,'Esha Gupta','esha@gmail.com','9876500005','Chennai'),
(106,'Farhan Ali','farhan@gmail.com','9876500006','Mumbai'),
(107,'Gopi Krishna','gopi@gmail.com','9876500007','Warangal'),
(108,'Harini Rao','harini@gmail.com','9876500008','Guntur'),
(109,'Ishaan Verma','ishaan@gmail.com','9876500009','Pune'),
(110,'John Mathew','john@gmail.com','9876500010','Kochi');

#values 2
insert into Categories values
(201,'Electronics'),(202,'Fashion'),(203,'Books'),
(204,'Home Appliances'),(205,'Sports');

#values 3
insert into Products values
(301,201,'Laptop',65000,20),
(302,201,'Smartphone',25000,40),
(303,201,'Bluetooth Speaker',3000,50),
(304,202,'Running Shoes',4500,35),
(305,202,'Backpack',1800,60),
(306,203,'Python Programming',700,100),
(307,203,'SQL Complete Guide',650,80),
(308,204,'Mixer Grinder',4200,25),
(309,204,'Air Fryer',5500,18),
(310,205,'Cricket Bat',2200,30);

#values 4
insert into Orders values
(401,101,301,1,'2026-07-01','Delivered'),
(402,102,302,1,'2026-07-02','Delivered'),
(403,103,304,2,'2026-07-03','Shipped'),
(404,104,306,1,'2026-07-04','Delivered'),
(405,105,309,1,'2026-07-05','Pending'),
(406,106,303,3,'2026-07-06','Delivered'),
(407,107,307,2,'2026-07-07','Delivered'),
(408,108,305,1,'2026-07-08','Cancelled'),
(409,109,308,1,'2026-07-09','Delivered'),
(410,110,310,2,'2026-07-10','Shipped'),
(411,101,302,1,'2026-07-11','Delivered'),
(412,103,301,1,'2026-07-12','Pending');

#values 5
insert into Payments values
(501,401,'UPI',65000,'Paid','2026-07-01'),
(502,402,'Credit Card',25000,'Paid','2026-07-02'),
(503,403,'Debit Card',9000,'Paid','2026-07-03'),
(504,404,'UPI',700,'Paid','2026-07-04'),
(505,405,'Net Banking',5500,'Pending','2026-07-05'),
(506,406,'UPI',9000,'Paid','2026-07-06'),
(507,407,'Credit Card',1300,'Paid','2026-07-07'),
(508,408,'Cash on Delivery',1800,'Cancelled','2026-07-08'),
(509,409,'UPI',4200,'Paid','2026-07-09'),
(510,410,'Debit Card',4400,'Paid','2026-07-10'),
(511,411,'UPI',25000,'Paid','2026-07-11'),
(512,412,'Credit Card',65000,'Pending','2026-07-12');

select * from Payments;
select * from Products;
select * from Orders;
select * from Categories;
select * from Customers;

#1. Display all products along with their prices and available stock.
select product_name, price,stock_quantity from Products;

#2. increase the price of all products in a particular category by 5%.
update products set price = price * 1.05 where category_id = 1;


#3. change the payment status of a pending payment to paid.
set sql_safe_updates = 0;
update payments set payment_status = 'paid' where payment_status = 'pending';
set sql_safe_updates = 1;


#4.delete a cancelled order.
delete from orders where status = 'cancelled';


#5.display all customer names in uppercase and lowercase.
select name,upper(name) as uppercase_name,lower(name) as lowercase_name from customers;


#6.display the first five characters of each product name.
select product_name,left(product_name, 5) as first_five_characters from products;


#28.find customers who have never placed an order using not exists.
select c.customer_name from customers where not exists (select 1 from orders o where o.customer_id = c.customer_id);

select * from customers;

select * from orders;

#29.create a view named customer_order_details displaying customer name, product name, quantity, order date, and payment status.
describe orders;
describe products;
create view customer_order_details as select c.customer_name,p.product_name,o.quantity,o.order_date,pay.payment_status
from customers c join orders o on c.customer_id = o.customer_id join products p on o.product_id = p.product_id join payments
pay on o.order_id = pay.order_id;

select * from customer_order_details;


#30.create another view named category_sales_report displaying category name, total products sold, and total sales amount.
create view category_sales_report as select c.category_name,sum(o.quantity) as total_products_sold,
sum(o.quantity * p.price) as total_sales_amount from categories c join
products p on c.category_id = p.category_id join orders o on p.product_id = o.product_id group by c.category_id, c.category_name;

select * from category_sales_report;


#31.retrieve records from both views.
select * from customer_order_details;

select * from category_sales_report;


#32.start a transaction. update the stock quantity of a product. create a savepoint.then update the payment status of an order. roll back to the savepoint. commit the transaction.
#start the the transaction
start transaction;

#update the stock quantity
update products set stock_quantity = stock_quantity - 1 where product_id = 301;

select * from products;

select product_id, product_name, stock_quantity from products where product_id = 301;

#create a savepoint
savepoint stock_updated;


#cecking orders
select * from orders;


#update payment status for order 405
update payments set payment_status = 'paid' where order_id = 405;

select order_id, payment_status from payments where order_id = 405;


#roll back to the savepoint
rollback to savepoint stock_updated;


#commit the transcastion
commit;


#veryfyin te both
select product_id, product_name, stock_quantity from products where product_id = 301;

select order_id, payment_status from payments where order_id = 405;

start transaction;

update products
set stock_quantity = stock_quantity - 1
where product_id = 301;

savepoint stock_updated;

update payments
set payment_status = 'paid'
where order_id = 405;

rollback;

commit;

#sailu

#7. concatenate the customer name and city.
select concat(customer_name, ' - ', city) as customer_name_city from customers;

#8. replace the word guide with handbook in product names.
select product_name, replace(product_name, 'guide', 'handbook') as updated_product_name from products;

#9. display last week orders.
select * from orders where order_date >= curdate() - interval 7 day;

#10. find the number of days since each order was placed.
select order_id, order_date, datediff(curdate(), order_date) as days_since_order from orders;

#11. display the payment date in dd-mon-yyyy format.
select payment_id, date_format(payment_date, '%d-%b-%Y') as formatted_payment_date from payments;

#12. display the month and year of every order.
select order_id, date_format(order_date, '%m-%Y') as month_year from orders;


#23. display category names, product names, customer names, and order status in a single result.
select c.category_name,p.product_name,cu.customer_name,o.order_status from categories c join products p on c.category_id = p.category_id join orders o on p.product_id = o.product_id join customers cu on o.customer_id = cu.customer_id;

#24. find customers whose payment amount is greater than the average payment amount.
select distinct c.customer_name,pay.payment_amount from customers c join orders o on c.customer_id = o.customer_id join payments pay on o.order_id = pay.order_id where pay.payment_amount > (select avg(payment_amount) from payments);

#25. display the category that contains the most expensive product.
select c.category_name,p.product_name,p.price from categories c join products p on c.category_id = p.category_id where p.price = (select max(price) from products);

#26. find customers who purchased the highest-priced product.
select distinct c.customer_name, p.product_name, p.price from customers c join orders o on c.customer_id = o.customer_id join products p on o.product_id = p.product_id where p.price = (select max(price) from products);

#27. display products whose price is greater than the average price of all products.
select product_id, product_name, price from products where price > (select avg(price) from products);


#geethika
# 13. count the total number of products in each category.
select c.category_name,count(p.product_id) as total_products from categories c join products p on c.category_id = p.category_id group by c.category_id,c.category_name;

# 14. display the average product price for each category.
select c.category_name,avg(p.price) as average_price from categories c join products p on c.category_id = p.category_id group by c.category_id,c.category_name;

# 15. find the highest-priced product.
select product_id,product_name,price from products where price = (select max(price) from products);

# 16. display the total sales amount collected through each payment method.
select payment_method,sum(payment_amount) as total_sales_amount from payments group by payment_method;

# 17. find the average quantity ordered for each product.
select p.product_name,avg(o.quantity) as average_quantity from products p join orders o on p.product_id = o.product_id group by p.product_id,p.product_name;

# 18. display customer names, product names, and order dates.
select c.customer_name,p.product_name,o.order_date from customers c join orders o on c.customer_id = o.customer_id join products p on o.product_id = p.product_id;

# 19. display customer names, ordered products, and payment status.
select c.customer_name,p.product_name,pay.payment_status from customers c join orders o on c.customer_id = o.customer_id join products p on o.product_id = p.product_id join payments pay on o.order_id = pay.order_id;

# 20. display customer names, product names, quantity ordered, and payment amount.
select c.customer_name,p.product_name,o.quantity,pay.payment_amount from customers c join orders o on c.customer_id = o.customer_id join products p on o.product_id = p.product_id join payments pay on o.order_id = pay.order_id;

# 21. display all products along with their category names, even if no orders have been placed for them.
select p.product_name,c.category_name from products p join categories c on p.category_id = c.category_id left join orders o on p.product_id = o.product_id;

# 22. display all customers and their order details.
select c.customer_name,o.order_id,o.product_id,o.quantity,o.order_date,o.order_status from customers c left join orders o on c.customer_id = o.customer_id;







#33.Create a stored procedure to display products whose stock quantity is below a given value.
delimiter //

create procedure low_stock(in stock_limit int)
begin
    select product_name, price, stock_quantity
    from products
    where stock_quantity < stock_limit;
end //

delimiter ;

##34.Create a stored procedure to find the total number of orders placed by customers from a particular city.
delimiter //

create procedure orders_by_city(in city_name varchar(100))
begin
    select count(*) as total_orders
    from orders o
    join customers c on o.customer_id = c.customer_id
    where c.city = city_name;
end //

delimiter ;

#35.Create a stored procedure to display the details of a particular order.
delimiter //

create procedure order_details(in order_id_input int)
begin
    select c.customer_name, p.product_name, oi.quantity,
           o.order_date, o.order_status, pay.payment_status
    from orders o
    join customers c on o.customer_id = c.customer_id
    join order_items oi on o.order_id = oi.order_id
    join products p on oi.product_id = p.product_id
    join payments pay on o.order_id = pay.order_id
    where o.order_id = order_id_input;
end //

delimiter ;

#36.Create a trigger on the Products table to prevent stock quantity from becoming negative.
delimiter //

create trigger check_stock
before update on products
for each row
begin
    if new.stock_quantity < 0 then
        signal sqlstate '45000'
        set message_text = 'stock cannot be negative';
    end if;
end //

delimiter ;

#37.Create a trigger on the Orders table to automatically reduce product stock when a new order is placed.
delimiter //

create trigger reduce_stock
after insert on orders
for each row
begin
    update products
    set stock_quantity = stock_quantity - new.quantity
    where product_id = new.product_id;
end //

delimiter ;
