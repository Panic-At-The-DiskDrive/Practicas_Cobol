      *****************************************************************
      * COPYBOOK: CONSTANTES.CPY
      * DESCRIPCION:
      * Constantes generales del sistema bancario.
      *****************************************************************

       01  CONSTANTES-SISTEMA.

      *****************************************************************
      * ESTADOS DE CUENTA
      *****************************************************************

           05  CTE-CUENTA-ACTIVA           PIC X VALUE "S".
           05  CTE-CUENTA-CERRADA          PIC X VALUE "N".

           05  CTE-BLOQUEADA              PIC X VALUE "S".
           05  CTE-NO-BLOQUEADA           PIC X VALUE "N".

      *****************************************************************
      * TIPOS DE CUENTA
      *****************************************************************

           05  CTE-CAJA-AHORRO            PIC XX VALUE "CA".
           05  CTE-CUENTA-CORRIENTE       PIC XX VALUE "CC".

      *****************************************************************
      * MONEDAS
      *****************************************************************

           05  CTE-PESOS                  PIC XXX VALUE "ARS".
           05  CTE-DOLARES                PIC XXX VALUE "USD".

      *****************************************************************
      * CODIGOS DE OPERACION
      *****************************************************************

           05  CTE-ALTA                   PIC 9 VALUE 1.
           05  CTE-CONSULTA               PIC 9 VALUE 2.
           05  CTE-DEPOSITO               PIC 9 VALUE 3.
           05  CTE-RETIRO                 PIC 9 VALUE 4.
           05  CTE-TRANSFERENCIA          PIC 9 VALUE 5.
           05  CTE-LISTADO                PIC 9 VALUE 6.
           05  CTE-CIERRE                 PIC 9 VALUE 7.
           05  CTE-SALIR                  PIC 9 VALUE 0.

      *****************************************************************
      * FILE STATUS
      *****************************************************************

           05  FS-OK                      PIC XX VALUE "00".
           05  FS-FIN-ARCHIVO             PIC XX VALUE "10".
           05  FS-DUPLICADO               PIC XX VALUE "22".
           05  FS-NO-EXISTE               PIC XX VALUE "23".
           05  FS-ARCHIVO-INEXISTENTE     PIC XX VALUE "35".

      *****************************************************************
      * VALORES NUMERICOS
      *****************************************************************

           05  CTE-CERO                   PIC 9 VALUE 0.
           05  CTE-UNO                    PIC 9 VALUE 1.
           05  CTE-DIEZ                   PIC 99 VALUE 10.
           05  CTE-CIEN                   PIC 999 VALUE 100.

      *****************************************************************
      * LIMITES DEL SISTEMA
      *****************************************************************

           05  LIM-MONTO-DEPOSITO
                                           PIC 9(9)V99
                                           VALUE 999999999.99.

           05  LIM-MONTO-RETIRO
                                           PIC 9(9)V99
                                           VALUE 500000.00.

           05  LIM-DESCUBIERTO
                                           PIC 9(9)V99
                                           VALUE 100000.00.

           05  SALDO-INICIAL
                                           PIC 9(9)V99
                                           VALUE 0.00.

      *****************************************************************
      * RESPUESTAS
      *****************************************************************

           05  RESPUESTA-SI               PIC X VALUE "S".
           05  RESPUESTA-NO               PIC X VALUE "N".

      *****************************************************************
      * BOOLEANOS
      *****************************************************************

           05  FLAG-VERDADERO             PIC X VALUE "S".
           05  FLAG-FALSO                 PIC X VALUE "N".

      *****************************************************************
      * ESPACIOS
      *****************************************************************

           05  ESPACIO                    PIC X VALUE SPACE.

           05  ESPACIOS-30                PIC X(30)
                                           VALUE SPACES.

           05  ESPACIOS-50                PIC X(50)
                                           VALUE SPACES.

      *****************************************************************
      * FECHA VACIA
      *****************************************************************

           05  FECHA-VACIA.
               10 FEC-AAAA                PIC 9(4) VALUE ZEROS.
               10 FEC-MM                  PIC 9(2) VALUE ZEROS.
               10 FEC-DD                  PIC 9(2) VALUE ZEROS.