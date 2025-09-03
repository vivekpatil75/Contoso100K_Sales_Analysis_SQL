# Contoso100K_Sales_Analysis_SQL

## Analysis Overview

At the core of this project is the **view salestable**  as fact table, which records individual sales transactions including order number, product, quantity, prices, costs, and calculated profit. This fact table is enriched through foreign keys linking to several dimension tables/views:

- **Customers**: Demographic and geographic information of buyers.

- **Products**: Product metadata including manufacturer, brand, cost, and category.

- **Stores**: Store details, location, size, and operational status.

- **Dates**: A comprehensive date dimension for temporal analysis.

- **Currency Exchange**: Daily exchange rates to support multi-currency insights.

- We have created SQL views to simplify analysis:

   - **view_salesTable** – Combines sales transaction details with profit calculations.

   - **view_customers,view_stores, view_products, view_dates**  -> Provide enriched and cleaned versions of the respective dimension tables.
 
##

## Data Overview

***The Contoso 100K Database is restored from backup file***

**1. Store Table**

Purpose: Contains details about each store, including its geographic location, operational status, and size.

- Key Columns:

    - StoreKey (Primary Key)
    
    - Store Code, Country, State, Square Meters
    
    - Open Date, Close Date, Status (e.g., NULL, Closed, Restructured)
 
      

**2. Product Table**

Purpose: Provides detailed metadata about the product catalog, including brand, manufacturer, and pricing.

- Key Columns:

    - ProductKey (Primary Key)
    
    - Product Name, Brand, Color, Weight
    
    - Unit Cost, Unit Price
    
    - Category and Subcategory hierarchies


**3. OrderRows Table**

Purpose: Contains line-item level details for each product in a customer order.

- Key Columns:

    - OrderKey (Foreign Key)
    
    - ProductKey (Foreign Key)
    
    - Quantity, Unit Price, Net Price, Unit Cost


**4. Orders Table**

Purpose: Master table containing order-level metadata including customer and store references, order dates, and currency codes.

- Key Columns:

    - OrderKey (Primary Key)
    
    - CustomerKey, StoreKey (Foreign Keys)
    
    - Order Date, Delivery Date
    
    - Currency Code (e.g., USD, CAD, EUR)


**5. GeoLocations Table**

Purpose: Maps geographic locations to customer counts, used for demographic or spatial analysis.

- Key Columns:

    - GeoLocationKey (Primary Key)
    
    - Country, State, NumCustomers



**6. Customer Table**

Purpose: Contains customer demographics, location, and personal metadata.

- Key Columns:

    - CustomerKey (Primary Key)
    
    - Name, Age, Birthday, Occupation
    
    - Location: City, State, Country
    
    - Latitude, Longitude, Continent



**7. Date Table**

Purpose: Standard date dimension used for time-series analysis.

- Key Columns:

    - DateKey (Primary Key)
    
    - Year, Quarter, Month, Day of Week
    
    - Flags for Working Day, Working Day Number



**8. CurrencyExchange Table**

Purpose: Provides daily currency exchange rates between multiple currencies.

- Key Columns:

    - Date, FromCurrency, ToCurrency, Exchange

##

## Data Preprocessing


Using the above tables, we've created several views to aid in analysis. These views normalize and link data to enrich the sales data with descriptive information:

Views Created:

- **salestable** – Enriched fact view combining:

    - Product, Customer, Store, and Date attributes

    - Profit calculation: profit = total_unitprice - total_unitcost

- **stores** – Cleaned store information with proper historical tracking of status (open/closed/restructured).

- **products** – Includes product hierarchy (Category > Subcategory) and pricing structure.

- **customers** – Contains customer demographics for segmentation and cohort analysis.

- **dates** – Centralized time dimension for all time-based reporting.

- **CurrencyExchange** – Supports currency conversion for globalized reporting and comparisons.


##

## Analysis
This data model supports a wide range of business intelligence and analytics use cases:

1. Sales Performance

Revenue and profit tracking over time

Units sold by product/category

Store-wise performance analysis

2. Customer Insights

Purchase behavior by age, gender, country

Cohort analysis using birthday or signup dates

Region-wise segmentation and trend tracking

3. Product Profitability

Margin analysis across categories and SKUs

Identifying top-selling and low-performing products

Seasonality impact on product sales

4. Store Operations

Store lifecycle and status trends

Performance comparison: open vs closed vs restructured

Store area vs revenue/profitability

5. Time-Series and Trend Analysis

Monthly, quarterly, yearly sales comparisons

Sales by working day vs weekends

Identifying high/low performing time periods

6. Currency Adjusted Reporting

Currency normalization using CurrencyExchange

Reporting in preferred or local currencies

Economic impact analysis on pricing and cost
