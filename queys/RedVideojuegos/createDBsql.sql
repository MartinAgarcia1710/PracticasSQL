-- RedVideoJuegos es una base de datos destinada a una red social donde distintos usuarios
-- podrán crearse una cuenta y postear reseñas de distintos videojuegos, entre usuarios 
-- podrán, también comentar y dar likes reseñas creadas. La red social está en desarrollo
-- usando las tecnologías C# dentro del framework ASP .NET. Esto está destinado a practicar
-- lo aprendido en las materias Laboratorio de computación 3 y Programación 3. En otros
-- scripts se realizarán Store Procedure, triggers y vistas que se necesiten para 
-- fortalecer la seguridad y optimizar el code behind de la app.

Create DataBase RedVideoJuegos 
go

use RedVideoJuegos
go

-- Creacion de tablas dentro de un try y transaccion, si falla no se crea nada

Begin Try
    Begin Transaction

        Create Table Paises(
            ID Int Not Null Primary Key Identity(1, 1),
            Nombre VarChar(100) Not Null Unique 
        )

        Create Table Avatares(
            ID BigInt Not Null Primary Key Identity(1, 1),
            Localizacion VarChar(1000) Not Null,
            Estado Bit Not Null
        )

        Create Table Generos_Usuarios(
            ID Int Not Null Primary Key Identity(1, 1),
            Nombre VarChar(50) Not Null Unique
        )

        Create Table Rangos(
            ID Int Not null Primary Key Identity(1, 1),
            Nombre VarChar(50) Not Null Unique,
            Estado Bit Null
        )
        Create Table Usuarios(
            ID BigInt Not Null Primary Key Identity(1, 1),
            ID_Avatar BigInt Null Foreign Key References Avatares(ID),
            NickName VarChar(30) Not Null,
            Email VarChar(150) Not Null Unique,
            Contrasenia VarChar(15) Not Null,
            FechaIngreso Date Not Null,
            FechaUltimaConexion DateTime Not Null,
            ID_Pais_Origen Int Not Null Foreign Key References Paises(ID),
            ID_Genero Int Null Foreign Key References Generos_Usuarios(ID),
            Cantidad_Comentarios BigInt Not Null,
            Cantidad_Likes_Recibidos BigInt Not Null,
            Cantidad_Likes_Dados BigInt not null,
            Cantidad_Resenias BigInt Not Null,
            ID_Grado Int Not Null,
            Estado Bit Not Null,
            Constraint chk_caracteresNickName Check (NickName Like '%[^a-zA-Z0-9_]%')
        )

        Create Table Trofeos(
            ID Int Not Null Primary Key Identity(1, 1),
            Nombre VarChar(100) Not Null,
            Estado Bit Null 
        )

        Create Table Trofeos_Por_Usuarios(
            ID_Trofeo Int Not Null Foreign Key References Trofeos(ID),
            ID_Usuario BigInt Not Null Foreign Key References Usuarios(ID),
            Primary Key(ID_Trofeo, ID_USuario)
        )

        Create Table Seguimientos(
            ID BigInt Not Null Primary Key Identity(1, 1),
            ID_Usuario BigInt Not Null Foreign Key References Usuarios(ID),
            ID_Seguidor BigInt Not Null Foreign Key References Usuarios(ID),
            Fecha DateTime Not Null,
            Estado Bit Not Null,
            Constraint Unk_Seguimientos Unique(ID_Usuario, ID_Seguidor)
        )

        Create Table Franquicias(
            ID BigInt Primary Key Identity(1, 1),
            Nombre VarChar(150) Not Null Unique,
            FechaPrimerTitulo Date Not Null
        )

        Create Table Ideadores(
            ID BigInt Primary Key Identity(1, 1),
            Nombre_Apellido Varchar(250) Not Null Unique,
            ID_Pais_Origen Int Null Foreign Key References Paises(ID)
        )

        Create Table VideoJuegos(
            ID BigInt Primary Key Identity(1, 1),
            Titulo VarChar(200) Not Null Unique,
            ID_Ideador BigInt Null Foreign Key References Ideadores(ID),
            ID_Franquicia BigInt Null Foreign Key References Franquicias(ID),
            Lanzamiento Date Not Null,
            ID_Pais_Origen Int Null Foreign Key References Paises(ID),
            Estado Bit Not Null
        )


        Create Table Generos_VideoJuegos(
            ID BigInt Primary Key Identity(1, 1),
            Nombre VarChar(100) Not Null
        )

        Create Table Generos_por_VideoJuegos(
            ID_Genero BigInt Foreign Key References Generos_VideoJuegos(ID),
            ID_VideoJuego BigInt Foreign Key References VideoJuegos(ID)
        ) 

        Create Table Logos_Imagenes(
            ID BigInt Not Null Primary Key Identity(1,1),
            Ubicacion VarChar(1000) Not Null
        )

        Create Table Marcas_Consolas(
            ID BigInt Primary Key Identity(1, 1),
            Nombre VarChar(50) Not Null Unique,
            Descripcion VarChar(500) Null,
            Fundacion Date Null,
            ID_Pais_Origen Int Null Foreign Key References Paises(ID),
            ID_Imagen_Logo BigInt Null Foreign Key References Logos_Imagenes(ID),    
            Estado Bit Not Null
        )

        Create Table Generaciones_Consolas(
            ID BigInt Primary Key Identity(1, 1),
            Numero Int Not Null,
            Nombre Varchar(50) Null
        )

        Create Table Consolas(
            ID BigInt Primary Key Identity(1, 1),
            ID_Marca BigInt Foreign Key References Marcas_Consolas(ID),
            ID_Generacion BigInt Foreign Key References Generaciones_Consolas(ID),
            Nombre VarChar(100) Not Null,
            Lanzamiento Date Not Null,
            ID_imagen_Logo BigInt Null Foreign Key References Logos_Imagenes(ID),
            Estado Bit Not Null
        )

        Create Table Desarrolladoras(
            ID BigInt Primary Key Identity(1, 1),
            Nombre VarChar(50) Not Null,
            Fundacion Date Null,
            ID_Pais_Origen Int Null Foreign Key References Paises(ID),
            Estado Bit Not Null
        )

        Create Table Tipos_Estudio(
            ID BigInt Primary Key Identity(1, 1),
            Descripcion Varchar(200) Not Null
        )

        Create Table Estudios(
            ID BigInt Primary key Identity(1, 1),
            Nombre VarChar(100) Not Null Unique,
            ID_Tipo BigInt Not Null Foreign Key References Tipos_Estudio(ID),
            Estado Bit Not Null,
            ID_Pais_Origen Int Null Foreign Key References Paises(ID),
            ID_Imagen_Logo BigInt Null Foreign Key References Logos_Imagenes(ID),    
            Descripcion Varchar(300) Null
        )

        Create Table Directores(
            ID BigInt Primary Key Identity(1, 1),
            Nombre_Apellido VarChar(150) Not Null Unique,
            ID_Pais_Origen Int Null Foreign Key References Paises(ID)
        )

        Create Table Mercadeo(
            ID Int not Null Primary Key identity(1, 1),
            Nombre VarChar(20) Not Null Unique,
        )

        Create Table Versiones(
            ID BigInt Not Null Primary Key Identity(1, 1),
            Descripcion VarChar(250) Null,
            Lanzamiento Date Null,
            ID_Desarrolladora BigInt Null Foreign Key References Desarrolladoras(ID),
            ID_Director BigInt Null Foreign Key References Directores(ID),
            ID_VideoJuego BigInt Not Null Foreign Key References VideoJuegos(ID),
            ID_Mercadeo Int Null,
            ID_Consola BigInt Not Null Foreign Key References Consolas(ID),
            Estado Bit Not Null
        )

        Create Table Imagenes_Versiones(
            ID Int Not Null Primary Key Identity (1, 1),
            ID_Version BigInt Not Null Foreign Key References Versiones(ID),
            Localizacion VarChar(1000) Not Null
        )

        Create Table Versiones_por_Estudios(
            ID_Version BigInt Not Null Foreign Key References Versiones(ID),
            ID_Estudio BigInt Not Null Foreign Key References Estudios(ID),
            Constraint Unk_Repeticiones Unique(ID_Version, ID_Estudio)
        )

        Create Table Idiomas(
            ID Int Not Null Primary Key Identity (1, 1),
            Nombre Varchar(30) Not Null Unique
        )

        Create Table Interacciones(
            ID Int Not Null Primary Key Identity(1, 1),
            Nombre VarChar(100) Not Null,
        )

        Create Table Idiomas_por_Interacciones(
            ID_Idioma Int Not Null Foreign Key References Idiomas(ID),
            ID_Interaccion Int Not Null Foreign Key References Interacciones(ID),
            ID_Version BigInt Not Null Foreign Key References Versiones(ID)
        )

        Create Table Resenias(
            ID BigInt Not Null Primary Key Identity(1, 1),
            ID_Version BigInt Not Null Foreign Key References Versiones(ID),
            ID_Usuario BigInt Not Null Foreign Key References Usuarios(ID),
            Calificacion SmallInt Not Null,
            Fecha_Hora DateTime Not Null,
            Observaciones VarChar(500) Null,
            Constraint Chk_Calificacion check(Calificacion between 1 and 5),
            Constraint Unk_Resenia_Por_Version Unique(ID_Version, ID_Usuario)
        )

        Create Table Comentarios(
            ID BigInt Not Null Primary Key Identity(1, 1),
            ID_Resenia BigInt Not Null Foreign Key References Resenias(ID),
            ID_Usuario_Comentador BigInt Not Null Foreign Key References Usuarios(ID),
            Mensaje varChar(500) Not Null,
            Estado Bit Null,
            Fecha_Hora DateTime Not Null
        )

        Create Table Likes(
            ID BigInt Not Null Primary Key Identity(1, 1),
            ID_Resenia BigInt Not Null Foreign Key References Resenias(ID),
            ID_Usuario_Que_Da BigInt Not Null Foreign Key References Usuarios(ID),
            Estado Bit Null,
            Fecha_Hora DateTime Not Null
        )

    Commit Transaction
End Try 
Begin Catch 

    Rollback transaction 
End Catch
