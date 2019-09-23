*&---------------------------------------------------------------------*
*&  Include           Z_IS_ANTO_FORMS
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_SELECT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_select .

  SELECT carrid connid fldate price currency
    FROM sflight
    INTO TABLE it_sflight
    WHERE carrid = p_aline AND price IN so_price.

  IF sy-subrc = 0.

    SELECT carrid connid cityfrom cityto
      FROM spfli
      INTO TABLE it_spfli
      FOR ALL ENTRIES IN it_sflight
      WHERE connid = it_sflight-connid
      AND carrid = it_sflight-carrid.

    IF sy-subrc = 0.
      SORT it_sflight BY carrid connid.
      SORT it_spfli BY carrid connid.

      LOOP AT it_sflight INTO wa_sflight.
        READ TABLE it_spfli INTO wa_spfli
        WITH KEY carrid = wa_sflight
        BINARY SEARCH.

        wa_tbl-connid = wa_sflight-connid.
        wa_tbl-fldate = wa_sflight-fldate.
        wa_tbl-price = wa_sflight-price.
        wa_tbl-currency = wa_sflight-currency.
        wa_tbl-cityfrom = wa_spfli-cityfrom.
        wa_tbl-cityto = wa_spfli-cityto.
        APPEND wa_tbl TO it_tbl.
      ENDLOOP.

    ENDIF.
  ENDIF.
ENDFORM.                    " F_SELECT
*&---------------------------------------------------------------------*
*&      Form  F_FORMULARIO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_formulario .

  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname                 = 'Z_SF_ANTO'
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
  endif.

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
    it_tbl                     = it_tbl
* IMPORTING
*   DOCUMENT_OUTPUT_INFO       =
*   JOB_OUTPUT_INFO            =
*   JOB_OUTPUT_OPTIONS         =
* EXCEPTIONS
*   FORMATTING_ERROR           = 1
*   INTERNAL_ERROR             = 2
*   SEND_ERROR                 = 3
*   USER_CANCELED              = 4
*   OTHERS                     = 5
          .
IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
ENDIF.


ENDFORM.                    " F_FORMULARIO
