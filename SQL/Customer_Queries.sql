select * from customer limit 20

--what is the total revenue genrated by male vs female customers?
select sum(purchase_amount) as revenue, gender
from customer
group by gender

--which customer used a discount but still spent more than the average purchase amount?
select customer_id, purchase_amount
from customer
where purchase_amount >= (select avg(purchase_amount) from customer)
and discount_applied = 'Yes'

--which are the top 5 products with the highest average rreview rating?
select item_purchased as product , avg(review_rating) as Average_Review_rating
from customer
group by item_purchased
order by avg(review_rating) desc
limit 5

--Compare the average purchase amounts between standard and express shipping
SELECT ROUND(AVG(purchase_amount),2) as AVERAGE_PURCHASE_AMOUNT , shipping_type
from customer
where shipping_type in ('Standard', 'Express')
group by shipping_type

--Do subscribed customers spend more? Compare average spend and total revenue between subscribers and non subscribers
select Round(avg(purchase_amount),2) as average_spend, sum(purchase_amount) as total_revenue, subscription_status
, count(customer_id) as total_customers
from customer
group by subscription_status

--which 5 products have the highest percentage of purchases with discounts applied?
select item_purchased, discount_applied
from customer
where discount_applied = 'Yes'
order by item_purchased desc
limit 5

--segment customers into new, returning and loyal based on their total number of previous purchases
-- and show the count of each segment.
with customer_type as (select  customer_id,previous_purchases, 
case  
     when previous_purchases = 1 then 'New'
	 when previous_purchases between 2 and 10 then 'Returning'
	 else 'Loyal'
	 End as customer_segment
from customer
)
select customer_segment , count(*) as "Number of Customers"
from customer_type
group by customer_segment

--what are the top 3 most purchased products within each category?
with item_counts as 
(select category, item_purchased, count(customer_id) as total_orders, 
row_number() over (partition by category order by count(customer_id) desc) as item_rank
from customer
group by category, item_purchased )
select item_rank, category, item_purchased, total_orders
from item_counts
where item_rank <= 3


--are customers who are repeat buyers (more than 5 previous purchases) also likely to subscribe
select subscription_status, count (customer_id) as repeat_buyers
from customer
where previous_purchases > 5
group by subscription_status

--what is the revenue contribution by each age group
select sum(purchase_amount) as total_revenue, age_group
from customer
group by age_group
order by total_revenue

	 
	 








