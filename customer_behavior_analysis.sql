select * from customer_behavior.mytable limit 20;

select gender, SUM(purchase_amount) as revenue
from mytable
group by gender;

select customer_id, purchase_amount
from mytable
where discount_applied = 'Yes' and purchase_amount >= (select AVG(purchase_amount) from mytable);

#top 5 product with highest review rating
select item_purchased,AVG(review_rating) as "Avarage Product Rating"
from mytable
group by item_purchased
order by avg(review_rating) desc
limit 5;


#compare the avarage Purchase amounts between Standard and express Shpping.
select shipping_type,
avg(purchase_amount)
from mytable
where shipping_type in ('Standard' , 'Express')
group by shipping_type;

#Compare avarage spend and total revenue b/w subscribers and non subscribers.
select subscription_status,
count(customer_id) as total_customers,
avg(purchase_amount) as  avg_spend,
sum(purchase_amount) as total_revenue
from mytable
group by subscription_status
order by total_revenue, avg_spend desc;

#which 5 products that have highest percentage of purchases with discouunt applied?
select item_purchased,
SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END)/COUNT(*)*100 as discount_rate
from mytable
group by item_purchased
order by discount_rate desc
limit 5;

# Segment customers into New, Returning, and Loyal based on their previous perchases, each count segment.
with customer_type as( 
select customer_id, previous_purchases,
CASE 
    WHEN previous_purchases  = 1 THEN 'New'
    WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
    ELSE 'Loyal'
    END AS customer_segment
from mytable)

Select customer_segment, count(*) as "Number of customers"
from customer_type
group by customer_segment;

#top 3 most purchased product within each category?
with item_count as(
select category,
item_purchased,
COUNT(customer_id) as total_orders,
ROW_NUMBER() over(partition by category order by count(customer_id) DESC) as item_rank
from mytable
group by category, item_purchased
)

select item_rank, category, item_purchased, total_orders
from item_count
where item_rank <=3;

#Are repeat buyers aslo likely to subscribe?
select subscription_status,
count(customer_id)as repeat_buyers
from  mytable
where previous_purchases >5 
group by subscription_status;

#Revenue contribution of each age group.
select age_group,
sum(purchase_amount) as total_revenue
from mytable
group by age_group
order by total_revenue desc;




