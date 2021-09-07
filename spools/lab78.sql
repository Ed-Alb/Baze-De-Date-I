-- daca zice initalization in progress ma conectez cu sys as sys dba
-- parola mea si apoi conect scott si bag parola tiger.

-- Laborator 7: Functii Sql + Functii de grup!!

select to_char(sysdate,'dd-mm-yyyy') "Data Curenta"
from dual;

select to_date('15112006', 'dd-mm-yyyy') data_ex
from dual;

select to_char (-11, '$999999.99MI') valoare
from dual;

select to_number ('$10000.00-', '$999999.99MI') valoare
from dual;



-- Să se selecteze toți angajații care au venit în firmă în 1982.

select nume, to_char (data_ang, 'dd-mm-yyyy') data_ang
from angajati
where to_char(data_ang, 'yyyy') like '1982';

select nume, to_char (data_ang, 'dd-mm-yyyy') data_ang
from angajati
where to_date(to_char(data_ang, 'yyyy'), 'yyyy') = to_date(to_char(1982), 'yyyy');

select nume, to_char (data_ang, 'dd-mm-yyyy') data_ang
from angajati
where to_number(to_char(data_ang, 'yyyy')) = 1982;



column numar format 99999
select 123.14 numar from dual;
select 0.14 numar from dual;

column numar format 999.99
select 123.14 numar from dual;

column numar format $999.99
select 123.14 numar from dual;

column numar format 00999.99
select 123.14 numar from dual;
select 0.14 numar from dual;

column numar format 9990.99
select 123.14 numar from dual;
select 0.14 numar from dual;

column numar format 09990.99
select 123.14 numar from dual;
select 0.14 numar from dual;

column numar format 999,999,999.99
select 123123123.14 numar from dual;

column numar format 999.99MI
select -123.14 numar from dual;

column numar format 999.99PR
select -123.14 numar from dual;
select 123.14 numar from dual;

column numar format 999.99EEEE
select 123.14 numar from dual;

column numar format B99999.99
select 123 numar from dual;

column numar format 99999D00
select 123.1 numar from dual;
select 0.14 numar from dual;

select greatest(23, 12, 34, 77, 89, 52) gr
from dual;

select least(23, 12, 34, 77, 89, 52) lst
from dual;

select greatest('15-JAN-1985', '23-AUG-2001') gr
from dual;

select least('15-JAN-1985', '23-AUG-2001') lst
from dual;

-- DECODE

select nume, functie, salariu,
	decode (functie, 'MANAGER', salariu * 1.25,
					 'ANALYST', salariu * 1.24,
					 salariu/4) "Prima"
from angajati
where id_dep = 20
order by functie;

select nume, functie, salariu,
	to_char(data_ang, 'yyyy') "An angajare",
	decode (sign(data_ang - to_date('1-JAN=1982')),
					 -1, salariu * 1.25,
					 salariu * 1.10) "Prima"
from angajati
where id_dep = 20
order by functie;

-- CASE - folosita in select sau where
select nume
from angajati
where id_ang = (case functie
					when 'SALESMAN' then 7844
					when 'CLERK' then 7900
					when 'ANALYST' then 7902
					else 7839
				end);
				
select nume
from angajati
where id_ang = (case
		when functie = 'SALESMAN' then 7844
		when functie = 'CLERK' then 7900
		when functie = 'ANALYST' then 7902
		else 7839
	end);
	
	
set null NULL
select nume, comision, nvl(comision, 0) nvl_com,
	salariu + comision "Sal + Com",
	salariu + nvl(comision, 0) "Sal + NVL_COM"
from angajati
where id_dep = 30;
set null ''

SELECT USER FROM dual;

-- Functii de Grup

select avg(salariu) salariu from angajati;
select avg(all salariu) salariu from angajati;
select avg(distinct salariu) salariu from angajati;

-- Să se calculeze salariul mediu pentru fiecare departament.
select id_dep , avg(salariu)
from angajati
group by id_dep
order by 1;

-- Să se calculeze venitul lunar mediu pentru fiecare departament.
-- Afișati id_dep și venitul lunar doar pentru departamentele care
-- au venitul lunar mediu mai mare de 2000. Pentru a aplica o
-- condiție bazată pe funcții de agregare, folosim HAVING în loc de WHERE.

select id_dep, avg(salariu + nvl(comision, 0)) "Venit_Lunar"
from angajati
group by id_dep
having avg(salariu + nvl(comision, 0)) > 2000;

-- Să se afișeze numărul angajatilor care au primit salariu pentru
-- fiecare departament.
select id_dep, count(*) nr_ang,
	count (salariu) count,
	count (all salariu) count_all,
	count (distinct salariu) count_distinct
from angajati
group by id_dep
order by 1;

-- Să se afișeze departamentele care au cel puțin două funcții
-- distincte pentru angajați.
select id_dep,
	count (functie) count,
	count (distinct functie) count_distinct
from angajati
group by id_dep
having count (distinct functie) >= 2
order by 1;

-- Să se afișeze salariul minim, maxim și suma slariilor pentru
-- fiecare departament.
select d.den_dep,
	min(a.salariu) sal_min,
	min(distinct a.salariu) sal_min_d,
	max(a.salariu) sal_max,
	max(distinct a.salariu) sal_max_d,
	sum(a.salariu) sal_sum,
	sum(distinct a.salariu) sal_sum_d
from angajati a natural join departamente d
group by d.den_dep
order by d.den_dep;

select id_dep,
	min(salariu) sal_min,
	min(distinct salariu) sal_min_d,
	max(salariu) sal_max,
	max(distinct salariu) sal_max_d,
	sum(salariu) sal_sum,
	sum(distinct salariu) sal_sum_d
from angajati
group by id_dep
order by id_dep;

select id_dep,
	variance(salariu) sal_varstd,
	variance(distinct salariu) sal_varstd_d,
	STDDEV(salariu) sal_devstd,
	STDDEV(distinct salariu) sal_devstd_d,
	stddev(comision) com_devstd
from angajati
group by id_dep
order by 1;



-- Laborator 8 - Subcereri

-- Subcereri necorelate care întorc o valoare în clauza WHERE

-- Să se selecteze angajatul cu cel mai mare salariu din firmă.
select id_dep, nume, functie, salariu
from angajati
where salariu = (select max(salariu) from angajati);

-- Subcereri necorelate care întorc o coloană în clauza WHERE

-- Să se selecteze angajații care au funcții similare funcțiilor
-- din departamentul 20 și nu lucrează în acest departament.
select id_dep, nume, functie, salariu
from angajati
where
	id_dep <> 20 AND
	functie in (select functie from angajati where id_dep = 20);
	
select id_dep, nume, functie, salariu
from angajati
where
	NOT id_dep = 20 AND
	functie in (select functie from angajati where id_dep = 20);
	
-- Să se selecteze angajații care nu s-au angajat în lunile
-- decembrie, ianuarie și februarie.
select id_dep, nume, functie, data_ang
from angajati
where
	to_date(data_ang, 'mm') not in ('DEC', 'JAN', 'FEB');
	
select id_dep, nume, functie, data_ang
from angajati
where
	to_char(data_ang, 'MON') not in ('DEC', 'JAN', 'FEB')
order by nume;

-- select to_char(sysdate,'mon') "Data Curenta"
-- from dual;

select id_dep, nume, functie, data_ang
from angajati
where
	data_ang not in (select distinct(data_ang)
					 from angajati
					 where to_char(data_ang, 'MON') IN
					 ('DEC', 'JAN', 'FEB'))
order by nume;

-- Să se selecteze angajații care au salariile in lista
-- de salarii maxime pe departament.
select id_dep, nume, functie
from angajati
where
	salariu in (select max(salariu) from angajati group by id_dep)
order by id_dep;

-- Subcereri necorelate care întorc o linie în clauza WHERE

-- Să se selecteze angajații care au venit în același an și
-- au aceeași funcție cu angajatul care are numele JONES.
select id_dep, nume, functie, data_ang
from angajati
where (to_char(data_ang, 'yyyy'), functie) 
	IN (select to_char(data_ang, 'yyyy'), functie 
		from angajati
		where
			lower(nume) = 'jones');
			
-- Subcereri necorelate care întorc mai multe linii în clauza WHERE

-- Să se afișeze angajatii care au venitul lunar minim pe fiecare departament.
select id_dep, nume, salariu
from angajati
where (id_dep, salariu+nvl(comision, 0)) in
	(select id_dep, min(salariu + nvl(comision, 0))
		from angajati
		group by id_dep)
order by id_dep;

select id_dep, min(salariu + nvl(comision, 0)) venit_lunar
from angajati
group by id_dep
order by id_dep;

-- Să se afișeze angajații care au salariul mai mare decât salariul
-- maxim din departamentul SALES.
select id_dep, nume, salariu
from angajati
where salariu >
	(select max(salariu)
		from angajati
		where id_dep = (select id_dep 
						from departamente
						where den_dep like 'SALES'))
order by id_dep;

-- Subcereri corelate în clauze WHERE
-- Să se afișeze angajații care au salariul peste valoare media a
-- departamentului din care fac parte.
select a.id_dep, a.nume, a.functie, a.salariu
from angajati a
where
	a.salariu >
		(select avg(b.salariu) from angajati b where b.id_dep = a.id_dep)
order by 1;

-- Să se mărească salariile angajaților cu 10% din salariul mediu
-- și să se acorde tuturor angajaților un comision egal cu comisionul
-- mediu pe fiecare departament, numai pentru persoanele angajate
-- înainte de 1-JUN-1981.
--update angajati a
--set (a.salariu, a.comision) = 
--	(select a.salariu + avg(b.salariu)*0.1, avg(b.comision)
--	 from angajati b
--	 where b.id_dep = a.id_dep)
--where data_and <= '1-JUN-81';

-- Subcereri pe tabelă temporară (în clauza FROM)

-- Să se afle salariul maxim pentru fiecare departament.
select b.id_dep, a.den_dep, b.max_sal_dep
from departamente a, (select id_dep, max(salariu) max_sal_dep
					  from angajati
					  group by id_dep) b
where a.id_dep = b.id_dep
order by b.id_dep;

select b.id_dep, a.den_dep, b.max_sal_dep
from departamente a INNER JOIN 
	(select id_dep, max(salariu) max_sal_dep
	 from angajati
	 group by id_dep) b on a.id_dep = b.id_dep
order by b.id_dep;

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
HAVING COUNT(C.EMPNO) >=3;

