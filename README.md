# Pewlett-Hackard-Analysis_pdouglass

# Executive Overview
When evaluating the opportunity to develop supervisors internally for future roles, PH has an ample supply of talent. There is an abundance of individuals (1549) in the Senior Engineer (529) and Senior Staff (569) ranks with several apiece for the Engineers (190), Staff (155) and Technique Leader (77) with a relatively low number of Assistant Engineers (29). However, if we consider that it’s preferable to lean on staff with extensive PH experience, we suggest looking to staff hired in 1985. This brings the total staff available for potential supervisory roles to 176. 

For future examination, we may want to consider broadening the range of hiring years outside of just one year. As it stands, there are only 3 Assistant Engineers available for mentoring responsibilities. Given that it’s likely that more people are hired into that position than more experienced roles (Engineer and Senior Engineer) there isn’t very much experience to lean on as mentors. However, most people at PH who are retiring are likely not in the Assistant role anyway and have more likely been promoted in the past to other roles.  

Additionally, we only looked at one hiring year (1965) which is a rather tight window. Opening up the range may prove to expand the list some without becoming overwhelming. 

![](https://github.com/prentiss04/Pewlett-Hackard-Analysis_pdouglass/blob/master/challenge.PNG)

## Table 1 – Imminent Retirees
For the first table, employee information is culled from the employee table, joined with both the titles and salaries tables winnowed by birthdates in 1965. This provides a preliminary high-level view of the individuals and experience that will be retiring imminently though not a fully refined list as many of the individuals will appear more than once due to multiple positions as well as people who are no longer at PH. 

### Table 1 code
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

![Table 1](https://github.com/prentiss04/Pewlett-Hackard-Analysis_pdouglass/blob/master/Analysis%20Projects%20Folder/Pewlett-Hackard-Analysis%20Folder/Queries/Table_1.PNG)

## Table 2 – Only Most Recent Titles
Many employees from Table 1 have worked their way through PH and have held various titles. To get a clearer picture of who is available as a supervisor in their most advanced capacity, all previous roles are removed from the list. 
A roll-up gives a quick glance at what roles have the greatest coverage for supervisory positions. 

![Table 2](https://github.com/prentiss04/Pewlett-Hackard-Analysis_pdouglass/blob/master/Analysis%20Projects%20Folder/Pewlett-Hackard-Analysis%20Folder/Queries/Table_2.PNG)

## Table 3 – Mentor List
This provides a name-by-name list of current employees primed for supervisory role. Rather than lean on employees who don’t have PH in their DNA (i.e. long-tenured), we looked at staff hired in 1985 as that would provide a suitable amount of experience to understand the nuance of working at PH. There was some confusion that the hire date needed to occur in 1965, yet we were already tasked with looking at people born in 1965.


![Table 3](https://github.com/prentiss04/Pewlett-Hackard-Analysis_pdouglass/blob/master/Analysis%20Projects%20Folder/Pewlett-Hackard-Analysis%20Folder/Queries/Table_3.PNG)
