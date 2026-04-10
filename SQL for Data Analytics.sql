create database try;

use try;

drop procedure if exists AddEmployee;
drop trigger if exists after_employee_insert;
drop table if exists Employee_audit;
drop table if exists Employees;

create table Employees (
   EmployeeID int primary key auto_increment,
   Name varchar(100),
   Position varchar(100),
   Salary decimal(10,2),
   Hire_date date
);

insert into Employees (Name, Position, Salary, Hire_date)
values 
     ('John Doe', 'Software Engineer', 80000, '2002-01-15'),
     ('Jane Smith', 'Project Manager',90000, '2021-05-22'),
     ('Alice Johnson', 'UX Designer', 75000, '2023-03-01');
     
select * from Employees;

create table Employee_audit(
   Audit_ID int primary key auto_increment,
   EmployeeID int,
   Name varchar(100),
   Position varchar(100),
   Salary decimal(10,2),
   Hire_date date,
   Action_date timestamp default current_timestamp
);

select * from Employee_audit;

-- ==========================================
-- TRIGGER: after_employee_insert
-- Purpose: Logs employee insert actions
-- ==========================================

delimiter $$

create trigger after_employee_insert
after insert on Employees
for each row
begin
    insert into Employee_audit (
          EmployeeID,
          Name,
          Position,
          Salary,
          Hire_date)
    values
         (New.EmployeeID,
          New.Name,
          New.Position,
          New.Salary,
          New.Hire_date);
end $$

delimiter ;

show triggers;

insert into Employees (Name, Position, Salary, Hire_date)
values
    ('David Miller', 'Business Analyst', 70000, '2024-01-10');

select * from Employee_audit;

-- ==========================================
-- STORED PROCEDURE: AddEmployee
-- Purpose: Inserts a new employee record
-- ==========================================

delimiter $$

create procedure AddEmployee (
   in p_Name varchar(100),
   in p_Position varchar(100),
   in p_Salary decimal(10,2),
   in p_Hire_date date
)
begin
    insert into Employees (Name, Position, Salary, Hire_date)
    values (p_Name, p_Position, p_Salary, p_Hire_date);
end $$

delimiter ;

call AddEmployee ('Robert Brown', 'Data Analyst', 85000, '2024-02-01');

select * from Employees;