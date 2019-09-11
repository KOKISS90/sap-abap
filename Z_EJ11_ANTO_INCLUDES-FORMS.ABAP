*&---------------------------------------------------------------------*
*&  Include           Z_EJ11_ANTO_FORMS
*&---------------------------------------------------------------------*

"aca hago los forms de los selects, los loops, los fieldcats y layouts

*&---------------------------------------------------------------------*
*&      Form  F_SELECTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_selects .

  SELECT kunnr razon
    FROM zclientes
    INTO TABLE it_clientes
    WHERE kunnr IN so_kunnr.

  IF sy-subrc = 0.
    SORT it_clientes BY kunnr.

    SELECT kunnr pedido direccion entrega
      FROM zpedidos
      INTO TABLE it_pedidos
      FOR ALL ENTRIES IN it_clientes
      WHERE kunnr = it_clientes-kunnr
      AND entrega = v_cruz.

    IF sy-subrc = 0.
      SORT it_pedidos BY kunnr.
    ENDIF.
  ENDIF.
  CLEAR: wa_tablita,
         it_tablita.
ENDFORM.                    " F_SELECTS
*&---------------------------------------------------------------------*
*&      Form  F_COMPLETAR_TABLITA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_completar_tablita .

  SORT: it_clientes BY kunnr,
        it_pedidos BY kunnr.

  LOOP AT it_pedidos INTO wa_pedidos.

    CLEAR: wa_clientes.
    READ TABLE it_clientes INTO wa_clientes
           WITH KEY kunnr = wa_pedidos-kunnr
                    BINARY SEARCH.

    IF sy-subrc EQ 0.
    wa_tablita-razon = wa_clientes-razon.
    ENDIF.

    wa_tablita-kunnr = wa_pedidos-kunnr.
    wa_tablita-pedido = wa_pedidos-pedido.
    wa_tablita-direccion = wa_pedidos-direccion.
    wa_tablita-entrega = wa_pedidos-entrega.


    APPEND wa_tablita TO it_tablita.
    CLEAR: wa_tablita.

  ENDLOOP.


ENDFORM.            " F_COMPLETAR_TABLITA
*&---------------------------------------------------------------------*
*&      Form  F_CONFIG_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_config_fieldcats .

  wa_layout-zebra = 'X'.

  wa_fieldcat-fieldname = 'KUNNR'.    "Nombre del Campo (en mayusculas)
  wa_fieldcat-tabname = 'IT_TABLITA'.      "Nombre de la Tabla a Mostrar (en mayusculas)
  wa_fieldcat-seltext_s = 'CLIENTE'.    "Nombre del Campo Small
  wa_fieldcat-seltext_m = 'NUM CLIENTE'.    "Nombre del Campo Medium
  wa_fieldcat-seltext_l = 'NUMERO DE CLIENTE'.    "Nombre del Campo Large
  wa_fieldcat-outputlen = 20.   "Opcional Cantidad de Campos de la Columna
  wa_fieldcat-just = 'C'.        "Opcional Justificacion del Texto c = centered

  APPEND wa_fieldcat TO it_fieldcat.     "No Cambia
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'RAZON'.    "Nombre del Campo (en mayusculas)
  wa_fieldcat-tabname = 'IT_TABLITA'.      "Nombre de la Tabla a Mostrar (en mayusculas)
  wa_fieldcat-seltext_s = 'R.S.'.    "Nombre del Campo Small
  wa_fieldcat-seltext_m = 'RAZ. SOC.'.    "Nombre del Campo Medium
  wa_fieldcat-seltext_l = 'RAZON SOCIAL'.    "Nombre del Campo Large
  wa_fieldcat-outputlen = 40.   "Opcional Cantidad de Campos de la Columna
  wa_fieldcat-just = 'C'.        "Opcional Justificacion del Texto c = centered

  APPEND wa_fieldcat TO it_fieldcat.     "No Cambia
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'PEDIDO'.    "Nombre del Campo (en mayusculas)
  wa_fieldcat-tabname = 'IT_TABLITA'.      "Nombre de la Tabla a Mostrar (en mayusculas)
  wa_fieldcat-seltext_s = 'PEDIDO'.    "Nombre del Campo Small
  wa_fieldcat-seltext_m = 'NUM PEDIDO'.    "Nombre del Campo Medium
  wa_fieldcat-seltext_l = 'NUMERO DE PEDIDO'.    "Nombre del Campo Large
  wa_fieldcat-outputlen = 15.   "Opcional Cantidad de Campos de la Columna
  wa_fieldcat-just = 'C'.        "Opcional Justificacion del Texto c = centered

  APPEND wa_fieldcat TO it_fieldcat.     "No Cambia
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'DIRECCION'.    "Nombre del Campo (en mayusculas)
  wa_fieldcat-tabname = 'IT_TABLITA'.      "Nombre de la Tabla a Mostrar (en mayusculas)
  wa_fieldcat-seltext_s = 'DIR'.    "Nombre del Campo Small
  wa_fieldcat-seltext_m = 'DIRECCION'.    "Nombre del Campo Medium
  wa_fieldcat-seltext_l = 'DIRECCION DEL CLIENTE'.    "Nombre del Campo Large
  wa_fieldcat-outputlen = 40.   "Opcional Cantidad de Campos de la Columna
  wa_fieldcat-just = 'C'.        "Opcional Justificacion del Texto c = centered

  APPEND wa_fieldcat TO it_fieldcat.     "No Cambia
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'ENTREGA'.    "Nombre del Campo (en mayusculas)
  wa_fieldcat-tabname = 'IT_TABLITA'.      "Nombre de la Tabla a Mostrar (en mayusculas)
  wa_fieldcat-seltext_s = 'ENTREG'.    "Nombre del Campo Small
  wa_fieldcat-seltext_m = 'ENTREGADO'.    "Nombre del Campo Medium
  wa_fieldcat-seltext_l = 'ENTREGADO SI/NO'.    "Nombre del Campo Large
  wa_fieldcat-outputlen = 10.   "Opcional Cantidad de Campos de la Columna
  wa_fieldcat-just = 'C'.        "Opcional Justificacion del Texto c = centered

  APPEND wa_fieldcat TO it_fieldcat.     "No Cambia
  CLEAR wa_fieldcat.



ENDFORM.                    " F_CONFIG_ALV
*&---------------------------------------------------------------------*
*&      Form  F_MOSTRAR_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_mostrar_alv .

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid     "No Cambiar
      is_layout          = wa_layout    "No Cambiar
      it_fieldcat        = it_fieldcat  "No Cambiar
    TABLES
      t_outtab           = it_tablita        "Nombre de la Tabla a Mostrar
    EXCEPTIONS
      program_error      = 1            "No Cambiar
      OTHERS             = 2.            "No Cambiar
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.                    " F_MOSTRAR_ALV
