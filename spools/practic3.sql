select s.grade, count(*)
from salgrade s join emp a on a.sal between s.losal and s.hisal
where a.hiredate > (select hiredate from emp where ename = 'ALLEN')
group by s.grade
having count(*) > 1;


select g.grade "Grad salarial", count(a.ename) "Numar angajati in grad"
from emp a join salgrade g on a.sal between g.losal and g.hisal
where a.hiredate > (select b.hiredate from emp b where b.ename = 'ALLEN')
group by g.grade
having count(a.ename) > 1;

select a.ename "Nume ang", a.comm "Comision ang", a.hiredate "Data angajare",
	   s.hiredate "Data angajare sef", g.grade "Grad Salarial",
	   case g.grade
		when 1 then 500
		when 2 then 300
		when 3 then 100
		else 0
	   end PRIMA
from emp a join salgrade g on a.sal between g.losal and g.hisal
		   join emp s on a.mgr = s.empno
where (a.comm is null or a.comm = 0)
	  and months_between(a.hiredate, s.hiredate) >= 2;
	  
select a.ename "Nume ang", a.comm "Comision ang", a.hiredate "Data angajare",
	   b.hiredate "Data angajare sef", c.grade "Grad salarial",
	   decode(c.grade, 1, 500, 2, 300, 3, 100, 0) PRIMA
from emp a inner join emp b on a.mgr = b.empno
		   inner join salgrade c on a.sal between c.losal and c.hisal
where nvl(a.comm, 0) = 0 and months_between(a.hiredate, b.hiredate) >= 2;


select a.ename "nume", g.grade "grad",
	   abs(sin(sqrt((months_between(sysdate, a.hiredate)/12) * g.grade)) * 150) "concediu"
from emp a join salgrade g on a.sal between g.losal and g.hisal
where a.hiredate < (select sef.hiredate from emp sef where sef.empno = a.mgr)
	  and g.grade >= 3
order by a.ename;

select sef.ename "Sef", d.dname "Denumire Departament", trunc(sef.sal / 2, 0) "Prima",
	   (select count(*) from emp subalt where subalt.mgr = sef.empno) "Nr subalterni"
from emp sef join dept d on sef.deptno = d.deptno
where
	3 <= (select count(*) from emp subalt where subalt.mgr = sef.empno);


SELECT A.ENAME SEF, B.DNAME "DENUMIRE DEPARTAMENT", FLOOR(A.SAL/2) PRIMA,
       COUNT(C.EMPNO)
FROM EMP A JOIN DEPT B ON A.DEPTNO=B.DEPTNO JOIN EMP C ON A.EMPNO=C.MGR
GROUP BY A.ENAME, B.DNAME, A.SAL
HAVING COUNT(C.EMPNO) >= 3;
	
-- prima zi din an: select trunc(sysdate, 'year') from dual;
-- prima zi din luna: select trunc(sysdate, 'mon') from dual;
-- ultima zi din an: SELECT ADD_MONTHS(TRUNC (SYSDATE ,’YEAR’),12)-1 FROM DUAL;

select d.dname "Den_dep", a.ename "Nume", a.hiredate "Data_ang",
	   extract(MONTH from a.hiredate) "Den_luna_prima",
	   a.sal "Salariu", nvl(a.comm, 0) "Comision", round(0.1*a.sal) "Prima"
from emp a join dept d on a.deptno = d.deptno
where round(months_between(sysdate, a.hiredate) / 12) > 25
	  and (a.comm is null or a.comm = 0);
-- metida 2
select d.dname "Den_dep", a.ename "Nume", a.hiredate "Data_ang",
	   extract(MONTH from to_date(trunc(a.hiredate, 'mon'))) "Den_luna_prima",
	   a.sal "Salariu", nvl(a.comm, 0) "Comision", ceil(0.1*a.sal) "Prima"
from emp a join dept d on a.deptno = d.deptno
where round((sysdate - a.hiredate) / 356) > 25
	  and nvl(a.comm, 0) = 0;

