--SET verify OFF;
--SELECT nume, functie, &salariu_anual salariu_anual
--FROM &tabel
--WHERE &nume_coloana = &valoare_coloana;

SELECT nume, functie, &&venit_lunar venit_lunar
FROM angajati
WHERE &venit_lunar > 2000;
-- venit_lunar = salariu + nvl(comision, 0)
-- undefine venit_lunar


SELECT id_ang, nume, functie, data_ang
FROM angajati
WHERE functie = '&&1' AND data_ang > '&&2'
ORDER BY data_ang;

accept functie_ang char prompt 'Introduceti functia angajatului:'

SELECT nume, salariu, comision
FROM angajati
WHERE functie = '&&functie_ang'
ORDER BY salariu;


accept id_ang char prompt 'Indroduceti ecusonul angajatului:'
accept nume char prompt 'Indroduceti numele angajatului:'
accept functie char prompt 'Indroduceti functia angajatului:'
accept salariu char prompt 'Indroduceti salariul angajatului:' hide

--INSERT INTO angajati(id_ang, nume, functie, salariu)
--	VALUES (&&id_ang, '&&nume', '&&functie', &&salariu);
	
	
define procent_prima = 0.15
define id_dep = 20

SELECT nume, salariu, salariu*&procent_prima prima
FROM angajati
WHERE id_dep = &id_dep;