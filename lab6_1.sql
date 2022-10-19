set search_path to lab601;

-- pregunta 1
select nombre, anho from pelicula
order by calificacion desc
limit 10;


select * from personaje inner join pelicula
on p_nombre = nombre and p_anho=anho;

select * from personaje inner join actor
on personaje.a_nombre = actor.nombre
       and genero = 'F' ;

-- Pregunta 2
select T1.a_nombre from pelicula
inner join (select * from personaje inner join actor
on personaje.a_nombre = actor.nombre
       and genero = 'F') T1
    on pelicula.nombre = T1.p_nombre and
       pelicula.anho = T1.p_anho
order by calificacion desc
limit 10;

-- Pregunta 3
select count(nombre) from actor;

-- Pregunta 4
select count(distinct anho) from pelicula ;

-- Pregunta 5
select a_nombre, count((p_nombre,p_anho)) as conteo
from personaje
group by a_nombre
having count((p_nombre,p_anho))>1
order by conteo desc;

-- Pregunta 6
select anho, avg(calificacion) as promedio
from pelicula
group by anho
having avg(calificacion)>8
order by promedio desc;

-- Pregunta 7
select count(*) as estrenos , (anho-anho%10) as decada
from pelicula
group by decada
order by estrenos desc;

-- Pregunta 8
select * from
(select a_nombre from personaje
where p_nombre = 'Terminator 2: Judgement Day') A
full outer join
(select a_nombre from personaje
where p_nombre = 'Terminator')B
on A.a_nombre = B.a_nombre
;

-- Pregunta 9
select * from
(select a_nombre from personaje
where p_nombre = 'Terminator 2: Judgement Day') A
full outer join
(select a_nombre from personaje
where p_nombre = 'Terminator')B
on A.a_nombre = B.a_nombre
where (A.a_nombre is null) or (B.a_nombre is null);

-- Pregunta 10

SELECT T1.nombre, T1.anho, actrices, actores, CAST(actrices AS NUMERIC)/(actrices+actores) AS proporcion
    FROM
        (SELECT p1.nombre, anho, count(a_nombre) AS actrices FROM
            pelicula p1
                LEFT JOIN
            (SELECT * FROM personaje p JOIN actor a ON a.nombre = p.a_nombre WHERE genero = 'F') p2
                ON p1.nombre = p2.p_nombre
            GROUP BY p1.nombre, anho) AS T1
    JOIN
        (SELECT p1.nombre, anho, count(a_nombre) AS actores FROM
            pelicula p1
                LEFT JOIN
            (SELECT * FROM personaje p JOIN actor a ON a.nombre = p.a_nombre WHERE genero = 'M') p2
                ON p1.nombre = p2.p_nombre
            GROUP BY p1.nombre, anho) AS T2
    ON T1.nombre = T2.nombre
ORDER BY proporcion, actrices DESC, actores DESC;