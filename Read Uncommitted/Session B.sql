USE WideWorldImporters;
GO
DBCC USEROPTIONS;
GO

-- Configuramos el nivel de aislamiento a READ UNCOMMITTED
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SELECT CustomerID, CustomerName
FROM Sales.Customers
WHERE CustomerID = 1;

-- Aqu� se ver� el valor 'Cliente Temporal',
-- aunque la transacci�n de Session A a�n no se ha confirmado.
-- Esto se conoce como "Dirty Read".