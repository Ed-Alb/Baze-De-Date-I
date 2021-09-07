---------------
-- Grunberg Edar-Albert
-- Colocviu BD1

-- pas 1
-- toti sefii care au cel putin 2 subalterni ce nu au primit comision

select sef.ename NUME_SEF, sef.sal, count(*)
from emp sef join emp a on a.mgr = sef.empno and nvl(a.comm, 0) = 0
group by sef.ename, sef.sal
having count(*) >= 2;


-- pas 2
-- aflarea salariului maxim din pasul precedent
select max(seflist.sal)
from (select sef.ename NUME_SEF, sef.sal, count(*)
	from emp sef join emp a on a.mgr = sef.empno and nvl(a.comm, 0) = 0
	group by sef.ename, sef.sal
	having count(*) >= 2) seflist;
	
-- pas 3
-- iau seful cu salariul max si subalternii sai si gata
-- de asemenea iau si departamentul cu acel join pe dept
select d.dname "DEN_DEP_SEF", seful.ename "NUME_SEF", seful.job "JOB_SEF",
	   seful.sal "SAL_SEF", a.ename "NUME_SUB", nvl(a.comm, 0) "COM_SUB"
from emp seful join dept d on seful.deptno = d.deptno
			   join emp a on a.mgr = seful.empno
where
	seful.sal = (
		select max(seflist.sal)
		from (select sef.ename NUME_SEF, sef.sal, count(*)
			from emp sef join emp a on a.mgr = sef.empno and nvl(a.comm, 0) = 0
			group by sef.ename, sef.sal
			having count(*) >= 2) seflist);