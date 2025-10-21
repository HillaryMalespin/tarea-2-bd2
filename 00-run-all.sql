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

-- No se hace COMMIT todavía
-- Se deja la transacción abierta para simular un cambio no confirmado
-- (Se mantiene esta ventana abierta)

---------------------------------------------------------
-- Mientras tanto, en otra sesión:
---------------------------------------------------------

/* ===================== SESSION B ===================== */
-- Configuramos el nivel de aislamiento a READ UNCOMMITTED
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SELECT CustomerID, CustomerName
FROM Sales.Customers
WHERE CustomerID = 1;

-- Aquí se verá el valor 'Cliente Temporal',
-- aunque la transacción de Session A aún no se ha confirmado.
-- Esto se conoce como "Dirty Read".

/* ===================== SESSION A ===================== */
-- Si decides revertir:
ROLLBACK TRAN;

-- Ahora el valor vuelve a ser el original.

/* ===================== SESSION B ===================== */
SELECT CustomerID, CustomerName
FROM Sales.Customers
WHERE CustomerID = 1;
------------------------------------------------------------
--------------------FIN-------------------------------------
------------------------------------------------------------



/*
=========================================================
  Ejemplo: Nivel de aislamiento READ COMMITTED
  Base de datos: WorldWideImporters
  Descripción:
    
=========================================================
*/
-- Cambiamos al contexto de la base de datos
USE WideWorldImporters;
GO

-- Paso 1: Confirmar el nivel de aislamiento actual
DBCC USEROPTIONS;
GO

/*
---------------------------------------------------------
  SIMULACIÓN DE CONCURRENCIA
  Se utilizarán dos sesiones (Session A y Session B)
  para demostrar el comportamiento del nivel READ COMMITTED.

  - Session A: modifica un registro sin confirmar (BEGIN TRAN)
  - Session B: intenta leer ese registro
---------------------------------------------------------
*/

---------------------------------------------------------
-- =============== SESSION A ============================
---------------------------------------------------------
BEGIN TRAN;

UPDATE Sales.Customers
SET CustomerName = 'Cliente Temporal RC'
WHERE CustomerID = 2;

-- No COMMIT ni ROLLBACK todavía.
-- Dejamos la transacción abierta para simular un cambio pendiente.
-- (Ventana abierta y sin cerrar la transacción)
---------------------------------------------------------


---------------------------------------------------------
-- =============== SESSION B ============================
---------------------------------------------------------
-- Configuramos el nivel de aislamiento READ COMMITTED
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- Intentamos leer el mismo registro que Session A modificó
SELECT CustomerID, CustomerName
FROM Sales.Customers
WHERE CustomerID = 2;

-- Comportamiento esperado:
-- La consulta quedará bloqueada (en espera)
-- hasta que Session A confirme (COMMIT) o revierta (ROLLBACK) su transacción.
---------------------------------------------------------


---------------------------------------------------------
-- =============== SESSION A (Continuación) =============
---------------------------------------------------------
-- Una vez que confirmamos o revertimos la transacción,
-- la Session B podrá continuar su ejecución.
ROLLBACK TRAN;
-- o, alternativamente:
-- COMMIT TRAN;
---------------------------------------------------------


-- Mientras Session A mantenía la transacción abierta,
-- Session B no pudo leer el registro (lectura bloqueada).

-- Al ejecutar ROLLBACK o COMMIT en Session A,
-- Session B finalmente accedió al valor confirmado.
------------------------------------------------------------
--------------------FIN-------------------------------------
------------------------------------------------------------


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