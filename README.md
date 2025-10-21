# Tarea: Microsoft SQL Server – Isolation Levels  
---

## ¿Qué es el aislamiento (Isolation Level)?

El **nivel de aislamiento** (Isolation Level) en una base de datos define **qué tan visible** es una transacción para otras transacciones concurrentes.  
En otras palabras, controla **qué fenómenos de concurrencia** pueden ocurrir (como lecturas sucias o inconsistentes) y **cómo se gestionan los bloqueos y versiones de datos** durante la ejecución simultánea de consultas.

Según la documentación de Microsoft (2024):

> "El nivel de aislamiento de una transacción determina el grado en que una transacción debe estar aislada de los efectos de otras transacciones concurrentes."  
> — [Microsoft Docs: SET TRANSACTION ISOLATION LEVEL (Transact-SQL)](https://learn.microsoft.com/en-us/sql/t-sql/statements/set-transaction-isolation-level-transact-sql)

---

## Niveles de aislamiento

## 1. Nivel de aislamiento: Read Uncommitted

### Definición

`READ UNCOMMITTED` es el **nivel de aislamiento más bajo** en SQL Server.  
Permite que una transacción lea datos que **todavía no han sido confirmados** (es decir, datos modificados por otra transacción que podría revertirse).  
Esto puede provocar lecturas sucias (*dirty reads*).

### Riesgos

- Lecturas sucias (dirty reads): se leen datos que podrían revertirse.  
- Lecturas no repetibles (non-repeatable reads): los datos pueden cambiar entre consultas.  
- Lecturas fantasmas (phantom reads): pueden aparecer o desaparecer filas.

### Uso recomendado

Se usa principalmente para **consultas de solo lectura o reportes rápidos**, donde la precisión absoluta no es crítica, pero la velocidad sí lo es.

### Paso a paso:
1. Preparación:
  1.1 Abre **SQL Server Management Studio (SSMS)**.  
  1.2  Conéctate al servidor donde tengas instalada la base de datos **WorldWideImporters**.  
  1.3 Abre **dos ventanas de consulta**:  
     - **Session A**, para modificar datos.  
     - **Session B**, para leer datos simultáneamente.
  
2. Configuración inicial
Ejecuta lo siguiente en **ambas sesiones**:

```sql
USE WorldWideImporters;
GO
DBCC USEROPTIONS;
GO
```

Esto mostrará el nivel de aislamiento actual, que por defecto suele ser READ COMMITTED.

3. Ejecución del escenario
**Sesión A**
Ejecuta la siguiente transacción:
```sql
BEGIN TRAN;
UPDATE Sales.Customers
SET CustomerName = 'Cliente Temporal'
WHERE CustomerID = 1;
```
> No confirmes la transacción (no ejecutes COMMIT ni ROLLBACK).
> Mantén esta sesión abierta para simular una modificación pendiente.

**Sesión B**
Ejecuta en una segunda ventana:
```sql
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SELECT CustomerID, CustomerName
FROM Sales.Customers
WHERE CustomerID = 1;
```
> En esta sesión verás el nombre "Cliente Temporal", aunque la transacción en la otra sesión no ha sido confirmada.
> Esto evidencia el fenómeno de lectura sucia (dirty read).

4. Verificación de lo que pasó

En **Session A**, ejecuta:
```sql
ROLLBACK TRAN;
```
Después, vuelve a consultar desde **Session B**:
```sql
SELECT CustomerID, CustomerName
FROM Sales.Customers
WHERE CustomerID = 1;
```
> El valor regresará al original.
> Esto demuestra que Session B leyó un dato no confirmado que luego fue revertido.

## Referencias

> Microsoft. (2024). SET TRANSACTION ISOLATION LEVEL (Transact-SQL).
> — https://learn.microsoft.com/en-us/sql/t-sql/statements/set-transaction-isolation-level-transact-sql
> SQL Shack. (2023). Dirty Reads and the Read Uncommitted Isolation Level.
> — https://www.sqlshack.com/dirty-reads-and-the-read-uncommitted-isolation-level/
> Anton Dev Tips. (2022). Complete Guide to Transaction Isolation Levels in SQL.
> — https://antondevtips.com/blog/complete-guide-to-transaction-isolation-levels-in-sql
> Understanding Isolation Level by Example (Read Uncommitted)
> — https://youtu.be/9ZyxJbPlw-E?si=I9R7DsXhzBSjQhel
