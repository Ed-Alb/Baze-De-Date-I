-- metoda1:

select dang.dname "Den_dep_subalt", a.ename "Nume_subalt" ,
	   a.hiredate "Data_ang_subalt", s.ename "Nume_sef",
	   s.hiredate "Data_ang_sef"
from emp a JOIN emp s ON a.mgr = s.empno
		   JOIN emp pres ON pres.job = 'PRESIDENT'
		   JOIN dept dang on dang.deptno = a.deptno
where
	a.deptno = s.deptno 
	and EXTRACT(YEAR from a.hiredate) = EXTRACT(YEAR from pres.hiredate);
order by 1;

-- metoda2:
select dang.dname "Den_dep_subalt", a.ename "Nume_subalt" ,
	   a.hiredate "Data_ang_subalt", s.ename "Nume_sef",
	   s.hiredate "Data_ang_sef"
from emp a, emp s, emp pres, dept dang
where
	a.mgr = s.empno
	AND pres.job = 'PRESIDENT'
	AND dang.deptno = a.deptno
	AND a.deptno = s.deptno 
	AND EXTRACT(YEAR from a.hiredate) = EXTRACT(YEAR from pres.hiredate);
order by 1;