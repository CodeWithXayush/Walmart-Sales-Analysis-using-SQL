Use final_project;
select * from dataset;
#  TASK---1
with 
Branchsales as (select branch,sum(total) as total_sales from dataset group by Branch)
SELECT Branch,total_sales,lag(total_sales) over (order by total_sales) as prev_sales ,(total_sales-lag(total_sales) 
over (order by total_sales))/(lag(total_sales) over(order by total_sales))* 100 as growth_rate from Branchsales;
#  TASK---2
select `Branch`,`Product line`,sum(`gross income`-cogs) as max_profit from dataset
group by `Branch`,`Product line` having sum(`gross income`-cogs)= (select max(max_profit) from (select `Branch`,`Product line`,
sum(`gross income`-cogs) as max_profit from dataset group by `Branch`,`Product line`) as sub
where `Branch`=dataset.`Branch`) order by `Branch`;
#  TASK ---3
create view INTERN as select `Customer ID`,sum(total) as Total_amount from dataset group by `Customer ID`
order by `Customer ID`;
select *, case
when Total_amount<20000 then 'Low'
when Total_amount<22000 then 'Medium' else 'High'
end as Type from INTERN;
# TASK ---4
with AverageSales AS (SELECT `Product line`,AVG(Total) AS Avg_sales
from dataset group by `Product line`)
select w.`Customer type`,w.`Product line`,w.Total,a.Avg_sales,
case
when w.Total>(a.Avg_Sales * 2)then 'High Anomaly'
when w.Total<(a.Avg_sales/2) then 'Low Anomaly'
else 'Normal'
end as Anomaly_status from dataset w join AverageSales a on w.`Product line` = a.`Product line`
where w.Total>(a.avg_sales*2) or w.Total<(a.Avg_sales/2)
order by Anomaly_status,w.Total desc;
#TASK ----5
select City,Payment,count(*)AS transaction_count from dataset
group by City,Payment
having count(*)=(select max(transaction_count)
from (select City,Payment,count(*) as transaction_count from dataset
group by City,Payment) as subquery where City=dataset.City)
order by City,transaction_count desc;
#  TASK ----6
with MonthlySales AS( 
select
year(STR_TO_DATE(date,'%d-%m-%y'))AS Sale_Year,
MONTH(STR_TO_DATE(date,'%d-%m-%y'))AS Sale_Month,
Gender,
sum(Total) AS Total_sales from dataset
where date is not null
group by YEAR(STR_TO_DATE(date,'%d-%m-%y')),
MONTH(STR_TO_DATE(date,'%d-%m-%y')),Gender)
select  
Sale_Year,Sale_Month,Gender,Total_sales
from MonthlySales order by Sale_year,Sale_Month,Gender;
#  TASK ----7
select `Customer type`,`Product line`,count(`Product line`)as Good_line
from dataset
group by `Customer type`,`Product line`
having count(`Product line`)=(select max(good_line)from(
select `Customer type`,`Product line`,count(`Product line`)as Good_line from dataset
group by `Customer type`,`Product line`) as sub where `Customer type`=dataset.`Customer type`);
#  TASK ---8
Select `Customer ID`,count(*) as repeat_purchase_count from dataset
where date between '01-01-2019' and '31-01-2019'
group by `Customer ID`
Having count(*)>1;
#TASK 9
select `Customer ID`,`Customer type`,City,sum(Quantity * Total) as Sales_Volume from dataset
group by `Customer ID`,`Customer type`,City
order by sales_volume desc limit 5;
 #  TASK -- 10
 select dayname(str_to_date(date,"%d-%m-%y")) as Day_of_week,
sum(total) as total_sales from dataset
group by Day_of_week
order by field(Day_of_week,"Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday");
