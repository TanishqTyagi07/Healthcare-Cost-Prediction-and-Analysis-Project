CREATE SCHEMA hospitalisation_insurance_data;

SHOW DATABASES;
USE hospitalisation_insurance_data;
SELECT database();

/*To gain a comprehensive understanding of the factors influencing hospitalization costs
a. Merge the two tables by first identifying the columns in the data tables that will help you
in merging
b. In both tables, add a Primary Key constraint for these columns */

DESC `hospitalisation_details`;

SELECT 
    COUNT(*) as total_rows,
    SUM(CASE WHEN customer_id LIKE '%?%' THEN 1 ELSE 0 END) as customer_id_count,
    SUM(CASE WHEN year LIKE '%?%' THEN 1 ELSE 0 END) as year_count,
    SUM(CASE WHEN month LIKE '%?%' THEN 1 ELSE 0 END) as month_count,
    SUM(CASE WHEN date LIKE '%?%' THEN 1 ELSE 0 END) as date_count,
    SUM(CASE WHEN children LIKE '%?%' THEN 1 ELSE 0 END) as children_count,
    SUM(CASE WHEN charges LIKE '%?%' THEN 1 ELSE 0 END) as charges_count,
    SUM(CASE WHEN hospital_tier LIKE '%?%' THEN 1 ELSE 0 END) as hospital_tier_count,
    SUM(CASE WHEN city_tier LIKE '%?%' THEN 1 ELSE 0 END) as city_tier_count,
    SUM(CASE WHEN state_id LIKE '%?%' THEN 1 ELSE 0 END) as state_id_count
FROM hospitalisation_details;

SELECT Customer_ID, COUNT(*)
FROM hospitalisation_details
GROUP BY Customer_ID
HAVING COUNT(*) > 1;

SELECT COUNT(*) AS null_count
FROM hospitalisation_details
WHERE Customer_ID IS NULL;

SELECT COUNT(*) AS SpecialCharCount
FROM hospitalisation_details
WHERE Customer_ID LIKE '%?%';

DELETE FROM hospitalisation_details 
WHERE Customer_ID LIKE '%?%';

DELETE FROM hospitalisation_details
WHERE month LIKE '%?%'
   OR hospital_tier LIKE '%?%'
   OR city_tier LIKE '%?%'
   OR state_id LIKE '%?%';
   
SELECT 
    COUNT(*) as total_rows,
    SUM(CASE WHEN customer_id LIKE '%?%' THEN 1 ELSE 0 END) as customer_id_count,
    SUM(CASE WHEN year LIKE '%?%' THEN 1 ELSE 0 END) as year_count,
    SUM(CASE WHEN month LIKE '%?%' THEN 1 ELSE 0 END) as month_count,
    SUM(CASE WHEN date LIKE '%?%' THEN 1 ELSE 0 END) as date_count,
    SUM(CASE WHEN children LIKE '%?%' THEN 1 ELSE 0 END) as children_count,
    SUM(CASE WHEN charges LIKE '%?%' THEN 1 ELSE 0 END) as charges_count,
    SUM(CASE WHEN hospital_tier LIKE '%?%' THEN 1 ELSE 0 END) as hospital_tier_count,
    SUM(CASE WHEN city_tier LIKE '%?%' THEN 1 ELSE 0 END) as city_tier_count,
    SUM(CASE WHEN state_id LIKE '%?%' THEN 1 ELSE 0 END) as state_id_count
FROM hospitalisation_details;

DESC `medical_examinations`;

SELECT 
    COUNT(*) as total_rows,
    SUM(CASE WHEN customer_id LIKE '%?%' THEN 1 ELSE 0 END) as customer_id_count,
    SUM(CASE WHEN BMI LIKE '%?%' THEN 1 ELSE 0 END) as BMI_count,
    SUM(CASE WHEN HBA1C LIKE '%?%' THEN 1 ELSE 0 END) as HBA1C_count,
    SUM(CASE WHEN heart_issues LIKE '%?%' THEN 1 ELSE 0 END) as heart_issues_count,
    SUM(CASE WHEN any_transplants LIKE '%?%' THEN 1 ELSE 0 END) as any_transplants_count,
    SUM(CASE WHEN cancer_history LIKE '%?%' THEN 1 ELSE 0 END) as cancer_history_count,
    SUM(CASE WHEN number_of_major_surgeries LIKE '%?%' THEN 1 ELSE 0 END) as number_of_major_surgeries_count,
    SUM(CASE WHEN smoker LIKE '%?%' THEN 1 ELSE 0 END) as smoker_count
FROM medical_examinations;

DELETE FROM medical_examinations
WHERE smoker LIKE '%?%';

SELECT 
    COUNT(*) as total_rows,
    SUM(CASE WHEN customer_id LIKE '%?%' THEN 1 ELSE 0 END) as customer_id_count,
    SUM(CASE WHEN BMI LIKE '%?%' THEN 1 ELSE 0 END) as BMI_count,
    SUM(CASE WHEN HBA1C LIKE '%?%' THEN 1 ELSE 0 END) as HBA1C_count,
    SUM(CASE WHEN heart_issues LIKE '%?%' THEN 1 ELSE 0 END) as heart_issues_count,
    SUM(CASE WHEN any_transplants LIKE '%?%' THEN 1 ELSE 0 END) as any_transplants_count,
    SUM(CASE WHEN cancer_history LIKE '%?%' THEN 1 ELSE 0 END) as cancer_history_count,
    SUM(CASE WHEN number_of_major_surgeries LIKE '%?%' THEN 1 ELSE 0 END) as number_of_major_surgeries_count,
    SUM(CASE WHEN smoker LIKE '%?%' THEN 1 ELSE 0 END) as smoker_count
FROM medical_examinations;

CREATE TABLE combined_data AS
SELECT 
    hd.customer_id,
    hd.year,
    hd.month,
    hd.date,
    hd.children,
    hd.charges,
    hd.hospital_tier,
    hd.city_tier,
    hd.state_id,
    me.bmi,
    me.hba1c,
    me.heart_issues,
    me.any_transplants,
    me.cancer_history,
    me.number_of_major_surgeries,
    me.smoker
FROM hospitalisation_details hd
INNER JOIN medical_examinations me
ON hd.customer_id = me.customer_id;

DESC `combined_data`;

SELECT* FROM combined_data
LIMIT 20;

ALTER TABLE hospitalisation_details
ADD CONSTRAINT PK_customer_id PRIMARY KEY (customer_id);

ALTER TABLE medical_examinations
ADD CONSTRAINT PK_customer_id PRIMARY KEY (customer_id);

ALTER TABLE combined_data
ADD PRIMARY KEY (customer_id);

ALTER TABLE combined_data
ADD COLUMN age INT;

UPDATE combined_data
SET age = 
    CASE 
        WHEN year IS NOT NULL AND month IS NOT NULL AND date IS NOT NULL THEN
    TIMESTAMPDIFF(YEAR, 
        STR_TO_DATE(CONCAT(year, '-', 
            CASE month
                WHEN 'Jan' THEN '01'
                WHEN 'Feb' THEN '02'
                WHEN 'Mar' THEN '03'
                WHEN 'Apr' THEN '04'
                WHEN 'May' THEN '05'
                WHEN 'Jun' THEN '06'
                WHEN 'Jul' THEN '07'
                WHEN 'Aug' THEN '08'
                WHEN 'Sep' THEN '09'
                WHEN 'Oct' THEN '10'
                WHEN 'Nov' THEN '11'
                WHEN 'Dec' THEN '12'
            END,
            '-', date), '%Y-%m-%d'),
        CURDATE())
	ELSE NULL
END;

/*Retrieve information about people who are diabetic and have heart problems with their average
age, the average number of dependent children, average BMI, and average hospitalization costs*/

SELECT AVG(age) as avg_age, AVG(children) as avg_children, AVG(BMI) as avg_bmi, AVG(charges) as avg_cost
FROM combined_data
WHERE HBA1C > 6.5 AND Heart_Issues = 'Yes';

/*Find the average hospitalization cost for each hospital tier and each city level. */

SELECT hospital_tier, city_tier, AVG(charges) as avg_cost
FROM combined_data
GROUP BY Hospital_tier, City_tier;

/*Determine the number of people who have had major surgery with a history of cancer. */

SELECT COUNT(*) as count
FROM combined_data
WHERE number_of_major_surgeries > 0 AND Cancer_history = 'Yes';

/*Determine the number of tier-1 hospitals in each state*/

SELECT state_id, COUNT(*) as tier1_hospitals
FROM combined_data
WHERE hospital_tier = 'tier - 1'
GROUP BY state_id;