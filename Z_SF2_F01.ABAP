*&---------------------------------------------------------------------*
*&  Include           Z_EJ_CELE_ANTO_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_SELECTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_selects .

  SELECT SINGLE vbeln fkdat kunag waerk
                name1 stras ort01
    INTO wa_datos
    FROM vbrk AS v
    INNER JOIN kna1 AS k
    ON k~kunnr = v~kunag
    WHERE vbeln = p_vbeln.

  IF sy-subrc NE 0.
    MESSAGE text-002 TYPE 'E'.
  ELSE.

    SELECT vbeln matnr fklmg meins arktx netwr mwsbp
      FROM vbrp
      INTO TABLE it_mai
      WHERE vbeln = p_vbeln.

    IF sy-subrc NE 0.
      MESSAGE text-003 TYPE 'E'.
    ELSE.

      LOOP AT it_mai INTO wa_mai.
        CLEAR wa_main.

        wa_main-matnr = wa_mai-matnr.
        wa_main-fklmg = wa_mai-fklmg.
        wa_main-meins = wa_mai-meins.
        wa_main-arktx = wa_mai-arktx.
        wa_main-total = wa_mai-netwr + wa_mai-mwsbp.

        IF wa_mai-fklmg NE 0.
          wa_main-unitario = wa_main-total / wa_mai-fklmg.
        ENDIF.

        APPEND wa_main TO it_main.

      ENDLOOP.
    ENDIF.
  ENDIF.

ENDFORM.                    " F_SELECTS
*&---------------------------------------------------------------------*
*&      Form  F_SMARTFORM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_smartform .

  DATA: lv_funcion TYPE rs38l_fnam.

  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname                 = 'Z_SF_CELE_ANTO'
*     VARIANT                  = ' '
*     DIRECT_CALL              = ' '
   IMPORTING
     fm_name                  = lv_funcion
   EXCEPTIONS
     no_form                  = 1
     no_function_module       = 2
     OTHERS                   = 3
            .
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.


CALL FUNCTION lv_funcion
  EXPORTING
*   ARCHIVE_INDEX              =
*   ARCHIVE_INDEX_TAB          =
*   ARCHIVE_PARAMETERS         =
*   CONTROL_PARAMETERS         =
*   MAIL_APPL_OBJ              =
*   MAIL_RECIPIENT             =
*   MAIL_SENDER                =
*   OUTPUT_OPTIONS             =
*   USER_SETTINGS              = 'X'
    it_main                    = it_main
    wa_datos                   = wa_datos
* IMPORTING
*   DOCUMENT_OUTPUT_INFO       =
*   JOB_OUTPUT_INFO            =
*   JOB_OUTPUT_OPTIONS         =
 EXCEPTIONS
   FORMATTING_ERROR           = 1
   INTERNAL_ERROR             = 2
   SEND_ERROR                 = 3
   USER_CANCELED              = 4
   OTHERS                     = 5
          .
IF sy-subrc <> 0.
 MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
ENDIF.


ENDFORM.                    " F_SMARTFORM
