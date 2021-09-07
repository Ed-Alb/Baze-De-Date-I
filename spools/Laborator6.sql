select sysdate from SYS.DUAL;
select 'A inceput laboratorul nr. 6' from sys.dual;

-- FLOOR(n), CEIL(n)

-- MOD(m, n)

-- TRUNC(n [, m]) -- fara a face ce face si floor
-- ROUND(n[, m])

SELECT ename, empno
from emp
where MOD(empno, 2)=0;

select ename, SAL, SAL/3 "salariu impartit la 3",
	floor(SAL/3) "Valoare nr intreg",
	round(SAL/3, -2) "Valoare rotunjita la sute",
	round(SAL/3, 2) "Valoare rotunjita la sutimi"
from emp;

-- lista in care sa fie calulata o prima pentru angajatii ce nu priemsc comision
-- nu au finctia de manager si s-au angajat inainte de ALLEN

select a.ename Angajatul, a.job Functia, a.comm Comisionul, a.hiredate "Data angajare", ALLEN.hiredate "Data angajare Allen",
	round((a.sal + nvl(a.comm, 0) * 0.23)) Prima
from emp a, emp ALLEN
where 
	ALLEN.ename = 'ALLEN'
	AND
	nvl(a.comm,0) = 0
	AND
	a.job!='MANAGER'
	AND
	a.hiredate < ALLEN.hiredate;
	
	-- a.job NOT LIKE 'MAKAGER'
	-- (comm is null or (comm=0)) sau .. or (com is not null and comm=0)
	
select a.ename Angajatul, a.job Functia, a.comm Comisionul, a.hiredate "Data angajare", ALLEN.hiredate "Data angajare Allen",
	round((a.sal + nvl(a.comm, 0) * 0.23)) Prima
from emp a JOIN emp ALLEN on a.hiredate < ALLEN.hiredate
where 
	ALLEN.ename = 'ALLEN'
	AND
	(a.comm is null or a.comm=0)
	AND
	a.job!='MANAGER';
	
	
	
select a.ename, b.loc, replace(a.ename, 'AR', 'XY') Replace, translate(a.ename, 'AR', 'XY') Translate
from emp a join dept b on a.deptno=b.deptno
where sal > 1000;

select a.ename, b.loc, replace(a.ename, 'AR', '') ReplaceSters, translate(a.ename, 'AR', 'X') Translate
from emp a join dept b on a.deptno=b.deptno
where sal > 1000;

select ename, job,
	substr(ename, -2) "Ultimele 2 litere",
	replace(job, substr(ename, -2), '') "Job fara 2 litere",
	length(replace(job, substr(ename, -2), '')) "Sir job ramas",
	(length(job)-length(replace(job, substr(ename, -2), '')))/2 "Nr Aparitii"
from emp;


select extract(YEAR from sysdate), extract(month from sysdate), extract(day from sysdate)
from sys.dual;

select next_day(SYSDATE, 'THURSDAY') "Urmatoarea joi", LAST_DAY(SYSDATE) "Ultima zi din luna"
from sys.dual;

alter session set nls_date_format = "DD-MM-YYYY";


select ename "Numele angajatului", DNAME Departamentul, HIREDATE "Data Angajarii",
	   next_day(add_months(hiredate, 2), 'SUNDAY') "Data Testarii"
from emp, dept
where emp.deptno = dept.deptno
	  and
	  dept.dname = 'SALES';
	  
	  
select concat(concat('=', ENAME), '=') as "Nume formatat",
	   round(months_between(sysdate, hiredate) / 12) as "Vechime ani",
	   lpad(SAL, 6, 'X') as "Salariu formatat"
from emp
where instr(ename, 'E') > 1;

select '=' || ENAME || '=' as "Nume formatat",
	   round((sysdate - hiredate) / 365) as "Vechime ani",
	   lpad(SAL, 6, 'X') as "Salariu formatat"
from emp
where ename LIKE '%E%';


select distinct mgr from emp;

select a.ename Angajat, nvl(a.comm,0) Comision, b.grade "Grad Salarial",
	   a.sal + nvl(a.comm,0) VENIT, 'BUN' "Calificativ Venit"
from emp a, salgrade b
where
	a.sal between b.losal and b.hisal
	and
	nvl(a.comm,0) > 0
	and
	a.sal + nvl(a.comm,0) <= 2500
	and b.grade > 1
union
select a.ename Angajat, nvl(a.comm,0) Comision, b.grade "Grad Salarial",
	   a.sal + nvl(a.comm,0) VENIT, 'FOARTE BUN' "Calificativ Venit"
from emp a, salgrade b
where
	a.sal between b.losal and b.hisal
	and
	nvl(a.comm,0) > 0
	and
	a.sal + nvl(a.comm,0) > 2500
	and b.grade > 1
order by 4;


