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

