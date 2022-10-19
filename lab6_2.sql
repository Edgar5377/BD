-- Pregunta 1

select dni_a, nombre, apellidos from arrendatario
where dni_a in
(select dni_a from arrienda where id_casa in (select id_casa from casa
where calle= '714-8965 Sem Avenue' and distrito = 'Iqaluit'));

-- Pregunta 2

------ CON CONSULTAS ANIDADAS

SELECT SUM(deuda) AS deuda_total
FROM arrienda
WHERE id_casa
IN (SELECT id_casa
	FROM casa
	WHERE dni_d 
	IN (SELECT dni_d
		FROM dueno
		WHERE nombre='Ignacia' and apellidos='Fletcher')
);

----- CON JOINS 

SELECT SUM(deuda) AS deuda_total
FROM arrienda 
INNER JOIN
(SELECT id_casa 
 FROM casa INNER JOIN dueno
 ON casa.dni_d=dueno.dni_d
 WHERE dueno.nombre='Ignacia' and apellidos='Fletcher') T1
ON arrienda.id_casa = T1.id_casa;


-- Pregunta 3

select A.dni_d,nombre,apellidos,A.sum from 
(select dni_d,sum(deuda)from 
casa 
inner join arrienda 
on (casa.id_casa = arrienda.id_casa)
group by dni_d) A
inner join dueno
on (A.dni_d = dueno.dni_d)


-- Pregunta 4

select distinct * from (select nombre, apellidos from dueno 
Union
(select nombre, apellidos from arrendatario))T1 ;

-- Pregunta 5

select dni_d, count(id_casa) as conteo from casa
group by dni_d
having count(id_casa) >= 3

-- Pregunta 6

select nombre, apellidos from
(select dni_d from
(select * from arrienda
where deuda = 0)A
inner join casa
on(A.id_casa=casa.id_casa))B
inner join dueno
on(B.dni_d = dueno.dni_d);


-- Pregunta 7

select avg (T1.conteo) from (select id_casa, count(dni_a) as conteo from arrienda
group by id_casa) T1;

-- Pregunta 8

select max (T1.conteo) from (select id_casa, count(dni_a) as conteo from arrienda
group by id_casa) T1;

-- Pregunta 9


SELECT dni_d, max_cant_casa
FROM dueno
INNER JOIN 
(SELECT dni_d, COUNT(id_casa) AS max_cant_casa
FROM casa
GROUP BY dni_d
HAVING COUNT(id_casa) =
	(SELECT MAX(casa_total)
	 FROM (	SELECT dueno.dni_d, count(id_casa) AS casa_total
		   	FROM dueno INNER JOIN casa
			USING (dni_d)
			GROUP BY dueno.dni_d) T1)
) T2
USING(dni_d);


-- Pregunta 10

	
--- CON ANIDADAS

SELECT dni, COUNT(fono) AS nro_telefonos
 FROM telefonos
 WHERE dni IN (
	 SELECT dni_a
	 FROM arrendatario
 )
 GROUP BY dni;
 
 ----- CON JOIN 
 SELECT dni_a, COUNT(fono) AS nro_telefonos
 FROM telefonos 
 INNER JOIN arrendatario
 ON dni=dni_a
 GROUP BY dni_a;
 

-- Pregunta 11

select dni_d,nombre,apellidos from dueno inner join (Select * from (select dni_d, count(id_casa) as maximo from casa
group by dni_d) as T3
inner join 
(select max(T1.conteo) as maximo from (select dni_d, count(id_casa) as conteo from casa
group by dni_d)T1)T2 using(maximo))T4 using (dni_d);
