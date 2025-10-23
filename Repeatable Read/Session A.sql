-- Cambiamos al contexto de la base de datos
USE WideWorldImporters;
GO

-- Paso 1: Confirmar el nivel de aislamiento actual
DBCC USEROPTIONS;
GO

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
BEGIN TRAN;

-- Leemos un cliente específico
SELECT CustomerID, CustomerName
FROM Sales.Customers
WHERE CustomerID = 3;

-- Mantenemos la transacción abierta para demostrar el bloqueo
-- NO ejecutar COMMIT todavía