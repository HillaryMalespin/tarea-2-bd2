/*
=========================================================
  Ejemplo: Nivel de aislamiento READ UNCOMMITTED
  Base de datos: WorldWideImporters
  Descripci�n:
    Demuestra c�mo el nivel READ UNCOMMITTED permite
    leer datos que a�n no han sido confirmados (dirty reads).
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
  SIMULACI�N DE CONCURRENCIA
  Tendremos dos sesiones (Session A y Session B):
  - Session A realiza una actualizaci�n sin confirmar (BEGIN TRAN)
  - Session B intenta leer el mismo registro usando READ UNCOMMITTED
---------------------------------------------------------
*/

/* ===================== SESSION A ===================== */
-- Simula una transacci�n que modifica datos sin confirmar
BEGIN TRAN;

UPDATE Sales.Customers
SET CustomerName = 'Cliente Temporal'
WHERE CustomerID = 1;

-- No se hace COMMIT todav�a
-- Se deja la transacci�n abierta para simular un cambio no confirmado
-- (Se mantiene esta ventana abierta)

---------------------------------------------------------
-- Mientras tanto, en otra sesi�n:
---------------------------------------------------------

/* ===================== SESSION B ===================== */
-- Configuramos el nivel de aislamiento a READ UNCOMMITTED
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SELECT CustomerID, CustomerName
FROM Sales.Customers
WHERE CustomerID = 1;

-- Aqu� se ver� el valor 'Cliente Temporal',
-- aunque la transacci�n de Session A a�n no se ha confirmado.
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
  Descripci�n:
    
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
  SIMULACI�N DE CONCURRENCIA
  Se utilizar�n dos sesiones (Session A y Session B)
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

-- No COMMIT ni ROLLBACK todav�a.
-- Dejamos la transacci�n abierta para simular un cambio pendiente.
-- (Ventana abierta y sin cerrar la transacci�n)
---------------------------------------------------------


---------------------------------------------------------
-- =============== SESSION B ============================
---------------------------------------------------------
-- Configuramos el nivel de aislamiento READ COMMITTED
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- Intentamos leer el mismo registro que Session A modific�
SELECT CustomerID, CustomerName
FROM Sales.Customers
WHERE CustomerID = 2;

-- Comportamiento esperado:
-- La consulta quedar� bloqueada (en espera)
-- hasta que Session A confirme (COMMIT) o revierta (ROLLBACK) su transacci�n.
---------------------------------------------------------


---------------------------------------------------------
-- =============== SESSION A (Continuaci�n) =============
---------------------------------------------------------
-- Una vez que confirmamos o revertimos la transacci�n,
-- la Session B podr� continuar su ejecuci�n.
ROLLBACK TRAN;
-- o, alternativamente:
-- COMMIT TRAN;
---------------------------------------------------------


-- Mientras Session A manten�a la transacci�n abierta,
-- Session B no pudo leer el registro (lectura bloqueada).

-- Al ejecutar ROLLBACK o COMMIT en Session A,
-- Session B finalmente accedi� al valor confirmado.
------------------------------------------------------------
--------------------FIN-------------------------------------
------------------------------------------------------------


/*
=========================================================
  Ejemplo: Nivel de aislamiento REPEATABLE READ
  Base de datos: WorldWideImporters
  Descripción:
    Demuestra cómo REPEATABLE READ evita lecturas no repetibles
    bloqueando las filas leídas, pero permite lecturas fantasmas.
=========================================================
*/

USE WideWorldImporters;
GO

-- Mostrar nivel actual
DBCC USEROPTIONS;
GO

/* ===================== SESSION A ===================== */
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
BEGIN TRAN;

SELECT CustomerID, CustomerName
FROM Sales.Customers
WHERE CustomerID = 3;

-- Mantener transacción abierta para demostrar bloqueo
-- NO EJECUTAR COMMIT TODAVÍA

/* ===================== SESSION B ===================== */
-- Esta actualización se BLOQUEARÁ hasta que Session A haga COMMIT
UPDATE Sales.Customers 
SET CustomerName = 'Cliente Modificado RR'
WHERE CustomerID = 3;

/* ===================== SESSION A ===================== */
-- Lectura repetida - el valor será consistente
SELECT CustomerID, CustomerName
FROM Sales.Customers
WHERE CustomerID = 3;

COMMIT TRAN;  -- Ahora Session B puede ejecutarse

/* ===================== SESSION B ===================== */
-- Verificar que la actualización se realizó
SELECT CustomerID, CustomerName
FROM Sales.Customers
WHERE CustomerID = 3;
------------------------------------------------------------

/*
=========================================================
  Ejemplo: Nivel de aislamiento Serializable 
  Base de datos: 
  Descripci�n:
    
=========================================================
*/

/*
=========================================================
  Ejemplo: Nivel de aislamiento Snapshot
  Base de datos: 
  Descripci�n:
    
=========================================================
*/