*Ejercicio 8. (2 horas)
*Realizar un reporte con el comando WRITE para listar todas las compañías con todos sus vuelos,
*mostrando el origen y el destino.
*En la pantalla de selección se deberá tener un rango para filtrar por número de vuelo (SPFLI-CONNID).
**Acceder a la tabla SPFLI con CONNID = rango de selección de la pantalla de selección y recuperar:
*Carrid (Compañía)
*Connid (Numero de vuelo)
*Cityfrom (Ciudad de origen)
*Cityto (ciudad destino)
**Con todas las entradas recuperadas en la selección anterior, acceder a la tabla SCARR con:
*Carrid = SPFLI-carrid
*Y recuperar:
*carrid (Compañía)
*carrname (Nombre de la compañía).
*Con los resultados obtenidos armar la tabla final, recorriendo la tabla obtenida en el primer acceso y
*leyendo los datos faltantes de la segunda tabla.
*Los datos a mostrar deberán estar ordenados por compañía.
*Luego mostrar la tabla final recorriéndola y usando el comando WRITE.
*PD: Existe posibilidad de mejorar el rendimiento del programa? Como??

*&---------------------------------------------------------------------*
*& Report  Z_EJ8_ANTO
*&---------------------------------------------------------------------*
REPORT  z_ej8_anto.
*&---------------------------------------------------------------------*
*& TABLES
*&---------------------------------------------------------------------*
TABLES: spfli,
        scarr.
*&---------------------------------------------------------------------*
*& TYPES
*&---------------------------------------------------------------------*
TYPES: BEGIN OF ty_spfli,
         carrid TYPE spfli-carrid,
         connid TYPE spfli-connid,
         cityfrom TYPE spfli-cityfrom,
         cityto TYPE spfli-cityto,
       END OF ty_spfli,

       BEGIN OF ty_scarr,
         carrid TYPE scarr-carrid,
         carrname TYPE scarr-carrname,
         END OF ty_scarr,

       BEGIN OF ty_nueva,
         carrid TYPE spfli-carrid,
         connid TYPE spfli-connid,
         carrname TYPE scarr-carrname,
         cityfrom TYPE spfli-cityfrom,
         cityto TYPE spfli-cityto,
         END OF ty_nueva.
TYPES: ity_scarr TYPE TABLE OF ty_scarr,
       ity_spfli  TYPE TABLE OF ty_spfli.
*&---------------------------------------------------------------------*
*& DATA
*&---------------------------------------------------------------------*
DATA: wa_spfli TYPE ty_spfli,
      it_spfli TYPE ity_spfli,
      wa_scarr TYPE ty_scarr,
      it_scarr TYPE ity_scarr,
      wa_nueva TYPE ty_nueva,
      it_nueva TYPE TABLE OF ty_nueva.
*&---------------------------------------------------------------------*
*& SELECT-OPTIONS
*&---------------------------------------------------------------------*
SELECT-OPTIONS: so_conid FOR spfli-connid.
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
*&---------------------------------------------------------------------*
*&      Form  F_NUEVA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_nueva .

  "Se ordenan las tablas por el campo principal que las une.
  SORT: it_spfli BY carrid,
        it_scarr BY carrid.
* CON ESTE LOOP METEMOS LOS DATOS DE LAS TABLAS DE LOS SELECTS EN LA WA FINAL
  LOOP AT it_spfli INTO wa_spfli.
    CLEAR: wa_scarr.

    READ TABLE it_scarr INTO wa_scarr
         WITH KEY carrid = wa_spfli-carrid
                  BINARY SEARCH.

    IF sy-subrc EQ 0.
      wa_nueva-carrname = wa_scarr-carrname.
    ENDIF.

    wa_nueva-carrid   = wa_spfli-carrid.
    wa_nueva-connid   = wa_spfli-connid.
    wa_nueva-cityfrom = wa_spfli-cityfrom.
    wa_nueva-cityto   = wa_spfli-cityto.
* CON EL APPEND PASAMOS LOS DATOS DE LA WA ANTERIOR LLENADA CON
*LOS DATOS DE LAS SPFLI Y SCARR EN LA TABLA INTERNA FINAL A MOSTRAR
    APPEND wa_nueva TO it_nueva.
    CLEAR: wa_nueva.
  ENDLOOP.

  LOOP AT it_nueva INTO wa_nueva.

    WRITE: / '|', wa_nueva-carrid,
             '|', wa_nueva-connid,
             '|', wa_nueva-cityfrom,
             '|', wa_nueva-cityto,
             '|', wa_nueva-carrname.
  ENDLOOP.

ENDFORM.                    " F_NUEVA
