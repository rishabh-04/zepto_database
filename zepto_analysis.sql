#view 10 rows
SELECT * FROM demo1.zepto_v2;
#count no of rows
SELECT count(*) FROM demo1.zepto_v2;
#null values
select * from demo1.zepto_v2 where name = null or mrp = null or discountPercent=null or availableQuantity=null;
#different product categories
select distinct category from  demo1.zepto_v2 order by category; #if not specified text --> alphabetical

#product instock vs outstock
select outOfStock,count(outOfStock) from demo1.zepto_v2 group by outOfStock;

#product name repeated
select name,count(name) as "NAME OF SKU" from demo1.zepto_v2 group by name having count(name)>1 order by count(name) desc;  #order by -- row order, group by -- row grouping

#data cleaning
select * from demo1.zepto_v2 where mrp=0 or discountedSellingPrice=0;
#deleting
delete from demo1.zepto_v2 where mrp=0 limit 1;
#cross check
select * from demo1.zepto_v2 where mrp=0 or discountedSellingPrice=0;
#converting paisa --> rupee
update demo1.zepto_v2
set mrp = mrp/100.00,
discountedSellingPrice = discountedSellingPrice/100.00 limit 3800;

SELECT * FROM demo1.zepto_v2;
#now onto business insights
-- Q1. Find the top 10 best-value products based on the discount percentage.
SELECT distinct * FROM demo1.zepto_v2  order by discountPercent desc limit 10;

-- Q2.What are the Products with High MRP but Out of Stock
select distinct name,mrp,outOfStock  from demo1.zepto_v2 where outOfStock ="TRUE" order by mrp desc limit 15;

-- Q3.Calculate Estimated Revenue for each category
select Category, sum(discountedSellingPrice*availableQuantity) as "Revenue" FROM demo1.zepto_v2  group by Category order by Revenue desc;

-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
select * from demo1.zepto_v2 where mrp > 500 and discountPercent < 10 order by mrp desc , discountPercent desc;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.
select Category ,avg(discountPercent) as "avg disc" from demo1.zepto_v2 group by category order by avg(discountPercent) desc limit 5;


-- Q6. Find the price per gram for products above 100g and sort by best value
select distinct name , round(discountedSellingPrice/weightInGms,2) as price_per_gram , weightInGms from demo1.zepto_v2 where weightInGms>=100 order by  price_per_gram asc;

SELECT DISTINCT name, 
       ROUND(discountedSellingPrice / weightInGms, 2) AS `price per gram`, 
       weightInGms 
FROM demo1.zepto_v2 
WHERE weightInGms >= 100 
ORDER BY `price per gram` asc;

-- Q7.Group the products into categories like Low, Medium, Bulk.
SELECT name,weightInGms, 
case when weightInGms<1000 then 'Low' 
when weightInGms<5000 then 'Medium' 
else 'Bulk' end as weight_category
 FROM demo1.zepto_v2 order by weightInGms desc;
 
-- Q8.What is the Total Inventory Weight Per Category 
select Category,sum(weightInGms*availableQuantity) as total_inventory_weight from demo1.zepto_v2 group by Category order by total_inventory_weight;
