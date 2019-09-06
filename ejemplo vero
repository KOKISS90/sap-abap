*&---------------------------------------------------------------------*
*& Report  Z_EJEMPLO_VERO_1
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  z_ejemplo_vero_2.
*&---------------------------------------------------------------------*
*& TABLES
*&---------------------------------------------------------------------*
TABLES: spfli.
*&---------------------------------------------------------------------*
*& Declaración de types
*&---------------------------------------------------------------------*
TYPES: BEGIN OF ty_alumno,
          nombre    TYPE char30,
          apellido  TYPE c      LENGTH 30,
          user      TYPE sy-uname,
          fechanac  TYPE d,
          direccion TYPE char50,
  END OF ty_alumno.

TYPES  ity_alumno  TYPE STANDARD TABLE OF ty_alumno.



*&---------------------------------------------------------------------*
*& Declaración de datos
*&---------------------------------------------------------------------*
DATA: it_alumno TYPE ity_alumno,
      wa_alumno TYPE ty_alumno.


*&---------------------------------------------------------------------*
*& Declaración de Pantalla
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.

SELECTION-SCREEN SKIP.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-002.
PARAMETERS: p_nom  TYPE char30 OBLIGATORY DEFAULT 'VERO',    "nombre
            p_ape  TYPE char30,  " apellido
            p_user TYPE sy-uname.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN SKIP.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE text-004.
PARAMETER p_fnac TYPE sy-datum OBLIGATORY.  "Fecha de vuelvo
SELECTION-SCREEN END OF BLOCK b3.

SELECTION-SCREEN SKIP.

SELECTION-SCREEN BEGIN OF BLOCK b4 WITH FRAME TITLE text-003.
PARAMETER p_dom TYPE char50 .  "Fecha de vuelvo
SELECTION-SCREEN END OF BLOCK b4.

SELECTION-SCREEN BEGIN OF BLOCK b5 WITH FRAME TITLE text-005.
PARAMETERS: rb_1 RADIOBUTTON GROUP gr1,
            rb_2 RADIOBUTTON GROUP gr1.
SELECTION-SCREEN END OF BLOCK b5.

SELECTION-SCREEN END OF BLOCK b1.
*&---------------------------------------------------------------------*
*& INITIALIZATION
*&---------------------------------------------------------------------*
INITIALIZATION.

  p_user = sy-uname.

*&---------------------------------------------------------------------*
*& START-OF-SELECTION
*&---------------------------------------------------------------------*
START-OF-SELECTION.

* obtener datos (los obtuve de pantalla.

* procesar datos
  PERFORM f_procesar_datos.

*&---------------------------------------------------------------------*
*& END-OF-SELECTION
*&---------------------------------------------------------------------*
END-OF-SELECTION.
* mostrar o devolver info.
* si le radiobutton 1 esta marcado muestro mi wa sino muestro mi tabla.
  IF rb_1 EQ 'X'.
    PERFORM f_mostrar_wa.
  ELSE.
    PERFORM f_mostrar_tabla.
  ENDIF.

*&---------------------------------------------------------------------*
*&  FORMS
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_PROCESAR_DATOS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_procesar_datos .

  DATA lwa_alumno TYPE ty_alumno.

*Asigno los valores obtenidos por pantalla a mi wa.
  PERFORM f_llenar_wa.

*lleno mi wa local.
  MOVE wa_alumno TO lwa_alumno.

*lleno mi tabla
  PERFORM f_llenar_tabla USING lwa_alumno.




ENDFORM.                    " F_PROCESAR_DATOS
*&---------------------------------------------------------------------*
*&      Form  F_MOSTRAR_WA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_mostrar_wa .

  WRITE / wa_alumno.

  WRITE: / 'Nombre alumno:', wa_alumno-nombre.
  WRITE: / 'Apellido Alumno:', wa_alumno-apellido.

ENDFORM.                    " F_MOSTRAR_WA
*&---------------------------------------------------------------------*
*&      Form  F_MOSTRAR_TABLA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_mostrar_tabla .

ENDFORM.                    " F_MOSTRAR_TABLA
*&---------------------------------------------------------------------*
*&      Form  F_LLENAR_WA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_llenar_wa .

*Asignación los valores de una variable a otra

  wa_alumno-nombre = p_nom.
  wa_alumno-user = p_user.
  wa_alumno-fechanac = p_fnac.

*Muevo un dato de una variable a otra
  MOVE: p_ape TO wa_alumno-apellido,
        p_dom TO wa_alumno-direccion.

ENDFORM.                    " F_LLENAR_WA
*&---------------------------------------------------------------------*
*&      Form  F_LLENAR_TABLA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LWA_ALUMNO  text
*----------------------------------------------------------------------*
FORM f_llenar_tabla  USING  p_lwa_alumno TYPE ty_alumno.

* inserto una posicion en mi tabla interna.
  APPEND  p_lwa_alumno TO it_alumno.

* inserto otra linea en mi tabla interna con la misma información.
  APPEND  p_lwa_alumno TO it_alumno.

* inserto otra linea en mi tabla interna con la misma información pero el campo user estara en blanco.
  CLEAR  p_lwa_alumno-user.
  APPEND  p_lwa_alumno TO it_alumno.

* inserto otra linea en mi tabla interna donde ahora user es el usuario del sistema y la fecha de nacimiento tambien es la fecha del sistema, a su vez, borramos la direccion y apellido.

  p_lwa_alumno-user = sy-uname.
  p_lwa_alumno-fechanac = sy-datum.
  CLEAR:  p_lwa_alumno-direccion, p_lwa_alumno-apellido.
  APPEND  p_lwa_alumno TO it_alumno.

ENDFORM.                    " F_LLENAR_TABLA
