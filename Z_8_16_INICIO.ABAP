*Ejercicio 16. (2 horas)
*Modificar el programa del ejercicio 8 de Reportes, agregándole a los parámetros de entrada
*un checkbox "Generar archivo" y un campo donde se ingresará
*la ruta del servidor donde será guardado el archivo.
*Cuando este checkbox esté tildado, dentro de la lógica se deberá agregar
*una nueva subrutina llamada Form f_crear_archivo.
*Dentro de esta subrutina, con la misma tabla que se realizó la impresión por pantalla,
*se debe crear un archivo ‘.txt’ con el nombre ‘lista_fecha_hora.txt’
*donde fecha y hora se saca de la fecha y hora del sistema.
*El formato del archivo debe ser el mismo que al imprimirlo por pantalla,
*separando cada campo por un ‘;’.
*NOTA: Para poder visualizar el archivo ir a la transacción AL11.

*&---------------------------------------------------------------------*
*& Report  Z_EJ8_ANTO
*&---------------------------------------------------------------------*
REPORT  z_ej8_anto_introducing_16.
*&---------------------------------------------------------------------*
*& INCLUDES
*&---------------------------------------------------------------------*
INCLUDE z_ej8_anto_introducing_16_top.
INCLUDE z_ej8_anto_introducing_16_scr.
INCLUDE z_ej8_anto_introducing_16_f01.

*&---------------------------------------------------------------------*
*& PARTE EJERCICIO 16
*&---------------------------------------------------------------------*

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_bajar.
  PERFORM f_browser.

START-OF-SELECTION.
*&---------------------------------------------------------------------*
*& ESTO ES PARA QUE SI NO SE SELECCIONA LA RUTA (PATH) SALTE MSJ DE ERROR
*&---------------------------------------------------------------------*
  IF p_chk IS NOT INITIAL
       AND p_bajar IS INITIAL.
    "   MESSAGE text-004 TYPE 'E'. HACER ASI
    MESSAGE i208(00) WITH text-004 DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING. "ESTA FORMA ES PARA QUE EL PROGRAMA NO SE CORTE
  ENDIF.
*&---------------------------------------------------------------------*
*& SELECTS - SE INTEGRAN LOS DATOS DE LAS DOS TABLAS EN UNA FINAL
*&---------------------------------------------------------------------*
  SELECT carrid connid cityfrom cityto
    FROM spfli
    INTO TABLE it_spfli
    WHERE connid IN so_conid.

  IF sy-subrc = 0.
    SORT it_spfli BY connid.

    SELECT carrid carrname
      FROM scarr
      INTO TABLE it_scarr
      FOR ALL ENTRIES IN it_spfli
      WHERE carrid = it_spfli-carrid.

    IF sy-subrc = 0.
      SORT it_scarr BY carrid.
    ENDIF.
  ENDIF.
  CLEAR: it_nueva, wa_nueva.
  PERFORM f_nueva.

  IF p_chk = abap_true
    AND p_bajar IS NOT INITIAL.
    PERFORM f_bajar.
  ENDIF.


*  ESTO ES SOLO PARA SERVIDORES, VA DONDE VA EL GUI_DOWNLOAD
*
*  OPEN DATASET P_BAJAR FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
*  TRANSFER 'ANTONELLA TIZZANO' TO P_BAJAR.
*  CLOSE DATASET P_BAJAR.
