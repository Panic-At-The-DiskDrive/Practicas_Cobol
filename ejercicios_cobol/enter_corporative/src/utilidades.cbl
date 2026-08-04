       IDENTIFICATION DIVISION.
       PROGRAM-ID. UTILIDADES.

      *****************************************************************
      * PROGRAMA:
      * UTILIDADES
      *
      * DESCRIPCION:
      * Rutinas generales utilizadas por el sistema bancario.
      *****************************************************************

       ENVIRONMENT DIVISION.

       DATA DIVISION.

       WORKING-STORAGE SECTION.

       COPY CONSTANTES.
       COPY MENSAJES.

       01  WS-OPCION                PIC 9.
       01  WS-MONTO                 PIC S9(11)V99.
       01  WS-RESPUESTA             PIC X.

       LINKAGE SECTION.

       01  LK-ACCION                PIC X(20).

       01  LK-NUMERO                PIC 9(8).

       01  LK-MONTO                 PIC S9(11)V99.

       01  LK-RETORNO               PIC X.

       PROCEDURE DIVISION USING
           LK-ACCION
           LK-NUMERO
           LK-MONTO
           LK-RETORNO.

           EVALUATE LK-ACCION

               WHEN "VALIDAR-OPCION"
                   PERFORM 1000-VALIDAR-OPCION

               WHEN "VALIDAR-MONTO"
                   PERFORM 2000-VALIDAR-MONTO

               WHEN "CONFIRMAR"
                   PERFORM 3000-CONFIRMAR

               WHEN "LIMPIAR"
                   PERFORM 4000-LIMPIAR

               WHEN "ENCABEZADO"
                   PERFORM 5000-ENCABEZADO

               WHEN OTHER
                   MOVE "N" TO LK-RETORNO

           END-EVALUATE

           GOBACK.

      *****************************************************************
      * VALIDA LA OPCION DEL MENU
      *****************************************************************

       1000-VALIDAR-OPCION.

           IF WS-OPCION >= 0
           AND WS-OPCION <= 7

               MOVE "S"
                   TO LK-RETORNO

           ELSE

               MOVE "N"
                   TO LK-RETORNO

           END-IF.

      *****************************************************************
      * VALIDA MONTOS POSITIVOS
      *****************************************************************

       2000-VALIDAR-MONTO.

           IF LK-MONTO > 0

               MOVE "S"
                   TO LK-RETORNO

           ELSE

               MOVE "N"
                   TO LK-RETORNO

           END-IF.

      *****************************************************************
      * SOLICITA CONFIRMACION
      *****************************************************************

       3000-CONFIRMAR.

           DISPLAY MSG-CONFIRMAR

           ACCEPT WS-RESPUESTA

           IF WS-RESPUESTA = RESPUESTA-SI

               MOVE "S"
                   TO LK-RETORNO

           ELSE

               MOVE "N"
                   TO LK-RETORNO

           END-IF.

      *****************************************************************
      * LIMPIA VARIABLES DE TRABAJO
      *****************************************************************

       4000-LIMPIAR.

           MOVE ZERO
               TO WS-OPCION

           MOVE ZERO
               TO WS-MONTO

           MOVE SPACE
               TO WS-RESPUESTA

           MOVE ZERO
               TO LK-NUMERO

           MOVE ZERO
               TO LK-MONTO

           MOVE SPACE
               TO LK-RETORNO.

      *****************************************************************
      * MUESTRA EL ENCABEZADO
      *****************************************************************

       5000-ENCABEZADO.

           DISPLAY SPACE

           DISPLAY MSG-TITULO-PRINCIPAL
           DISPLAY MSG-NOMBRE-SISTEMA
           DISPLAY MSG-SEPARADOR

           DISPLAY SPACE.