select a.deptno, count(extract( YEAR from a.hiredate)) ani,
	extract( YEAR from a.hiredate)
from emp a
group by a.deptno, extract( YEAR from a.hiredate);

select * from
(select d.dname DEN_DEP, count(*) NR_ANG, extract(year from a.hiredate) AN
from emp a inner join dept d on a.deptno = d.deptno
group by extract(year from a.hiredate), d.dname) s
where s.NR_ANG = (
select max(t.NR_ANG) from
(select d.dname DEN_DEP, count(*) NR_ANG, extract(year from a.hiredate) AN
from emp a inner join dept d on a.deptno = d.deptno
group by extract(year from a.hiredate), d.dname) t
);

-- selectarea angajatilor din departamentul lui scott
select a.ename, a.job, a.deptno, a.sal
from emp a join emp SCOTT on LOWER(SCOTT.ename) = 'scott'
where
	a.deptno = SCOTT.deptno
	and
	a.ename not like 'SCOTT';
	
	
select ename, job, deptno, sal
from emp
where
	deptno IN (select deptno from emp where ename LIKE 'SCOTT');
	
-- gradul salarial din care fac parte cele mai multe salarii din firma
select t.grade
from salgrade t
join emp f on f.sal between t.losal and t.hisal
group by t.grade having count(*) =
	(
	select max(count(*)) nr_ang
	from salgrade s join emp e on e.sal between s.losal and s.hisal
	group by s.grade
	);
	

-- final
select a.ename "Nume angajat", a.sal "Salariu",
	   a.sal + nvl(a.comm, 0) "Venit", salg.grade "Grad salarial"
from emp a join emp SCOTT on LOWER(SCOTT.ename) = 'scott'
		   join salgrade salg on a.sal between salg.losal and salg.hisal
where
	a.deptno = SCOTT.deptno
	and
	a.ename not like 'SCOTT'
	and
	salg.grade = 
		(select t.grade
		from salgrade t
		join emp f on f.sal between t.losal and t.hisal
		group by t.grade having count(*) =
			(
			select max(count(*)) nr_ang
			from salgrade s join emp e on e.sal between s.losal and s.hisal
			group by s.grade
			)
		);
		
CREATE TABLE ANGAJATI_GRAD_ALLEN AS
(
SELECT A.ENAME "Nume angajat", A.SAL + NVL(A.COMM, 0) Venit, B.GRADE
FROM EMP A JOIN SALGRADE B ON A.SAL BETWEEN B.LOSAL AND B.HISAL
WHERE
B.GRADE=( SELECT D.GRADE 
          FROM EMP C JOIN SALGRADE D ON C.SAL BETWEEN D.LOSAL AND D.HISAL
          WHERE 
            C.ENAME='ALLEN'
        )
AND
1 >= (SELECT COUNT(*)
      FROM EMP E JOIN SALGRADE F ON E.SAL BETWEEN F.LOSAL AND F.HISAL
      WHERE
          F.GRADE=B.grade
        AND 
        E.SAL + NVL(E.COMM, 0) > A.SAL + NVL(A.COMM, 0)
       )
);

select * from ANGAJATI_GRAD_ALLEN;

SELECT A.ENAME "Nume angajat", A.SAL + NVL(A.COMM, 0) Venit, B.GRADE
FROM EMP A JOIN SALGRADE B ON A.SAL BETWEEN B.LOSAL AND B.HISAL
WHERE
B.GRADE=( SELECT D.GRADE 
          FROM EMP C JOIN SALGRADE D ON C.SAL BETWEEN D.LOSAL AND D.HISAL
          WHERE 
            C.ENAME='ALLEN'
        )
AND
1 >= (SELECT COUNT(*)
      FROM EMP E JOIN SALGRADE F ON E.SAL BETWEEN F.LOSAL AND F.HISAL
      WHERE
          F.GRADE=( SELECT GRADE 
          FROM EMP  JOIN SALGRADE  ON SAL BETWEEN LOSAL AND HISAL
          WHERE 
            ENAME='ALLEN'
        )
        AND 
        E.SAL + NVL(E.COMM, 0) > A.SAL + NVL(A.COMM, 0)
       );

drop table ANGAJATI_GRAD_ALLEN;


-- Sa se afiseze anul in care s-au angajat cei mai multi salariati
-- in firma, afisand si numarul celor angajati in acel an

select extract (YEAR from a.hiredate) anul, count(*)
from emp a
GROUP BY extract (YEAR FROM A.HIREDATE)
having count(*) = 
	( SELECT MAX(COUNT(*))
      FROM EMP B
	  GROUP BY    EXTRACT (YEAR FROM B.HIREDATE));
	  
-- O lista de premiere a angajatilor:
--   a) Angajatii care au primit comision primesc o prima egala cu salariul mediu pe companie;
--   b) Angajatii care nu au primit comision primesc o prima egala cu salariul minim pe companie;
--   c) Presedintele si directorii (JOB= Manager) nu primesc prima.
-- Salariile si prima se afiseaza fara zecimale.

select b.dname den_dep, a.ename nume_ang, a.job, a.comm comision, 
		min(c.sal) salariu_min_com, trunc( avg(c.sal)) salariu_mediu_com,
		trunc(decode(a.job, 'MANAGER', 0, 'PRESIDENT', 0, 
		decode(nvl(a.comm, 0), 0, min(c.sal), avg(c.sal)))) prima
from emp a, dept b, emp c
where a.deptno = b.deptno
group by b.dname, a.ename, a.comm, a.job;

select to_char(a.hiredate, 'day')
from emp a;

select to_char(a.hiredate, 'month')
from emp a;

select to_char(a.hiredate, 'year')
from emp a;


