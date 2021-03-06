m
-- This section was needed to address permissions in the database during
-- creation and deletion.  These make sure there is a public schema to put
-- the tables in.
CREATE SCHEMA public;
grant usage on schema public to public;
grant create on schema public to public;

-- To be consistent with the provided insertion statements, underscores where
-- removed from any column names.

-- This table needs to be created without the foreign key constraint because the
-- other table doesn't yet exist.
CREATE TABLE employee (
  Fname VARCHAR(15) NOT NULL,
  Minit CHAR,
  Lname VARCHAR(15) NOT NULL,
  Ssn CHAR(9) NOT NULL PRIMARY KEY,
  Bdate DATE,
  Address VARCHAR(30),
  Sex CHAR,
  Salary DECIMAL(10, 2),
  superssn CHAR(9),
  Dno INT NOT NULL
);

-- Perform inserts before adding the recursive foreign key.  Without this, each
-- insert fails as the superviser needs to already be in the table.
INSERT INTO EMPLOYEE(FNAME, MINIT,LNAME,SSN,BDATE,ADDRESS,SEX,SALARY,SUPERSSN,DNO) VALUES
('John', 'B', 'Smith', 123456789, '09-JAN-65', '731 Fondren, Houston, TX', 'M', 30000, 333445555,5);

INSERT INTO EMPLOYEE(FNAME, MINIT,LNAME,SSN,BDATE,ADDRESS,SEX,SALARY,SUPERSSN,DNO) VALUES
('Franklin','T','Wong',333445555,'08-DEC-55','635 Voss, Houston, TX','M',40000,888665555,5);

INSERT INTO EMPLOYEE(FNAME, MINIT,LNAME,SSN,BDATE,ADDRESS,SEX,SALARY,SUPERSSN,DNO) VALUES
('Joyce','A','English',453453453,'31-JUL-72','5631 Rice Houston','F',25000,333445555,5);

INSERT INTO EMPLOYEE(FNAME, MINIT,LNAME,SSN,BDATE,ADDRESS,SEX,SALARY,SUPERSSN,DNO) VALUES
('Ramesh','K','Narayan',666884444,'15-SEP-62','975 Fire Oak, Humble, TX','M',38000, 333445555,5);

INSERT INTO EMPLOYEE(FNAME, MINIT,LNAME,SSN,BDATE,ADDRESS,SEX,SALARY,SUPERSSN,DNO) VALUES
('James','E','Borg',888665555,'10-NOV-37','450 Stone, Houston, TX','M',55000,NULL,1);

INSERT INTO EMPLOYEE(FNAME, MINIT,LNAME,SSN,BDATE,ADDRESS,SEX,SALARY,SUPERSSN,DNO) VALUES
('Jennifer','S','Wallace',987654321,'20-JUN-41','291 Berry, Bellaire, TX','F',43000,888665555,4);

INSERT INTO EMPLOYEE(FNAME, MINIT,LNAME,SSN,BDATE,ADDRESS,SEX,SALARY,SUPERSSN,DNO) VALUES
('Ahmad','V','Jabbar',987987987,'29-MAR-69','980 Dallas, Houston','M',25000,987654321,4);

INSERT INTO EMPLOYEE(FNAME, MINIT,LNAME,SSN,BDATE,ADDRESS,SEX,SALARY,SUPERSSN,DNO) VALUES
('Alicia','J','Zelaya',999887777,'19-JAN-68','3321 Castle, Spring','F',25000,987654321,4);

-- After inserts, the recursive foreign key from ssn to superssn can be added.
ALTER TABLE employee
  ADD CONSTRAINT superssn_fkey FOREIGN KEY (superssn)
    REFERENCES employee (ssn);

-- remove underscores for compatibility with provided insertion statements

-- No foreign keys are initially included to prevent errors from the non-existent
-- foreign tables.
CREATE TABLE department (
  Dname VARCHAR(15) UNIQUE NOT NULL,
  Dnumber INT NOT NULL PRIMARY KEY,
  Mgrssn CHAR(9) NOT NULL,
  Mgrstartdate DATE
);

-- insert departments to allow employee <-> foreign keys
INSERT INTO DEPARTMENT(DNAME,DNUMBER,MGRSSN,MGRSTARTDATE) VALUES
('Headquarters',1,888665555,'19-JUN-81');

INSERT INTO DEPARTMENT(DNAME,DNUMBER,MGRSSN,MGRSTARTDATE) VALUES
('Administration',4,987654321,'01-JAN-95');

INSERT INTO DEPARTMENT(DNAME,DNUMBER,MGRSSN,MGRSTARTDATE) VALUES
('Research',5,333445555,'22-MAY-88');

-- Now that both tables exist, include employee foreign key from department table.
ALTER TABLE employee
  ADD CONSTRAINT dno_fkey FOREIGN KEY (Dno)
    REFERENCES department (Dnumber);

-- Now that both tables exist, include department foreign key from employee table.
ALTER TABLE department
  ADD CONSTRAINT mgrssn_fkey FOREIGN KEY (Mgrssn)
    REFERENCES employee (Ssn);

-- Dept_locations table can be created with foreign keys as the other
-- referenced table already exists.
CREATE TABLE dept_locations (
  Dnumber INT NOT NULL REFERENCES department (Dnumber),
  Dlocation VARCHAR(15) NOT NULL,
  PRIMARY KEY (Dnumber, Dlocation)
);

-- Insert locations
INSERT INTO DEPT_LOCATIONS(DNUMBER,DLOCATION) VALUES
(1,'Houston');

INSERT INTO DEPT_LOCATIONS(DNUMBER,DLOCATION) VALUES
(4,'Stafford');

INSERT INTO DEPT_LOCATIONS(DNUMBER,DLOCATION) VALUES
(5,'Bellaire');

-- Missing value, taken from pg 72
INSERT INTO DEPT_LOCATIONS(DNUMBER,DLOCATION) VALUES
(5,'Sugarland');

INSERT INTO DEPT_LOCATIONS(DNUMBER,DLOCATION) VALUES
(5,'Houston');

-- The rest can all be Created and inserted without issue, as the referenced
-- foreign keys all exist.

CREATE TABLE project (
  Pname VARCHAR(15) UNIQUE NOT NULL,
  Pnumber INT NOT NULL PRIMARY KEY,
  Plocation VARCHAR(15),
  Dnum INT NOT NULL REFERENCES department (Dnumber)
);

INSERT INTO PROJECT(PNAME,PNUMBER,PLOCATION,DNUM) VALUES
('ProductX',1,'Bellaire',5);

INSERT INTO PROJECT(PNAME,PNUMBER,PLOCATION,DNUM) VALUES
('ProductY',2,'Sugarland',5);

INSERT INTO PROJECT(PNAME,PNUMBER,PLOCATION,DNUM) VALUES
('ProductZ',3,'Houston',5);

INSERT INTO PROJECT(PNAME,PNUMBER,PLOCATION,DNUM) VALUES
('Computerization',10,'Stafford',4);

INSERT INTO PROJECT(PNAME,PNUMBER,PLOCATION,DNUM) VALUES
('Reorganization',20,'Houston',1);

INSERT INTO PROJECT(PNAME,PNUMBER,PLOCATION,DNUM) VALUES
('Newbenefits',30,'Stafford',4);

CREATE TABLE works_on (
  Essn  CHAR(9) NOT NULL REFERENCES employee (Ssn),
  Pno INT NOT NULL REFERENCES project (Pnumber),
  Hours DECIMAL(3, 1) NOT NULL,
  PRIMARY KEY (Essn, Pno)
);

INSERT INTO WORKS_ON(ESSN,PNO,HOURS) VALUES
(123456789,1,32.5);

INSERT INTO WORKS_ON(ESSN,PNO,HOURS) VALUES
(123456789,2,7.5);

INSERT INTO WORKS_ON(ESSN,PNO,HOURS) VALUES
(333445555,2,10);

INSERT INTO WORKS_ON(ESSN,PNO,HOURS) VALUES
(333445555,3,10);

INSERT INTO WORKS_ON(ESSN,PNO,HOURS) VALUES
(333445555,10,10);

INSERT INTO WORKS_ON(ESSN,PNO,HOURS) VALUES
(333445555,20,10);

INSERT INTO WORKS_ON(ESSN,PNO,HOURS) VALUES
(453453453,1,20);

INSERT INTO WORKS_ON(ESSN,PNO,HOURS) VALUES
(453453453,2,20);

INSERT INTO WORKS_ON(ESSN,PNO,HOURS) VALUES
(666884444,3,40);

-- remove NULL value that fails constraint (randomely using 20)
INSERT INTO WORKS_ON(ESSN,PNO,HOURS) VALUES
(888665555,20,20);

INSERT INTO WORKS_ON(ESSN,PNO,HOURS) VALUES
(987654321,20,15);

INSERT INTO WORKS_ON(ESSN,PNO,HOURS) VALUES
(987654321,30,20);

INSERT INTO WORKS_ON(ESSN,PNO,HOURS) VALUES
(987987987,10,35);

INSERT INTO WORKS_ON(ESSN,PNO,HOURS) VALUES
(987987987,30,5);

INSERT INTO WORKS_ON(ESSN,PNO,HOURS) VALUES
(999887777,10,10);

INSERT INTO WORKS_ON(ESSN,PNO,HOURS) VALUES
(999887777,30,30);

CREATE TABLE dependent (
  Essn  CHAR(9) NOT NULL REFERENCES employee (Ssn),
  Dependent_name  VARCHAR(15) NOT NULL,
  Sex CHAR,
  Bdate DATE,
  Relationship VARCHAR(8),
  PRIMARY KEY (Essn, Dependent_name)
);

INSERT INTO DEPENDENT(ESSN,DEPENDENT_NAME,SEX,BDATE,RELATIONSHIP) VALUES
(123456789,'Alice','F','30-DEC-88','Daughter');

INSERT INTO DEPENDENT(ESSN,DEPENDENT_NAME,SEX,BDATE,RELATIONSHIP) VALUES
(123456789,'Elizabeth','F','05-MAY-67','Spouse');

INSERT INTO DEPENDENT(ESSN,DEPENDENT_NAME,SEX,BDATE,RELATIONSHIP) VALUES
(123456789,'Micheal','M','04-JAN-88','Son');

INSERT INTO DEPENDENT(ESSN,DEPENDENT_NAME,SEX,BDATE,RELATIONSHIP) VALUES
(333445555,'Alice','F','05-APR-86','Daughter');

INSERT INTO DEPENDENT(ESSN,DEPENDENT_NAME,SEX,BDATE,RELATIONSHIP) VALUES
(333445555,'Joy','F','03-MAY-58','Spouse');

INSERT INTO DEPENDENT(ESSN,DEPENDENT_NAME,SEX,BDATE,RELATIONSHIP) VALUES
(333445555,'Theodore','M','25-OCT-83','Son');

INSERT INTO DEPENDENT(ESSN,DEPENDENT_NAME,SEX,BDATE,RELATIONSHIP) VALUES
(987654321,'Abner','M','28-FEB-42','Spouse');
