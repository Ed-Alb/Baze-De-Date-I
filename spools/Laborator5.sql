select * from angajati;

select deptno from dept;

set verify off

select deptno departamentul, dname denumirea, loc from dept;

select ename, empno, sal, comm
from emp
where sal > &&salariu and (comm is not null and comm > 0);


-- NVL(a, b) -> retuns a if a not null or b if a is null
select ename, empno, sal, comm
from emp
where sal > &salariu and nvl(comm, 0) > 0;

-- venit salariat = salariu + nvl(comision, 0)!!!!


select ename, dname from emp, dept; 
-- produs cartezian cu 56 inregistrari(14 * 4)

select emp.ename, emp.sal, emp.comm, dept. dname
from emp, dept
where dept.dname = 'ACCOUNTING' and nvl(comm, 0) = 0;


select emp.ename, emp.sal, emp.comm, dept. dname
from emp, dept
where emp.deptno = dept.deptno and dept.dname = 'ACCOUNTING' and nvl(comm, 0) = 0;
-- conditia de join este prima parte din where, fara ea rezulta produs cartezian

-- join on
select emp.ename Numele, emp.sal + nvl(comm, 0) Venit, dept.dname Departamente
from emp join dept on emp.deptno = dept.deptno
where dname = 'ACCOUNTING' and nvl(comm, 0)=0;

-- Natural join - capcana can sunt mai multe coloane comune
select emp.ename Numele, emp.sal + nvl(comm, 0) Venit, dept.dname Departamente
from emp natural join dept
where dept.dname = 'ACCOUNTING' and nvl(comm, 0)=0;

select emp.ename Numele, dept.dname Departamente
from emp natural join dept;

-- toti angajatii ce castiga mai mult decat sefii lor (venit mai mare)
select a.ename, s.ename, a.sal + nvl(a.comm, 0) venit_angajat, s.sal + nvl(s.comm, 0) venit_sef
from emp a, emp s
where a.mgr = s.empno and (a.sal + nvl(a.comm, 0)) > (s.sal + nvl(s.comm, 0));
-- aliasurile date in select nu se pot folosi in clauza where


select a.ename, s.ename, a.sal + nvl(a.comm, 0) venit_angajat, s.sal + nvl(s.comm, 0) venit_sef
from emp a JOIN emp s on a.mgr = s.empno
where (a.sal + nvl(a.comm, 0)) > (s.sal + nvl(s.comm, 0));

-- sa se selecteze toti angajatii care castiga
-- mai mult decat o valoare citia de la tastatura
-- si care sunt angajati inainte de sefii lor

select a.ename, s.ename, a.hiredate data_angajat, s.hiredate data_sef
from emp a JOIN emp s on a.mgr = s.empno
where a.sal + nvl(a.comm, 0) > &&venit and a.hiredate < s.hiredate;


-- join urile bazate pe egalitati -> equijoin

select a.ename, b.dname, a.sal, c.grade
from emp a, dept b, salgrade c
where a.deptno = b.deptno and a.sal >= c.losal and a.sal <= c.hisal
and b.dname like 'SALES'
order by 4;

select a.ename, b.dname, a.sal, c.grade
from emp a join dept b on a.deptno = b.deptno
	join salgrade c on a.sal between c.losal and c.hisal
where b.dname like 'SALES'
order by 4;




select a.dname, a.deptno, b.ename, b.job
from dept a, emp b
where a.deptno = b.deptno(+)
order by a.dname;

-- in dreapta tabela mai bogata, in stanga cea mai saraca
select a.dname, a.deptno, b.ename, b.job
from dept a left outer join emp b on a.deptno = b.deptno
order by a.dname;

-- cu join sau using: slectati toti ang dintr un departament cu denumirea
-- citita de la tastatura ce au salariul in grad 3: numele, denumirea dept,
-- sal, grad salarial.

select a.ename, b.dname, a.sal, c.grade
from emp a join dept b on a.deptno = b.deptno
join salgrade c on a.sal between c.losal and c.hisal
where b.dname = '&dept_name' and c.grade = 3;


