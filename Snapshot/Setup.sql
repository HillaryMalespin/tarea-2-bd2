CREATE DATABASE Restaurante
GO
USE Restaurante
GO

ALTER DATABASE Restaurante SET
ALLOW_SNAPSHOT_ISOLATION ON

CREATE TABLE CatalogoPlatillo(
  id INT PRIMARY KEY IDENTITY(1,1),
  nombre NVARCHAR(50)
)
GO

INSERT INTO CatalogoPlatillo
VALUES ('Gallo Pinto'), ('Casado'), ('Causa limeña'), ('Rice & beans')
GO

SELECT * FROM CatalogoPlatillo
GO
