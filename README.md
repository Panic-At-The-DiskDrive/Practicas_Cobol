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
```

## Ejercicio 7  
  
# Sistema Bancario Simplificado – COBOL (v2)

Este proyecto es una evolución de un sistema bancario básico desarrollado en COBOL, incorporando conceptos clásicos del dominio bancario como la separación entre archivo maestro y archivo de movimientos.

El objetivo es practicar lógica de negocio bancaria real utilizando estructuras tradicionales del lenguaje.

## Funcionalidades

- Alta de cuentas bancarias
- Consulta de cuentas
- Depósitos
- Extracciones con validación de saldo
- Registro de movimientos
- Listado de cuentas
- Listado de movimientos

## Archivos

- `cuentas.dat` → Archivo maestro de cuentas
- `movimientos.dat` → Archivo detalle con historial de operaciones

Cada operación financiera genera un registro de movimiento con fecha, tipo, monto y saldo resultante.

## Estructura

- `sistema_bancario_v2.cbl` → Programa principal
- Persistencia mediante archivos secuenciales

## Tecnologías

- Lenguaje: COBOL
- Persistencia: Archivos secuenciales
- Compilador recomendado: GnuCOBOL

## Ejecución

```bash
cobc -x sistema_bancario_v2.cbl
./sistema_bancario_v2
```

## Ejercicio 8

Sistema de Facturación por Archivo – COBOL

Descripción

Este proyecto implementa un sistema de facturación batch desarrollado en COBOL. El programa procesa un archivo maestro de productos y un archivo de ventas, calcula subtotales, IVA (21%) y totales finales, y genera un archivo de reporte con el resultado de cada operación.

El objetivo es demostrar manejo de archivos secuenciales, lógica de negocio, cálculo decimal y control de fin de archivo en un entorno empresarial clásico. El sistema funciona completamente en modo batch, sin interacción por pantalla.

Estructura del Proyecto

facturacion.cbl → Programa principal
PRODUCTOS.DAT → Archivo maestro de productos
VENTAS.DAT → Archivo de ventas
REPORTE.TXT → Archivo generado con resultados

Funcionamiento General

Al iniciar la ejecución, el programa abre los archivos de productos y ventas en modo lectura y el archivo de reporte en modo escritura.

Por cada registro de venta:

Se busca el producto correspondiente en el archivo maestro.

Si el producto existe:

Se calcula el subtotal (precio × cantidad).

Se calcula el IVA (21%).

Se calcula el total final.

Se escribe el resultado en el archivo de reporte.

Si el producto no existe:

Se registra un mensaje de error en el reporte indicando el código inválido.

Al finalizar el procesamiento de todas las ventas, el programa cierra los archivos y termina la ejecución.

Estructura de PRODUCTOS.DAT

Archivo secuencial con el siguiente layout:

Código PIC 9(5)
Nombre PIC X(20)
Precio PIC 9(7)V99

Ejemplo:

00001Laptop 00050000
00002Mouse 00001000
00003Teclado 00002000

El precio utiliza dos decimales implícitos. Por ejemplo, 00050000 representa 500.00.

Estructura de VENTAS.DAT

Archivo secuencial con el siguiente layout:

Código PIC 9(5)
Cantidad PIC 9(5)

Ejemplo:

0000100002
0000200003
0000500001

Cada línea contiene el código del producto seguido por la cantidad vendida.

Cálculos Implementados

Subtotal = Precio × Cantidad
IVA = Subtotal × 0.21
Total = Subtotal + IVA

Todos los cálculos utilizan campos numéricos con decimales implícitos definidos en WORKING-STORAGE.

Validaciones Implementadas

Control de fin de archivo (EOF) mediante cláusula AT END.

Verificación de existencia del producto en el maestro.

Registro de errores cuando una venta referencia un producto inexistente.

Conceptos Técnicos Aplicados

División estructural clásica de COBOL (IDENTIFICATION, ENVIRONMENT, DATA y PROCEDURE).

Definición de archivos en FILE SECTION mediante FD.

Uso de archivos secuenciales.

Instrucciones READ y WRITE.

Manejo de fin de archivo.

Uso de WORKING-STORAGE para variables de control y cálculos.

Instrucción COMPUTE para operaciones aritméticas.

Instrucción STRING para generación del reporte.

Modularización mediante PERFORM.

Requisitos

Se recomienda utilizar GnuCOBOL u otro compilador compatible con COBOL estándar que soporte archivos secuenciales.

Compilación con GnuCOBOL

cobc -x facturacion.cbl

Ejecución

./facturacion

Nivel del Proyecto

Intermedio.

Demuestra procesamiento batch típico de entornos administrativos y financieros legacy, con manejo real de archivos y lógica de negocio estructurada.

Posibles mejoras futuras incluyen manejo de FILE STATUS, acumulador general de facturación, separación en subprogramas y uso de archivos indexados en lugar de secuenciales. 
  
##  