--subconsultas
---------------------------------1-------------------------------------
--Listado con apellidos y nombres de los usuarios 
--que no se hayan inscripto a cursos durante el año 2019.

Select Dp.Nombres, Dp.Apellidos from Datos_Personales Dp 
left join Usuarios U on Dp.ID = U.ID
Where U.ID not in 
    (select U.ID from Inscripciones I    
     Left join Usuarios U on I.IDUsuario = U.ID
     where YEAR(I.Fecha) = 2019
    )


-----------------------------------2---------------------------------------
--Listado con apellidos y nombres de los usuarios que se hayan inscripto 
--a cursos pero no hayan realizado ningún pago.

Select Dp.Nombres, Dp.Apellidos, U.ID from Datos_Personales Dp 
left join Usuarios U on U.ID = Dp.ID
Left Join Inscripciones I on U.ID = I.IDUsuario
Where U.ID not in 
    (Select I.IDUsuario from Inscripciones I 
     left Join Pagos P on P.IDInscripcion = I.ID
    )

---------------------------------------3---------------------------------
--Listado de países que no tengan usuarios relacionados.

select P.Nombre from Paises P 
Where P.ID not in 
    (select L.IDPais from Localidades L 
     Inner join Datos_Personales Dp on Dp.IDLocalidad = L.ID
    )
------------------------------------4------------------------------------
--Listado de clases cuya duración sea mayor a la duración promedio.
--Con variable y sin Subconsultas
Declare @DuracionPromedioGeneral int
Select @DuracionPromedioGeneral = AVG(Duracion) from Clases 
Select distinct C.ID, C.Nombre from Clases C
Where C.Duracion > @DuracionPromedioGeneral

--Con Subconsultas
Select C.Nombre, C.Duracion from Clases C 
Group by C.ID, C.Nombre, C.Duracion
Having C.Duracion > (Select AVG(Duracion) from Clases)

------------------------------------5----------------------------------------
--Listado de contenidos cuyo tamaño sea mayor al tamaño de todos los 
--contenidos de tipo 'Audio de alta calidad'.
-- Con variable y sin Subconsultas
Declare @MaxTamanioContenidoAAC int
Select @MaxTamanioContenidoAAC = Max(Tamaño) from Contenidos C where C.IDTipo = 1
Select * from Contenidos C 
where C.Tamaño > @MaxTamanioContenidoAAC


--Con SubConsultas
Select * from Contenidos C 
where C.Tamaño > ALL
    (Select C.Tamaño from Contenidos C 
     Left Join TiposContenido Tc on Tc.ID = C.IDTipo
     Where Tc.Nombre like 'Audio de alta calidad' 
    )

-------------------------------------6------------------------------------------
--Listado de contenidos cuyo tamaño sea menor al tamaño de algún contenido
--de tipo 'Audio de alta calidad'.

Select * from Contenidos C 
where C.Tamaño < ANY
    (Select C.Tamaño from Contenidos C 
     Inner Join TiposContenido Tc on Tc.ID = C.IDTipo
     where Tc.Nombre like 'Audio de alta calidad'
    )

--------------------------------------7----------------------------------------
--Listado con nombre de país y la cantidad de usuarios de género masculino y 
--la cantidad de usuarios de género femenino que haya registrado.

Select P.Nombre,
    (select count(Dp.Genero) from Datos_Personales Dp
    Inner Join Localidades L on L.ID = Dp.IDLocalidad
    Inner Join Paises Ps  on Ps.ID = L.IDPais 
    where Dp.Genero = 'F' and IDPais = P.ID) as 'Cantidad Femenino',
    (select count(Dp.Genero) from Datos_Personales Dp
    Inner Join Localidades L on L.ID = Dp.IDLocalidad
    Inner Join Paises Ps  on Ps.ID = L.IDPais 
    where Dp.Genero = 'M' and IDPais = P.ID) as 'Cantidad Masculino'
From Paises P
Group by P.Nombre, P.ID

----------------------------------------8------------------------------------------
--Listado con apellidos y nombres de los usuarios y la cantidad de inscripciones 
--realizadas en el 2019 y la cantidad de inscripciones realizadas en el 2020.

Select Dp.Nombres, Dp.Apellidos,
    (Select count(I.Fecha) from Inscripciones I 
     Inner join Datos_Personales Dps on Dps.ID = I.IDUsuario
     where year(I.Fecha) = 2019 and Dps.ID = Dp.ID) as 'Inscripciones 2019',
     (Select count(I.Fecha) from Inscripciones I 
     Inner join Datos_Personales Dps on Dps.ID = I.IDUsuario
     where year(I.Fecha) = 2020 and Dps.ID = Dp.ID) as 'Inscripciones 2020'

from Datos_Personales Dp
Group by Dp.ID,Dp.Nombres, Dp.Apellidos

------------------------------------------9-----------------------------------------
--Listado con nombres de los cursos y la cantidad de idiomas de cada tipo. Es decir, 
--la cantidad de idiomas de audio, la cantidad de subtítulos y la cantidad de texto de video.

Select C.Nombre,
    (select count(Ics.IDCurso) from Idiomas_x_Curso Ics
     inner join Idiomas I2 on I2.ID = Ics.IDIdioma
     Inner Join FormatosIdioma Fis on Fis.ID = Ics.IDFormatoIdioma
     where Fis.Nombre like 'Audio' and C.ID = Ics.IDCurso
    ) as 'Cantidad Audio',
    (select count(Ics.IDCurso) from Idiomas_x_Curso Ics
     inner join Idiomas I2 on I2.ID = Ics.IDIdioma
     Inner Join FormatosIdioma Fis on Fis.ID = Ics.IDFormatoIdioma
     where Fis.Nombre like 'Subtitulo' and C.ID = Ics.IDCurso
    ) as 'Cantidad Subtitulo',
    (select count(Ics.IDCurso) from Idiomas_x_Curso Ics
     inner join Idiomas I2 on I2.ID = Ics.IDIdioma
     Inner Join FormatosIdioma Fis on Fis.ID = Ics.IDFormatoIdioma
     where Fis.Nombre like 'Texto del video' and C.ID = Ics.IDCurso
    ) as 'Cantidad Texto del video'
from Cursos C

--------------------------------------------10------------------------------------
--Listado con apellidos y nombres de los usuarios, nombre de usuario y cantidad de 
--cursos de nivel 'Principiante' que realizó y cantidad de cursos de nivel 'Avanzado' que realizó.

Select Dp.Nombres, Dp.Apellidos, U.NombreUsuario,
    (select count(I2.IDCurso) from Inscripciones I2
    Inner join Cursos Cs on Cs.ID = I2.IDCurso
    Inner Join Niveles N2 on N2.ID = Cs.IDNivel
    where N2.Nombre like 'Principiante' and U.ID = I2.IDUsuario
    ) as 'Cantidad Principiante',
    (select count(I2.IDCurso) from Inscripciones I2
    Inner join Cursos Cs on Cs.ID = I2.IDCurso
    Inner Join Niveles N2 on N2.ID = Cs.IDNivel
    where N2.Nombre like 'Avanzado' and U.ID = I2.IDUsuario
    ) as 'Cantidad Avanzado'

From Datos_Personales Dp
Inner Join Usuarios U on U.ID = Dp.ID

--------------------------------------11--------------------------------------------
--Listado con nombre de los cursos y la recaudación de inscripciones de usuarios de
--género femenino que se inscribieron y la recaudación de inscripciones de usuarios 
--de género masculino.

Select C.Nombre,
    (select Sum(P2.Importe) from Pagos P2
     Inner Join Inscripciones I2 on I2.ID = P2.IDInscripcion
     Inner Join Datos_Personales Dp2 on Dp2.ID =I2.IDUsuario
     where Dp2.Genero = 'M' and I2.IDCurso = C.ID   
     ) as 'Recaudacion Masculina',
     (select Sum(P2.Importe) from Pagos P2
     Inner Join Inscripciones I2 on I2.ID = P2.IDInscripcion
     Inner Join Datos_Personales Dp2 on Dp2.ID =I2.IDUsuario
     where Dp2.Genero = 'F' and I2.IDCurso = C.ID   
     ) as 'Recaudacion Femenina'

from Cursos C

--------------------------------------12-------------------------------------------
--Listado con nombre de país de aquellos que hayan registrado más usuarios de 
--género masculino que de género femenino.

Select  Sub.*  from ( select P.Nombre,
    (select count(Dp.Genero) from Datos_Personales Dp
    Inner Join Localidades L on L.ID = Dp.IDLocalidad
    Inner Join Paises Ps  on Ps.ID = L.IDPais 
    where Dp.Genero = 'F' and IDPais = P.ID) as 'Cantidad Femenino',

    (select count(Dp.Genero) from Datos_Personales Dp
    Inner Join Localidades L on L.ID = Dp.IDLocalidad
    Inner Join Paises Ps  on Ps.ID = L.IDPais 
    where Dp.Genero = 'M' and IDPais = P.ID) as 'Cantidad Masculino'

    From Paises P
) as Sub
Where Sub.[Cantidad Masculino] > Sub.[Cantidad Femenino]

-------------------------------------------13-----------------------------------------
--Listado con nombre de país de aquellos que hayan registrado más usuarios de género 
--masculino que de género femenino pero que haya registrado al menos un usuario de género femenino.

Select  Sub.*  from ( select P.Nombre,
    (select count(Dp.Genero) from Datos_Personales Dp
    Inner Join Localidades L on L.ID = Dp.IDLocalidad
    Inner Join Paises Ps  on Ps.ID = L.IDPais 
    where Dp.Genero = 'F' and IDPais = P.ID) as 'Cantidad Femenino',

    (select count(Dp.Genero) from Datos_Personales Dp
    Inner Join Localidades L on L.ID = Dp.IDLocalidad
    Inner Join Paises Ps  on Ps.ID = L.IDPais 
    where Dp.Genero = 'M' and IDPais = P.ID) as 'Cantidad Masculino'

    From Paises P
) as Sub
Where Sub.[Cantidad Masculino] > Sub.[Cantidad Femenino] and sub.[Cantidad Femenino] >= 1

-----------------------------------------------14---------------------------------------------
--Listado de cursos que hayan registrado la misma cantidad de idiomas de audio que de subtítulos.

Select Sub.* from ( select C.Nombre,
    (select count(Ics.IDCurso) from Idiomas_x_Curso Ics
     inner join Idiomas I2 on I2.ID = Ics.IDIdioma
     Inner Join FormatosIdioma Fis on Fis.ID = Ics.IDFormatoIdioma
     where Fis.Nombre like 'Audio' and C.ID = Ics.IDCurso
    ) as 'Cantidad Audio',
    (select count(Ics.IDCurso) from Idiomas_x_Curso Ics
     inner join Idiomas I2 on I2.ID = Ics.IDIdioma
     Inner Join FormatosIdioma Fis on Fis.ID = Ics.IDFormatoIdioma
     where Fis.Nombre like 'Subtitulo' and C.ID = Ics.IDCurso
    ) as 'Cantidad Subtitulo'
    From Cursos C
    ) as Sub
Where Sub.[Cantidad Audio] = Sub.[Cantidad Subtitulo]

---------------------------------------------15----------------------------------------------------
--Listado de usuarios que hayan realizado más cursos en el año 2018 que en el 2019 y a su vez más 
--cursos en el año 2019 que en el 2020.

Select Sub.* from (select Dp.Nombres,


(Select count(*) from Datos_Personales Dp2 
inner join Inscripciones I on I.IDUsuario = Dp2.ID 
where year(I.Fecha) = 2018 and Dp.ID = Dp2.ID) as Ins2018, 

(Select count(*) from Datos_Personales Dp2 
inner join Inscripciones I on I.IDUsuario = Dp2.ID 
where year(I.Fecha) = 2019 and Dp.ID = Dp2.ID) as Ins2019,
(Select count(*) from Datos_Personales Dp2 
inner join Inscripciones I on I.IDUsuario = Dp2.ID 
where year(I.Fecha) = 2020 and Dp.ID = Dp2.ID) as Ins2020

From Datos_Personales Dp

) as Sub 
where Sub.Ins2018 > Sub.Ins2019 and Sub.Ins2019 > Sub.Ins2020

------------------------------------------16-------------------------------------------------------
--Listado de apellido y nombres de usuarios que hayan realizado cursos pero nunca se hayan certificado.
--Aclaración: Listado con apellidos y nombres de usuarios que hayan realizado al menos un curso y no se hayan certificado nunca.

Select Dp.Apellidos, U.NombreUsuario from Datos_Personales Dp 
inner join Usuarios U on U.ID = Dp.ID 
inner join Inscripciones I2 on I2.IDUsuario = U.ID
where U.ID not in (Select I.ID from Inscripciones I 
                   inner join Certificaciones Ce on Ce.IDInscripcion = I.ID
                   where Ce.IDInscripcion = I.ID
)
group by Dp.Apellidos, U.NombreUsuario
-------------------------------------------------------------------------------------------
Select Dp.Apellidos, U.NombreUsuario from Datos_Personales Dp 
Inner Join Usuarios U on U.ID = Dp.ID
Inner Join Inscripciones I on I.IDUsuario = U.ID 
where U.ID not in (Select I2.IDUsuario from Inscripciones I2
                   Inner Join Certificaciones C2 on C2.IDInscripcion = I2.ID) and 
                   U.ID in (select I2.IDUsuario from Inscripciones I2)
group by Dp.Apellidos, U.NombreUsuario
