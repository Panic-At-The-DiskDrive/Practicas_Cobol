      *****************************************************************
      * COPYBOOK: CUENTA.CPY
      * DESCRIPCION:
      * Estructura estándar del registro de cuentas bancarias.
      *****************************************************************

       01  REGISTRO-CUENTA.

           05  CTA-NUMERO.
               10 CTA-SUCURSAL           PIC 9(4).
               10 CTA-ID                 PIC 9(8).

           05  CTA-CLIENTE.
               10 CTA-NOMBRE             PIC X(30).
               10 CTA-APELLIDO           PIC X(30).

           05  CTA-DOCUMENTO.
               10 CTA-TIPO-DOC           PIC X(03).
               10 CTA-NRO-DOC            PIC 9(10).

           05  CTA-DOMICILIO.
               10 CTA-CALLE              PIC X(40).
               10 CTA-NUMERO-CALLE       PIC 9(05).
               10 CTA-CIUDAD             PIC X(30).
               10 CTA-PROVINCIA          PIC X(30).
               10 CTA-CODIGO-POSTAL      PIC X(08).

           05  CTA-CONTACTO.
               10 CTA-TELEFONO           PIC X(20).
               10 CTA-EMAIL              PIC X(50).

           05  CTA-DATOS-BANCARIOS.
               10 CTA-TIPO               PIC X(02).
                  88 CTA-CAJA-AHORRO     VALUE "CA".
                  88 CTA-CTA-CTE         VALUE "CC".

               10 CTA-MONEDA            PIC X(03).
                  88 CTA-PESOS          VALUE "ARS".
                  88 CTA-DOLARES        VALUE "USD".

               10 CTA-SALDO             PIC S9(11)V99.

               10 CTA-LIMITE-DESCUBIERTO
                                          PIC S9(11)V99.

           05  CTA-ESTADO.
               10 CTA-ACTIVA            PIC X.
                  88 CUENTA-ACTIVA      VALUE "S".
                  88 CUENTA-CERRADA     VALUE "N".

               10 CTA-BLOQUEADA         PIC X.
                  88 BLOQUEADA          VALUE "S".
                  88 NO-BLOQUEADA       VALUE "N".

           05  CTA-FECHAS.
               10 CTA-FECHA-ALTA.
                  15 CTA-ALTA-AAAA      PIC 9(4).
                  15 CTA-ALTA-MM        PIC 9(2).
                  15 CTA-ALTA-DD        PIC 9(2).

               10 CTA-ULT-MOVIMIENTO.
                  15 CTA-MOV-AAAA       PIC 9(4).
                  15 CTA-MOV-MM         PIC 9(2).
                  15 CTA-MOV-DD         PIC 9(2).

           05  CTA-CONTROL.
               10 CTA-CANT-DEPOSITOS    PIC 9(5).
               10 CTA-CANT-RETIROS      PIC 9(5).
               10 CTA-CANT-TRANSFER     PIC 9(5).

           05  CTA-RESERVADO.
               10 FILLER                PIC X(100).
              