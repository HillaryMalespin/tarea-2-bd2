-- -- Cambiamos al contexto de la base de datos
USE WideWorldImporters;
GO

-- Paso 1: Confirmar el nivel de aislamiento actual
DBCC USEROPTIONS;
GO

-- Configuramos el nivel de aislamiento REPEATABLE READ
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

BEGIN TRAN;

-- Primera lectura del registro (esto activa el bloqueo)
SELECT CustomerID, CustomerName, GETDATE() AS HoraLectura
FROM Sales.Customers
WHERE CustomerID = 2;

-- No COMMIT ni ROLLBACK todavía.
-- Dejamos la transacción abierta para mantener el bloqueo
-- (Ventana abierta y sin cerrar la transacción)

-- Segunda lectura - será IDÉNTICA gracias a REPEATABLE READ
SELECT CustomerID, CustomerName, GETDATE() AS HoraSegundaLectura
FROM Sales.Customers
WHERE CustomerID = 2;

-- Una vez que confirmamos o revertimos la transacción,
-- la Session B podrá continuar su ejecución.
COMMIT TRAN;
-- o, alternativamente:
-- ROLLBACK TRAN;ía