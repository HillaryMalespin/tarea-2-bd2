-- Sesión A.

USE Restaurante
GO

SET TRANSACTION ISOLATION LEVEL SNAPSHOT

-- Ejemplo 1.
BEGIN TRANSACTION                   -- [1] Inicia la transacción A. Recibe su propio snapshot.
SELECT nombre FROM CatalogoPlatillo -- [3] La transacción A realiza una lectura.
-- B realiza una escritura.
SELECT nombre FROM CatalogoPlatillo -- [6] La transacción A realiza otra lectura.
COMMIT TRANSACTION                  -- [7] Termina la transacción A.
SELECT nombre FROM CatalogoPlatillo -- [8] Se realiza una lectura fuera de la transacción anterior.

-- Ejemplo 2.
BEGIN TRANSACTION                   -- [1] Inicia la transacción A. Recibe su propio snapshot.
SELECT nombre FROM CatalogoPlatillo -- [3] La transacción A realiza una lectura.
UPDATE CatalogoPlatillo SET nombre = 'Rice & beans con carne' WHERE id = 4 -- [4] La transacción A realiza una escritura.
SELECT nombre FROM CatalogoPlatillo -- [5] La transacción A realiza otra lectura.
COMMIT TRANSACTION                  -- [9] Termina la transacción A.
SELECT nombre FROM CatalogoPlatillo -- [11] Se realiza una lectura fuera de la transacción anterior.