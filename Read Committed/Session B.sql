-- Cambiamos al contexto de la base de datos
USE WideWorldImporters;
GO

-- Paso 1: Confirmar el nivel de aislamiento actual
DBCC USEROPTIONS;
GO

-- Configuramos el nivel de aislamiento READ COMMITTED
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- Intentamos leer el mismo registro que Session A modificó
SELECT CustomerID, CustomerName
FROM Sales.Customers
WHERE CustomerID = 2;