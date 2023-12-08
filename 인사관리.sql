select * from tab;
alter user hr IDENTIFIED by hr ACCOUNT UNLOCK;

select * from employees; 
describe employees;
select * from departments;
select location_id, department_id from departments;
select department_id, location_id from departments;
select department_id, department_id from departments;
select last_name,salary,(salary + 300) as "덧셈" from employees;
select last_name,salary,12*salary+100 from employees;
select last_name,salary,12*(salary+100) from employees;

select last_name,job_id,salary, commission_pct from employees;
select last_name,12*salary*NVL(commission_pct,1) from employees;

select last_name as name,commission_pct comm from employees;
select last_name "Name" , salary*12 "Annual Salary" from employees;
select last_name as 이름,commission_pct 보너스 from employees;

select last_name || job_id as "Employees" from employees;
select last_name ||' is a ' || job_id as "Employees Details" from employees;



select department_id from employees; -- 원래 department_id 앞에 ALL이 붙어있음
select distinct department_id from employees;
select distinct department_id, job_id from employees;

select department_id from employees order by department_id;

desc departments;
select * from departments;

desc employees;
select employee_id, last_name, job_id, hire_date as startdate from employees;

select distinct job_id from employees; 

desc employees;
select employee_id as "Emp #", last_name as "Employee", job_id as "Job", hire_date as "Hire Date" from employees;

select job_id ||' , '|| last_name as "Employee and Title" from employees; 

select employee_id, last_name,job_id,department_id from employees where department_id=90;
select last_name, job_id,department_id from employees where last_name = 'Whalen';
select last_name from employees where hire_date = '05-10-10';

select last_name,salary from employees where salary <=3000;

select last_name, hire_date from employees where hire_date < '05/01/01';

select last_name,salary from employees where salary between 2500 and 3500;
select last_name,salary from employees where salary between 3500 and 2500; --쓰레기값(논리적오류)
select employee_id,last_name,salary,manager_id from employees where manager_id in(100,101,201);

select first_name from employees where first_name like 'S%';
select last_name from employees where last_name like '%s';
select last_name, hire_date from employees where hire_date like '05%';
select last_name, hire_date from employees where last_name like '_o%';
select employee_id, last_name,job_id from employees where job_id like '%SA_%';
select employee_id, last_name,job_id from employees where job_id like '%SA3_%' escape '3';

select employee_id, last_name,job_id from employees where job_id like '%_M%';
select employee_id, last_name,job_id from employees where job_id like '%\_M%' escape '\';

select * from employees where commission_pct is null;

select employee_id, last_name, job_id,salary from employees where salary >= 10000 and job_id like '%MAN%';
select employee_id, last_name, job_id,salary from employees where salary >= 10000 or job_id like '%MAN%';

select last_name,job_id from employees where job_id not in('IT_PROG','ST_CLERK','SA_REP');

select last_name,job_id,salary from employees where job_id = 'SA_REP' or job_id = 'AD_PRES' and salary > 15000;
select last_name,job_id,salary from employees where (job_id = 'SA_REP' or job_id = 'AD_PRES') and salary > 15000;

--1
select last_name,salary 
from employees 
where salary >12000;

--2
select last_name,employee_id 
from employees 
where employee_id = 176;

--3
select last_name,salary 
from employees 
where salary not between 5000 and 12000;

--6
select last_name as "Employee",salary as "Monthly Salary"
from employees
where (salary between 5000 and 12000) and DEPARTMENT_ID in('20','50');

select last_name,hire_date from employees where hire_date BETWEEN '14-01-01' and '15-01-01';
select hire_date from employees;

select last_name,job_id from employees where manager_id is null;

select last_name from employees where last_name = '__a%';

select last_name from employees where last_name = '%a%' or last_name = '%e%';

select last_name,job_id,salary from employees where (job_id='SA_REP' or job_id='ST_CLERK') and salary in('2500','3500','7000');

select last_name,salary,commission_pct from employees where commission_pct =0.2;
select * from employees;

select HIRE_DATE from employees;


select * from job_history;

select employee_id from employees UNION select employee_id from job_history;
select employee_id,job_id,department_id from employees UNION all select employee_id,job_id,department_id from job_history order by employee_id;

select employee_id,job_id from employees INTERSECT select employee_id,job_id from job_history order by employee_id;
select employee_id,job_id from job_history INTERSECT select employee_id,job_id from employees order by employee_id;

select employee_id,job_id from employees MINUS select employee_id,job_id from job_history order by employee_id;
select employee_id,job_id from job_history MINUS select employee_id,job_id from employees order by employee_id;

desc dual;
select * from dual;

select sysdate from dual;

select 'The job id for ' || Upper (last_name) || ' is ' || lower(job_id) as "EMPLOYEE DETAILS" from employees;

select employee_id,last_name,department_id from employees where lower(last_name) = 'higgins';
select last_name,substr(last_name,-3,2) from employees where department_id=90;
select employee_id, concat(first_name,last_name) name, job_id,length(last_name),instr(last_name,'4') "contains 'a'?" from employees where substr(job_id,4) = 'REP';
select Ltrim('yyedaymy','yea') from dual;
select rtrim('yyedaymy','yea') from dual;

select round(345.678) as round1, round(345.678,0) as round2, round(345.678,1) as round3, round(345.678,-1) as round4 
from dual;

select trunc(345.678) as trunc1, trunc(345.678,0) as trunc2, trunc(345.678,1) as trunc3, trunc(345.678,-1) as trunc4 
from dual;

select last_name,salary,mod(salary,5000) 
from employees;

select sysdate as "Date" 
from dual;

select employee_id,last_name,salary,round((salary * 1.15)) as "New Salary" 
from employees;

select employee_id,last_name,salary,((salary * 1.15)-salary) as "Increase" 
from employees;

select upper(last_name), length(last_name) from employees where substr(last_name,1,1) in('J','A','M') order by 1;
























































































