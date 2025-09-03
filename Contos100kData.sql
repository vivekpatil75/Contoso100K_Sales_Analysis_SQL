 use [Contoso 100K];

Database used here has been restored from a backup file;
 --------------------------------------------------------------------------------------------------------------------------

 -- view for Currency Exchange 
 create view CurExchange as 
 select Date,FromCurrency,ToCurrency,Exchange 
 from Data.CurrencyExchange;

 --------------------------------------------------------------------------------------------------------------------------

 -- view for Customer 
 drop view customers;
 create view customers as 
 select CustomerKey,
 Gender,
 GivenName+' '+Surname as Name,
 StreetAddress as Address,
 City,
 State as statecode,
 StateFull as state,
 Zipcode,
 Country as countrycode,
 CountryFull as country,
 Continent ,
 Birthday,
 Age
 from Data.Customer;

 ----------------------------------------------------------------------------------------------------------------------------

 --- view for date taking only required fields
 CREATE   VIEW dates AS
    SELECT 
      [Date], 
      [Year], 
      [Year Quarter] as year_quarter, 
      [Year Quarter Number] as Yearquarter_number, 
      [Quarter], 
      [Year Month] as year_month, 
      [Year Month Short] as yearmonth_short, 
      [Year Month Number] as yearmonth_number, 
      [Month], 
      [Month Short] as month_short, 
      [Month Number] month_number, 
      [Day of Week] as day, 
      [Day of Week Short] as day_short, 
      [Day of Week Number] as week_number, 
      [Working Day] as workingday, 
      [Working Day Number] as workingday_number
    FROM 
      Data.Date

-----------------------------------------------------------------------------------------------------------------------

---- view to select only required fields
CREATE   VIEW products AS
	SELECT
		ProductKey,
		[Product Code] as product_code,
		[Product Name] as product_name,
		[Manufacturer],
		[Brand],
		[Color],
		[Weight Unit Measure] as unit,
		[Weight],
		[Unit Cost] as cost,
		[Unit Price] as price,
		[Subcategory Code] as subcategory_code,
		Subcategory,
		[Category Code] category_code,
		Category
	FROM Data.Product

---------------------------------------------------------------------------------------------------------------------
--- creating view to find sales 



CREATE VIEW salesview as
SELECT 
        Orders.OrderKey as Order_Number,
        OrderRows.[Line Number] as Line_Number,
        Orders.[Order Date] as order_date,
        Orders.[Delivery Date] as delivery_date,
        Orders.CustomerKey,
        Orders.StoreKey,
        OrderRows.ProductKey,
        OrderRows.Quantity,
        OrderRows.[Unit Price] as unitprice,
        OrderRows.[Net Price] as netprice,
        OrderRows.[Unit Cost] as unitcost,
        Orders.[Currency Code] as currencycode,
        [CurrencyExchange].Exchange AS exchange_rate,

		case 
		when Orders.[Currency Code]='USD' then OrderRows.[Net Price]
		when [CurrencyExchange].Exchange is not null then Round(OrderRows.[Net Price]/[CurrencyExchange].Exchange,2)
		else Null
		End as netprice_usd,

		case 
		when Orders.[Currency Code]='USD' then OrderRows.[Net Price]*OrderRows.Quantity
		when [CurrencyExchange].Exchange is not null then Round((OrderRows.[Net Price]/[CurrencyExchange].Exchange)*OrderRows.Quantity,2)
		else Null
		End as total_netprice,

		case 
		when Orders.[Currency Code]='USD' then OrderRows.[Unit Price]
		when [CurrencyExchange].Exchange is not null then Round(OrderRows.[Unit Price]/[CurrencyExchange].Exchange,2)
		else Null
		End as unitprice_usd,

		case 
		when Orders.[Currency Code]='USD' then OrderRows.[Unit Price]*OrderRows.Quantity
		when [CurrencyExchange].Exchange is not null then Round((OrderRows.[Unit Price]/[CurrencyExchange].Exchange)*OrderRows.Quantity,2)
		else Null
		End as total_unitprice,

		case 
		when Orders.[Currency Code]='USD' then OrderRows.[Unit Cost]
		when [CurrencyExchange].Exchange is not null then round(OrderRows.[Unit Cost]/[CurrencyExchange].Exchange,2)
		else Null
		End as unitcost_usd, 

		case 
		when Orders.[Currency Code]='USD' then OrderRows.[Unit Cost]*OrderRows.Quantity
		when [CurrencyExchange].Exchange is not null then round((OrderRows.[Unit Cost]/[CurrencyExchange].Exchange)*OrderRows.Quantity,2)
		else Null
		End as total_unitcost,

		Round(
		case 
		when Orders.[Currency Code]='USD' then OrderRows.[Net Price]*OrderRows.Quantity
		when [CurrencyExchange].Exchange is not null then Round((OrderRows.[Net Price]/[CurrencyExchange].Exchange)*OrderRows.Quantity,2)
		else Null
		End 
        -
		case 
		when Orders.[Currency Code]='USD' then OrderRows.[Unit Cost]*OrderRows.Quantity
		when [CurrencyExchange].Exchange is not null then round((OrderRows.[Unit Cost]/[CurrencyExchange].Exchange)*OrderRows.Quantity,2)
		else Null
		End,
    2) AS profit

    FROM
        [Data].Orders  
            LEFT OUTER JOIN [Data].OrderRows
                ON Orders.OrderKey = OrderRows.OrderKey
            LEFT OUTER JOIN [Data].[CurrencyExchange]
                ON 
                    [CurrencyExchange].Date = Orders.[Order Date] AND
                    [CurrencyExchange].[ToCurrency] = Orders.[Currency Code] AND
                    [CurrencyExchange].[FromCurrency] = 'USD'


--creating view to select only selecteed columns for proper analysis
create view salestable as
select 
 Orders.OrderKey as Order_Number,
        OrderRows.[Line Number] as Line_Number,
        Orders.[Order Date] as order_date,
        Orders.[Delivery Date] as delivery_date,
        Orders.CustomerKey,
        Orders.StoreKey,
        OrderRows.ProductKey,
        OrderRows.Quantity,

		case 
		when Orders.[Currency Code]='USD' then OrderRows.[Net Price]*OrderRows.Quantity
		when [CurrencyExchange].Exchange is not null then Round((OrderRows.[Net Price]/[CurrencyExchange].Exchange)*OrderRows.Quantity,2)
		else Null
		End as total_netprice,

		case 
		when Orders.[Currency Code]='USD' then OrderRows.[Unit Price]*OrderRows.Quantity
		when [CurrencyExchange].Exchange is not null then Round((OrderRows.[Unit Price]/[CurrencyExchange].Exchange)*OrderRows.Quantity,2)
		else Null
		End as total_unitprice,

		case 
		when Orders.[Currency Code]='USD' then OrderRows.[Unit Cost]*OrderRows.Quantity
		when [CurrencyExchange].Exchange is not null then round((OrderRows.[Unit Cost]/[CurrencyExchange].Exchange)*OrderRows.Quantity,2)
		else Null
		End as total_unitcost,

		Round(
		case 
		when Orders.[Currency Code]='USD' then OrderRows.[Net Price]*OrderRows.Quantity
		when [CurrencyExchange].Exchange is not null then Round((OrderRows.[Net Price]/[CurrencyExchange].Exchange)*OrderRows.Quantity,2)
		else Null
		End 
        -
		case 
		when Orders.[Currency Code]='USD' then OrderRows.[Unit Cost]*OrderRows.Quantity
		when [CurrencyExchange].Exchange is not null then round((OrderRows.[Unit Cost]/[CurrencyExchange].Exchange)*OrderRows.Quantity,2)
		else Null
		End,
    2) AS profit

	FROM
        [Data].Orders  
            LEFT OUTER JOIN [Data].OrderRows
                ON Orders.OrderKey = OrderRows.OrderKey
            LEFT OUTER JOIN [Data].[CurrencyExchange]
                ON 
                    [CurrencyExchange].Date = Orders.[Order Date] AND
                    [CurrencyExchange].[ToCurrency] = Orders.[Currency Code] AND
                    [CurrencyExchange].[FromCurrency] = 'USD'


-----------------------------------------------------------------------------------------------------------------------

----- view for stores for only required fields
CREATE   VIEW stores AS
SELECT 
    StoreKey,
    [Store Code] as storecode,
    [Country],
    [State],
    [Name],
    [Square Meters] as square_meters,
    [Open Date] as opendate,
    [Close Date] as closedate,
    [Status]
FROM
    [Data].Store


=============================================================================================================================

 -- Basic EDA Knowing the data

 ## Product Table

 --distinct categories
 select distinct(category) from products;


 --distinct product
 select distinct([product_name]) from products;


 --count of distinct product
 select count(distinct([product_name])) as 'Total No. of Products' from products;


 --distinct brands
 select distinct([brand]) from products;


 --no of manufactureres
 select distinct(manufacturer) as Manufacturers from products;


 --no. of sub categories
 select distinct(subcategory) as subcategory from products;


 -- categpries and sub categories
 select category,subcategory from products group by category,Subcategory order by category asc;

 ============================================================================================================================

 ## view dates analysis
 -- finding time frame
 select min(date) as start_date,max(date) as end_date ,count(*) as 'No. of Days'  from dates;

=============================================================================================================================

## Currency exchange view analysis

-- finding no of curriences used to trade
select distinct(FromCurrency) from CurExchange;


-- find which currency is used most
select currencycode,count(Order_Number) as 'No of times the currency is used to pay' 
from vw_sales
group by currencycode
order by count(Order_NUmber) desc;

==============================================================================================================================

## Store Analysis

--finding how many stores in total
select distinct(Name) as total_stores from stores ;


-- no of stores
select count(distinct(storecode)) as 'No. of Stores' from stores;


---finding no of stores in each country and state
select country,state,count(storecode) as 'No of Stores'
from stores
where status is null
group by country,state
order by count(storecode) desc;


---finding no of stores in each country
select country,count(storecode) as 'No of Stores'
from stores
where status is null
group by country
order by count(storecode) desc;

===============================================================================================================================

# Customer Analysis

-- finding which continent has how many customers
select continent,count(customerkey) as 'No. of Customers '
from customers
group by continent;


-- finding customers in country
select country,count(customerkey) as 'No. of Customers '
from customers
group by country
order by count(customerkey) desc;


-- finding which country and state has have many customers
select country,state,count(customerkey) as 'No. of Customers '
from customers
group by country,state
order by count(customerkey) DESC;


-- finding gender distribution in customers
select Gender,count(customerkey) as 'No. of Customers '
from customers
group by Gender
order by count(customerkey) desc;


-- finding which continent is doing how much sales
select c.continent,round(sum(s.total_netprice),2) as Total_sales,round(sum(s.profit),2) as Total_Profit
from salestable s
inner join customers c
on s.customerkey=c.customerkey
group by continent;


--finding which country is doing how much sales and profit
select c.continent,c.country,round(sum(s.total_netprice),2) as Total_sales,round(sum(s.profit),2) as Total_Profit 
from salestable s
inner join customers c
on s.customerkey=c.customerkey
group by c.continent,c.country
order by c.continent;

=============================================================================================================================

SALES ANALYSIS

--find which store has done how much sale for offline stores
select Name,round(sum(s.total_netprice),2) as Total_Sales,round(sum(s.profit),2) as Total_Profit
from salestable s 
inner join stores s1
on s.storekey=s1.storekey
where s1.Name <> 'Online Store' 
group by s1.Name
order by Total_Profit;


-- calculate sales done by online store
select s1.Name,Round(sum(s.total_netprice),2) as Total_sales,round(sum(s.profit),2) as Total_Profit
from salesview s
join stores s1
on s.storekey=s1.storekey
where s1.Name ='Online Store'
group by s1.Name;


--find which product category make how much sales
select p.category,round(sum(s.total_netprice),2) as total_sales,round(sum(s.profit),2) as Total_Profit
from salestable s
join products p
on s.productkey=p.productkey
group by p.category
order by Total_Profit desc;


--find sales by subcategories
select p.category,p.subcategory,round(sum(s.total_netprice),2) as total_sales,round(sum(s.profit),2) as Total_Profit
from salesview s
join products p
on s.productkey=p.productkey
group by p.category,p.subcategory
order by Total_Profit desc;


----find sales by brands
select p.manufacturer,p.brand,round(sum(s.total_netprice),2) as total_sales,round(sum(s.profit),2) as Total_Profit
from salestable s
join products p
on s.productkey=p.productkey
group by p.manufacturer,p.brand
order by total_sales desc;


--top 5 products by sales for each category

WITH RankedProducts AS (
    SELECT 
        p.product_name,
        p.category,
        ROUND(SUM(s.total_netprice), 2) AS total_sales,
        ROUND(SUM(s.profit), 2) AS total_profit,
        ROW_NUMBER() OVER (PARTITION BY p.category ORDER BY SUM(s.total_netprice) DESC) AS rank
    FROM salestable s
    JOIN products p ON s.productkey = p.productkey
    GROUP BY p.category, p.product_name
)
SELECT 
    product_name,
    category,
    total_sales,
    total_profit
FROM RankedProducts
WHERE rank <= 5
ORDER BY category, total_sales DESC;


-- finding how much sales and profit done in last 10 years
select datepart(year,order_date) as sales_year,round(sum(total_netprice),2) as total_sales,
round(sum(profit),2) as total_profit,
round(sum(profit)*100.0/nullif(sum(total_netprice),0),2) as Profit_Percentage
from salestable
group by  datepart(year,order_date)
order by sales_year;


--finding top 3 months in each year by profits
with months as (
select datepart(year,order_date) as sales_year,
datepart(month,order_date) as Months,
round(sum(total_netprice),2) as total_sales,
round(sum(profit),2) as total_profit,
round(sum(profit)*100.0/nullif(sum(total_netprice),0),2) as Profit_Percentage,
row_number() over (partition by datepart(year,order_date) order by round(sum(profit)*100.0/nullif(sum(total_netprice),0),2) desc ) as rank
from salestable
group by datepart(year,order_date),datepart(month,order_date) 
)
select * from months
where rank<=3
order by sales_year,rank;



--- finding top 5 products with highesh profits
select top 5 p.product_name,round(sum(s.profit),2) as profits
from salestable s
join products p
on s.productkey=p.productkey
group by p.product_name
order by profits desc;


--finding 5 products with least profits;
select top 5 p.product_name,round(sum(s.profit),2) as profits
from salestable s
join products p
on s.productkey=p.productkey
group by p.product_name
order by profits asc;

-- checking quarterly sales trends for every year 

select datepart(year,order_date) as Year,
round(sum(case when datepart(quarter,order_date)=1 then total_netprice else 0 end),2) as sales_Q1,
round(sum(case when datepart(quarter,order_date)=2 then total_netprice else 0 end),2) as sales_Q2,
round(sum(case when datepart(quarter,order_date)=3 then total_netprice else 0 end),2) as sales_Q3,
round(sum(case when datepart(quarter,order_date)=4 then total_netprice else 0 end),2) as sales_Q4,
round(sum(total_netprice),2) as total_sales
from salestable 
group by datepart(year,order_date)
order by datepart(year,order_date) asc;


---finding monthly trends for sales fro all years

select datepart(year,order_date) as Year,
round(sum(case when datepart(month,order_date)=1 then total_netprice else 0 end),2) as sales_January,
round(sum(case when datepart(month,order_date)=2 then total_netprice else 0 end),2) as sales_Frbruary,
round(sum(case when datepart(month,order_date)=3 then total_netprice else 0 end),2) as sales_March,
round(sum(case when datepart(month,order_date)=4 then total_netprice else 0 end),2) as sales_April,
round(sum(case when datepart(month,order_date)=5 then total_netprice else 0 end),2) as sales_May,
round(sum(case when datepart(month,order_date)=6 then total_netprice else 0 end),2) as sales_June,
round(sum(case when datepart(month,order_date)=7 then total_netprice else 0 end),2) as sales_July,
round(sum(case when datepart(month,order_date)=8 then total_netprice else 0 end),2) as sales_Augudt,
round(sum(case when datepart(month,order_date)=9 then total_netprice else 0 end),2) as sales_September,
round(sum(case when datepart(month,order_date)=10 then total_netprice else 0 end),2) as sales_October,
round(sum(case when datepart(month,order_date)=11 then total_netprice else 0 end),2) as sales_November,
round(sum(case when datepart(month,order_date)=12 then total_netprice else 0 end),2) as sales_December,
round(sum(total_netprice),2) as total_sales
from salestable 
group by datepart(year,order_date)
order by datepart(year,order_date) asc;


---finding avg wait time for 1787 productkey
select avg(case when productkey=1787 then datediff(delivery_date,order_date,days)) else 0 end) as avg_wait_time 
from salestable
where productkey=1787
group by productkey;


--- finding delivery time for products
SELECT 
    productkey,
    AVG(DATEDIFF(day, order_date, delivery_date)) AS avg_wait_time
FROM salestable
GROUP BY productkey;


--finding avg delivery time for diff stores
select s1.name,avg(datediff(day,s.order_date,s.delivery_date)) as avg_delivery_time_days
from salestable s
join stores s1 on s.storekey=s1.storekey
group by s1.name
order by avg_delivery_time_days desc;















