-- Test 2: JOIN-uri, UNION, functii SQL
-- 2 metode solicitate. Variatii metode: tipuri de join, functii, 
-- variatiile disponibile si pt testul 1

--- test 2, exemplu subiect
-- Sa se scrie o cerere SQL care face o lista cu toti angajatii care au 
-- acelasi departament cu cel al  sefului direct 
-- si au venit in companie in anul 1981.  Lista se ordoneaza dupa numele
-- subalternilor.  
-- Den depart   Nume angajat   Data angajat   Nume sef   Data sef
-- Se se rezolve folosind doua metode distincte utilizand tipuri de join, 
-- functii, expresii diferite.



------------------------------
-- Functii de conversie
------------------------------
-- TO_CHAR(expr[,format[,’nlsparams’]])	face conversia lui expr
-- (care poate avea tipul fie numeric, fie dată) la VARCHAR2
-- TO_DATE(expr[,format[,’nlsparams’]])	face conversia lui expr
-- (cu tipul CHAR sau VARCHAR2) în formatul DATE
-- TO_NUMBER(expr [,format[,’nlsparams’]])	face conversia lui
-- expr la o valoare de tip NUMBER

-- important: TO_CHAR POATE FI FOLOSIT CA SI VARIATIE LA EXTRACT
-- ( YEAR/MONTH/DAY FROM...)



------------------------------
-- Functii diverse: NVL, DECODE, CASE
------------------------------
-- DECODE(expr, search_1, result_1, search_2, result_2, …, search_n, 
-- result_n, default) – compară expr cu fiecare valoare 
-- search_i și întoarce valoarea result_i dacă expr este egală cu valoarea
-- search_i, dacă nu găsește nicio egalitate întoarce 
-- valoarea default (i=1..n).
-- expr – poate din orice tip de dată
-- search_i – este de același tip ca expr
-- result_i – este valoarea întoarsă și poate fi de orice tip
-- default – este de același tip ca result_i
-- functie de  if-then-else.



-- Sa se calculeze, pentru fiecare angajat din SALES, o prima de 200
-- pentru toti care au EMPNO par si de 300 pentru ceilalti

select a.ename, a.empno, DECODE(MOD(a.empno, 2), 0, 200, 300) PRIMA
from emp a, dept b
where a.deptno = b.deptno AND b.dname = 'SALES';

-- Sa se selecteze toti angajatii ce primesc un comision si au gradul
-- salarial > 1, afisand si un indicator 
-- cu privire la venitul lor (BUN, FOARTE BUN)
-- Daca venitul unui angajat este <=2500, atunci venitul este BUN. 
-- Daca venitul este > 2500, 
-- atunci venitul este FOARTE BUN
-- Lista va fi afisata sub forma:
-- ANGAJAT  COMISION  GRAD SALARIAL VENIT  CALIFICATIV VENIT

select a.ename, a.comm, g.grade, a.sal+nvl(a.comm,0) VENIT,
		decode(sign(a.sal + nvl(a.comm,0)-2500), -1, 'BUN', 0, 'BUN', 'FOARTE BUN')
from emp a, salgrade g
where
	a.sal between g.losal and g.hisal and nvl(a.comm,0) > 0 and g.grade > 1;
	
	
-- Instrucținea CASE poate fi folosită în clauza SELECT sau WHERE. Are doua forme:
-- CASE expr
-- WHEN value1 THEN statements_1
-- WHEN value2 THEN statements_2
-- ...
-- [ELSE statements_k]
-- END

-- Sa se traduca in limba romana joburile angajatilor din EMP
select ename, job,
	case job
         when 'SALESMAN' then 'VANZATOR'
         when 'CLERK' then 'FUNCTIONAR' 
         when 'ANALYST' then 'ANALIST' 
         when 'MANAGER' then 'DIRECTOR' 
         else 'PRESEDINTE'
       end Traducere
from emp;

SELECT a.ENAME ANGAJAT, NVL(a.COMM, 0) COMISION, g.GRADE GRAD_SALARIAL, a.SAL+ NVL(a.COMM, 0) VENIT, 
      case sign(a.SAL+ NVL(a.COMM, 0)-2500)
        when -1  then 'BUN'
        when 0  then 'BUN'
        else 'FOARTE BUN'
      end "Apreciere venit"
FROM EMP a, SALGRADE g
WHERE 
	a.SAL BETWEEN g.LOSAL AND g.HISAL
AND
	NVL(a.COMM, 0) > 0
and 
	g.grade > 1;

	
--- CASE 
-- WHEN expr_1 THEN statements_1
-- WHEN expr_2 THEN statements_2
-- ...
-- [ELSE statements_k]
-- END
-- expr_i – reprezintă expresia care se va evalua
-- statements_i – reprezintă valoarea care se va returna pentru expr_i

-- Sa se afiseze, pentru toti angajatii departamentului RESEARCH,
-- o lista care sa contina o apreciere a vechimii angajatului. 
-- Aprecierea vechimii se va face astfel :
--	Daca au venit in firma inainte de 31 decembrie 1980
-- atunci vechime=’FOARTE VECHI’
--	Daca au venit in firma intre anii 1981 si 1986, atunci vechime=’VECHI’
--	Daca au venit in firma dupa 1986, atunci vechime=’RECENT’

select a.ename Nume_angajat, a.sal Salariu, 
case when extract( YEAR from a.hiredate)<= 1980 THEN 'FOARTE VECHI' 
     when extract( YEAR from a.hiredate) BETWEEN 1981 AND 1986 then 'VECHI' 
     when extract( YEAR from a.hiredate)>= 1987 THEN 'RECENT' END Apreciere_vechime
from emp a, dept b
where
	a.deptno=b.deptno
	and b.dname='RESEARCH';
	
-- lista de premiere a angajatilor:
-- a) au primit comision -> prima 200
-- b) nu au primit comision -> prima 300
-- c) presedintele si directorii(job - manager) nu primesc prima

-- conditia cu manager si president trebuie sa fie neaparat prima
-- altfel, nu mai ajungea la acea ramura
select ename, job, comm,
	   case
		when job='PRESIDENT' OR job='MANAGER' then 0
		when nvl(comm, 0)=0 then 300
		else 200
		end "Prima"
from emp;
	
------------------------------
---- Funcții de grup
------------------------------
-- principalele: SUM, COUNT, MAX, MIN, AVG
-- returneaza un rezultat pentru un grup de inregistrari
-- HAVING - filtreaza la nivel de blocuri

-- val salariului rotunjita la zeci
select round(sal, -1) from emp;
select max(sal) from emp;

-- SA SE AFLE SALARIUL MAXIM DIN DEPARTAMENTUL SALES
-- where se executa primul!!!!!!!!
select max(a.sal) from emp a, dept b
where a.deptno = b.deptno and b.dname = 'SALES';


-- Sa se afiseze pentru fiecare departament: denumirea, numarul de angajati
-- TOTI ANGAJATII --> DENUMIREA DEPARTAMENTULUI (14 INREG)

select d.dname
from dept d join emp a on d.deptno = a.deptno;


-- GRUPEZ ANGAJATII DUPA CRITERIUL DIN CLAUZA
-- GROUP BY --> DENUMIREA DEPARTAMENTELOR (3 INREG)

select d.dname
from dept d join emp a on a.deptno = d.deptno
group by d.dname;

-- APLICAREA FUNCTIEI DE GRUP PE FIECARE GRUP CREAT DE GROUP BY
select d.dname, count(*) "Nr Angajati"
from dept d join emp a on d.deptno = a.deptno
group by d.dname;

-- APLICAREA FUNCTIEI DE GRUP PE FIECARE GRUP CREAT DE GROUP BY.
-- FILTRARE LA NIVEL DE GRUP
-- having nu merge fara group by!!!!!
-- nu merge count(*)>4 in clauza select!!!!!!

select d.dname, count(*) "Nr Angajati"
from dept d join emp a on d.deptno = a.deptno
group by d.dname
having count(*) > 4;

-- Sa se afiseze pentru fiecare grad salarial, cati angajati din SALES
-- au salariul in acel grad salarial. 
-- Se vor afisa doar gradele cu mai mult de un angajat

select c.grade, count(*)
from emp a join dept b on a.deptno = b.deptno
		   join salgrade c on a.sal between c.losal and c.hisal
where b.dname = 'SALES'
GROUP BY c.grade
having COUNT(*) > 1;


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


-- Exemplu subiect test 2
-- Să se selecteze, pentru fiecare angajat ce nu il are ca sef pe KING 
-- si care castiga mai mult (venitul) decat seful său:  
-- numele angajatului, denumirea departamentului din care face parte, data angajarii, 
-- numele șefului său, denumirea departamentului din care face parte 
-- șeful său, data angajării șefului. 
-- Nu se va afisa angajatul SCOTT.
-- Veți efectua cerinta în cel putin 2 moduri.

select a.ename "Nume Ang", d.dname "Depart Ang", a.sal+nvl(a.comm,0) "Venit Ang",
	   a.hiredate "Data angajat", s.ename "Nume Sef", ds.dname "Depart Sef",
	   s.sal+nvl(s.comm,0) "Venit Sef"
from emp a join dept d on a.deptno = d.deptno
		   join emp s join dept ds on s.deptno = ds.deptno on a.mgr = s.empno
where s.ename not like 'KING'
	  AND a.ename not like 'SCOTT'
	  AND a.sal+nvl(a.comm,0) > s.sal+nvl(s.comm,0);
