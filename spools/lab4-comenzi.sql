select
	id_ang||'-'||nume angajat, 
	functie,
	salariu+nvl(comision,0) AS "Venit Lunar",
	'      ' AS SEMNATURA
FROM ANGAJATI
ORDER BY id_dep;


select den_dep || ' are codul ' || id_dep "Lista Departamente"
from departamente
order by den_dep;

select id_dep departament, functie, nume, data_ang as "Data Angajarii"
from angajati
where data_ang BETWEEN '1-MAY-1981' AND '31-DEC-1981'
order by 1, 2 DESC;

select id_ang as ecuson, nume, functie, salariu + nvl(comision, 0) "Venit Lunar"
from angajati
where id_ang in (7499, 7902, 7876)
order by nume;

select id_ang as ecuson, nume, functie, data_ang as "Data Angajarii"
from angajati
where data_ang LIKE '%80';

select id_ang as ecuson, nume, functie, data_ang as "Data Angajarii"
from angajati
where nume like 'F%' and functie like '_______';

select id_ang as ecuson, nume, functie, salariu, comision
from angajati
where (comision = 0 or comision is null) AND id_dep = 20
order by nume;

select id_ang as ecuson, nume, functie, salariu, comision
from angajati
where (comision != 0 and comision is not null) AND functie = UPPER('salesman')
order by nume;

select id_ang as ecuson, nume, functie, salariu, id_dep as departament
from angajati
where (functie = UPPER('manager') AND salariu > 1500) OR functie = 'ANALYST'
order by nume;











SELECT ename Nume, job Functie, sal+nvl(comm,0) venit_lunar, &prima*sal Prima, '       ' as semnatura
FROM emp
WHERE sal+nvl(comm,0) > &salVal and nvl(comm, 0) = 0;

define procentSal = &prima*sal
define salVal = &prag_sal
SELECT ename Nume, job Functie, sal+nvl(comm,0) venit_lunar, &procentSal Prima, '       ' as semnatura
FROM emp
WHERE sal+nvl(comm,0) > &salVal and nvl(comm, 0) = 0;


accept prima char prompt 'introduceti procentul ce reprezinta prima:'
accept salariu_prag char prompt 'introduceti pragul de salariu:'
SELECT ename Nume, job Functie, sal+nvl(comm,0) venit_lunar, &prima*sal Prima, '       ' as semnatura
FROM emp
WHERE sal+nvl(comm,0) > &salariu_prag and (comm is null or comm = 0);


SELECT ename Nume, job Functie, sal+nvl(comm,0) venit_lunar, &1*sal Prima, '       ' as semnatura
FROM emp
WHERE sal+nvl(comm,0) > &2 and nvl(comm,0) = 0;

undefine venit_lunar
undefine salVal