--Create DataBase RedVideoJuegos 
--go

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

go 



-- Los comentarios no pueden darse de baja física, solo lógica,
-- este trigger impide que se borre.
Create or Alter Trigger Tr_Desactivar_Comentario on Comentarios
Instead of Insert 
As 
Begin 
    Begin Try 
        Begin Transaction 
            Declare @ID BigInt
            Declare @ID_Reseña BigInt
            Declare @Mensaje VarChar(500)
            Declare @Estado Bit 
            Declare @Fecha_Hora DateTime 

            Select
                @ID = I.ID,
                @ID_Reseña = I.ID_Resenia,
                @Mensaje = I.Mensaje,
                @Estado = I.Estado,
                @Fecha_Hora = I.Fecha_Hora
            From Inserted I

        Update Comentarios set Estado = 0 
        Where ID = @ID  

        Commit Transaction 
    End Try 
    Begin Catch
        Print Error_Message()
        RollBack Transaction 
    End Catch

End

-- Cuando el usuario cambia la imagen de avatar, esta debe actualizar la ruta,
-- no agregarse una nueva. Quizá este trigger no sea necesario pero considero
-- que fortalece la seguridad de la base de datos. Si desea no tener imagen de 
-- avatar esta se pondrá una por defecto
go

Create or Alter Trigger Tr_Borrar_Avatares on Avatares 
Instead of Delete 
As 
Begin 
    Begin Try
        Begin Transaction 
            Declare @ID BigInt
            Declare @Localizacion Varchar(1000)
            Declare @Estado Bit 

            Select 
                @ID = I.ID,
                @Localizacion = I.Localizacion,
                @Estado = I.Estado 
            From Inserted I

            if @Estado = 0 Begin 
                Update Avatares Set Localizacion = 'https://img.freepik.com/vector-premium/no-hay-foto-disponible-icono-vector-simbolo-imagen-predeterminado-imagen-proximamente-sitio-web-o-aplicacion-movil_87543-10615.jpg'
            End 

        Commit Transaction 
    End Try 
    Begin Catch
        print Error_Message()
        RollBack Transaction  
    End Catch 
End 

-- Las reseñas no pueden tener baja física, solo lógica y debe ocurrir lo 
-- mismo con los comentarios y likes que hayan recibido 
go 

Create or Alter Trigger Tr_Borrar_Resenias on Resenias 
Instead of Delete 
As 
Begin 
    Begin Transaction 
        Declare @ID BigInt 
        Declare @ID_Version BigInt 
        Declare @ID_Usuario BigInt
        Declare @Calificacion SmallInt 
        Declare @Fecha_Hora DateTime 
        Declare @Observaciones VarChar(500)

        Select 
            @ID = I.ID,
            @ID_Version = I.ID_Version, 
            @ID_Usuario = I.ID_Usuario,
            @Calificacion = I.Calificacion,
            @Fecha_Hora = I.Fecha_Hora,
            @Observaciones = I.Observaciones 
        From Inserted I

        Update Likes set Estado = 0
        Where ID_Resenia = @ID

        Update Comentarios set Estado = 0 
        Where ID_Resenia = @ID

    Commit Transaction 
End 


-- Vistas 
-- 1. Vista para ver todas las cantidades de reseñas, comentarios hechos, 
-- likes recibidos y likes dados.
go 

Create or Alter View Vw_Estadisticas_Usuarios 
As 
Select 
    U.NickName as 'Nombre de Usuario', 
    U.Email as 'Correo electrónico', 
    (Select count(*) from Resenias R where R.ID_Usuario = U.ID ) as 'Reseñas comentadas',
    (Select count(*) From Likes L
     Inner Join Resenias R on R.ID = L.ID_Resenia
     where R.ID_Usuario = U.ID ) as 'Likes recibidos',
    (Select count(*) From Likes L 
     where L.ID_Usuario_Que_Da = U.ID) as 'Likes dados',
    (Select count(*) From Comentarios C
     Where C.ID_Usuario_Comentador = U.ID ) as 'Comentarios hechos'
from Usuarios U

go 

