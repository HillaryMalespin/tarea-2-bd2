USE WideWorldImporters;
GO
DBCC USEROPTIONS;
GO

-- Configuramos el nivel de aislamiento a READ UNCOMMITTED
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SELECT CustomerID, CustomerName
FROM Sales.Customers
WHERE CustomerID = 1;

-- Aquí se verá el valor 'Cliente Temporal',
-- aunque la transacción de Session A aún no se ha confirmado.
-- Esto se conoce como "Dirty Read".