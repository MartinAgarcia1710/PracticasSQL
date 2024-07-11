--3.1 objetos de base de datos
--Agregar una columna a la tabla Cursos llamada DebeSerMayorDeEdad bit 
--que permita determinar si para realizar el curso el usuario debe ser 
--mayor de edad ( edad >= 18). El valor por defecto de la columna debe 
--ser un 0. Luego, modificar algunos cursos para que el valor de la 
--nueva columna sea 1.

ALTER TABLE Cursos
ADD DebeSerMayorDeEdad bit DEFAULT 0;

Update Cursos  SET DebeSerMayorDeEdad = 0
where Cursos.IDNivel = 4

go 
------------------------------1-----------------------------------------
--Hacer una función llamada FN_PagosxUsuario que a partir de un IDUsuario 
--devuelva el total abonado en concepto de pagos. Si no hay pagos debe retornar 0.

Create or Alter PROCEDURE FN_PagosxUsuario (
    @IdUsuario int
)
as 
Begin 
    Select 
    case When 
        sum(P.Importe) is Null then 0
    Else sum(P.Importe)
    End as 'Total'
    from Pagos P
    Inner join Inscripciones I on I.ID = P.IDInscripcion
    Inner Join Datos_Personales Dp on Dp.ID = I.IDUsuario
    Where @IdUsuario = Dp.ID
End


-- Verificacion
EXEC FN_PagosxUsuario 32
EXEC FN_PagosxUsuario 2
EXEC FN_PagosxUsuario 9
--Al principio No se porqué creé un Procedimiento en vez de Función, 
--Si bien trae los datos que se pide no era la consigna, abajo hago 
--la función que corresponde.
go
-------------FUNCIÓN--------------------------------------------
Create or Alter FUNCTION FN_PagosxUsuario1 (
    @IdUsuario int
)
Returns Money 
as 
Begin 
    Declare @total Money
    
    Select @total = Coalesce( sum(P.Importe),0)
    from Pagos P
    Inner join Inscripciones I on I.ID = P.IDInscripcion
    Inner Join Datos_Personales Dp on Dp.ID = I.IDUsuario
    Where @IdUsuario = Dp.ID

    Return @total
End

go
--vERIFICACIÓN
select Dp.Nombres, dbo.FN_PagosxUsuario1(Dp.ID) as 'Total' from Datos_Personales Dp
go


---------------------------------------2-------------------------------------
--Hacer una función llamada FN_DeudaxUsuario que a partir de un IDUsuario devuelva 
--el total adeudado. Si no hay deuda debe retornar 0.

Create or Alter FUNCTION FN_DeudaxUsuario(
    @IdUsuario int
)
Returns Money
as 
Begin 
    Declare @Deuda Money
    select @Deuda = Coalesce(Sum(I.Costo), 0)
    From Inscripciones I
    where @IdUsuario = I.IDUsuario

    Declare @Total Money
    Select @Total = Coalesce(Sum(P.Importe), 0)
    from Pagos P
    Inner Join Inscripciones I on I.ID = P.IDInscripcion
    where @IdUsuario = I.IDUsuario
   
    Return @Total - @Deuda
End

go

use Univ
--Verificación

SELECT dbo.FN_DeudaxUsuario(26) AS TotalDeuda

select P.Importe, P.IDInscripcion, I.IDUsuario  from Pagos P
inner join Inscripciones I on I.ID = P.IDInscripcion
order by I.IDUsuario asc

Select * from Inscripciones I 
where I.IDUsuario = 26

go
----------------------------------------3----------------------------------
--Hacer una función llamada FN_CalcularEdad que a partir de un IDUsuario 
--devuelva la edad del mismo. La edad es un valor entero.

Create or Alter Function FN_CalcularEdad(
    @IDUsuario int
)
Returns Int 
as 
Begin
    Declare @EdadDevuelvo int
    Declare @Fecha Date 
     
    Select @Fecha = Dp.Nacimiento from Datos_Personales Dp 
    where Dp.ID = @IDUsuario
    
    Set @EdadDevuelvo = DateDiff(Year,@Fecha, getDate())

    If (month(getDate()) < month(@Fecha)) or (month(getDate()) = month(@Fecha) and Day(getDate()) < day(@Fecha))
        Begin
            set @EdadDevuelvo = @EdadDevuelvo - 1 
        End 
    Return @EdadDevuelvo
End

go
--Verificacion 

select * from Datos_Personales Dp 
Where Dp.ID = 10
-- El usuario 10 nació el 24-6-1984 (39 años al día 10-6-2024)
select dbo.FN_CalcularEdad(10) as 'Edad'

----------------------------------------4------------------------------------
--Hacer una función llamada Fn_PuntajeCurso que a partir de un IDCurso 
--devuelva el promedio de puntaje en concepto de reseñas.
go
Create or Alter Function Fn_PuntajeCurso (
    @IDCurso int 
)
Returns decimal 
as 
Begin
    Declare @Promedio decimal
    Select @IDCurso = C.ID from Cursos C 
    where C.ID = @IDCurso 

    Select @Promedio = Avg(R.Puntaje) from Reseñas R
    Inner join Inscripciones I on I.ID = R.IDInscripcion
    Inner join Cursos C on C.ID = I.IDCurso
    where @IDCurso = C.ID

    Return @Promedio
End 

go 
--verificación 
Select dbo.Fn_PuntajeCurso(8) as 'Promedio'

select * from Reseñas R 
Inner join Inscripciones I on I.ID = R.IDInscripcion
Inner join Cursos C on C.ID = I.IDCurso
order by C.ID asc
go
---------------------------------------5------------------------------------------------
--Hacer una vista que muestre por cada usuario el apellido y nombre, una columna llamada 
--Contacto que muestre el celular, si no tiene celular el teléfono, si no tiene teléfono el 
--email, si no tiene email el domicilio. También debe mostrar la edad del usuario, el total
-- pagado y el total adeudado.
go

Create or Alter View VW_MostrarUsuarioContactoEdadPagoDeuda
as 
    Select 
    Dp.Nombres, 
    Dp.Apellidos,
        case 
        when Dp.Celular is not NULL then Dp.Celular
        When Dp.Telefono is not null then Dp.Telefono
        when Dp.Email is not NULL then Dp.Email
        else Dp.Domicilio 
        end as 'Contacto',
    dbo.FN_CalcularEdad(Dp.ID) as 'Edad',
    dbo.FN_PagosxUsuario1(Dp.ID) as 'Pagos',
    dbo.FN_DeudaxUsuario(Dp.ID) as 'Total Adeudado'
    From Datos_Personales Dp

go 

select * from dbo.VW_MostrarUsuarioContactoEdadPagoDeuda
go
---------------------------------6---------------------------------------
--Hacer uso de la vista creada anteriormente para obtener la cantidad de 
--usuarios que adeuden más de los que pagaron.

---------------------------------7----------------------------------------
--Hacer un procedimiento almacenado que permita dar de alta un nuevo curso. 
--Debe recibir todos los valores necesarios para poder insertar un nuevo registro.

Create or Alter Procedure SP_NuevoCurso(
    @IDNivel Tinyint, 
    @Nombre Varchar(100),
    @CostoCurso Money,
    @CostoCertificacion Money,
    @Estreno Date, 
    @DebeSerMayorDeEdad bit
)
as 
Begin 
    If @Nombre is null Begin 
        Raiserror('Debe ingresar un nombre', 16, 0)
        Return 
    End 
    If @CostoCurso is null Begin 
        Raiserror('Debe ingresar un costo del curso', 16, 0)
        Return 
    End
    If @CostoCertificacion is null Begin 
        Raiserror('Debe ingresar un costo de certificación', 16, 0)
        Return 
    End
    If @Estreno is null Begin 
        Raiserror('Debe ingresar una Fecha', 16, 0)
        Return 
    End

    Insert into Cursos (IDNivel, Nombre, CostoCurso, CostoCertificacion, Estreno, DebeSerMayorDeEdad)
    values (@IDNivel, @Nombre, @CostoCurso, @CostoCertificacion, @Estreno, @DebeSerMayorDeEdad)
End 

go

Exec SP_NuevoCurso 2, 'Reparacion', 15000, 10000, '2024-6-10', 1 
select * from Cursos
go 
-----------------------------------8---------------------------------------
--Hacer un procedimiento almacenado que permita modificar porcentualmente el 
--Costo de Cursada de todos los cursos. El procedimiento debe recibir un valor 
--numérico que representa el valor a aumentar porcentualmente. Por ejemplo, 
--si recibe un 60. Debe aumentar un 60% todos los costos.

Create or Alter Procedure SP_Aumentar(
    @Porcentaje int
)
as 
Begin 
    Declare @costo Money
    
    Update Cursos  Set CostoCurso = CostoCurso + CostoCurso * @Porcentaje / 100 
End

--Verificación
EXEC SP_Aumentar 100 
Select * from Cursos


---------------------------------------9--------------------------------------------
--Hacer un procedimiento almacenado llamado SP_PagarInscripcion que a partir de un 
--IDInscripcion permita hacer un pago de la inscripción. El pago puede ser menor al 
--costo de la inscripción o bien el total del mismo. El sistema no debe permitir que 
--el usuario pueda abonar más dinero para una inscripción que el costo de la misma. 
--Se debe registrar en la tabla de pagos con la información que corresponda.
go

Create or Alter Procedure SP_PagarInscripcion(
    @IDInscripcion Int,
    @monto Money
)
as 
Begin 
    Declare @Aux Money 
    Select @Aux = C.CostoCurso from Cursos C 
    Inner Join Inscripciones I on C.ID = I.IDCurso
    where @IDInscripcion = I.ID

    
    if @monto > @Aux Begin 
        Raiserror('No se puede abonar más de lo que la inscripción vale', 16, 1)
        Return
    End  
    
    Insert into Pagos (IDInscripcion, Fecha, Importe)
    values (@IDInscripcion, GetDate(), @monto)
End

EXEC SP_PagarInscripcion 1, 100000
select * from pagos