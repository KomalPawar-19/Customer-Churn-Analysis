SELECT * FROM customer_churn_analysis.customer_churn;

select count(*) as Total_records
from customer_churn;

Drop table customer_churn;

use customer_churn_analysis;

RENAME TABLE `telco-customer-churn` TO customer_churn;

show tables;

select count(*) as Total_records
from customer_churn;

select * from customer_churn
limit 10;

select customerID, count(*) as duplicate_count
from customer_churn 
group by customerID
having count(*) > 1;


select * 
 from customer_churn 
where TotalCharges = ' ';


create table customer_churn_copy
as select * from customer_churn;

select count(*) as missing_customer_ID 
from customer_churn_copy 
where customerID is null;

SELECT COUNT(*) AS missing_totalcharges
FROM customer_churn_copy
WHERE TotalCharges IS NULL 
OR TotalCharges=' ';

SET SQL_SAFE_UPDATES = 0;

update customer_churn_copy
set TotalCharges=Null
where TotalCharges = ' ';

SET SQL_SAFE_UPDATES = 1;

SELECT *
FROM customer_churn_copy
WHERE TotalCharges IS NULL;

SELECT COUNT(*) AS missing_totalcharges
FROM customer_churn_copy
WHERE TotalCharges IS NULL;

DESCRIBE customer_churn_copy;

alter table customer_churn_copy
modify TotalCharges decimal(10,2);

select 
Round (avg(MonthlyCharges),2) as avg_monthly_charges
from customer_churn_copy;

select 
Round (avg(TotalCharges),2) as avg_Total_charges
from customer_churn_copy;

SELECT COUNT(*) AS total_rows
FROM customer_churn_copy;

select distinct contract 
from customer_churn_copy;

select distinct InternetService
from customer_churn_copy;

select distinct PaymentMethod
from customer_churn_copy;

select distinct churn,length(churn)
from customer_churn_copy;

SET SQL_SAFE_UPDATES = 0;

UPDATE customer_churn_copy
SET churn = TRIM(churn);

SET SQL_SAFE_UPDATES = 1;

update customer_churn_copy
set gender = 'Male'
where lower(gender) = 'male';

UPDATE customer_churn_copy
SET gender = 'Female'
WHERE LOWER(gender)='female';

SELECT 
MIN(tenure) AS minimum_tenure,
MAX(tenure) AS maximum_tenure
FROM customer_churn_copy;

SELECT 
MIN(MonthlyCharges),
MAX(MonthlyCharges)
FROM customer_churn_copy;

alter table customer_churn_copy
add column churn_flag INT;

UPDATE customer_churn_copy
set churn_flag = 
case
when churn = 'Yes' THEN 1
Else 0
End;

SELECT 
Churn,
churn_flag,
COUNT(*) AS customers
FROM customer_churn_copy
GROUP BY Churn, churn_flag;

alter table customer_churn_copy
add column tenure_group VARCHAR(30);

set SQL_Safe_updates = 0;

update customer_churn_copy
set tenure_group = 
case 
when tenure <= 12 then 'New Customer'
When tenure <=36 then 'Medium customer'
ELSE 'Long Term customer'
End;

set SQL_SAFE_UPDATES = 1;

SELECT 
tenure_group,
COUNT(*) AS customers
FROM customer_churn_copy
GROUP BY tenure_group;

SELECT
tenure_group,
COUNT(*) AS total_customers,
SUM(churn_flag) AS churned_customers,
ROUND(
SUM(churn_flag)*100.0/COUNT(*),
2
) AS churn_rate
FROM customer_churn_copy
GROUP BY tenure_group;

SELECT
Contract,
COUNT(*) AS total_customers,
SUM(churn_flag) AS churned_customers,
ROUND(
SUM(churn_flag)*100.0/COUNT(*),
2
) AS churn_rate
FROM customer_churn_copy
GROUP BY Contract;


SELECT
PaymentMethod,
COUNT(*) AS total_customers,
SUM(churn_flag) AS churned_customers,
ROUND(
SUM(churn_flag)*100.0/COUNT(*),
2
) AS churn_rate
FROM customer_churn_copy
GROUP BY PaymentMethod
Order by churn_rate DESC;


SELECT
InternetService,
COUNT(*) AS total_customers,
SUM(churn_flag) AS churned_customers,
ROUND(
SUM(churn_flag)*100.0/COUNT(*),
2
) AS churn_rate
FROM customer_churn_copy
GROUP BY InternetService
ORDER BY churn_rate DESC;

ALTER TABLE customer_churn_copy
ADD COLUMN charge_category VARCHAR(20);

set SQL_SAFE_UPDATES = 0;

UPDATE customer_churn_copy
SET charge_category =
CASE
    WHEN MonthlyCharges < 40 THEN 'Low'
    WHEN MonthlyCharges BETWEEN 40 AND 80 THEN 'Medium'
    ELSE 'High'
END;

SELECT
charge_category,
COUNT(*) AS total_customers,
SUM(churn_flag) AS churned_customers,
ROUND(
SUM(churn_flag)*100.0/COUNT(*),
2
) AS churn_rate
FROM customer_churn_copy
GROUP BY charge_category
ORDER BY churn_rate DESC;

SELECT
SeniorCitizen,
COUNT(*) AS total_customers,
SUM(churn_flag) AS churned_customers,
ROUND(
    SUM(churn_flag)*100.0/COUNT(*),
    2
) AS churn_rate
FROM customer_churn_copy
GROUP BY SeniorCitizen;

SELECT
Partner,
COUNT(*) AS total_customers,
SUM(churn_flag) AS churned_customers,
ROUND(
    SUM(churn_flag)*100.0/COUNT(*),
    2
) AS churn_rate
FROM customer_churn_copy
GROUP BY Partner;

SELECT
Dependents,
COUNT(*) AS total_customers,
SUM(churn_flag) AS churned_customers,
ROUND(
    SUM(churn_flag)*100.0/COUNT(*),
    2
) AS churn_rate
FROM customer_churn_copy
GROUP BY Dependents;

SELECT
PhoneService,
COUNT(*) AS total_customers,
SUM(churn_flag) AS churned_customers,
ROUND(
    SUM(churn_flag)*100.0/COUNT(*),
    2
) AS churn_rate
FROM customer_churn_copy
GROUP BY PhoneService;

SELECT
COUNT(*) AS total_customers,
SUM(churn_flag) AS churned_customers,
ROUND(SUM(churn_flag)*100.0/COUNT(*),2) AS churn_rate
FROM customer_churn_copy;

SELECT
SUM(CASE WHEN MonthlyCharges IS NULL THEN 1 ELSE 0 END) AS missing_monthly_charges,
SUM(CASE WHEN TotalCharges IS NULL THEN 1 ELSE 0 END) AS missing_total_charges,
SUM(CASE WHEN Churn IS NULL THEN 1 ELSE 0 END) AS missing_churn
FROM customer_churn_copy;

CREATE VIEW churn_dashboard AS
SELECT
customerID,
gender,
SeniorCitizen,
Partner,
Dependents,
tenure,
tenure_group,
Contract,
PaymentMethod,
InternetService,
MonthlyCharges,
TotalCharges,
charge_category,
Churn,
churn_flag
FROM customer_churn_copy;

SELECT
customerID,
tenure,
Contract,
InternetService,
MonthlyCharges,
TotalCharges,
PaymentMethod,
Churn
FROM customer_churn_copy
WHERE Churn='Yes'
ORDER BY MonthlyCharges DESC;

show databases;

SELECT USER();

USE customer_churn_analysis;

SHOW TABLES;


SELECT USER();
SELECT @@hostname;
SHOW DATABASES;











