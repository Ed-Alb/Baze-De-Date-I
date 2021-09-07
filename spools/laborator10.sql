-- Crearea tabelelor
-- cateva reguli:
-- Userul trebuie să aibă drepturi de crearea a unei tabele.
-- Numele trebuie să fie unic în contul în care se creeaza și nu este case sentitive.
-- Numele trebuie să aibă maxim 30 de caractere continue, să înceapă cu o literă și
-- să nu fie cuvânt rezervat Oracle.
-- Structura tabelelor poate fi modificată și ulterior (prin adăugarea sau ștergerea
-- coloanelor, constrângerilor, indecși, etc.).

-------------------------------------------------
-- Crearea unei tabele indicand structura acesteia
-------------------------------------------------
create table firme
(
id_firma number(3),
den_firma varchar2(20),
constraint pk_firme primary key(id_firma)
);

-- Principalele tipuri de constrangeri:
-- NOT NULL - înregistrările nu pot conține valori nule
-- UNIQUE - definește o cheie unică pe una sau mai multe coloane (nu pot fi mai multe
-- înregistrări cu aceleași valori pe coloanele respective
-- PRIMARY KEY - definește o cheie primară la nivel de coloană sau tabelă (nu pot fi
-- mai multe înregistrări cu aceeași cheie primară)
-- FOREIGN KEY - definește o cheie externă (tabela se relaționează cu altă tabelă pe
-- o cheie unică sau cheie primară)

CREATE TABLE ANGAJATI_NOI
(
ID_ANG NUMBER(3),
NUME_ANG VARCHAR2(30),
FUNCTIE_ANG VARCHAR2(30),
SAL NUMBER,
COMM NUMBER,
ID_FIRMA number(3),
CONSTRAINT PK_ANGAJATI_NOI PRIMARY KEY(ID_ANG),
CONSTRAINT FK_ANGAJATI_NOI_FIRME FOREIGN KEY (ID_FIRMA)
REFERENCING FIRME(ID_FIRMA) ON DELETE CASCADE
);

-- Opțiunea ON DELETE CASCADE
-- Pentru a putea șterge în tabela de referință linii referite în alte tabele
-- se folosește opțiunea ON DELETE CASCADE. 
-- În acest caz, când se șterge o linie în tabela de referință se vor șterge
-- toate liniile din tabelele relaționate 
-- care sunt în relație cu linia respectivă

DROP TABLE ANGAJATI_NOI;

desc firme

-- Modificarea unei tabele - comanda ALTER TABLE
alter table firme
add
(nr_angajati NUMBER(4));

alter table firme
drop constraint pk_firme;

desc firme

DROP TABLE FIRME  CASCADE CONSTRAINTS;

--------------------------------------------
-- Crearea unei tabele printr-o cerere select
--------------------------------------------

-- Mai intai se executa SELECT-ul, apoi se creaza tabela pe structura setului de date
-- intors de SELECT


-- Sa se creeze o tabela, denumita ULTIMII_VENITI cu toti angajatii care au venit
-- in firma ultimii din departamentul lor. Structura tabelei este urmatoarea :
-- Nume_angajat, Den_departament, Data_angajare, Ani_vechime
-- Nu vor intra in calcul cei care s-au angajat intr-o luna de primavara.
-- Vechimea se va calcula ca si numar natural.
-- Se va utiliza, pentru testare, baza de date formata din tabelele EMP, DEPT si
-- SALGRADE.

select a.ename Nume_angajat, b.dname Den_departament, a.hiredate,
	   trunc(months_between(sysdate, a.hiredate)/12) Ani_vechime
from emp a join dept b on a.deptno = b.deptno
where extract(month from a.hiredate) not in (3,4,5)
	AND 0 = (
		select count(*)
		from emp c
		where a.hiredate <c.hiredate
			AND extract(month from c.hiredate) not in (3,4,5)
			AND a.deptno=c.deptno
		);
		
create table ultimii_veniti as (
	select a.ename Nume_angajat, b.dname Den_departament, a.hiredate,
	   trunc(months_between(sysdate, a.hiredate)/12) Ani_vechime
from emp a join dept b on a.deptno = b.deptno
where extract(month from a.hiredate) not in (3,4,5)
	AND 0 = (
		select count(*)
		from emp c
		where a.hiredate < c.hiredate
			AND extract(month from c.hiredate) not in (3,4,5)
			AND a.deptno=c.deptno
		)
);

desc ultimii_veniti
select * from ultimii_veniti;
drop table ultimii_veniti;


----- Exemplu subiect colocviu
--Sa se creeze o tabela denumita ANG_BLAKE care sa contina toti angajatii
-- din departamentul sefului cu cei mai multi subordonati. Structura tabelei
-- este urmatoarea :
--Nume_angajat, Den_departament, An_angajare, Venit, Ani_vechime
--Vechimea se va calcula ca si numar natural.
--Se va utiliza, pentru testare, baza de date formata din tabelele EMP, DEPT
-- si SALGRADE.

select b.mgr
from emp b
group by b.mgr
having count(*) = (select max(count(*)) from emp c group by c.mgr);

select a.deptno
from emp a
where
a.empno in (select b.mgr
            from emp b
            group by b.mgr
            having count(*) = (select max(count(*)) from emp c group by c.mgr)
            );
			
select x.ename Nume_angajat, 
	   e.dname Den_departament, 
	   extract (YEAR from x.hiredate) An_angajare, 
		x.sal+nvl(x.comm, 0) Venit,
	   trunc((sysdate-x.hiredate)/365) Ani_vechime
from emp x, dept e
where e.deptno=x.deptno
	AND x.deptno in (
		select a.deptno
		from emp a
		where
		a.empno in (select b.mgr
					from emp b
					group by b.mgr
					having count(*) = (select max(count(*)) from emp c group by c.mgr)
					));
					
create table ang_blake as 
(select 
x.ename Nume_angajat, 
e.dname Den_departament, 
extract (YEAR from x.hiredate) An_angajare, 
x.sal+nvl(x.comm, 0) Venit,
 trunc((sysdate-x.hiredate)/365) Ani_vechime
from emp x, dept e
where
e.deptno=x.deptno
and
x.deptno in (
select a.deptno
from emp a
where
a.empno in (select b.mgr
            from emp b
            group by b.mgr
            having count(*) = (select max(count(*)) from emp c group by c.mgr)
            ))
);

select * from ang_blake;
drop table ang_blake;


--------------------------
-- VIEW ------------------
--------------------------
-- O vedere este o tabelă logică care extrage date dintr-o tabelă propriu-zisă
-- sau dintr-o alta vedere. 
-- O vedere nu are date proprii, ci este ca o fereastră prin care datele din
-- tabele pot fi actualizate sau vizualizate.

CREATE OR REPLACE VIEW EMP_SALE
AS
SELECT A.EMPNO, A.ENAME, A.DEPTNO
FROM EMP A
WHERE
A.DEPTNO IN (
              SELECT B.DEPTNO 
              FROM DEPT B
              WHERE
                B.DNAME LIKE 'SALES'
            );



-- Pe un VIEW care extrage date dintr-o singură tabelă se pot utiliza comenzile
-- INSERT, UPDATE, DELETE. 
-- Dacă VIEW-UL extrage informații din mai multe tebele atunci comenzile INSERT,
-- UPDATE, DELETE nu se pot folosi.
--------------------------
-- delete from vs truncate, commit, rollback
--------------------------
-- TRUNCATE este mai rapida, este o comanda definitiva, nu se mai pot face
-- ROLLBACK datele sterse DELETE FROM poate fi facuta ROLLBACK
commit;
rollback;

delete from emp;

select * from emp;

rollback;

select * from emp;

SELECT * FROM EMP_SALE;


DROP VIEW EMP_SALE;

--------------------------
-- Useri, roluri, schema
--------------------------

create role contabil;

grant insert, select, delete on emp to contabil;

create user contab1 identified by parolacontab1;

grant contabil1 to contab1;

create user contab2 identified by parolacontab2;

grant contabil1 to contab2

drop user contab2;
