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

-- No COMMIT ni ROLLBACK todavía.
-- Dejamos la transacción abierta para simular un cambio pendiente.
-- (Ventana abierta y sin cerrar la transacción)

-- Una vez que confirmamos o revertimos la transacción,
-- la Session B podrá continuar su ejecución.
ROLLBACK TRAN;
-- o, alternativamente:
-- COMMIT TRAN;