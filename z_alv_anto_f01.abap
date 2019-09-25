*----------------------------------------------------------------------*
***INCLUDE Z_ALV_ANTO_F01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_SELECTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_selects .

  SELECT e~bukrs
         e~ebeln
         e~bsart
         e~lifnr
         l~name1
      FROM ekko AS e
      INNER JOIN  lfa1 AS l
      ON e~lifnr = l~lifnr
      INTO TABLE it_ekfa
      WHERE e~ebeln IN so_ebeln "EN SELECT-OPTIONS VA IN
      AND e~lifnr IN so_lifnr
      AND e~bukrs = p_bukrs. "EN PARAMETERS VA IGUAL =

  IF sy-subrc NE 0.
    MESSAGE text-002 TYPE 'E'.
  ELSE.
    SORT it_ekfa BY ebeln.

    SELECT ebeln ebelp matnr werks menge meins
      FROM ekpo
      INTO TABLE it_ekpo
      FOR ALL ENTRIES IN it_ekfa
      WHERE ebeln = it_ekfa-ebeln.

    IF sy-subrc NE 0.
      MESSAGE text-003 TYPE 'E'.
    ELSE.
      SORT it_ekpo BY ebeln.
    ENDIF.
  ENDIF.
ENDFORM.                    " F_SELECTS

*&---------------------------------------------------------------------*
*&      Form  F_LOOP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_loop .

  SORT it_ekfa BY ebeln.

  LOOP AT it_ekpo INTO wa_ekpo.

    READ TABLE it_ekfa INTO wa_ekfa
    WITH KEY ebeln = wa_ekpo-ebeln
    BINARY SEARCH.

    IF sy-subrc NE 0.
      MESSAGE text-004 TYPE 'E'.
    ELSE.
      wa_final-ebeln = wa_ekfa-ebeln.
      wa_final-bsart = wa_ekfa-bsart.
      wa_final-lifnr = wa_ekfa-lifnr.
      wa_final-name1 = wa_ekfa-name1.
    ENDIF.
    IF sy-subrc NE 0.
      MESSAGE text-005 TYPE 'E'.
    ELSE.
      wa_final-ebelp = wa_ekpo-ebelp.
      wa_final-matnr = wa_ekpo-matnr.
      wa_final-werks = wa_ekpo-werks.
      wa_final-menge = wa_ekpo-menge.
      wa_final-meins = wa_ekpo-meins.
    ENDIF.
    APPEND wa_final TO it_final.
    CLEAR wa_final.
  ENDLOOP.

ENDFORM.                    " F_LOOP
*&---------------------------------------------------------------------*
*&      Form  F_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_alv .

  wa_layout-zebra = 'X'.
  wa_layout-colwidth_optimize = 'X'.
  wa_layout-window_titlebar   = 'ANTONELLA'.


  wa_fieldcat-fieldname       = 'EBELN'.
  wa_fieldcat-tabname         = 'IT_FINAL'.
  wa_fieldcat-seltext_m       = 'PURCHASE DOC.:'.


  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname       = 'BSART'.
  wa_fieldcat-tabname         = 'IT_FINAL'.
  wa_fieldcat-seltext_m       = 'DOC. TYPE:'.

  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname       = 'LIFNR'.
  wa_fieldcat-tabname         = 'IT_FINAL'.
  wa_fieldcat-seltext_m       = 'VENDOR N°:'.

  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname       = 'NAME1'.
  wa_fieldcat-tabname         = 'IT_FINAL'.
  wa_fieldcat-seltext_m       = 'VENDOR NAME:'.

  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname       = 'EBELP'.
  wa_fieldcat-tabname         = 'IT_FINAL'.
  wa_fieldcat-seltext_m       = 'ITEM N°:'.

  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname       = 'MATNR'.
  wa_fieldcat-tabname         = 'IT_FINAL'.
  wa_fieldcat-seltext_m       = 'MATERIAL N°:'.

  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname       = 'WERKS'.
  wa_fieldcat-tabname         = 'IT_FINAL'.
  wa_fieldcat-seltext_m       = 'PLANT:'.

  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname       = 'MENGE'.
  wa_fieldcat-tabname         = 'IT_FINAL'.
  wa_fieldcat-seltext_m       = 'QUANTITY:'.

  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname       = 'MEINS'.
  wa_fieldcat-tabname         = 'IT_FINAL'.
  wa_fieldcat-ref_fieldname   = 'MEINS'.
  wa_fieldcat-seltext_m       = 'UM:'.

  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.


  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      is_layout          = wa_layout
      it_fieldcat        = it_fieldcat
    TABLES
      t_outtab           = it_final
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.                    " F_ALV
