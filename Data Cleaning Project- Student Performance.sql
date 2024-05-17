-- SQL Project - Data Cleaning

/* Dataset used in the link below, the math data
https://www.kaggle.com/datasets/dillonmyrick/high-school-student-performance-and-demographics/data */

/* I intentionally added one duplicate to the second to last row with the student_id 1 to illustrate the remove duplicate process
   I intentionally added one row filled with NULLS to the last row to further illustrate the data cleaning process */

-- Import table using Table Data Import Wizard

-- Select all data from imported table

SELECT * 
FROM student_performance.math_data;

-- Create a staging table with raw data. This is the data we will work with to clean up the data so we don't overwrite the source data

CREATE TABLE student_performance.math_data_staging
LIKE student_performance.math_data;

INSERT student_performance.math_data_staging 
SELECT * FROM  student_performance.math_data;
 
 
-- ***General data cleaning steps***
-- 1. Check for and remove duplicates
-- 2. Standardize data and fix errors
-- 3. Look at null values and determine how to manage them 
-- 4. Remove any columns and rows that are unnecessary


-- 1. Remove Duplicates

-- Select all data from staging table
 
SELECT *
FROM student_performance.math_data_staging;

-- Using Row Number to number the output of a result set, if there is a potential duplicate, a row_num value of 2 will appear; we want to partition by all columns to ensure we find a duplicate

/* SELECT student_id, school, sex, age,
			ROW_NUMBER() OVER (
				PARTITION BY student_id, school, sex, age, address_type, family_size, parent_status, mother_education, father_education, mother_job, father_job, school_choice_reason, guardian, travel_time, study_time, class_failures, school_support, family_support, extra_paid_classes, activities, nursery_school, higher_ed, internet_access, romantic_relationship, family_relationship, free_time, social, weekday_alcohol, weekend_alcohol, health, absences, grade_1, grade_2, final_grade) 
				AS row_num
		FROM 
			student_performance.math_data_staging; */

-- Selecting all rows greater than 1 after executing Row_Number argument; selects all duplicates

/* Select *
FROM (
	SELECT student_id, school, sex, age,
		ROW_NUMBER() OVER (
			PARTITION BY student_id, school, sex, age, address_type, family_size, parent_status, mother_education, father_education, mother_job, father_job, school_choice_reason, guardian, travel_time, study_time, class_failures, school_support, family_support, extra_paid_classes, activities, nursery_school, higher_ed, internet_access, romantic_relationship, family_relationship, free_time, social, weekday_alcohol, weekend_alcohol, health, absences, grade_1, grade_2, final_grade) 
            AS row_num
	FROM 
		student_performance.math_data_staging
) duplicates
WHERE
	row_num > 1; */

-- Intuitively, would like to delete duplicate entries using a CTE. However, this doesn't work in mySQL. 
-- One solution is to create a new column and add the row numbers in. Then, we delete the row numbers which are greater than 1.

CREATE TABLE `math_data_staging2` (
  `student_id` int DEFAULT NULL,
  `school` text,
  `sex` text,
  `age` int DEFAULT NULL,
  `address_type` text,
  `family_size` text,
  `parent_status` text,
  `mother_education` text,
  `father_education` text,
  `mother_job` text,
  `father_job` text,
  `school_choice_reason` text,
  `guardian` text,
  `travel_time` text,
  `study_time` text,
  `class_failures` int DEFAULT NULL,
  `school_support` text,
  `family_support` text,
  `extra_paid_classes` text,
  `activities` text,
  `nursery_school` text,
  `higher_ed` text,
  `internet_access` text,
  `romantic_relationship` text,
  `family_relationship` int DEFAULT NULL,
  `free_time` int DEFAULT NULL,
  `social` int DEFAULT NULL,
  `weekday_alcohol` int DEFAULT NULL,
  `weekend_alcohol` int DEFAULT NULL,
  `health` int DEFAULT NULL,
  `absences` int DEFAULT NULL,
  `grade_1` int DEFAULT NULL,
  `grade_2` int DEFAULT NULL,
  `final_grade` int DEFAULT NULL,
  `row_num` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Utilizing the code developed earlier with row_number to insert column into new table

INSERT INTO math_data_staging2
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY student_id, school, sex, age, address_type, family_size, parent_status, mother_education, father_education, mother_job, father_job, school_choice_reason, guardian, travel_time, study_time, class_failures, school_support, family_support, extra_paid_classes, activities, nursery_school, higher_ed, internet_access, romantic_relationship, family_relationship, free_time, social, weekday_alcohol, weekend_alcohol, health, absences, grade_1, grade_2, final_grade) 
AS row_num
FROM math_data_staging;

 -- Selecting newly created table to see that columns were setup correctly

SELECT *
FROM student_performance.math_data_staging2;

-- Unique entries have row number 1 and duplicates have higher row number
-- Select Duplicates

SELECT *
FROM student_performance.math_data_staging2
WHERE row_num > 1;
      
-- DELETE Duplicates
      
DELETE FROM student_performance.math_data_staging2
WHERE row_num >1;


-- 2. Standardize Data

SELECT *
FROM student_performance.math_data_staging2;

-- Select distinct values on a certain column, can check each column as needed

SELECT DISTINCT student_id
FROM student_performance.math_data_staging2
ORDER by student_id;

-- Select the row where there is a blank or NULL in a particular column field, in this case student_id

SELECT *
FROM student_performance.math_data_staging2
WHERE student_id IS NULL 
OR student_id = ''
ORDER BY student_id;

-- In most cases, we should set blanks to NULLS

UPDATE student_performance.math_data_staging2
SET student_id = NULL
WHERE student_id = '';

-- 3. Look at NULL values and manage them

-- We will delete the entire row of NULLs, as shown in the next step

-- 4. Remove Rows and Columns as needed

-- Select all rows where student_id is NULL

SELECT *
FROM student_performance.math_data_staging2
WHERE student_id IS NULL;

-- Deleting all rows where student_id is NULL

DELETE FROM student_performance.math_data_staging2
WHERE student_id IS NULL;

SELECT *
FROM student_performance.math_data_staging2;

-- Remove row_num column

ALTER TABLE student_performance.math_data_staging2
DROP COLUMN row_num;

-- Final data table we will use for data exploration

SELECT * 
FROM student_performance.math_data_staging2;



