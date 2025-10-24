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

---

## 2. Nivel de aislamiento: Read Committed

### Definición

`READ COMMITTED` es el **nivel de aislamiento predeterminado** en SQL Server.  
Solo permite leer **datos confirmados (committed)**, bloqueando temporalmente las filas que están siendo modificadas por otra transacción.  
Evita las **lecturas sucias**, aunque aún pueden ocurrir **lecturas no repetibles** o **fantasmas**.

### Riesgos

-  No se permiten lecturas sucias.  
-  Puede haber **lecturas no repetibles** (el mismo registro puede cambiar entre lecturas).  
-  Puede haber **lecturas fantasmas** (nuevas filas pueden aparecer en consultas repetidas).

### Uso recomendado

Ideal para **sistemas transaccionales comunes**, donde se busca un equilibrio entre **rendimiento y consistencia**.  
Es el nivel predeterminado de SQL Server y uno de los más utilizados en entornos de producción.

---

### Paso a paso

#### 1. Preparación

1.1 Abre **SQL Server Management Studio (SSMS)**.  
1.2 Conéctate al servidor con la base de datos **WorldWideImporters**.  
1.3 Crea **dos ventanas de consulta**:  
   - **Session A**, para modificar datos.  
   - **Session B**, para consultar datos en paralelo.

---

#### 2. Configuración inicial

Ejecuta en **ambas sesiones**:

```sql
USE WorldWideImporters;
GO
DBCC USEROPTIONS;
GO
```
Esto mostrará el nivel de aislamiento actual.

3. Ejecución del escenario
**Sesión A**
Ejecuta la siguiente transacción:
```sql
BEGIN TRAN;
UPDATE Sales.Customers
SET CustomerName = 'Cliente Temporal RC'
WHERE CustomerID = 2;
```
> Mantener la transaccion abierta (sin ejecutar COMMIT ni ROLLBACK).
> Esto simula una operación que aún no ha sido confirmada.

**Sesión B**
Ejecuta la siguiente transacción:
```sql
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

SELECT CustomerID, CustomerName
FROM Sales.Customers
WHERE CustomerID = 2;
```
> En esta sesión, la consulta no se ejecutará inmediatamente.
> SQL Server bloqueará la lectura hasta que la transacción en Session A sea confirmada o revertida, garantizando que solo se lean datos confirmados.

4. Confirmación del comportamiento
En **Session A**, ejecuta:
```sql
ROLLBACK TRAN;
-- o, alternativamente:
-- COMMIT TRAN;
```
> Una vez que se ejecuta este comando, la Session B finalmente mostrará el valor original del registro.
> Esto demuestra que READ COMMITTED evita las lecturas sucias, ya que no permite acceder a datos no confirmados.

---

## 3. Nivel de aislamiento: Repeatable read

### Definición

Este nivel evita que otros usuarios modifiquen las filas que una transacción ya ha leído hasta que la transacción finalice.
Sin embargo, sí permite la lectura de nuevas filas que cumplen una condición después de que la transacción haya iniciado.

### Riesgos

-  Permite lecturas fantasma.
-  Usa bastantes bloqueos.

### Uso recomendado

Cuando se ocupa garantizar que los valores leídos no cambien durante la transacción.

---

### Paso a paso

1.1 Abrir **SQL Server Management Studio (SSMS)**.  
1.2 Entrar al directorio Repeatable Read de este repositorio.  
1.3 Ejecutar las transacciones contenidas en los archivos Session A.sql y
Session B.sql guiándose con los comentarios proporcionados.  

---


## 4. Nivel de aislamiento: Serializable

### Definición

Es el nivel más estricto de aislamiento estándar. La transacción se comporta como si se ejecutara
de forma completamente secuencial con respecto a las demás. Evita modificaciones y también la
inserción de nuevas filas que cumplan las condiciones de búsqueda.

### Riesgos

-  Usa bastantes bloqueos.
-  Puede llevar a una ejecución más lenta de las consultas.

### Uso recomendado

Cuando la consistencia total de los datos es más importante que el rendimiento. Es ideal para procesos críticos.

---

### Paso a paso

1.1 Abrir **SQL Server Management Studio (SSMS)**.  
1.2 Entrar al directorio Serializable de este repositorio.  
1.3 Ejecutar las transacciones contenidas en los archivos Session A.sql y
Session B.sql guiándose con los comentarios proporcionados.  

---


## 5. Nivel de aislamiento: Snapshot

### Definición

Cada transacción recibe su propia copia de los datos. Los cambios hechos dentro de una transacción se ven reflejados dentro
de ella, pero no los cambios hechos de manera externa.

### Riesgos

-  Se puede perder la información modificada en transacciones rechazadas por generar conflictos de cambios.

### Uso recomendado

Transacciones que necesiten una cantidad pequeña de filas para sus operaciones o que no suelan hacer modificaciones.

---

### Paso a paso

1.1 Abrir **SQL Server Management Studio (SSMS)**.  
1.2 Conectarse a la base de datos de su preferencia.  
1.3 Abrir los archivos de prueba ubicados en el directorio Snapshot de este repositorio.  
1.4 Ejecutar el archivo Setup.sql.  
1.5 Ejecutar los ejemplos contenidos en los archivos Session A.sql y Session B.sql en el orden indicado
en los comentarios.  

---

## Referencias

> Microsoft. (2024). SET TRANSACTION ISOLATION LEVEL (Transact-SQL).
> 
> — https://learn.microsoft.com/en-us/sql/t-sql/statements/set-transaction-isolation-level-transact-sql
> 
> SQL Shack. (2023). Dirty Reads and the Read Uncommitted Isolation Level.
> 
> — https://www.sqlshack.com/dirty-reads-and-the-read-uncommitted-isolation-level/
> 
> Anton Dev Tips. (2022). Complete Guide to Transaction Isolation Levels in SQL.
> 
> — https://antondevtips.com/blog/complete-guide-to-transaction-isolation-levels-in-sql
> 
> Understanding Isolation Level by Example (Read Uncommitted)
> 
> — https://youtu.be/9ZyxJbPlw-E?si=I9R7DsXhzBSjQhel
