-- Exploratory Data Analysis 

-- Selecting the data what we cleaned up in the previous project titled "Data Cleaning Project - Student Performance"

SELECT * 
FROM student_performance.math_data_staging2;

-- Order the data by final_grade, descending

SELECT * 
FROM student_performance.math_data_staging2
ORDER BY final_grade DESC;

-- Display the percent grades for grade1, grade2, and final_grade for all students

SELECT student_id, (grade_1/20)*100 grade_1_percent, (grade_2/20)*100 grade_2_percent , (final_grade/20)*100 final_grade_percent
FROM student_performance.math_data_staging2;

-- Count of total number of male students and average final grade of male students

/* SELECT COUNT(sex) Males
FROM student_performance.math_data_staging2
WHERE sex = "M"; */

/* SELECT AVG(final_grade) 
FROM student_performance.math_data_staging2
WHERE sex = "M"; */

-- Count of total number of female students and average final grade of female students

/* SELECT COUNT(sex) Females
FROM student_performance.math_data_staging2
WHERE sex = "F"; */

/* SELECT AVG(final_grade) 
FROM student_performance.math_data_staging2
WHERE sex = "F"; */

-- Select min and max values in the column, in this case final_grade

SELECT MAX(final_grade) MAX, MIN(final_grade) MIN
FROM student_performance.math_data_staging2;

-- Select students with specified condition, in this case with mother and father with higher education and living apart

SELECT * 
FROM student_performance.math_data_staging2
WHERE mother_education = "higher education" 
AND father_education = "higher education" 
AND parent_status = "Apart";

-- The total number of students who meet the specified conditions, Max final grade, and Min final grade
 
SELECT COUNT(student_id), MAX(final_grade), MIN(final_grade)
FROM student_performance.math_data_staging2
WHERE mother_education = "higher education" 
AND father_education = "higher education" 
AND parent_status = "Apart";

-- Select max value in the column, in this case final_grade

SELECT MAX(final_grade) AS Max_Final_Grade
FROM student_performance.math_data_staging2;

-- I want to select the entire row with the max values returned from the query above. Unfortunately, you cannot return an ungrouped column value in a grouped query. 
-- The following SQL query returns the entire row with the max value from final_grade column

SELECT *
FROM student_performance.math_data_staging2
WHERE final_grade = (SELECT MAX(final_grade) FROM student_performance.math_data_staging2);

-- Applying the same structure to grade_1 column, this query outputs multiple rows with max values

/* SELECT MAX(grade_1) AS Max_Grade_1
FROM student_performance.math_data_staging2; */

SELECT *
FROM student_performance.math_data_staging2
WHERE grade_1 = (SELECT MAX(grade_1) FROM student_performance.math_data_staging2);

-- Select the max value (final_grade) for each distinct value of another column, in this case the "sex", and groups by the "sex" column

Select sex, MAX(final_grade) AS Max_Final_Grade
FROM student_performance.math_data_staging2
GROUP BY sex;

-- This accomplishes the same result as the earlier code which has been commented out, but outputs both results only using one query

Select sex, AVG(final_grade) 
FROM student_performance.math_data_staging2
GROUP BY sex;

-- Now let's use the same logic to find the count for each gender

Select sex, COUNT(student_id)  
FROM student_performance.math_data_staging2
GROUP BY sex;

-- Can combine above three queries into one query 

Select sex, COUNT(student_id) AS Number_Of_Students, AVG(final_grade) AS Average_Final_Grade, MAX(final_grade) AS Max_Final_Grade
FROM student_performance.math_data_staging2
GROUP BY sex;

-- Group by the address_type utilizing multiple aggregate functions  

Select address_type, COUNT(student_id) AS Number_Of_Students, AVG(final_grade) AS Average_Final_Grade, MAX(final_grade) AS Max_Final_Grade
FROM student_performance.math_data_staging2
GROUP BY address_type;

-- Group by the school utilizing multiple aggregate functions

Select school, COUNT(student_id) AS Number_Of_Students, AVG(final_grade) AS Average_Final_Grade, MAX(final_grade) AS Max_Final_Grade
FROM student_performance.math_data_staging2
GROUP BY school;

-- Let's group by study time, have to use custom ordering as the > and < symbols make it hard to order normally

Select study_time, COUNT(student_id) AS Number_Of_Students, AVG(final_grade) AS Average_Final_Grade, MAX(final_grade) AS Max_Final_Grade
FROM student_performance.math_data_staging2
GROUP BY study_time
ORDER BY CASE `study_time`
			  when  '<2 hours' then 1
			  when '2 to 5 hours' then 2
		      when '5 to 10 hours' then 3
			  when '>10 hours' then 4
         end;

-- Group by parent status and aggregate more columns as needed

SELECT parent_status, COUNT(student_id) AS Number_Of_Students, AVG(final_grade) AS Average_Final_Grade, AVG(grade_1) AS Average_Grade_1, AVG(grade_2) AS Average_Grade_2,
AVG(absences) AS Average_Absences, AVG(class_failures) AS Average_Failures
FROM student_performance.math_data_staging2
GROUP BY parent_status;

-- Group by multiple columns, in this case the school and parent status

Select school, parent_status, COUNT(student_id) AS Number_Of_Students, AVG(final_grade) AS Average_Final_Grade, MAX(final_grade) AS Max_Final_Grade
FROM student_performance.math_data_staging2
GROUP BY school, parent_status

/* Select MAX(final_grade) AS Max_Final_Grade
FROM student_performance.math_data_staging2
GROUP BY sex; */

-- Now to return the entire rows with the max value after grouping. Insert the code from line 34 inside the Inner Join. Utilize an alias "m" for our working data table to make the code easier to read and write
-- Create a new table "sub" after the Inner Join argument. Then, join on the column grouped by "sex" and the Max_Final_Grade found using the aggregate function MAX

SELECT m.*
FROM student_performance.math_data_staging2 m
INNER JOIN (
				SELECT sex, MAX(final_grade) AS Max_Final_Grade
                FROM  student_performance.math_data_staging2
                GROUP by sex
) sub
ON m.sex= sub.sex
AND m.final_grade= sub.Max_Final_Grade

-- Find all of the students whose final grade is more than the average final grade of all of the students

WITH temporaryTable(AverageFinalGrade) as
	(SELECT avg(final_grade)
    FROM math_data_staging2)
		SELECT *
        FROM math_data_staging2, temporaryTable
        WHERE math_data_staging2.final_grade > temporaryTable.AverageFinalGrade;

-- Find all of the students by age where the total absences is less than the average absences of all students

WITH totalabsences(age, total) AS
	(SELECT age, sum(absences)
	FROM math_data_staging2
	GROUP by age),
    ageAverage(avgabsences) as
    (SELECT avg(absences)
    FROM math_data_staging2)
    SELECT * 
    FROM totalabsences, ageAverage
    WHERE totalabsences.total < ageAverage.avgabsences;
    
-- Now use a CTE to find the average final grade per age, notice the same result is obtained as the code directly commented out below

/* Select age, COUNT(student_id) AS Number_Of_Students, AVG(final_grade) AS Average_Final_Grade, MAX(final_grade) AS Max_Final_Grade
FROM student_performance.math_data_staging2
GROUP BY age; */

WITH cte_finalgrade (Age, Number_Of_Students, Average_Final_Grade, Max_Final_Grade) 
AS
(SELECT age, COUNT(final_grade), AVG(final_grade), MAX(final_grade)
FROM student_performance.math_data_staging2
GROUP BY age)
SELECT *
FROM cte_finalgrade;

-- Now use a CTE again, the commented code is what we used earlier to find the rows with max final grades by gender, we get the same output using a CTE with neater code

/* SELECT m.*
FROM student_performance.math_data_staging2 m
INNER JOIN (
				SELECT sex, MAX(final_grade) AS Max_Final_Grade
                FROM  student_performance.math_data_staging2
                GROUP by sex
) sub
ON m.sex= sub.sex
AND m.final_grade= sub.Max_Final_Grade */

WITH highestgrade AS (
	SELECT sex, MAX(final_grade) AS Max_Final_Grade
	FROM  student_performance.math_data_staging2  
	GROUP by sex
)
SELECT orig.*,
h.Max_Final_Grade
FROM student_performance.math_data_staging2 orig
JOIN highestgrade h
ON orig.sex = h.sex
AND orig.final_grade = h.Max_Final_Grade

-- Try a nested CTE. Filter by students who have more than 5 or more absences and display the average final grade by gender

WITH cte_1 AS
(SELECT student_id, sex, absences
FROM student_performance.math_data_staging2
WHERE  absences > 4 
),
cte_2 AS 
(SELECT sex, AVG(final_grade)
FROM student_performance.math_data_staging2
GROUP BY 1
)
SELECT *
FROM cte_1
JOIN cte_2
	ON cte_1.sex = cte_2.sex;
 




