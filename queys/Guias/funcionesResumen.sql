use Univ
go
----------------------1---------------------------------
--Listado con la cantidad de cursos.
select count(*) as 'cantidad de cursos' from Cursos
-----------------------2-------------------------------
--Listado con la cantidad de usuarios.
select count(*) as 'cantidad de usuarios' from Usuarios
------------------------3------------------------------
--Listado con el promedio de costo de certificación de los cursos.
select sum(C.CostoCertificacion) / count(*) as 'promedio costo certificacion' from Cursos C
------------------------4---------------------------------
--Listado con el promedio general de calificación de reseñas.
select sum(R.Puntaje) / count(*) as 'promedio de Puntaje' from Reseñas R
-----------------------5----------------------------------
--Listado con la fecha de estreno de curso más antigua.
select min(C.Estreno) from Cursos C
------------------------6-----------------------------------
--Listado con el costo de certificación menos costoso.
select max(C.CostoCertificacion) from Cursos C
------------------------7---------------------------------
--Listado con el costo total de todos los cursos.
select sum(C.CostoCurso) as 'costo total de cursos' from Cursos C 
-------------------------8-----------------------------------
--Listado con la suma total de todos los pagos.
select sum(P.Importe) as 'total facturado' from Pagos P
------------------------9-------------------------------------
--Listado con la cantidad de cursos de nivel principiante.
select count(*) as 'cantidad cursos Principiante' from Cursos C
inner join Niveles N on N.ID = C.IDNivel
where N.Nombre like 'Principiante'
--------------------------10--------------------------------------
--Listado con la suma total de todos los pagos realizados en 2020.
select sum(P.Importe) as 'pagos en 2020' from Pagos P 
where year(P.Fecha) = 2020
---------------------------11--------------------------------------
--Listado con la cantidad de usuarios que son instructores.
select count(*) from Usuarios U 
inner join Instructores_x_Curso I on I.IDUsuario = U.ID 
---------------------------12---------------------------------------
--Listado con la cantidad de usuarios distintos que se hayan certificado.
select distinct count(*) from Usuarios U
inner join Inscripciones I on I.IDUsuario = U.ID
inner join Certificaciones C on C.IDInscripcion = I.ID
------------------------------13-----------------------------------------
--Listado con el nombre del país y la cantidad de usuarios de cada país.
select P.Nombre, count(*) as 'cantidad de usuarios' from Paises P
inner join Localidades L on L.IDPais = P.ID
inner join Datos_Personales dp on dp.IDLocalidad = L.ID 
group by P.Nombre
------------------------------14------------------------------------------
--Listado con el apellido y nombres del usuario y el importe más costoso 
--abonado como pago. Sólo listar aquellos que hayan abonado más de $7500.
select dp.Nombres, dp.Apellidos, U.NombreUsuario, max(P.Importe) as 'Importe maximo'
from Datos_Personales dp
inner join Usuarios U ON U.ID = dp.ID
inner join Inscripciones I ON I.IDUsuario = U.ID
inner join Pagos P ON P.IDInscripcion = I.ID
where P.Importe > 7500
group by dp.Nombres, dp.Apellidos, U.NombreUsuario
------------------------------15------------------------------------------------
--Listado con el apellido y nombres de usuario de cada usuario y el importe más 
--costoso del curso al cual se haya inscripto. Si hay usuarios sin inscripciones
--deben figurar en el listado de todas maneras.
select dp.Apellidos, U.NombreUsuario, max(P.Importe) from Usuarios U
left join Datos_Personales dp on dp.ID = U.ID 
left join Inscripciones I on I.IDUsuario = U.ID 
left join Pagos P on I.ID = P.IDInscripcion 
group by dp.Apellidos, U.NombreUsuario
--------------------------------16-----------------------------------------------
--Listado con el nombre del curso, nombre del nivel, cantidad total de clases 
--y duración total del curso en minutos.
select C.Nombre as 'Nombre de curso', N.Nombre as 'Nivel', count(*) as 'Total de clases', sum(Cl.Duracion) as 'Duracion total de clases'
from Cursos C 
inner join Clases Cl on Cl.IDCurso = C.ID
inner join Niveles N on N.ID = C.IDNivel
group by C.Nombre, N.Nombre
--------------------------------17-----------------------------------------------
--Listado con el nombre del curso y cantidad de contenidos registrados.
--Sólo listar aquellos cursos que tengan más de 10 contenidos registrados.
select C.Nombre, count(*) as 'Cantidad de clases' from Cursos C 
inner join Clases Cl on Cl.IDCurso = C.ID 
inner join Contenidos Co on Co.IDClase = Cl.ID 
group by C.Nombre 
having count(*) > 10
---------------------------------18-----------------------------------------------
--Listado con nombre del curso, nombre del idioma y cantidad de tipos de idiomas.
select C.Nombre, I.Nombre, count (distinct I.ID) as 'cantidad de idiomas' from Cursos C 
inner join Idiomas_x_Curso Ic on Ic.IdCurso = C.ID 
inner join Idiomas I on I.ID = Ic.IDIdioma 
group by  C.Nombre, I.Nombre

---------------------------------19-------------------------------------------------
--Listado con el nombre del curso y cantidad de idiomas distintos disponibles.
select C.Nombre, count (distinct I.ID) as 'cantidad de idiomas' from Cursos C 
inner join Idiomas_x_Curso Ic on Ic.IdCurso = C.ID 
inner join Idiomas I on I.ID = Ic.IDIdioma 
group by  C.Nombre


----------------------------------20-----------------------------------------------
--Listado de categorías de curso y cantidad de cursos asociadas a cada 
--categoría. Sólo mostrar las categorías con más de 5 cursos.
select Ca.Nombre, count(Cu.ID) as 'Cantidad de cursos' from Categorias Ca
inner join Categorias_x_Curso Cc on Cc.IDCategoria = Ca.ID
inner join Cursos Cu on Cu.ID = Cc.IDCurso 
group by Ca.Nombre
having count(Cu.ID) > 5

-----------------------------------21-----------------------------------------------
--Listado con tipos de contenido y la cantidad de contenidos asociados a cada tipo. 
--Mostrar también aquellos tipos que no hayan registrado contenidos con cantidad 0.
select Tc.Nombre, count(C.ID) as 'contenidos asociados' from TiposContenido Tc 
left join Contenidos C on C.IDTipo = Tc.ID 
group by Tc.Nombre


-----------------------------------22------------------------------------------------
--Listado con Nombre del curso, nivel, año de estreno y el total recaudado en 
--concepto de inscripciones. Listar también aquellos cursos sin inscripciones con total igual a $0.



23
Listado con Nombre del curso, costo de cursado y certificación y cantidad de usuarios distintos inscriptos cuyo costo de cursado sea menor a $10000 y cuya cantidad de usuarios inscriptos sea menor a 5. Listar también aquellos cursos sin inscripciones con cantidad 0.
24
Listado con Nombre del curso, fecha de estreno y nombre del nivel del curso que más recaudó en concepto de certificaciones.
25
Listado con Nombre del idioma del idioma más utilizado como subtítulo.
26
Listado con Nombre del curso y promedio de puntaje de reseñas apropiadas.
27
Listado con Nombre de usuario y la cantidad de reseñas inapropiadas que registró.
28
Listado con Nombre del curso, nombre y apellidos de usuarios y la cantidad de veces que dicho usuario realizó dicho curso. No mostrar cursos y usuarios que contabilicen cero.
29
Listado con Apellidos y nombres, mail y duración total en concepto de clases de cursos a los que se haya inscripto. Sólo listar información de aquellos registros cuya duración total supere los 400 minutos.
30
Listado con nombre del curso y recaudación total. La recaudación total consiste en la sumatoria de costos de inscripción y de certificación. Listarlos ordenados de mayor a menor por recaudación.

