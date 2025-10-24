-- Cambiamos al contexto de la base de datos
USE WideWorldImporters;
GO

-- Paso 1: Confirmar el nivel de aislamiento actual
DBCC USEROPTIONS;
GO

-- Intentamos ACTUALIZAR el mismo registro que Session A está leyendo
UPDATE Sales.Customers 
SET CustomerName = 'Modificado - ' + CONVERT(VARCHAR, GETDATE(), 114)
WHERE CustomerID = 2;
