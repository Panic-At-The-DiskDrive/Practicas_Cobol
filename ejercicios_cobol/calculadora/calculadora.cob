       IDENTIFICATION DIVISION.
       PROGRAM-ID. Calculadora.
       AUTHOR. Daniel.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       77 NUM1       PIC 9(5)V99.
       77 NUM2       PIC 9(5)V99.
       77 RESULT     PIC 9(10)V99.
       77 OPCION     PIC 9.
       77 FIN        PIC X VALUE 'N'.

       PROCEDURE DIVISION.
       PRINCIPAL.
           PERFORM HASTA FIN = 'S'
               DISPLAY "==============================="
               DISPLAY "   Calculadora en COBOL"
               DISPLAY "==============================="
               DISPLAY "1. Sumar"
               DISPLAY "2. Restar"
               DISPLAY "3. Multiplicar"
               DISPLAY "4. Dividir"
               DISPLAY "5. Salir"
               DISPLAY "Ingrese opción (1-5): "
               ACCEPT OPCION

               IF OPCION = 5
                   MOVE 'S' TO FIN
               ELSE
                   DISPLAY "Ingrese primer número: "
                   ACCEPT NUM1
                   DISPLAY "Ingrese segundo número: "
                   ACCEPT NUM2

                   EVALUATE OPCION
                       WHEN 1
                           ADD NUM1 TO NUM2 GIVING RESULT
                           DISPLAY "Resultado: " RESULT
                       WHEN 2
                           SUBTRACT NUM2 FROM NUM1 GIVING RESULT
                           DISPLAY "Resultado: " RESULT
                       WHEN 3
                           MULTIPLY NUM1 BY NUM2 GIVING RESULT
                           DISPLAY "Resultado: " RESULT
                       WHEN 4
                           IF NUM2 = 0
                               DISPLAY "Error: División por cero"
                           ELSE
                               DIVIDE NUM1 BY NUM2 GIVING RESULT
                               DISPLAY "Resultado: " RESULT
                           END-IF
                       WHEN OTHER
                           DISPLAY "Opción inválida."
                   END-EVALUATE
               END-IF
               DISPLAY "Presione Enter para continuar..."
               ACCEPT OPCION
           END-PERFORM
           DISPLAY "Gracias por usar la calculadora. ¡Adiós!"
           STOP RUN.
