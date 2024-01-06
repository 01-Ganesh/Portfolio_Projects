--Q Select Employees from same city

select e1.* from Employee e1,Employee e2 
where
e1.City = e2.City and e1.EmpId<>e2.EmpId;



--Q Find Cumulative Sum of Salary

select *,sum(Salary) over (order by EmpId) as CumSum from Employee;



--Q Find Male and Female ratio

SELECT 
sum(CASE WHEN Gender = 'M' THEN 1 else 0 END)*100.0/count(*) as Male,
sum(CASE WHEN Gender = 'F' THEN 1 else 0 END)*100.0/ COUNT(*) AS Female
from Employee;



--Q Employees working in the same project

with cte as 
(select e.EmpID , e.EmpName , ed.Project from Employee e
	join EmployeeDetail ed
	on e.EmpID = ed.EmpID)	

select c1.EmpName,c2.EmpName,c1.Project from cte c1,cte c2
where c1.Project = c2.Project and 
c1.EmpName<>c2.EmpName and 
c1.EmpId>c2.empID




--Q 50% of records from table

with cte as 
(select *,ROW_NUMBER() over (order by EmpID) as rn from Employee)
select * from cte where rn<= (select count(*)/2 from Employee)

SELECT * FROM Employee
WHERE
EmpID <= (SELECT count(EmpID )/2 from Employee);



--Q Fetch  Employee's salary but replace last 2 digits with 'XX'

select Salary, 
concat(left(Salary,len(Salary)-2),'XX') as Sal
from Employee;



--Q Fetch odd and even number of rows

select * from
	(select *,ROW_NUMBER() over (order by EmpID) as rn from Employee) e
where e.rn%2 = 0

select * from Employee
where EmpId%2 = 0


--Q Write a query to find all the Employee names whose name

--Begin with ‘A’
--Contains ‘A’ alphabet at second place
--Contains ‘Y’ alphabet at second last place
--Ends with ‘L’ and contains 4 alphabets 
--Begins with ‘V’ and ends with ‘A’

 select * from Employee where EmpName like 'A%'
 select * from Employee where EmpName like '_a%'
 select * from Employee where EmpName like '%y_'
 select * from Employee where EmpName like '____l'
 select * from Employee where EmpName like 'V%a'



 --Q Write a query to find the list of Employee names which is:

--starting with vowels (a, e, i , o, or u), without duplicates

--ending with vowels (a, e, i , o, or u), without duplicates

--starting & ending with vowels (a, e, i , o, or u), without duplicates


select EmpName from Employee where Empname like '[AEIOU]%'  OR   select EmpName from Employee WHERE LEFT(EmpName , 1) IN ('a','e','i','o','u')

select distinct EmpName from Employee where Empname like '%[AEIOU]'

select distinct EmpName from Employee where Empname like '[AEIOU]%[AEIOU]'




-- Find nth highest salary

select * from 
	(select *, DENSE_RANK() over ( order by Salary desc) as rn from Employee) e
where e.rn = 2

select * from Employee
order by Salary desc 
OFFSET 1 ROWS FETCH first 1 ROWS ONLY;

with cte as 
	(select *, DENSE_RANK() over ( order by Salary desc) as rn from Employee) 
select * from cte where rn = 2



--Q Find and Remove Duplicates

select EmpID, count(*) from Employee
group by EmpID having count(*) > 1


with cte as 
	(select *,ROW_NUMBER() over (partition by EmpID order by EmpID) as rn from Employee)
delete from cte where rn >1

--OR

delete from Employee
where EmpID in 
(select EmpID,count(*) from Employee group by EmpID having count(*)>1)



--Q Employee with nth highest salary for project

select ed.Project, max(e.Salary) as Sal from Employee e
join EmployeeDetail ed on 
e.EmpID = ed.EmpID
group by ed.Project
order by Sal desc


with cte as 
	(select e.*,ed.Project,DENSE_RANK() over (partition by ed.Project order by Salary desc) as rn from Employee e
	join EmployeeDetail ed on e.EmpID = ed.EmpID)
select * from cte where rn = 1



--Q Total Employees joined by year

select YEAR(DOJ),count(*) as EmpCount from EmployeeDetail ed
join Employee e on e.EmpID = ed.EmpID
group by YEAR(DOJ)


-- Q Create 3 groups based on salary col, salary less than 1L is low, between 1-2L is medium and above 2L is High

select *,case 
	when Salary<100000 then 'Low'
	when Salary between 100000 and 200000 then 'Medium'
	else 'High'
	end as 'Range'
from Employee



-- Q Total Salary for each city with seperate columns for each city
SELECT
EmpID,
EmpName,
SUM(CASE WHEN City = 'Mathura' THEN Salary END) AS "Mathura",
SUM(CASE WHEN City = 'Pune' THEN Salary END) AS "Pune",
SUM(CASE WHEN City = 'Delhi' THEN Salary END) AS "Delhi"
FROM Employee
GROUP BY
EmpID , EmpName