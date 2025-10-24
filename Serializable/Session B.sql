-- Cambiamos al contexto de la base de datos
USE WideWorldImporters;
GO

-- Paso 1: Confirmar el nivel de aislamiento actual
DBCC USEROPTIONS;
GO

-- Intentamos INSERTAR un nuevo registro en el mismo rango
INSERT INTO Sales.Customers 
(CustomerName, BillToCustomerID, CustomerCategoryID, PrimaryContactPersonID)
VALUES 
('Nuevo Cliente Serializable', 1, 1, 1);

-- Verificamos la inserción
SELECT CustomerID, CustomerName, 'Después del INSERT' AS Estado
FROM Sales.Customers 
WHERE CustomerName = 'Nuevo Cliente Serializable';