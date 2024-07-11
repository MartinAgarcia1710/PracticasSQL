Use Univ
go
------------------------------1------------------------------------------
--Listado con nombre de usuario de todos los usuarios
--y sus respectivos nombres y apellidos.
select Nombres, Apellidos, U.NombreUsuario from Datos_Personales DP
inner join Usuarios U on U.ID = DP.ID
------------------------------2------------------------------------------
--Listado con apellidos, nombres, fecha de nacimiento y nombre 
--del país de nacimiento. 
select dp.Nombres, dp.Apellidos, dp.Nacimiento, P.Nombre  from Datos_Personales dp
inner join Localidades L on L.ID = dp.IDLocalidad
inner join Paises P on L.IDPais = P.ID
-----------------------------3-------------------------------------------
--Listado con nombre de usuario, apellidos, nombres, email o 
--celular de todos los usuarios que vivan en una domicilio comience con vocal.
--NOTA: Si no tiene email, obtener el celular.
select U.NombreUsuario, dp.Nombres, dp.Apellidos, dp.Domicilio,
case 
    when dp.Celular is NULL then dp.Email
end
from Usuarios U
inner join Datos_Personales dp on U.ID = dp.ID
where dp.Domicilio like 'A%'
--------------------------------4--------------------------------------------
--Listado con nombre de usuario, apellidos, nombres, email 
--o celular o domicilio como 'Información de contacto'.
--NOTA: Si no tiene email, obtener el celular y si no posee celular obtener el domicilio.
select * from Datos_Personales
where ID = 28
select U.NombreUsuario, dp.Nombres, dp.Apellidos,
case 
    when dp.Email is not NULL then dp.Email
    when dp.Celular is not NULL then dp.Celular
    else dp.Domicilio
end as 'Información de contacto'
from Usuarios U
inner join Datos_Personales dp on U.ID = dp.ID
---------------------------------5------------------------------------------------
--Listado con apellido y nombres, nombre del curso y costo de la inscripción 
--de todos los usuarios inscriptos a cursos.
--NOTA: No deben figurar los usuarios que no se inscribieron a ningún curso.
select dp.Nombres, dp.Apellidos, C.Nombre, I.Costo from Datos_Personales dp
inner join Usuarios U on U.ID = dp.Id
inner join Inscripciones I on I.IDUsuario = U.ID
inner join Cursos C on C.ID = I.IDCurso 
------------------------------------6---------------------------------------------
--Listado con nombre de curso, nombre de usuario y mail de todos los inscriptos 
--a cursos que se hayan estrenado en el año 2020.
select C.Nombre, U.NombreUsuario, dp.Email, C.Estreno from Datos_Personales dp 
inner join Usuarios U on U.ID = dp.Id 
inner join Inscripciones I on I.IDUsuario = U.ID 
inner join Cursos C on C.ID = I.IDCurso
where year(C.Estreno) = 2020
-------------------------------------7----------------------------------------------
--Listado con nombre de curso, nombre de usuario, apellidos y nombres, fecha de 
--inscripción, costo de inscripción, fecha de pago e importe de pago. Sólo listar 
--información de aquellos que hayan pagado.
select C.Nombre, U.NombreUsuario, dp.Nombres, dp.Apellidos, I.Fecha as 'Fecha de inscripción', I.Costo, P.Fecha as 'Fecha de pago', P.Importe from Datos_Personales dp 
inner join Usuarios U on U.ID = dp.ID 
inner join Inscripciones I on I.IDUsuario = U.ID 
inner join Cursos C on C.ID = I.IDCurso
inner join Pagos P on P.IDInscripcion = I.ID
where P.Importe > 0
-------------------------------------8-----------------------------------------------
--Listado con nombre y apellidos, género, fecha de nacimiento, mail, nombre del curso 
--y fecha de certificación de todos aquellos usuarios que se hayan certificado.
Select dp.Nombres, dp.Apellidos, dp.Genero, dp.Nacimiento as 'Fecha de nacimiento', dp.Email, Cu.Nombre as 'Nombre de curso', Ce.Fecha as 'Fecha de certificación' from Datos_Personales dp
inner join Inscripciones I on I.IDUsuario = dp.ID 
inner join Cursos Cu on Cu.ID = I.IDCurso 
inner join Certificaciones Ce on Ce.IdInscripcion = I.ID 
select * from Certificaciones
---------------------------------------9------------------------------------------------
--Listado de cursos con nombre, costo de cursado y certificación, costo total 
--(cursado + certificación) con 10% de descuento aplicado de todos los cursos de nivel Principiante.
select Cu.Nombre, Cu.CostoCurso, Cu.CostoCertificacion, 
((Cu.CostoCurso + Cu.CostoCertificacion) - (Cu.CostoCurso + Cu.CostoCertificacion) *10 / 100 ) ,
N.Nombre as 'Nivel'
from Cursos Cu 
inner join Niveles N on N.ID = Cu.IDNivel
where N.Nombre = 'Principiante'
---------------------------------------10------------------------------------------------
--Listado con nombre y apellido y mail de todos los instructores. Sin repetir.
select distinct dp.Nombres, dp.Apellidos, dp.Email from Datos_Personales dp 
inner join Usuarios U on U.ID = dp.ID 
inner join Instructores_x_Curso IC on Ic.IDUsuario = U.ID
-------------------------------------11-----------------------------------------------------
--Listado con nombre y apellido de todos los usuarios que hayan cursado algún curso 
--cuya categoría sea 'Historia'.
select dp.Nombres, dp.Apellidos, Cu.Nombre, C.Nombre from Datos_Personales dp 
inner join Usuarios U on U.ID = dp.ID 
inner join Inscripciones I on I.IDUsuario = U.ID
inner join Cursos Cu on Cu.ID = I.IDCurso 
inner join Categorias_x_Curso Cc on Cu.ID = Cc.IDCurso 
inner join Categorias C on C.ID = Cc.IDCategoria
where C.Nombre = 'Historia'
-----------------------------------12----------------------------------------------------------
--Listado con nombre de idioma, código de curso y código de tipo de idioma. Listar 
--todos los idiomas indistintamente si no tiene cursos relacionados.
select I.Nombre as 'Idioma', I.ID as 'Código de idioma', Ic.IDCurso as 'Código de curso', Fi.Nombre as 'Formato de idioma' from Idiomas I
left join Idiomas_x_Curso Ic on Ic.IDIdioma = I.ID 
left join FormatosIdioma Fi on Fi.ID = Ic.IDFormatoIdioma
left join Cursos C on C.ID = Ic.IDCurso 
-----------------------------------13----------------------------------------------------------
--Listado con nombre de idioma de todos los idiomas que no tienen cursos relacionados.
select I.Nombre from Idiomas I 
Left join Idiomas_x_Curso Ic on Ic.IDIdioma = I.ID
left join Cursos C on C.ID = Ic.IDCurso
where Ic.IDIdioma is null
------------------------------------14--------------------------------------------------------
--Listado con nombres de idioma que figuren como audio de algún curso. Sin repeticiones.
select distinct I.Nombre, Fi.Nombre from Idiomas I 
inner join Idiomas_x_Curso Ic on I.ID = Ic.IDIdioma
inner join FormatosIdioma Fi on Fi.ID = Ic.IDFormatoIdioma
where Fi.Nombre = 'Audio'
-----------------------------------15------------------------------------------------------------
--Listado con nombres y apellidos de todos los usuarios y el nombre del país en el que 
--nacieron. Listar todos los países indistintamente si no tiene usuarios relacionados.
select dp.Nombres, dp.Apellidos, P.Nombre from Datos_personales dp 
inner join Localidades L on L.ID = dp.IDLocalidad
right join Paises P on P.ID = L.IDPais
-----------------------------------16-------------------------------------------------------------
--Listado con nombre de curso, fecha de estreno y nombres de usuario de todos los inscriptos. 
--Listar todos los nombres de usuario indistintamente si no se inscribieron a ningún curso.
select C.Nombre as 'Se inscribió a', C.Estreno as 'Se estrena el', U.NombreUsuario as 'Usuario' from Cursos C
inner join Inscripciones I on I.IDCurso = C.ID 
right join Usuarios U on U.ID = I.IDUsuario
-----------------------------------17--------------------------------------------------------------
--Listado con nombre de usuario, apellido, nombres, género, fecha de nacimiento y 
--mail de todos los usuarios que no cursaron ningún curso.
select U.NombreUsuario as 'Usuario', dp.Nombres, dp.Apellidos, dp.Genero, dp.Nacimiento, dp.Email from Datos_Personales dp 
full join Usuarios U on U.ID = dp.ID 
full join Inscripciones I on I.IDUsuario = U.ID
where I.IDUsuario is null
----------------------------------18-----------------------------------------------------------------
--Listado con nombre y apellido, nombre del curso, puntaje otorgado y texto de la reseña. 
--Sólo de aquellos usuarios que hayan realizado una reseña inapropiada.

select dp.Nombres, dp.Apellidos, C.Nombre, R.Puntaje, R.Observaciones from Datos_personales dp 
inner join Usuarios U on U.ID = dp.ID 
inner join Inscripciones I on U.ID = I.IDUsuario 
inner join Cursos C on C.ID = I.IDCurso
inner join Reseñas R on R.IDInscripcion = I.ID 
where R.Inapropiada = 1
-----------------------------------19------------------------------------------------------------------
--Listado con nombre del curso, costo de cursado, costo de certificación, nombre del idioma y 
--nombre del tipo de idioma de todos los cursos cuya fecha de estreno haya sido antes del año actual.
-- Ordenado por nombre del curso y luego por nombre de tipo de idioma. Ambos ascendentemente.

select C.Nombre, C.CostoCurso, C.CostoCertificacion, I.Nombre, Fi.Nombre from Cursos C 
inner join Idiomas_x_Curso Ic on Ic.IDCurso = C.ID 
inner join Idiomas I on I.ID = Ic.IDIdioma 
inner join FormatosIdioma Fi on Fi.ID = Ic.IDFormatoIdioma
order by C.Nombre, Fi.Nombre asc


20
Listado con nombre del curso y todos los importes de los pagos relacionados.
21
Listado con nombre de curso, costo de cursado y una leyenda que indique "Costoso" si el costo de cursado es mayor a $ 15000, "Accesible" si el costo de cursado está entre $2500 y $15000, "Barato" si el costo está entre $1 y $2499 y "Gratis" si el costo es $0.
