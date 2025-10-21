/*
=========================================================
  Ejemplo: Nivel de aislamiento READ UNCOMMITTED
  Base de datos: WorldWideImporters
  Descripción:
    Demuestra cómo el nivel READ UNCOMMITTED permite
    leer datos que aún no han sido confirmados (dirty reads).
=========================================================
*/

-- Cambiamos al contexto de la base de datos WWI
USE WideWorldImporters;
GO

-- Paso 1: Mostrar el nivel de aislamiento actual
DBCC USEROPTIONS;
GO

/*
---------------------------------------------------------
  SIMULACIÓN DE CONCURRENCIA
  Tendremos dos sesiones (Session A y Session B):
  - Session A realiza una actualización sin confirmar (BEGIN TRAN)
  - Session B intenta leer el mismo registro usando READ UNCOMMITTED
---------------------------------------------------------
*/

/* ===================== SESSION A ===================== */
-- Simula una transacción que modifica datos sin confirmar
BEGIN TRAN;

UPDATE Sales.Customers
SET CustomerName = 'Cliente Temporal'
WHERE CustomerID = 1;

-- No hacemos COMMIT todavía
-- Deja la transacción abierta para simular un cambio no confirmado
-- (mantén esta ventana abierta)

---------------------------------------------------------
-- Mientras tanto, ejecuta lo siguiente en otra sesión:
---------------------------------------------------------

/* ===================== SESSION B ===================== */
-- Configuramos el nivel de aislamiento a READ UNCOMMITTED
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SELECT CustomerID, CustomerName
FROM Sales.Customers
WHERE CustomerID = 1;

-- Aquí verás el valor 'Cliente Temporal',
-- aunque la transacción de Session A aún no se ha confirmado.
-- Esto se conoce como "Dirty Read".

/* ===================== SESSION A ===================== */
-- Si decides revertir:
ROLLBACK TRAN;

-- Ahora el valor vuelve a ser el original.
---------------------------------------------------------


/*
=========================================================
  Ejemplo: Nivel de aislamiento READ COMMITTED
  Base de datos: WorldWideImporters
  Descripción:
    
=========================================================
*/

/*
=========================================================
  Ejemplo: Nivel de aislamiento Repeatable read 
  Base de datos: 
  Descripción:
    
=========================================================
*/

/*
=========================================================
  Ejemplo: Nivel de aislamiento Serializable 
  Base de datos: 
  Descripción:
    
=========================================================
*/

/*
=========================================================
  Ejemplo: Nivel de aislamiento Snapshot
  Base de datos: 
  Descripción:
    
=========================================================
*/