-- Sesión B.

USE Restaurante
GO

SET TRANSACTION ISOLATION LEVEL SNAPSHOT

-- Ejemplo 1.
BEGIN TRANSACTION -- [2] Inicia la transacción B. Recibe su propio snapshot.
UPDATE CatalogoPlatillo SET nombre = 'Arroz y frijoles' WHERE id = 4 -- [4] La transacción B realiza una escritura.
SELECT nombre FROM CatalogoPlatillo
COMMIT TRANSACTION -- [5] Termina la transacción B.

-- Ejemplo 2.
BEGIN TRANSACTION                   -- [2] Inicia la transacción B. Recibe su propio snapshot.
SELECT nombre FROM CatalogoPlatillo -- [6] La transacción B realiza una lectura.
UPDATE CatalogoPlatillo SET nombre = 'Rice & beans con pollo' WHERE id = 4 -- [7] La transacción B realiza una escritura.
SELECT nombre FROM CatalogoPlatillo -- [8] La transacción B realiza otra lectura.
COMMIT TRANSACTION                  -- [10] Termina la transacción B.