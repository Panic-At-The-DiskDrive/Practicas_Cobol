# Ejercicio 1

Este es un ejemplo de "Hola Mundo" escrito en COBOL, usando GnuCOBOL y Visual Studio Code.

## Requisitos

- GnuCOBOL
- VS Code + extensión `bitlang.cobol`

## Compilar

```bash
cobc -x hola.cob
```

# Ejercicio 2

Este es un ejemplo de Calculadora escrito en COBOL, usando GnuCOBOL y Visual Studio Code.  
  
# Ejercicio 3  

Este es un ejemplo basico de un login.

# Ejercicio 4  
  
Este es un ejemplo de un login compuesto, con registro.  
  
# Ejercicio 5  

# Gestión de Usuarios en COBOL

Este proyecto es un sistema básico de gestión de usuarios desarrollado en COBOL, pensado como práctica inicial para afianzar los fundamentos del lenguaje y su estructura clásica.

El objetivo del proyecto es demostrar el uso correcto de:
- División estructural de un programa COBOL
- Manejo de archivos secuenciales
- Menús interactivos por consola
- Uso de PERFORM, IF y EVALUATE
- Buenas prácticas de legibilidad y orden del código

## Funcionalidades

El programa permite:
- Dar de alta usuarios
- Listar todos los usuarios registrados
- Buscar un usuario por ID
- Salir del sistema

Cada usuario cuenta con los siguientes campos:
- ID numérico
- Nombre
- Email
- Estado (ACTIVO)

Los datos se almacenan en un archivo secuencial llamado `usuarios.dat`.

## Estructura del proyecto

- `gestion_usuarios.cbl` → Programa principal en COBOL
- `usuarios.dat` → Archivo generado automáticamente con los registros

## Requisitos

- Compilador COBOL (GnuCOBOL o compatible)
- Sistema operativo con acceso a consola

## Ejecución

Ejemplo usando GnuCOBOL:

```bash
cobc -x gestion_usuarios.cbl
./gestion_usuarios

