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
``` 

# Ejercicio 6  
  
# Sistema de Gestión de Cuentas Bancarias – COBOL

Este proyecto es un sistema básico de gestión de cuentas bancarias desarrollado en COBOL, orientado a la práctica de conceptos fundamentales del lenguaje aplicados a un dominio bancario clásico.

El objetivo es simular operaciones esenciales de un sistema bancario legacy, manteniendo una estructura simple, clara y alineada con las buenas prácticas del lenguaje.

## Funcionalidades

El sistema permite:
- Alta de cuentas bancarias
- Consulta de cuentas por número
- Depósitos de dinero
- Extracciones con validación de saldo
- Listado completo de cuentas
- Salida del sistema

Cada cuenta contiene:
- Número de cuenta
- Titular
- Tipo de cuenta (CA / CC)
- Saldo
- Estado

Los datos se almacenan en un archivo secuencial llamado `cuentas.dat`.

## Estructura del proyecto

- `gestion_cuentas_bancarias.cbl` → Programa principal en COBOL
- `cuentas.dat` → Archivo secuencial generado por el sistema

## Tecnologías

- Lenguaje: COBOL
- Persistencia: Archivo secuencial
- Entorno recomendado: GnuCOBOL

## Ejecución

Ejemplo de compilación y ejecución con GnuCOBOL:

```bash
cobc -x gestion_cuentas_bancarias.cbl
./gestion_cuentas_bancarias
´´´  

