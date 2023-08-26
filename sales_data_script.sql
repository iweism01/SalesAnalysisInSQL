-- Inspecting data
select * from sales_data;

-- checking unique values
select distinct status from sales_data;
select distinct year_id from sales_data;
select distinct productline from sales_data;
select distinct country from sales_data;
select distinct dealsize from sales_data;
select distinct territory from sales_data;

select distinct month_id from sales_data
where year_id = 2005;
-- 2005 sales only go up to May

-- ANALYSIS

-- grouping sales by productline
select productline, sum(sales) as Revenue
from sales_data
group by productline
order by 2 desc;

-- grouping sales by year
select year_id, sum(sales) as Revenue
from sales_data
group by year_id
order by 2 desc;

-- grouping sales by deal size
select dealsize, sum(sales) as Revenue
from sales_data
group by dealsize
order by 2 desc;

-- what was the best month for sales
select month_id, sum(sales) as Revenue, count(ordernumber) as Frequency
from sales_data
where year_id = 2004
group by month_id
order by 2 desc;
-- november is by far the best month for sales for both 2003 and 2004

-- what product do they sell in November
select month_id, productline, sum(sales) as Revenue, count(ordernumber) as Frequency
from sales_data
where year_id = 2004 and month_id = 11
group by month_id, productline
order by 3 desc;

-- who is the best customer
select customername, count(ordernumber) as Frequency, sum(priceeach*quantityordered) as CustomerSpending, 
datediff((select max(orderdate) from sales_data), max(orderdate)) as DaysSinceLastPurchase,
case
	when datediff((select max(orderdate) from sales_data), max(orderdate)) > 365 then 'lost customer'
    else 'loyal customer'
end as CustomerClassification,
case
	when sum(priceeach*quantityordered) > 100000 then 'High Spender'
    when sum(priceeach*quantityordered) > 50000 then 'Average Spender'
    else 'low spender'
end as SpendingClassification,
case
	when count(ordernumber) > 100 then 'frequent customer'
    when count(ordernumber) > 20 then 'occasional customer'
    else 'rare customer'
end as FrequencyClassification
from sales_data
group by customername
order by 2 desc;

-- what products are sold together most often
select
    o1.productcode as productcode1,
    o2.productcode as productcode2,
    (COUNT(DISTINCT o1.ordernumber) / (SELECT COUNT(DISTINCT ordernumber) FROM sales_data)) * 100 AS CoPurchasePercentage
from sales_data o1
join sales_data o2 on o1.ordernumber = o2.ordernumber and o1.productcode < o2.productcode
group by o1.productcode, o2.productcode
order by CoPurchasePercentage desc
limit 15; -- Limiting the results to the top 15 associations



show errors