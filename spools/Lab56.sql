select a.nume, a.functie, d.den_dep
from angajati a, departamente d
where a.functie = 'ANALYST';

select nume, functie, den_dep
from angajati CROSS JOIN departamente
where functie = 'ANALYST';

select d.id_dep "ID Departament", d.den_dep "Nume Departament", a.nume, a.functie
from angajati a JOIN departamente d ON a.id_dep = d.id_dep
where d.id_dep = 10
order by 1;


-- Daca folosesc using, atunci coloana numita id_dep nu mai trb
-- sa fie extrasa cu a. sau d., se stie ca e pt amandoua
select id_dep "ID Departament", d.den_dep "Nume Departament", a.nume, a.functie
from angajati a JOIN departamente d USING (id_dep)
where id_dep = 10
order by 1;

-- Nu mai trebuie deloc alias-uri pentru NARUTAL JOIN
select id_dep "ID Departament", den_dep "Nume Departament", nume, functie
from angajati NATURAL JOIN departamente
where id_dep = 10
order by 1;

select a.nume, a.salariu, g.grad
from angajati a JOIN grila_salariu g 
				ON a.salariu 
				BETWEEN g.nivel_inf AND g.nivel_sup
where a.id_dep = 20;


select a.nume, a.salariu, g.grad, d.den_dep
from angajati a JOIN grila_salariu g 
				ON a.salariu 
				BETWEEN g.nivel_inf AND g.nivel_sup
				JOIN departamente d
				ON a.id_dep = d.id_dep
where d.id_dep = 20;

select a.nume, a.salariu, g.grad, d.den_dep
from angajati a JOIN grila_salariu g 
				ON a.salariu >= g.nivel_inf AND a.salariu <= g.nivel_sup
				JOIN departamente d
				ON a.id_dep = d.id_dep
where d.id_dep = 20;



select s.nume, a.functie, s.nume, s.functie
from angajati a JOIN angajati s ON a.id_sef = s.id_ang
where a.id_dep = 10;



select d.id_dep, d.den_dep, a.nume, a.functie
from departamente d, angajati a
where d.id_dep = a.id_dep(+)
order by a.id_dep;

select d.id_dep, d.den_dep, a.nume, a.functie
from departamente d LEFT OUTER JOIN angajati a ON d.id_dep = a.id_dep
order by a.id_dep;



select a.nume, a.functie, a.salariu, g.grad
from angajati a FULL OUTER JOIN grila_salariu g 
				ON 2 * a.salariu BETWEEN g.nivel_inf AND g.nivel_sup
order by 1;



select d.den_dep, a.nume, a.salariu, g.grad
from angajati a FULL OUTER JOIN departamente d
				ON a.id_dep = d.id_dep
				FULL OUTER JOIN grila_salariu g
				ON 2 * a.salariu BETWEEN g.nivel_inf AND g.nivel_sup
order by d.den_dep, a.nume, g.grad;

select d.den_dep, a.nume, a.salariu, g.grad
from grila_salariu g
		FULL OUTER JOIN angajati a
				RIGHT OUTER JOIN departamente d
				ON d.id_dep = a.id_dep
		ON 2 * a.salariu BETWEEN g.nivel_inf AND g.nivel_sup
order by d.den_dep, a.nume, g.grad;


select id_dep, nume, functie, salariu
from angajati
where id_dep = 10
UNION
select id_dep, nume, functie, salariu
from angajati
where id_dep = 30;

select id_dep, nume, 'are salariul ' are, salariu sal_com
from angajati
where id_dep = 10
UNION
select id_dep, nume, 'are comisionul ' are, salariu sal_com
from angajati
where id_dep = 30;

-- UNION ALL ia si duplicate
select functie
from angajati
where id_dep = 10
UNION ALL
select functie
from angajati
where id_dep = 20;


select functie, nvl(comision,0) comision
	from angajati where id_dep = 10
INTERSECT
select functie, nvl(comision,0) comision
	from angajati where id_dep = 20
INTERSECT
select functie, nvl(comision,0) comision
	from angajati where id_dep = 30;
	
	
select functie
	from angajati where id_dep = 10
MINUS
select functie
	from angajati where id_dep = 30;
