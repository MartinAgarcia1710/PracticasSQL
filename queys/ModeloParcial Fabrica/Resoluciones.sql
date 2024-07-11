Use ModeloExamenIntegrador_20241C
go
-----------------------------------------------

---------------------------1----------------------------------------------------
--La fábrica quiere evitar que empleados sin experiencia mayor a 5 años puedan
--generar producciones de piezas cuyo costo unitario de producción supere los $ 15.
--Hacer un trigger que asegure esta comprobación para registros de producción cuya
--fecha sea mayor a la actual. En caso de poder registrar la información, calcular el
--costo total de producción.
--(30 puntos)


Create or Alter Trigger Tr_EmpleadosSinExperiencia on Produccion 
After Insert 
as 
Begin 
begin Try
    Declare @FechaIngresoOperario smallint
    Declare @PrecioDePieza Money 
    Declare @IdOperario bigint
    Declare @IDPieza bigint 
    Declare @CostoPieza Money
    Declare @Medida decimal 
    Declare @Cantidad int
    --Declare @total Money 

Begin Transaction 
    Select 
        @IDPieza = I.IDPieza,
        @IdOperario = I.IDOperario,
        @FechaIngresoOperario = Op.AnioAlta,
        @IDPieza = I.IDPieza,
        @CostoPieza = Pi.CostoUnitarioProduccion,
        @Medida = I.Medida,
        @Cantidad = I.Cantidad
    From Inserted I
    Inner Join Operarios Op on Op.IDOperario = I.IDOperario
    Inner join Piezas Pi on Pi.IDPieza = I.IDPieza
    
    If year(GetDate()) - @FechaIngresoOperario  < 5 And @CostoPieza > 15 Begin 
    Rollback Transaction 
    Raiserror('El operario cuenta con menos de 5 años de experiencia y la pieza cuesta mas de $15', 16, 1)
    Return 
    End

    Insert into Produccion (IDOperario, IDPieza, Fecha, Medida, Cantidad, CostoTotal)
    Values (@IdOperario, @IDPieza, getDate(), @Medida, @Cantidad, @Cantidad * @CostoPieza)
Commit Transaction
End Try
Begin Catch
    RollBack Transaction 
    Raiserror('Error', 16, 1)

End Catch
End

select * from Piezas
select * from Produccion
Select * from Operarios


Insert into Produccion (IDOperario, IDPieza, Fecha, Medida, Cantidad, CostoTotal)
    Values (20, 14, getDate(), 1, 3, 50)


------------------------------------2----------------------------------------------------
-- Hacer un listado que permita visualizar el nombre del material, el nombre de la pieza
--y la cantidad de operarios que nunca produjeron esta pieza.
--(20 puntos)

Declare @CantidadOperarios Int
Select @CantidadOperarios = Count(*) From Operarios
Select 
    M.Nombre as Material, 
    P.Nombre as Pieza,
    @CantidadOperarios - (Select Count(distinct IDOperario) From Produccion Where IDPieza = P.IDPieza) as CantOperarios
From Materiales M 
Inner Join Piezas P ON M.IDMaterial = P.IDMaterial

-------------------------------------3---------------------------------------------------
--Hacer un procedimiento almacenado llamado Punto_3 que reciba el nombre de un
--material y un valor porcentual (admite 2 decimales) y modifique el precio unitario de
--producción a partir de este valor porcentual a todas las piezas que sean de este
--material.
--Por ejemplo:
-- *Si el procedimiento recibe 'Acero' y 50. Debe aumentar el precio unitario de
--producción de todas las piezas de acero en un 50%.
-- *Si el procedimiento recibe 'Vidrio' y -25. Debe disminuir el precio unitario de
--producción de todas las piezas de vidrio en un 25%.
--NOTA: No se debe permitir hacer un descuento del 100% ni un aumento mayor al
--1000%.
--(20 puntos)
go 

Create or Alter Procedure SP_Punto_3(
    @NombreMaterial varchar(50),
    @Porcentaje Decimal(6,2)

)
As 
Begin
    
    If @Porcentaje not between -100 and 1000 Begin 
        RAISERROR('no se puede modificar precio', 16, 0)
        Return
    End

    Declare @idMaterial smallint 
    Select @idMaterial = Ma.IDMaterial  From Materiales Ma 
    Where Ma.Nombre like @NombreMaterial
    Update Piezas Set CostoUnitarioProduccion = CostoUnitarioProduccion + CostoUnitarioProduccion * @Porcentaje / 100 
    Where Piezas.IDMaterial = @idMaterial
    


End 

go 
Select * from Materiales
Select * from Piezas



Exec dbo.SP_Punto_3 'Plástico', 50


go

--------------------------4----------------------------------------------------
--Hacer un procedimiento almacenado llamado Punto_4 que reciba dos fechas y
--calcule e informe el costo total de todas las producciones que se registraron entre
--esas fechas.
--(10 puntos)

Create or Alter Procedure SP_Punto_4(
    @FechaUNO Date,
    @FechaDos Date 
)
As 
Begin 

    Select Coalesce(Sum(Pr.CostoTotal), 0) as 'Total entre las fechas ingresadas' from Produccion Pr
    where Pr.Fecha BETWEEN @FechaUNO and @FechaDos 

End

Select * from Produccion

Exec dbo.SP_Punto_4 '2023-01-15', '2023-05-25'

---------------------------------5--------------------------------------------
--Hacer un listado que permita visualizar el nombre de cada material y el costo total de
--las producciones estropeadas de ese material. Sólo listar aquellos registros que
--totalicen un costo total mayor a $100.
--(20 puntos)

Select Ma.Nombre, Pr.CostoTotal from Materiales Ma
Inner join Piezas Pi on Pi.IDMaterial = Ma.IDMaterial
Inner Join Produccion Pr on Pr.IDPieza = Pi.IDPieza
where (Pr.Medida > Pi.MedidaMaxima or Pr.Medida < Pi.MedidaMinima) And Pr.CostoTotal > 100




Select M.Nombre as Material, Sum(PRO.CostoTotal) As CostoTotalEstropeado
From Materiales M
Inner Join Piezas P ON M.IDMaterial = P.IDMaterial
Inner Join Produccion PRO ON PRO.IDPieza = P.IDPieza
Where PRO.Medida Not Between P.MedidaMinima And P.MedidaMaxima
Group by M.Nombre
Having SUM(PRO.CostoTotal) > 100