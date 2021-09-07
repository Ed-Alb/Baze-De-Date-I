-- la exercitiile cu creare de tabela
-- de pus si select * from tabela sau din view
-- si drop table sau view

-- -- Subiect pentru pregatirea colocviului (fara rezolvare propusa):
-- Sa se creeze o tabela denumita ANGAJATI_GRAD_ALLEN continand primii doi
-- angajati, ca marime a veniturilor lor, ce fac parte din acelasi grad
-- salarial cu ALLEN.

-- Se va afisa : Nume angajat, Venit, Grad salarial
-- Se va utiliza baza de date a userului SCOTT, formata din tabelele EMP, DEPT, SALGRADE.
-- Includeti si selectarea inregistrarilor din tabela creata precum si stergerea tabelei

-- Pas 1: Selectare angajati din acelasi grad salarial cu ALLEN
SELECT A.ENAME "Nume angajat", A.SAL + NVL(A.COMM, 0) Venit, B.GRADE
FROM EMP A JOIN SALGRADE B ON A.SAL BETWEEN B.LOSAL AND B.HISAL
WHERE
B.GRADE=( SELECT D.GRADE 
          FROM EMP C JOIN SALGRADE D ON C.SAL BETWEEN D.LOSAL AND D.HISAL
          WHERE 
            C.ENAME='ALLEN'
        );
		
-- Pas 2: Selectarea primelor doua venituri din lista de mai sus
-- se verifica cati angajati au salariul mai mare decat al unuia
-- de aia 0 >= e cand niciunul nu are salariu mai mare si 1 >=
-- e pentru primii 2 (al doilea are 1 singur angajat cu salariu mai mare)

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

-- Pas 3: Crearea tabelei, select, drop
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
          F.GRADE=( SELECT GRADE 
          FROM EMP  JOIN SALGRADE  ON SAL BETWEEN LOSAL AND HISAL
          WHERE 
            ENAME='ALLEN'
        )
        AND 
        E.SAL + NVL(E.COMM, 0) > A.SAL + NVL(A.COMM, 0)
       )
);

SELECT * FROM ANGAJATI_GRAD_ALLEN;

DROP TABLE ANGAJATI_GRAD_ALLEN;

-------------------------------
-- EXEMPLIFICARE ROLURI, USERI ---
-------------------------------
CONNECT sys as sysdba

-- introducere parola
alter session set "_ORACLE_SCRIPT"=true;

CREATE ROLE rol_contabil;
grant insert, delete, select on scott.emp to rol_contabil;

grant select, insert on scott.dept to rol_contabil;

revoke insert on scott.dept from rol_contabil;

CREATE USER user1 identified by user1;
GRANT CREATE SESSION TO user1;

GRANT rol_contabil to user1;

conn user1/user1

select * from SCOTT.dept;
insert into SCOTT.dept values (60, 'TEST', 'TESTLOC');

conn sys as sysdba
alter session set "_ORACLE_SCRIPT"=true;
drop user user1;

drop role rol_contabil;


conn scott/tiger

-----------------------------------------
-- Comenzile SQL*Plus
-----------------------------------------


-- Editarea, memorarea și executarea comenzilor SQL
-- Efectuarea de calcule, formatarea datelor de ieșire și printarea
-- listelor
-- Listarea structurii obiectelor din baza de date
-- Accesul și transferul datelor între baze de date
-- Interceptarea și interpretarea mesajelor de eroare


----------------------------------
-- Comanda SET
----------------------------------
-- Este folosită pentru setarea și activarea/dezactivarea anumitor
-- parametri specifici sesiunii curente
-- Acești parametri au valori implicite la deschiderea unei sesiuni
-- în SQL*Plus, dar sunt situații când unii 
-- trebuie modificați conform cerințelor utilizatorului și la terminarea
-- sesiunii revin la valorile implicite.

-- FEED[BACK] {6|n|OFF|ON afișează numărul de înregistrări returnate de
-- un query când sunt returnate cel puțin n înregistrări, valoarea implicită este 6
-- TIMING on/off afiseaza timpul in care s-a executat o comanda SQL, daca
-- e pusa pe on
-- SPA[CE] n	setează numărul de spații dintre coloane in timpul
-- afisarii (valoarea implicită este 1, valoarea maxima pentru n este 10)
-- NUM[WIDTH] n	setează lungimea implicită pentru afișarea valorilor
-- numerice, valoarea implicită este 10

set timing on
select * from emp, dept;
set timing off

select ename, empno from emp;

set space 6
select ename, empno from emp;
set space 1

----------------------------
-- Formatarea listelor output ale comenzilor SELECT 
----------------------------

----------------
-- Comanda COLUMN - este folosită pentru definirea și formatarea coloanelor de ieșire.
----------------
-- Parametri:
-- FOR[MAT] format	specifică formatul de afisare An pentru coloane alfanumerice sau unul din formatele numerice
-- HEA[DING] text	definește antetul coloanei
-- JUS[TIFY] L[EFT]|C[ENTER]|R[IGHT]	specifică alinierea antetului (implicit dreapta pentru coloane numerice și stânga pentru celelalte tipuri)
COLUMN SAL FORMAT 00999 HEADING 'Salariu'

select ename, sal from emp;
select sal, comm from emp;

clear columns;

-----------------
--Comenzile TITLE si BTITLE
-----------------
-- Comanda TTITLE se folosește pentru formatarea titlui de început al unui raport.
-- Comanda BTITLE se folosește pentru formatarea titlui de sfârșit al unui raport.
-- parametri
-- LEFT 	se poziționează articolul care urmează acestei opțiuni în partea stângă a liniei. Dacă nu mai există nicio opțiune de aliniere în comandă, toate articolele vor fi aliniate în ordinea apariției în partea stângă, altfel se aliniază numai cele care apar pana la urmatoarea opțiune
-- CENTER	în acest caz, poziționarea se face central și se ia în calcul lungimea liniei setată cu LINESIZE
-- RIGHT	similar cu opțiunea de mai sus, dar poziționarea se face la dreapta
-- BOLD	se specifică ca afișarea să se facă folosind caractere îngroșate
-- la final btittle off si ttitle off

ttitle 'Titlu raport sus' center underline
btitle 'Incheiere pagina raport'

select ename, sal from emp;

ttitle off
btitle off


------------------------
-- Comenzile BREAK si COMPUTE
-- Comanda BREAK este folosită pentru fragmentarea unui raport în mai multe segmente
-- Comanda COMPUTE execută anumite calcule pe segmentele respective
-- Comanda BREAK (care face o fragmentare) are următoarea sintaxă:
--BRE[AK] [ON report_element [action [action]]] …
-- Calculele care se pot face cu comanda COMPUTE sunt:
-- Operatie	Descriere operatie
-- AVG	calcul medie (pentru date de tip number)
-- COU[NT]	numără valorile nenule (pentru orice tip de date)
-- MAX[IMUM]	valoare maximă (pentru date de tip number și char)
-- MIN[IMUM]	valoare minimă (pentru date de tip number și char)
-- NUM[BER]	numără rânduri (pentru orice tip de data)
-- STD	calcul deviație standard pentru valori nenule (pentru date de tip number)
-- SUM	calcul suma pentru valori nenule (pentru date de tip number)
-- VAR[IANCE]	calcul variație (pentru date de tip number)
--- NU UITATI SA INCLUDETI ORDER BY!!!!

TTITLE right 'Nr. pag' sql.pno center 'Angajati pe departamente'
BTITLE 'Final pagina raport'
COLUMN ENAME format a20 heading 'Nume'
COLUMN SAL heading 'Salariul'

BREAK ON DNAME NODUP ON REPORT
COMPUTE SUM OF SAL ON DNAME SKIP 2 REPORT

SELECT A.ENAME, B.DNAME, A.SAL
FROM EMP A JOIN DEPT B
     ON A.DEPTNO=B.DEPTNO
ORDER BY B.DNAME, A.SAL DESC;



SELECT A.ENAME, B.DNAME, A.SAL
FROM EMP A JOIN DEPT B
     ON A.DEPTNO=B.DEPTNO
ORDER BY B.DNAME, A.SAL DESC;

TTITLE OFF
BTITLE OFF
CLEAR BREAK
CLEAR COMPUTE
CLEAR COLUMNS


-- Ex 1:
-- Să se seteze pagina de afișare la 120 caractere pe linie, 24 de
-- linii pe pagină, un spațiu de 2 caractere între coloanele de afișare,
-- salt de 5 linii între pagini, afișare să se facă fără antetul de
-- coloană și fără a specifica numărul de înregistrări returnate de
-- interogare.

set lines 120
set pagesize 24
set space 2
set newpage 5
set heading off
set feedback off

-- Ex 2:
-- Să se listeze id_dep, functie, id_ang, salariu, comision și venitul
-- lunar pentru anajații din departamentul 30. Formatați coloanele.
column id_dep format 099 heading 'Departament' justify center
column functie format A10 heading 'Job' justify left
column id_ang format 9999 heading 'Ecuson' justify center
column salariu format 99,999
column comision format 99,999.99 null 0
column venit format 99,999.99 heading 'Venit Lunar'

select id_dep, functie, id_ang, salariu,
	   comision, salariu + nvl(comision,0) venit
from angajati
where id_dep = 30;

-- Ex 3:
-- Să se creeze un raport care afișează id_ang, nume, functie,
-- data_ang și salariu pentru angajații din departamentul 20.

set lines 80
set pagesize 20
column A format 9999 heading 'Ecuson' justify center
column B format A20 heading 'Nume Angajat'
column C format A10 heading 'Job' justify left
column D format A14 heading 'Data Angajare' justify center
column E format 99,999.00 heading 'Salariu'

ttitle left 'Pag:' sql.pno center underline 'Lista Angajati'
btitle right 'DIRECTOR'

select id_ang A, nume B, functie C, data_ang D, salariu E
from angajati
where id_dep = 20;

TTITLE OFF
BTITLE OFF


-- Ex 4:
-- Sa se faca un raport care să conțină numele departamentului, numele
-- angajaților, funcția și salariul. Să se calculeze salariu total pe
-- fiecare departament și salariul total pe firma.

set pages 30
column den_dep heading 'Departament'
column name format a25 heading 'Nume Angajat'
column functie format a15 heading 'Job' justify left
column salariu format 99,999 heading 'Salariu'

ttitle left 'Pag:' sql.pno center underline 'Lista Angajati'
btitle right 'DIRECTOR'

break on den_dep noduplicates on report
compute sum of salariu on den_dep skip 1 report

select d.den_dep, a.nume, a.functie, a.salariu
from angajati a inner join departamente d on a.id_dep = d.id_dep
order by a.id_dep;

TTITLE OFF
BTITLE OFF

set heading on
set feedback on
clear column
clear break
clear compute