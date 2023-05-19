/* What is the total amount each customer has spent on Zomato?*/

select userid, sum(price) total_amount from product
inner join sales on
product.product_id = sales.product_id
group by userid
