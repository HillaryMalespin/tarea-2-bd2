USE WideWorldImporters;
GO
DBCC USEROPTIONS;
GO

-- Simula una transacci�n que modifica datos sin confirmar
BEGIN TRAN;
UPDATE Sales.Customers
SET CustomerName = 'Cliente Temporal'
WHERE CustomerID = 1;

-- No se hace COMMIT todav�a
-- Se deja la transacci�n abierta para simular un cambio no confirmado
-- (Se mantiene esta ventana abierta)

-- Si verificacion:
ROLLBACK TRAN;