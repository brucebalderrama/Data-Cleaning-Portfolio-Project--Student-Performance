-- Queries used for Tableau Project "Student Performance" 


-- 1. Displays the Average Final Grade, Max Final Grade, and Number of Students grouped by sex (Male & Female)

Select sex, COUNT(student_id) AS Number_Of_Students, AVG(final_grade) AS Average_Final_Grade, MAX(final_grade) AS Max_Final_Grade
FROM student_performance.math_data_staging2
GROUP BY sex;

-- 2. Displays the Average Final Grade, Max Final Grade, and Number of Students grouped by address type (Urban & Rural)

Select address_type, COUNT(student_id) AS Number_Of_Students, AVG(final_grade) AS Average_Final_Grade, MAX(final_grade) AS Max_Final_Grade
FROM student_performance.math_data_staging2
GROUP BY address_type;

-- 3.Displays the Average Final Grade, Max Final Grade, and Number of Students grouped by school (Gabriel Pereira or Mousinho da Silveira)

Select school, COUNT(student_id) AS Number_Of_Students, AVG(final_grade) AS Average_Final_Grade, MAX(final_grade) AS Max_Final_Grade
FROM student_performance.math_data_staging2
GROUP BY school;

-- 4. Displays the Average Final Grade grouped by study time ( <2 hours, 2 to 5 hours, 5 to 10 hours, >10 hours)

Select study_time, AVG(final_grade) AS Average_Final_Grade
FROM student_performance.math_data_staging2
GROUP BY study_time
ORDER BY CASE `study_time`
			  when  '<2 hours' then 1
			  when '2 to 5 hours' then 2
		      when '5 to 10 hours' then 3
			  when '>10 hours' then 4
         end; 
         
-- 5. Displays the Average Final Grade grouped by travel time (<15 min., 15 to 30 min., 30min. to 1 hour, >1 hour)
 
Select travel_time, AVG(final_grade) AS Average_Final_Grade
FROM student_performance.math_data_staging2
GROUP BY travel_time
ORDER BY CASE `travel_time`
			  when  '<15 min.' then 1
			  when '15 to 30 min.' then 2
		      when '30 min. to 1 hour' then 3
			  when '>1 hour' then 4
         end; 

-- 6. Displays the Number of Students and Average Final Grade grouped by age (15, 16, 17, 18, 19, 20, 21, 22), excludes 20-22 year olds from output because there are a small number of students in this range

Select age, COUNT(student_id) AS Number_Of_Students, AVG(final_grade) AS Average_Final_Grade
FROM student_performance.math_data_staging2
WHERE age <20
GROUP BY age
ORDER BY age;

-- 7. Displays the Number of Students, Average Final Grade, Average Grade 1, Average Grade 2, Average Absences, Average Failures grouped by parent status (Apart & Living Together)

SELECT parent_status, COUNT(student_id) AS Number_Of_Students, AVG(final_grade) AS Average_Final_Grade, AVG(grade_1) AS Average_Grade_1, AVG(grade_2) AS Average_Grade_2,
AVG(absences) AS Average_Absences, AVG(class_failures) AS Average_Failures
FROM student_performance.math_data_staging2
GROUP BY parent_status;