-- Cambiamos al contexto de la base de datos
USE WideWorldImporters;
GO

-- Paso 1: Confirmar el nivel de aislamiento actual
DBCC USEROPTIONS;
GO

-- Configuramos el nivel de aislamiento SERIALIZABLE
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

BEGIN TRAN;

-- Lectura de un rango de registros (esto activa bloqueos de rango)
SELECT CustomerID, CustomerName, GETDATE() AS HoraLectura
FROM Sales.Customers
WHERE CustomerID BETWEEN 1 AND 5;

-- No COMMIT ni ROLLBACK todavía.
-- Dejamos la transacción abierta para mantener los bloqueos
-- (Ventana abierta y sin cerrar la transacción)

-- Segunda lectura - será IDÉNTICA gracias a SERIALIZABLE
SELECT CustomerID, CustomerName, GETDATE() AS HoraSegundaLectura
FROM Sales.Customers
WHERE CustomerID BETWEEN 1 AND 5;

-- Una vez que confirmamos o revertimos la transacción,
-- la Session B podrá continuar su ejecución.
COMMIT TRAN;
-- o, alternativamente:
-- ROLLBACK TRAN;