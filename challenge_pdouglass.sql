-- Queries
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31'

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31'

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31'

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31'

-- Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');


-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;

DROP TABLE retirement_info;

-- Joining departments and dept_managers tables
SELECT d.dept_name, 
	dm.emp_no, 
	dm.from_date, 
	dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

-- Joining retirement_info and dept_emp tables
SELECT ri.emp_no, 
	ri.first_name, 
ri.last_name, 
	de.to_date
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no


SELECT ri.emp_no, 
	ri.first_name, 
	ri.last_name, 
de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

SELECT * FROM salaries
ORDER BY to_date DESC;

-- Employee Information
SELECT e.emp_no, 
	e.first_name, 
e.last_name, 
	e.gender,
	s.salary, 
	de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01');

SELECT ei.emp_no, 
	count(*)
FROM
	emp_info AS ei
GROUP BY 
	ei.emp_no
HAVING count(*) >1;


-- Check the table
SELECT * FROM retirement_info;

-- List of managers per department
SELECT dm.dept_no, 
	d.dept_name, 
	dm.emp_no, 
	ce.last_name, 
	ce.first_name, 
	dm.from_date, 
	dm.to_date
INTO manager_info
FROM dept_manager AS dm
	INNER JOIN departments AS D
		ON (dm.dept_no = d.dept_no)
	INNER JOIN current_emp AS ce
		ON (dm.emp_no = ce.emp_no);
		
-- Department retirees
SELECT ce.emp_no, 
ce.first_name, 
ce.last_name, 
d.dept_name
INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);

-- Sales Department retirees
SELECT ce.emp_no, 
ce.first_name, 
ce.last_name, 
d.dept_name
-- INTO sales_dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);

-- Module 7 Challenge

-- Table 1
-- Create a query that returns a list of current employees eligible for retirement, as well as their most recent titles. 
-- Employee Information
SELECT 
	e.emp_no, 
	e.first_name, 
	e.last_name, 
	t.title,
	t.from_date, 
	t.to_date,
	s.salary
INTO emps_titles_salaries
FROM employees as e
RIGHT JOIN titles as t
ON (e.emp_no = t.emp_no)
RIGHT JOIN salaries as s
ON (e.emp_no = s.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31');


DROP TABLE emps_titles_salaries;

-- Table 2, exclude older positions
-- Group duplicate info
SELECT ets.emp_no, 
	count(*)
FROM
	emps_titles_salaries AS ets
GROUP BY 
	ets.emp_no
HAVING count(*) >1;	

-- Display duplicates with all information
SELECT 
	emp_no, 
	first_name, 
	last_name, 
	title, 
	from_date,
	to_date,
	salary
INTO recent_titles_by_emp_no
FROM
  (SELECT 
   	ets.emp_no, 
   	ets.first_name, 
   	ets.last_name, 
   	ets.title, 
   	ets.from_date, 
    ets.to_date,
   	ets.salary,
     ROW_NUMBER() OVER (
		 PARTITION BY (ets.emp_no) 
		 ORDER BY ets.from_date DESC) 
   	rn
FROM emps_titles_salaries AS ets
  ) tmp WHERE rn = 1;

DROP TABLE recent_titles_by_emp_no

-- Title roll-up by date (descending)
SELECT COUNT(title),
	title
INTO mentor_rollup_summary
FROM recent_titles_by_emp_no
WHERE (to_date = '9999-01-01')
GROUP BY title, to_date
ORDER BY to_date DESC;

DROP TABLE mentor_rollup_summary

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- Table 3
-- The final query should return the potential mentor’s employee number, first and last name, their title, birth date and employment dates.
-- combine recent_title table with employees to retrieve .hire_date = XX/YY/1985
SELECT 
	rte.emp_no, 
	rte.first_name, 
	rte.last_name, 
	rte.title, 
	rte.from_date,
	rte.to_date
INTO mentor_table_final
FROM recent_titles_by_emp_no AS rte
RIGHT JOIN employees as e
ON (rte.emp_no = e.emp_no)
WHERE (e.hire_date BETWEEN '1985-01-01' AND '1985-12-31')
AND (rte.to_date = '9999-01-01');

DROP TABLE mentor_table_final
