      *****************************************************************
      * COPYBOOK: MENSAJES.CPY
      * DESCRIPCION:
      * Mensajes utilizados por el Sistema Bancario Empresarial.
      *****************************************************************

       01  MENSAJES-SISTEMA.

      *****************************************************************
      * TITULOS
      *****************************************************************

           05 MSG-TITULO-PRINCIPAL        PIC X(60)
              VALUE "==============================================".

           05 MSG-NOMBRE-SISTEMA          PIC X(60)
              VALUE "        SISTEMA BANCARIO EMPRESARIAL".

           05 MSG-SEPARADOR               PIC X(60)
              VALUE "==============================================".

      *****************************************************************
      * MENU PRINCIPAL
      *****************************************************************

           05 MSG-MENU-01                 PIC X(40)
              VALUE "1 - Alta de cuenta".

           05 MSG-MENU-02                 PIC X(40)
              VALUE "2 - Consultar cuenta".

           05 MSG-MENU-03                 PIC X(40)
              VALUE "3 - Depositar dinero".

           05 MSG-MENU-04                 PIC X(40)
              VALUE "4 - Retirar dinero".

           05 MSG-MENU-05                 PIC X(40)
              VALUE "5 - Transferencia".

           05 MSG-MENU-06                 PIC X(40)
              VALUE "6 - Listar cuentas".

           05 MSG-MENU-07                 PIC X(40)
              VALUE "7 - Cerrar cuenta".

           05 MSG-MENU-00                 PIC X(40)
              VALUE "0 - Salir".

      *****************************************************************
      * ENTRADAS
      *****************************************************************

           05 MSG-INGRESE-OPCION          PIC X(40)
              VALUE "Seleccione una opcion:".

           05 MSG-INGRESE-CUENTA          PIC X(40)
              VALUE "Numero de cuenta:".

           05 MSG-INGRESE-SUCURSAL        PIC X(40)
              VALUE "Sucursal:".

           05 MSG-INGRESE-NOMBRE          PIC X(40)
              VALUE "Nombre:".

           05 MSG-INGRESE-APELLIDO        PIC X(40)
              VALUE "Apellido:".

           05 MSG-INGRESE-DOCUMENTO       PIC X(40)
              VALUE "Numero de documento:".

           05 MSG-INGRESE-MONTO           PIC X(40)
              VALUE "Ingrese el monto:".

           05 MSG-INGRESE-DESTINO         PIC X(40)
              VALUE "Cuenta destino:".

           05 MSG-CONFIRMAR               PIC X(40)
              VALUE "Confirma la operacion (S/N):".

      *****************************************************************
      * OPERACIONES
      *****************************************************************

           05 MSG-ALTA-CUENTA             PIC X(40)
              VALUE "*** ALTA DE CUENTA ***".

           05 MSG-CONSULTA                PIC X(40)
              VALUE "*** CONSULTA DE CUENTA ***".

           05 MSG-DEPOSITO                PIC X(40)
              VALUE "*** DEPOSITO ***".

           05 MSG-RETIRO                  PIC X(40)
              VALUE "*** RETIRO ***".

           05 MSG-TRANSFERENCIA           PIC X(40)
              VALUE "*** TRANSFERENCIA ***".

           05 MSG-LISTADO                 PIC X(40)
              VALUE "*** LISTADO DE CUENTAS ***".

           05 MSG-CIERRE                  PIC X(40)
              VALUE "*** CIERRE DE CUENTA ***".

      *****************************************************************
      * EXITO
      *****************************************************************

           05 MSG-CUENTA-CREADA           PIC X(50)
              VALUE "Cuenta creada correctamente.".

           05 MSG-DEPOSITO-OK            PIC X(50)
              VALUE "Deposito realizado correctamente.".

           05 MSG-RETIRO-OK              PIC X(50)
              VALUE "Retiro realizado correctamente.".

           05 MSG-TRANSFERENCIA-OK       PIC X(50)
              VALUE "Transferencia realizada correctamente.".

           05 MSG-CUENTA-CERRADA         PIC X(50)
              VALUE "Cuenta cerrada correctamente.".

           05 MSG-ACTUALIZACION-OK       PIC X(50)
              VALUE "Registro actualizado correctamente.".

      *****************************************************************
      * ERRORES
      *****************************************************************

           05 MSG-ERROR-GENERAL          PIC X(50)
              VALUE "Ha ocurrido un error en la operacion.".

           05 MSG-ARCHIVO               PIC X(50)
              VALUE "Error al acceder al archivo.".

           05 MSG-CUENTA-EXISTE         PIC X(50)
              VALUE "La cuenta ya existe.".

           05 MSG-CUENTA-NO-EXISTE      PIC X(50)
              VALUE "La cuenta no existe.".

           05 MSG-CUENTA-CERRADA-ERR    PIC X(50)
              VALUE "La cuenta se encuentra cerrada.".

           05 MSG-CUENTA-BLOQUEADA      PIC X(50)
              VALUE "La cuenta esta bloqueada.".

           05 MSG-SALDO-INSUFICIENTE    PIC X(50)
              VALUE "Saldo insuficiente.".

           05 MSG-MONTO-INVALIDO        PIC X(50)
              VALUE "El monto ingresado es invalido.".

           05 MSG-DATOS-INVALIDOS       PIC X(50)
              VALUE "Los datos ingresados son invalidos.".

           05 MSG-OPCION-INVALIDA       PIC X(50)
              VALUE "Opcion invalida.".

      *****************************************************************
      * INFORMACION
      *****************************************************************

           05 MSG-SALDO-ACTUAL          PIC X(25)
              VALUE "Saldo actual:".

           05 MSG-TITULAR               PIC X(25)
              VALUE "Titular:".

           05 MSG-ESTADO                PIC X(25)
              VALUE "Estado:".

           05 MSG-TIPO-CUENTA           PIC X(25)
              VALUE "Tipo de cuenta:".

           05 MSG-MONEDA               PIC X(25)
              VALUE "Moneda:".

           05 MSG-DESPEDIDA            PIC X(50)
              VALUE "Gracias por utilizar el Sistema Bancario.".
             