/*CLEANING AND MANIPULATING THE TABLE BEFORE ANALYZING THE EMPLOYEE ATTRTION DATA */ 

/*Initiating with assigning the database */ 
USE hr_project;
/*For Ease in handling Data- converting Female to F and Male to M */
UPDATE  hr_analytics_dataset_adviti
SET Gender= CASE
    WHEN Gender='Female' THEN 'F'
    WHEN Gender='Male' THEN 'M'
    ELSE Gender
END;    
SELECT * FROM hr_analytics_dataset_adviti;   

/* This Command is Used to disable safe_mode, in order to make updates in table */ 
SET SQL_SAFE_UPDATES = 0;


/*Categorizing Age into Age groups*/
ALTER TABLE hr_analytics_dataset_adviti
ADD COLUMN Age_Group VARCHAR(10);
UPDATE  hr_analytics_dataset_adviti
SET Age_Group= CASE
        WHEN Age BETWEEN 20 AND 30 THEN '20-30'
        WHEN Age BETWEEN 31 AND 40 THEN '31-40'
        WHEN Age BETWEEN 41 AND 50 THEN '41-50'
        ELSE 'Other'
END;
/* Drop the original "Age" column */
ALTER TABLE hr_analytics_dataset_adviti
DROP COLUMN Age;

/*Cleaning the Position Column  */
UPDATE  hr_analytics_dataset_adviti
SET Position= CASE
    WHEN Position IN ('Account Executive','AccountExecutive', 'AccountExec.', 'Account Exec.') THEN 'Account Executive'
    WHEN Position IN ('Content Creator','Creator') THEN 'Content Creator'
    WHEN Position IN ('Data Analyst','Analyst','DataAnalyst') THEN  'Data Analyst'
    ELSE Position
END;

/*Altering Years of Services Column Datatype from 'INT' TO 'VARCHAR' before categorizing */
ALTER TABLE hr_analytics_dataset_adviti
MODIFY COLUMN Years_of_Service VARCHAR(20);

/* Categorizing Years of Services */
UPDATE  hr_analytics_dataset_adviti
SET Years_of_Service= CASE
   WHEN Years_of_Service BETWEEN 0 AND 2 THEN '0-2 Years'
        WHEN Years_of_Service > 2 AND Years_of_Service <= 5 THEN '2-5 Years'
        WHEN Years_of_Service > 5 AND Years_of_Service <= 10 THEN '5-10 Years'
        WHEN Years_of_Service > 10 AND Years_of_Service <= 15 THEN '10-15 Years'
        ELSE '15+ Years'
END ;
ALTER TABLE hr_analytics_dataset_adviti
CHANGE Years_of_Service Experience_Category VARCHAR(20) ; 

/* Altering Salary column before categorizing it  */
ALTER TABLE hr_analytics_dataset_adviti
MODIFY COLUMN Salary VARCHAR(20);
ALTER TABLE hr_analytics_dataset_adviti
CHANGE Salary Income_Group VARCHAR(20) ; 

/* Categorizing The Salary Column */
UPDATE  hr_analytics_dataset_adviti
SET Income_Group= CASE 
        WHEN Income_Group BETWEEN 0 AND 100000 THEN '0-1Lacs'
        WHEN Income_Group BETWEEN 100001 AND 1000000 THEN '1-10 Lacs'
        WHEN Income_Group BETWEEN 1000001 AND 2000000 THEN '10-20 Lacs'
        WHEN Income_Group BETWEEN 2000001 AND 3000000 THEN '20-30 Lacs'
        WHEN Income_Group BETWEEN 3000001 AND 4000000 THEN '30-40 Lacs'
        WHEN Income_Group BETWEEN 4000001 AND 5000000 THEN '40-50 Lacs'
        WHEN Income_Group BETWEEN 5000001 AND 6000000 THEN '50-60 Lacs'
        WHEN Income_Group BETWEEN 6000001 AND 7000000 THEN '60-70 Lacs'
        WHEN Income_Group BETWEEN 7000001 AND 8000000 THEN '70-80 Lacs'
        WHEN Income_Group BETWEEN 8000001 AND 9000000 THEN '80-90 Lacs'
        WHEN Income_Group >= 9000001 THEN '90 Lacs-1 Cr'
        ELSE 'Above 1 Cr'
END;

/* Altering Training hours column name before categorizing  */
ALTER TABLE hr_analytics_dataset_adviti
CHANGE Training_Hours Training_Hours_Category VARCHAR(20);

/*Categorizing Training hours column */
UPDATE hr_analytics_dataset_adviti
SET Training_Hours_Category= CASE 
        WHEN Training_Hours_Category BETWEEN 0 AND 10 THEN '0-10 Hours'
        WHEN Training_Hours_Category BETWEEN 11 AND 20 THEN '11-20 Hours'
        WHEN Training_Hours_Category BETWEEN 21 AND 30 THEN '21-30 Hours'
        WHEN Training_Hours_Category BETWEEN 31 AND 40 THEN '31-40 Hours'
        ELSE '40+ Hours'
END;

/* Altering Absenteeism column name before categorizing  */
ALTER TABLE hr_analytics_dataset_adviti
CHANGE Absenteeism Absenteeism_Category VARCHAR(20);

/*Categorizing Absenteeism column */
UPDATE hr_analytics_dataset_adviti
SET Absenteeism_Category= CASE 
        WHEN Absenteeism_Category BETWEEN 0 AND 5 THEN '0-5 Days'
        WHEN Absenteeism_Category BETWEEN 6 AND 10 THEN '6-10 Days'
        WHEN Absenteeism_Category BETWEEN 11 AND 15 THEN '11-15 Days'
        ELSE '15+ Days'
END;

/* Altering Distance_from_Work column name before categorizing  */
ALTER TABLE hr_analytics_dataset_adviti
CHANGE Distance_from_Work Distance_from_Work_Category VARCHAR(20);

/*Categorizing Distance_from_Work column */
UPDATE hr_analytics_dataset_adviti
SET Distance_from_Work_Category =  CASE 
        WHEN Distance_from_Work_Category BETWEEN 0 AND 10 THEN '0-10 kms'
        WHEN Distance_from_Work_Category BETWEEN 11 AND 20 THEN '11-20 kms'
        WHEN Distance_from_Work_Category BETWEEN 21 AND 30 THEN '21-30 kms'
        WHEN Distance_from_Work_Category BETWEEN 31 AND 40 THEN '31-40 kms'
        ELSE '40+ kms'
END;

/* FEATURE-WISE ANALYZING THE ATTRITION */

/*Department-Wise Attrition*/
SELECT Department, COUNT(Employee_ID) AS TotalEmployees, 
SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS 'Attrition Yes',
SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) AS 'Attrition No'
FROM  hr_analytics_dataset_adviti
WHERE Position <>'Intern'
GROUP BY 1
ORDER BY 1;

/*Position-wise Attrition */
SELECT Position, COUNT(Employee_ID) AS TotalEmployees, 
SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS 'Attrition Yes',
SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) AS 'Attrition No'
FROM  hr_analytics_dataset_adviti
WHERE Position <>'Intern'
GROUP BY 1
ORDER BY 1;

/*Performance-Rating-Wise Attrition  */
SELECT Performance_Rating, 
SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS 'Attrition Yes',
SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) AS 'Attrition No'
FROM  hr_analytics_dataset_adviti
WHERE Position <>'Intern'
GROUP BY 1;

/*Age-Group-wise Attrition */
SELECT Age_Group, 
SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS 'Attrition Yes',
SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) AS 'Attrition No'
FROM  hr_analytics_dataset_adviti
WHERE Position <>'Intern'
GROUP BY 1;

/*Experience-wise Attrition */
SELECT Experience_Category, 
SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS 'Attrition Yes',
SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) AS 'Attrition No'
FROM  hr_analytics_dataset_adviti
WHERE Position <>'Intern'
GROUP BY 1;

/*Gender-Wise Attrition */
SELECT Gender, 
SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS 'Attrition Yes',
SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) AS 'Attrition No'
FROM  hr_analytics_dataset_adviti
WHERE Position <>'Intern'
GROUP BY 1;

/*Income-Wise Attrition*/
SELECT Income_Group, 
SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS 'Attrition Yes',
SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) AS 'Attrition No'
FROM  hr_analytics_dataset_adviti
WHERE Position <>'Intern'
GROUP BY 1
ORDER BY 1;
 
SELECT Performance_Rating,Count(Attrition)
FROM hr_analytics_dataset_adviti
WHERE Attrition= 'Yes' and Position <> 'Intern' and Income_Group='1-10 Lacs'
GROUP BY 1;
# Employees with lowest salary(1-10lacs) and with lowest performance(1) have the most attrition count
  
## Effectivness of training programs

/* Training_Hours VS Avg. Performance_Rating */

SELECT Training_Hours_Category, AVG(Performance_Rating)
FROM hr_analytics_dataset_adviti
WHERE Position <>'Intern'
GROUP BY 1;

/* Training_Hours vs Promotion */
SELECT Training_Hours_Category,
SUM(CASE WHEN Promotion= 'Yes' THEN 1 ELSE 0 END) AS 'Promotion_Yes',
SUM(CASE WHEN Promotion= 'No' THEN 1 ELSE 0 END) AS 'Promotion_No'
FROM hr_analytics_dataset_adviti
WHERE Position <>'Intern'
Group by 1;