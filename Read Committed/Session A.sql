-- Cambiamos al contexto de la base de datos
USE WideWorldImporters;
GO

-- Paso 1: Confirmar el nivel de aislamiento actual
DBCC USEROPTIONS;
GO

BEGIN TRAN;

UPDATE Sales.Customers
SET CustomerName = 'Cliente Temporal RC'
WHERE CustomerID = 2;

-- No COMMIT ni ROLLBACK todav�a.
-- Dejamos la transacci�n abierta para simular un cambio pendiente.
-- (Ventana abierta y sin cerrar la transacci�n)

-- Una vez que confirmamos o revertimos la transacci�n,
-- la Session B podr� continuar su ejecuci�n.
ROLLBACK TRAN;
-- o, alternativamente:
-- COMMIT TRAN;