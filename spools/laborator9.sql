-- Test nr 3: De repetat functii, functii de grup, CASE, DECODE
-- de repetat inclusiv laboratorul nr 6, functii. De repetat functiile care se pot utiliza alternativ

---- exersare pt test nr 3: subiect nr 1
-- Sa se afiseze, pentru fiecare angajat care face parte dintr-un departament cu cel putin 4 angajati 
-- si care are un venit peste media veniturilor din firma, 
-- daca castiga mai mult decat seful sau direct (DA sau NU).
-- Se va afisa o lista antetul :
-- Angajatul, Departamentul, Venit angajat, Mai mult decat sef
-- Se va utiliza, pentru testare, baza de date formata din tabelele EMP, DEPT si SALGRADE.
-- Se va rezolva in doua moduri, utilizand functii diverse SQL.

---- exersare pt test nr 3: subiect nr 2
-- Sa se afiseze, pentru toti angajatii departamentului SALES, o lista care sa contina o apreciere a venitului anual al angajatului 
-- precum si numarul de subordonati direct ai angajatului respectiv. 
-- Aprecierea venitului anual se va face astfel :
-- Daca venitul anual este <= 12000, atunci venitul anual este SCAZUT
-- Daca venitul anual este intre 12001 si 22000, atunci venitul anual este MEDIU
-- Daca venitul anual este peste 22000, atunci venitul anual este RIDICAT
-- 
-- Lista va afisa si angajatii care nu au subordonati.
-- Antetul listei este urmatorul:
-- Nume_angajat,  Venit_anual, Apreciere_venit, Nr_subordonati
-- Se se rezolve prin doua metode (scripturi) distincte folosind diverse functii SQL.
-- Se va utiliza, pentru testare, baza de date formata din tabelele EMP, DEPT si SALGRADE

----------------------------------------------------------------------------
-- Subcereri pe clauza HAVING
----------------------------------------------------------------------------

-- Clauza Having poate fi folosită și într-o subcerere pe tabela temporală.
-- Nu trebuie uitat ca functiile de grup pot fi imbricate.

-- Tipul de enunturi: '...cu cei mai multi'

-- selectati numarul de angajati din fiecare departament
select dname, count(*)
from emp a join dept b on a.deptno = b.deptno
group by dname;

-- departamentul cu cei mai multi angajati
select dname, count(*)
from emp a join dept b on a.deptno = b.deptno
group by dname
having count(*) = 
	(select max(count(*))
	 from emp c
	 group by c.deptno);
	 
-- Sa se afiseze anul in care s-au angajat cei mai multi salariati
-- in firma, afisand si numarul celor angajati in acel an

select extract (YEAR from a.hiredate) anul, count(*)
from emp a
GROUP BY extract (YEAR FROM A.HIREDATE)
having count(*) = 
	( SELECT MAX(COUNT(*))
      FROM EMP B
	  GROUP BY    EXTRACT (YEAR FROM B.HIREDATE));
	  
	  
-- Sa se selecteze departamentul in care s-au angajat cei mai multi angajati
-- in acelasi an. 
-- Nu veti tine cont de anul 1981. 
-- Veti afisa: denumirea departamentului, anul angajarii si numarul de angajati
-- ce au venit in departament in acel an
select a.dname, extract(year from b.hiredate), count(*)
from emp b, dept a
where
a.deptno = b.deptno
and 
extract(year from b.hiredate) != 1981
group by a.dname, extract(year from b.hiredate)
having count(*) = (select max(count(*))
                             from emp c
                             where 
                              extract(year from c.hiredate) != 1981
                             group by  c.deptno, extract(year from c.hiredate));
							 
----------------------------------------------------------------------------
-- Subcereri pe clauza SELECT
----------------------------------------------------------------------------
-- Aceste subcereri pot fi necorelate , sau corelate dar trebuie să returneze
-- întotdeauna o singură valoare.
-- EXEMPLU SUBCERERE NECORELATA IN CLAUZA SELECT

-- Sa se selecteze, pentru fiecare angajat al carui nume nu se termina cu ES,
-- care are acelasi grad salarial cu SCOTT:
-- Numele, salariul, gradul salarial, salariul maxim din firma

-- VARIANTA CU SUBCERERE IN SELECT --> INTOARCE O SINGURA VALOARE
SELECT A.ENAME, A.SAL, (SELECT MAX(B.SAL) FROM EMP B) SALMAX
FROM EMP A JOIN SALGRADE C ON A.SAL BETWEEN C.LOSAL AND C.HISAL
WHERE
SUBSTR(A.ENAME, -2) !='ES'
AND
C.GRADE = ( SELECT E.GRADE 
            FROM EMP D JOIN SALGRADE E ON D.SAL BETWEEN E.LOSAL AND E.HISAL
            WHERE
                  D.ENAME='SCOTT'
  ) ;
  
-- REFORMULARE CU SUBCERERE IN FROM -- TABELA TEMPORARA
SELECT A.ENAME, A.SAL,  X.SALMAX
FROM EMP A JOIN SALGRADE C ON A.SAL BETWEEN C.LOSAL AND C.HISAL,
 (SELECT MAX(B.SAL) SALMAX FROM EMP B) X
WHERE
SUBSTR(A.ENAME, -2) !='ES'
AND
C.GRADE = ( SELECT E.GRADE 
            FROM EMP D JOIN SALGRADE E ON D.SAL BETWEEN E.LOSAL AND E.HISAL
            WHERE
                  D.ENAME='SCOTT'
  ) ;
  
-- REFORMULARE CU TOATE SUBCERERILE IN FROM -- TABELE TEMPORARE
SELECT A.ENAME, A.SAL,  X.SALMAX
FROM EMP A JOIN SALGRADE C ON A.SAL BETWEEN C.LOSAL AND C.HISAL,
 (SELECT MAX(B.SAL) SALMAX FROM EMP B) X,
 ( SELECT E.GRADE 
            FROM EMP D JOIN SALGRADE E ON D.SAL BETWEEN E.LOSAL AND E.HISAL
            WHERE
                  D.ENAME='SCOTT'
  ) Y
WHERE
SUBSTR(A.ENAME, -2) !='ES'
AND
C.GRADE = Y.GRADE;

-- EXEMPLU SUBCERERE CORELATA IN CLAUZA SELECT
-- Sa se selecteze, pentru fiecare angajat: numele, denumirea departamentului
-- si numarul de angajati din departamentul sau
SELECT A.ENAME, B.DNAME, 
	(SELECT COUNT(*) NRANG FROM EMP C WHERE C.DEPTNO=A.DEPTNO) NRANG
FROM EMP A JOIN DEPT B ON A.DEPTNO=B.DEPTNO;


-- DE REFORMULAT PRIN SUBCERERE IN CLAUZA FROM
-- NU SE POATE CORELA O SUBCERERE IN FROM

SELECT A.ENAME, B.DNAME, COUNT(C.EMPNO)
FROM EMP A JOIN DEPT B ON A.DEPTNO=B.DEPTNO, (SELECT EMPNO, DEPTNO FROM EMP ) C
WHERE
C.DEPTNO = B.DEPTNO
GROUP BY A.ENAME, B.DNAME;

----------------------------------------------------------------------------
-- Subcereri pe clauza ORDER BY
----------------------------------------------------------------------------
-- o sugestie de utilizare: cand dorim sa sortam dupa numarul de inregistrari
-- dintr-un grup anume

-- Sa se selecteze toti angajatii din firma, sortati descrescator dupa dimensiunea
-- departamentelor lor
SELECT  A.ENAME
FROM EMP A
ORDER BY (select count(*) from dept b
          where b.deptno=a.deptno
            ) DESC;

-- Operatori în subcereri
-- Operatorii prezentați pentru cereri sunt valabili și pentru subcereri
-- Operatorul [NOT] EXISTS este folosit adesea în subcereri corelate și
-- testează dacă 
-- subcererea returnează cel puțin o valoare, pentru EXISTS, sau niciuna,
-- în cazul lui NOT EXISTS, returnând TRUE sau FALSE.


-- Sa se selecteze toti sefii angajatilor din firma
SELECT A.ENAME 
FROM EMP A
WHERE
  EXISTS( SELECT B.ENAME FROM EMP B WHERE B.MGR=A.EMPNO );


SELECT A.ENAME 
FROM EMP A
WHERE
  0 < ( SELECT COUNT(*) FROM EMP B WHERE B.MGR=A.EMPNO );


-- SA SE SELECTEZE TOATE DEPARTAMENTELE CARE nu AU ANGAJATI IN GRADELE 4 SI 5

select a.dname
from
dept a
where
not exists (select * 
            from emp b join salgrade c on b.sal between c.losal and c.hisal 
            where 
               b.deptno=a.deptno 
               and
               c.grade in (4, 5) );
