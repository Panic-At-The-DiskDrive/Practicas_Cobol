CREATE TABLE CLIENTES
(
    ID          INTEGER       NOT NULL PRIMARY KEY,
    NOMBRE      VARCHAR(50)   NOT NULL,
    APELLIDO    VARCHAR(50)   NOT NULL,
    EMAIL       VARCHAR(100)  NOT NULL
);

INSERT INTO CLIENTES (ID, NOMBRE, APELLIDO, EMAIL)
VALUES
    (1, 'Juan', 'Pérez', 'juan.perez@email.com'),
    (2, 'María', 'Gómez', 'maria.gomez@email.com'),
    (3, 'Carlos', 'Rodríguez', 'carlos.rodriguez@email.com');