CREATE TABLE zepto (
    sku_id INT IDENTITY(1,1) PRIMARY KEY,
    category VARCHAR(120),
    name VARCHAR(150) NOT NULL,
    mrp DECIMAL(8,2),
    discountPercent DECIMAL(5,2),
    availableQuantity INT,
    discountedSellingPrice DECIMAL(8,2),
    weightInGms INT,
    outOfStock BIT,	
    quantity INT
);

drop table zepto;

------------------------------------------------------------

select * from zepto_v1

select  * into zepto from zepto_v1

select * from zepto;

SELECT COUNT(*) FROM zepto;

select top 10 * from zepto

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='zepto'


SELECT DISTINCT category
FROM zepto
ORDER BY category;


select name,count(outOfStock)
from zepto
group by name

--Q1. Top 10 best-value products by discount percentage

select  top 10  name
from zepto
order by discountPercent desc


with cte as (select *,row_number()over(partition by name,category,mrp  order by name) as rnk
from zepto)
select * from cte where rnk>1


 select top 20 * from zepto

 --Q2. Products with high MRP but out of stock

 select name , mrp
 from zepto
 where outOfStock=1 and mrp>300
 order by mrp desc

 SELECT DISTINCT name, mrp
FROM zepto
WHERE outOfStock = 1 AND mrp > 300
ORDER BY mrp DESC;


SELECT
    category,
    name,
    mrp,
    discountPercent,
    discountedSellingPrice,
    weightInGms,
    outOfStock,
    SUM(quantity) AS total_quantity,
    SUM(availableQuantity) AS total_available_quantity
FROM zepto
GROUP BY
    category,
    name,
    mrp,
    discountPercent,
    discountedSellingPrice,
    weightInGms,
    outOfStock;


    --convert paise to rupees

    select top 10 * from zepto

    update zepto 
    set mrp = mrp/100.0, discountedSellingPrice=discountedSellingPrice/100.0

    --Q3.Calculate Estimated Revenue for each category

    select category,sum(discountedSellingPrice*availableQuantity)as Revenue
    from zepto
    group by Category
    order by Revenue desc


    -- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.

    select distinct name,mrp,discountPercent
    from zepto
    where mrp>500 and discountPercent<10


    -- Q5. Identify the top 5 categories offering the highest average discount percentage.

    select top 5 category , avg(discountPercent) as AVGPERCENT
    from zepto
    group by Category
    order by AVGPERCENT desc

    -- Q6. Find the price per gram for products above 100g and sort by best value.

   
    SELECT DISTINCT
    name,
    weightInGms,
    discountedSellingPrice,
    ROUND(discountedSellingPrice * 1.0 / weightInGms, 2) AS price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram;

--Q7.Group the products into categories like Low, Medium, Bulk.

select Category,name ,
       case when weightInGms <1000 then 'Low'
       when weightInGms <5000 then 'Medium'
       else 'Bulk'
       end as WeightCategory
       from Zepto
                          

--Q8.What is the Total Inventory Weight Per Category 

select category , sum(weightInGms*availableQuantity) as TotalWeight
from Zepto
group by Category
order by TotalWeight

     --Handling Overflow error :
     SELECT
    category,
    SUM(
        CAST(weightInGms AS BIGINT) *
        CAST(availableQuantity AS BIGINT)
    ) AS TotalWeight
FROM zepto
GROUP BY category
ORDER BY TotalWeight;