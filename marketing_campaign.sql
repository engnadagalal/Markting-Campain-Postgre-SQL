
CREATE TABLE marketing_campaign (
    ID INT PRIMARY KEY,
    Age INT,
    Year_Birth INT,
    Education VARCHAR(50),
    Marital_Status VARCHAR(50),
    Income INT,
    Kidhome INT,
    Teenhome INT,
    Dt_Customer DATE,
    Recency INT,
    MntWines INT,
    MntFruits INT,
    MntMeatProducts INT,
    MntFishProducts INT,
    MntSweetProducts INT,
    MntGoldProds INT,
    NumDealsPurchases INT,
    NumWebPurchases INT,
    NumCatalogPurchases INT,
    NumStorePurchases INT,
    NumWebVisitsMonth INT,
    AcceptedCmp3 INT,
    AcceptedCmp4 INT,
    AcceptedCmp5 INT,
    AcceptedCmp1 INT,
    AcceptedCmp2 INT,
    Complain INT,
    Response INT
);
--------------------------
SET datestyle = 'DMY';
-------------------------
COPY marketing_campaign 
FROM 'E:/Marketing Campaign final.csv' 
DELIMITER ',' 
CSV HEADER;

select * from marketing_campaign 
-------------------------------------------------
--1. How does income distribution vary across different educational levels?

SELECT education, AVG(income) AS avg_income
FROM marketing_campaign
GROUP BY education
ORDER BY avg_income DESC;
--3. Are older customers spending more on specific categories like luxury goods or daily essentials?
SELECT  CASE 
        WHEN age BETWEEN 18 AND 24 THEN ' (18-24 )'
        WHEN age BETWEEN 25 AND 34 THEN ' (25-34 )'
        WHEN age BETWEEN 35 AND 44 THEN ' (35-44 )'
        WHEN age BETWEEN 45 AND 54 THEN ' (45-54 )'
        WHEN age BETWEEN 55 AND 64 THEN ' (55-64 )'
        WHEN age BETWEEN 65 AND 74 THEN ' (65-74 )'
    END AS marketing_age_group
, AVG(mntgoldprods) AS avg_gold, AVG(mntmeatproducts) AS avg_meat 
FROM marketing_campaign
GROUP BY marketing_age_group
ORDER BY marketing_age_group ;

------------
select * from marketing_campaign
------------
--4. How does spending vary across different age groups?
SELECT CASE 
        WHEN age BETWEEN 18 AND 24 THEN ' (18-24 )'
        WHEN age BETWEEN 25 AND 34 THEN ' (25-34 )'
        WHEN age BETWEEN 35 AND 44 THEN ' (35-44 )'
        WHEN age BETWEEN 45 AND 54 THEN ' (45-54 )'
        WHEN age BETWEEN 55 AND 64 THEN ' (55-64 )'
        WHEN age BETWEEN 65 AND 74 THEN ' (65-74 )'
    END AS marketing_age_group , SUM(mntwines + mntfruits + mntmeatproducts + mntfishproducts + mntsweetproducts + mntgoldprods) AS total_spending
FROM marketing_campaign
GROUP BY marketing_age_group
ORDER BY marketing_age_group;

--5. How does the family structure (Kidhome/Teenhome) affect spending behavior?
SELECT (kidhome + teenhome) AS total_children, AVG(mntwines + mntfruits + mntmeatproducts + mntfishproducts + mntsweetproducts + mntgoldprods) AS avg_spending
FROM marketing_campaign
GROUP BY total_children
order by avg_spending desc ;

--6. How do customer complaints correlate with their overall spending?
SELECT 
    complain, 
    COUNT(*) AS count_customers, 
    AVG(mntwines + mntfruits + mntmeatproducts + mntfishproducts + mntsweetproducts + mntgoldprods) AS avg_spending
FROM 
    marketing_campaign
GROUP BY 
    complain;

--8. Income vs gold purchase: How does income influence the amount spent on gold products?
Select CASE
        WHEN income BETWEEN 108775 AND 162397 THEN '108775-162397'
        WHEN income BETWEEN 1730 AND 54351 THEN '1730-54351'
        WHEN income BETWEEN 54352 AND 108774 THEN '54352-108774'        
    END AS income_range,
    CASE
	    WHEN income BETWEEN 108775 AND 162397 THEN 'High Income'
        WHEN income BETWEEN 1730 AND 54351 THEN 'Low Income'
        WHEN income BETWEEN 54352 AND 108774 THEN 'Medium Income'               
    END AS income_category ,  AVG(mntgoldprods) AS avg_gold_spent
FROM marketing_campaign
GROUP BY income_category , income_range
order by income_category , income_range ;

--9. Website Engagement: How do the number of web visits per month impact the total purchases made by customers?
SELECT 
    numwebvisitsmonth,
    CASE 
        WHEN numwebpurchases > 0 THEN 'Visited and Purchased'
        ELSE 'Visited but No Purchase'
    END AS purchase_status,
    COUNT(*) AS customer_count
FROM 
    marketing_campaign
WHERE 
    numwebvisitsmonth > 0
GROUP BY 
    numwebvisitsmonth, 
    purchase_status
ORDER BY 
    numwebvisitsmonth;



--10. What is the relationship between marital status and overall spending?
DELETE FROM marketing_campaign
WHERE marital_status IN ('Absurd', 'YOLO');
SELECT marital_status, AVG(mntwines + mntfruits + mntmeatproducts + mntfishproducts + mntsweetproducts + mntgoldprods) AS avg_spending
FROM marketing_campaign
GROUP BY marital_status
order by avg_spending ;


--12. Which group of customers is most loyal, reflected by frequent purchases or low recency?
SELECT marital_status, recency, COUNT(*) AS frequent_purchases
FROM marketing_campaign
WHERE recency < 30
GROUP BY marital_status, recency
ORDER BY frequent_purchases , recency DESC;
--13. What is the distribution of web purchases versus store purchases?
SELECT 
    id, 
    AVG(numwebpurchases) AS avg_web_purchases, 
    AVG(numstorepurchases) AS avg_store_purchases,
    AVG(numcatalogpurchases) AS avg_catalog_purchases
FROM 
    marketing_campaign
GROUP BY 
    id 
ORDER BY 
    id;

--14. What is the relationship between catalog purchases and store/web purchases?



--
--------16-----------
SELECT numwebvisitsmonth, AVG(numstorepurchases) AS avg_store_purchases, AVG(numcatalogpurchases) AS avg_catalog_purchases
FROM marketing_campaign
GROUP BY numwebvisitsmonth;
--------17-----------
SELECT numdealspurchases, AVG(mntwines + mntfruits + mntmeatproducts + mntfishproducts + mntsweetproducts + mntgoldprods) AS avg_spending
FROM marketing_campaign
GROUP BY numdealspurchases;
-------18----------
SELECT  CASE
        WHEN income BETWEEN 108775 AND 162397 THEN '108775-162397'
        WHEN income BETWEEN 1730 AND 54351 THEN '1730-54351'
        WHEN income BETWEEN 54352 AND 108774 THEN '54352-108774'        
    END AS income_range,
    CASE
	    WHEN income BETWEEN 108775 AND 162397 THEN 'High Income'
        WHEN income BETWEEN 1730 AND 54351 THEN 'Low Income'
        WHEN income BETWEEN 54352 AND 108774 THEN 'Medium Income'               
    END AS income_category , AVG(mntwines + mntfruits + mntmeatproducts + mntfishproducts + mntsweetproducts + mntgoldprods) AS avg_total_spending
FROM marketing_campaign
GROUP BY income_category , income_range
ORDER BY income_category , income_range ;
--------19--------
SELECT DATE_TRUNC('month', TO_DATE(dt_customer, 'DD/MM/YYYY')) AS month, AVG(numwebvisitsmonth) AS avg_web_visits, AVG(numwebpurchases) AS avg_web_purchases
FROM marketing_campaign
GROUP BY month
ORDER BY month;
-------20-------
SELECT (kidhome + teenhome) AS total_children, AVG(income) AS avg_income
FROM marketing_campaign
GROUP BY total_children;



