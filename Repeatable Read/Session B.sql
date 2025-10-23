-- Cambiamos al contexto de la base de datos
USE WideWorldImporters;
GO

-- Paso 1: Confirmar el nivel de aislamiento actual
DBCC USEROPTIONS;
GO

-- Intentamos actualizar el mismo registro que Session A está leyendo
UPDATE Sales.Customers 
SET CustomerName = 'Intento de Cambio'
WHERE CustomerID = 3;

-- Esta consulta se BLOQUEARÁ y esperará
-- porque REPEATABLE READ bloquea las filas leídas