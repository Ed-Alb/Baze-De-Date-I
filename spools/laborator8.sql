-- Testul nr 3
-- functii de grup, case, decode, subcereri partea 1
-- 2 metode: case vs decode, functii de grup, having,
-- subcereri in where si in from, vs join


------------------------------
--- SUBCERERI ----
------------------------------
-- Subcererile sunt cereri SQL incluse în clauzele SELECT, FROM, WHERE, HAVING și ORDER BY ale altei cereri numită 
-- și cerere principală.

-- Subcereri necorelate: rezultatul subcererii nu este condiționat de valorile din cererea principală
-- Subcereri corelate: rezultatul subcererii este condiționat de valorile din cererea principală

-- Subcererea trebuie să fie inclusă între paranteze;
-- Pentru cazurile în care subcererea se află în clauza WHERE, sau HAVING, aceasta trebuie să fie în 
-- partea dreaptă a condiției;
-- Subcererile nu pot fi ordonate, deci nu conțin clauza ORDER BY
-- Clauza ORDER BY apare la sfârșitul cererii principale.


--------------------------------
-- Subcereri necorelate în clauza WHERE
--------------------------------
-- Subcererile necorelate sunt subcereri care nu au o legătură de asociere între expresiile 
-- cererii exterioare și cele ale cererii interioare.

-- Sa se selecteze, prin JOIN si prin SUBCERERE, pentru fiecare angajat care nu e in SALES
-- si care castiga (VENIT) mai mult decat MARTIN: NUMELE, DENUMIREA DEPARTAMENTULUI, venitul sau
-- JOIN

-- sunt metode alternative (join vs subcereri)
-- dupa studii, cea cu subcereri este optima totusi

select a.ename, b.dname, a.sal + nvl(a.comm,0) VENIT
from emp a, dept b, emp MARTIN
where a.deptno = b.deptno
	  and b.dname not like 'SALES'
	  and MARTIN.ename = 'MARTIN' 
	  and a.sal + nvl(a.comm, 0) > martin.sal + nvl(martin.comm, 0);
	

select martin.sal+nvl(martin.comm, 0)
from emp martin
where
	martin.ename like 'MARTIN';
		 
		 
SELECT A.ENAME, B.DNAME, A.SAL + NVL(A.COMM, 0) VENIT
FROM EMP A, DEPT B
where
	A.DEPTNO=B.DEPTNO
	AND
	B.DNAME NOT LIKE 'SALES'
	AND
	A.SAL  + NVL(A.COMM, 0) > 
    ( 
		select martin.sal+nvl(martin.comm, 0)
		from emp martin
		where martin.ename like 'MARTIN'
    );
	
-- Sa se selecteze angajatul din SALES cu cel mai mare salariu din acest departament

select a.empno, a.sal, b.dname
from emp a join dept b on a.deptno = b.deptno
where
	a.deptno in (
				select c.deptno
				from dept c
				where c.dname = 'SALES'
				)
	and
	a.sal = (
				select max(d.sal)
				from emp d join dept e on e.deptno = d.deptno
				where e.dname = 'SALES'
			);
-- sau in loc de prima subcerere: b.dname = 'SALES'

-- Sa se afiseze, pentru fiecare angajat, ce castiga peste media SALARIILOR DIN FIRMA: numele, salariul, departamentul
SELECT A.ENAME, A.SAL, B.DNAME
FROM EMP A JOIN DEPT B ON A.DEPTNO=B.DEPTNO
WHERE
A.SAL > (SELECT AVG(C.SAL) 
         FROM EMP C);
		 
-- toti angajatii ce au venit in firma dupa allen
select allen.hiredate
from emp allen
where allen.ename like 'ALLEN';
-- mergea si fara aliasuri
SELECT A.ENAME Nume_ang, B.DNAME Nume_dep, A.hiredate Data_ang, A.SAL + NVL(A.COMM, 0) VENIT
FROM EMP A, DEPT B
where
	A.DEPTNO=B.DEPTNO
	AND A.hiredate > 
    ( 
		select allen.hiredate
		from emp allen
		where allen.ename like 'ALLEN'
    );
	
-- TODO: fa-l cu join


---------------------------------------------
-- Subcereri corelate în clauze WHERE
---------------------------------------------
-- Subcererile corelate se execută o singură dată pentru fiecare linie candidat prelucrată de cererea principală. 
-- O subcerere corelată se join-ează cu cererea exterioară prin folosirea unei coloane a cererii exterioare 
-- în clauza predicatului cererii interioare.

-- Sa se afiseze, pentru fiecare angajat ce castiga peste media departamentului sau: numele, salariul, departamentul

SELECT a.ename, a.sal, b.dname
from emp a join dept b on a.deptno = b.deptno
where a.sal + nvl(a.comm, 0) > (SELECT AVG(c.sal + nvl(c.comm, 0)) 
							  FROM EMP c
							  WHERE c.deptno=a.deptno); 

-- Sa se selecteze angajatii care au salariul al n-lea din firma

-- angajatul cu salariul maxim - necorelata
select * from emp a
where sal in (select max(sal) from emp);

-- angajatul cu al doilea salariu
-- subcereri necorelate (nu folosesc a in subcereri)
select * from emp a
where a.sal = (select max(sal) 
			   from emp
               where sal != (select max(sal) from emp)
		      );
			  
-- al 5 lea salariu

select * from emp order by sal desc;

SELECT A.ENAME, A.SAL
FROM EMP A
WHERE
 1 = (SELECT COUNT(distinct sal)
     FROM EMP B
     WHERE
      B.SAL > A.SAL
     );

SELECT A.ENAME, A.SAL
FROM EMP A
WHERE
 4 = (SELECT COUNT(*)
     FROM EMP B
     WHERE
      B.SAL > A.SAL
     );

-- primele 5 salarii
SELECT A.ENAME, A.SAL, rownum
FROM EMP A
WHERE
 4 >= (SELECT COUNT(*)
     FROM EMP B
     WHERE
      B.SAL >A.SAL
     );
-- order by sal desc;

SELECT A.ENAME, A.SAL, rownum
FROM EMP A
WHERE
 rownum <= 5
order by a.sal desc;

-- ROWNUM, order by
-- rownum numara inregistrarile din acel moment

-------------------------------------------
-- Subcereri pe tabelă temporară (în clauza FROM)
-- Aceste subcereri se întâlnesc în cazul în care se folosește o subcerere la nivelul clauzei FROM;
-- În clauza FROM se pot folosi doar subcereri necorelate;
-- Corelarea dintre tabele și tabelele temporare din clauza FROM se face folosind metode de join.
-------------------------------------------
-- SA SE SELECTEZE, PENTRU FIECARE ANGAJAT: NUMELE, GRADUL SALARIAL, SALARIUL ANGAJATULUI SI SALARIUL MAXIM DIN FIRMA

SELECT A.ENAME, B.GRADE, A.SAL, C.SALMAX
from emp A, salgrade B, (select max(sal) SALMAX from emp) C
where A.SAL BETWEEN b.losal and b.hisal;

-- SA SE SELECTEZE, PENTRU FIECARE ANGAJAT CE CASTIGA MAI MULT DECAT BLAKE:
-- NUMELE ANGAJATULUI, SALARIUL, SALARIUL LUI BLAKE, DIFERENTA INTRE SALARIUL SAU SI SALARIUL LUI BLAKE, DENUMIREA DEPARTAMENTULUI LUI BLAKE

SELECT A.ENAME, A.SAL, BLAKE.SAL "SALARIU BLAKE", A.SAL-BLAKE.SAL DIFERENTA, BLAKE.DNAME
FROM EMP A, (SELECT B.SAL, C.DNAME
             FROM EMP B JOIN DEPT C ON B.DEPTNO=C.DEPTNO
             WHERE
               B.ENAME='BLAKE'
            ) BLAKE
WHERE A.SAL > BLAKE.SAL;


-- Exemplu1 subiect Test 3 
-- Sa se afiseze toti angajatii departamentelor RESEARCH sau SALES, care s-au angajat cu cel putin 3 luni dupa seful lor direct, 
-- afisand, pentru fiecare angajat, numarul de luni ce au trecut de la angajarea sefului pana s-au angajat ei, precum si
-- o traducere a denumirii departamentului (CERCETARE sau VANZARI). Se va afisa o lista cu antetul:
-- Nume_angajat, Nume_sef, Data_ang_angajat, Data_ang_sef, Nr_luni_dupa_sef (valoare intreaga), Traducere departament, 
--  Salariul maxim din departamentul respectiv
-- Se se rezolve prin doua metode distincte.

select a.ename "Nume Angajat", s.ename "Nume Sef",
	   a.hiredate "Data Ang Angajat",
	   s.hiredate "Data Ang Sef",
	   round ((a.hiredate - s.hiredate) / 30) "Nr luni dupa sef",
	   case d.dname
		when 'RESEARCH' then 'CERCETARE'
		when 'SALES' then 'VANZARI'
	   end "Traducere departament"
from emp a join emp s on a.mgr = s.empno
		   join dept d on a.deptno = d.deptno
where
	d.dname in ('RESEARCH', 'SALES') and
	(a.hiredate - s.hiredate) / 30 >= 3
order by 1;

select a.ename "Nume Angajat", s.ename "Nume Sef",
	   a.hiredate "Data Ang Angajat",
	   s.hiredate "Data Ang Sef",
	   round(months_between(a.hiredate, s.hiredate)) "Nr luni dupa sef",
	   case d.dname 
		when 'RESEARCH' then 'CERCETARE'
		when 'SALES' then 'VANZARI'
	   end "Traducere departament"
from emp a join emp s on a.mgr = s.empno
		   join dept d on a.deptno = d.deptno
where
	d.dname in ('RESEARCH', 'SALES') and
	months_between(a.hiredate, s.hiredate) >= 3
order by 1;

-- Exemplu 2 subiect Test 3
-- Pentru fiecare angajat ce nu face parte din departamentul angajatului cu cel mai mic salariu, 
-- si nu s-a angajat in luna FEBRUARIE selectati: 
-- numele, denumirea departamentului, numele sefului, luna_angajarii, diferenta dintre venitul sefului si venitul sau, plafonul salarial.
-- Sa se rezolve prin doua metode

SELECT A.ENAME, B.DNAME, C.ENAME, TO_CHAR(A.HIREDATE, 'MM') luna_angajarii, C.SAL+NVL(C.COMM, 0) - A.SAL - NVL(A.COMM, 0) DIF_VENIT, D.GRADE
FROM EMP A, DEPT B, EMP C, SALGRADE D
WHERE
A.DEPTNO = B.DEPTNO
AND
A.MGR= C.EMPNO
AND
A.SAL>=D.LOSAL
AND
A.SAL<=D.HISAL
AND
TO_CHAR(A.HIREDATE, 'MM') != '02'
AND
A.DEPTNO!=(SELECT E.DEPTNO FROM EMP E WHERE E.SAL=(SELECT MIN(SAL) FROM EMP));