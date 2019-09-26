*&---------------------------------------------------------------------*
*& Report  Z_BI_ANTO
*&---------------------------------------------------------------------*
REPORT  z_bi_anto.
*&---------------------------------------------------------------------*
*&      TABLAS
*&---------------------------------------------------------------------*
TABLES: bdcmsgcoll,
        zuser05client.
*&---------------------------------------------------------------------*
*&      TYPES
*&---------------------------------------------------------------------*
TYPE-POOLS: slis.

TYPES: BEGIN OF ty_file,
       kunnr TYPE zuser05client-kunnr,
       razon TYPE zuser05client-razon,
       zobservaciones TYPE zuser05client-zobservaciones,
       END OF ty_file,

       BEGIN OF ty_file_msg,
       kunnr TYPE zuser05client-kunnr,
       razon TYPE zuser05client-razon,
       zobservaciones TYPE zuser05client-zobservaciones,
       msg TYPE string,
       END OF ty_file_msg.
*&---------------------------------------------------------------------*
*&      DECLARACIONES
*&---------------------------------------------------------------------*
DATA: it_bdc TYPE TABLE OF bdcdata,
      wa_bdc TYPE bdcdata,
*LAS TABLAS QUE SE MOSTRARAN
      it_file TYPE TABLE OF ty_file,
      wa_file TYPE ty_file,
*SE USAN PARA RESOLVER EL TEMA DEL PIPE SEPARADOR
      it_file_txt TYPE TABLE OF string,
      wa_file_txt TYPE string,
*
      it_bdc_msg TYPE TABLE OF bdcmsgcoll,
      wa_bdc_msg TYPE bdcmsgcoll,
* MENSAJES DE ERROR
      it_file_msg TYPE TABLE OF ty_file_msg,
      wa_file_msg TYPE ty_file_msg,
* ALV
      wa_layout TYPE slis_layout_alv,
      it_fieldcat TYPE slis_t_fieldcat_alv,
      wa_fieldcat TYPE slis_fieldcat_alv.
*&---------------------------------------------------------------------*
*&     PANTALLA
*&---------------------------------------------------------------------*
START-OF-SELECTION.

  SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.

  SELECTION-SCREEN SKIP.

  SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-002.
  PARAMETERS: p_file TYPE string.
  SELECTION-SCREEN END OF BLOCK b2.

  SELECTION-SCREEN SKIP.

  SELECTION-SCREEN END OF BLOCK b1.
*&---------------------------------------------------------------------*
*&      PERFORMS
*&---------------------------------------------------------------------*
  PERFORM f_leer_file.
  PERFORM f_exec_bi.
  PERFORM f_alv.
  PERFORM f_mostrar_alv.

*&---------------------------------------------------------------------*
*&      Form  F_LEER_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_leer_file .

  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      filename                = p_file
    TABLES
      data_tab                = it_file_txt
    EXCEPTIONS
      file_open_error         = 1
      file_read_error         = 2
      no_batch                = 3
      gui_refuse_filetransfer = 4
      invalid_type            = 5
      no_authority            = 6
      unknown_error           = 7
      bad_data_format         = 8
      header_not_allowed      = 9
      separator_not_allowed   = 10
      header_too_long         = 11
      unknown_dp_error        = 12
      access_denied           = 13
      dp_out_of_memory        = 14
      disk_full               = 15
      dp_timeout              = 16
      OTHERS                  = 17.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

*ESTO ES PARA RESOLVER EL TEMA DEL SEPARADOR PIPE PARA QUE NO APAREZCAN CUANDO CARGAMOS LA TABLA.

  LOOP AT it_file_txt INTO wa_file_txt.
    SPLIT wa_file_txt AT '|'
    INTO wa_file-kunnr wa_file-razon wa_file-zobservaciones.

    APPEND wa_file TO it_file.

  ENDLOOP.
  REFRESH it_file_txt.

ENDFORM.                    " F_LEER_FILE
*&---------------------------------------------------------------------*
*&      Form  F_EXEC_BI
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_exec_bi .


  LOOP AT it_file INTO wa_file.
    REFRESH it_bdc.

    PERFORM f_llenar_bdc_tab USING:

          'X' 'SAPMSVMA' '0100',
          ' ' 'BDC_CURSOR' 'VIEWNAME',
          ' ' 'BDC_OKCODE' 'UPD',
          ' ' 'VIEWNAME' 'ZUSER05CLIENT',
          ' ' 'VIMDYNFLDS-LTD_DTA_NO' 'X',
          'X' 'SAPLZUSER05CLIENT' '0001',
          ' ' 'BDC_CURSOR' 'ZUSER05CLIENT-KUNNR(01)',
          ' ' 'BDC_OKCODE' '=NEWL',
          'X' 'SAPLZUSER05CLIENT' '0001',
          ' ' 'BDC_CURSOR' 'ZUSER05CLIENT-KUNNR(01)',
          ' ' 'BDC_OKCODE' '=SAVE',
          ' ' 'ZUSER05CLIENT-KUNNR(01)' wa_file-kunnr,
          ' ' 'ZUSER05CLIENT-RAZON(01)' wa_file-razon,
          ' ' 'ZUSER05CLIENT-ZOBSERVACIONES(01)' wa_file-zobservaciones,
          'X' 'SAPLZUSER05CLIENT' '0001',
          ' ' 'BDC_CURSOR' 'ZUSER05CLIENT-KUNNR(02)',
          ' ' 'BDC_OKCODE' '=BACK',
          'X' 'SAPLZUSER05CLIENT' '0001',
          ' ' 'BDC_CURSOR' 'ZUSER05CLIENT-KUNNR(02)',
          ' ' 'BDC_OKCODE' '=BACK',
          'X' 'SAPLZUSER05CLIENT' '0100',
          ' ' 'BDC_OKCODE' '/EBACK',
          ' ' 'BDC_CURSOR' 'VIEWNAME'.

    CALL TRANSACTION 'SM30' USING it_bdc MODE 'N' MESSAGES INTO it_bdc_msg. "USAMOS LA TABLITA PARA TIRAR MENSAJES DE ERROR.

    LOOP AT it_bdc_msg INTO wa_bdc_msg.

      CLEAR wa_file_msg.
      wa_file_msg-kunnr = wa_file-kunnr.
      wa_file_msg-razon = wa_file-razon.
      wa_file_msg-zobservaciones = wa_file-zobservaciones.

      IF wa_bdc_msg-msgtyp = 'E'.
        MESSAGE ID wa_bdc_msg-msgid
           TYPE wa_bdc_msg-msgtyp
           NUMBER wa_bdc_msg-msgnr
           WITH wa_bdc_msg-msgv1
*                wa_bdc_msg-msgv2
*                wa_bdc_msg-msgv3
*                wa_bdc_msg-msgv4
           INTO wa_file_msg-msg.
      ELSE.
        wa_file_msg-msg = text-003.
      ENDIF.



*       OTRA MANERA DE HACER MENSAJES DE ERROR (PERO HARCODEADOS)
*        wa_file_msg-msg = 'ERROR AL CARGAR CLIENTE'.
*      ELSE.
*        wa_file_msg-msg = 'CLIENTE CARGADO EXITOSAMENTE'.
*      ENDIF.

    ENDLOOP.

    APPEND wa_file_msg TO it_file_msg.

  ENDLOOP.

ENDFORM.                    " F_EXEC_BI
*&---------------------------------------------------------------------*
*&      Form  F_LLENAR_BDC_TAB
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_llenar_bdc_tab USING dynbegin name value.

  IF dynbegin = 'X'.
    CLEAR wa_bdc.
    MOVE: name TO wa_bdc-program,
          value TO wa_bdc-dynpro,
          'X' TO wa_bdc-dynbegin.
    APPEND wa_bdc TO it_bdc.
  ELSE.
    CLEAR wa_bdc.
    MOVE: name TO wa_bdc-fnam,
          value TO wa_bdc-fval.
    APPEND wa_bdc TO it_bdc.
  ENDIF.

ENDFORM.                    " F_LLENAR_BDC_TAB
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
  wa_layout-window_titlebar = ''.


  wa_fieldcat-fieldname = 'KUNNR'.
  wa_fieldcat-tabname = 'IT_FILE_MSG'.
  wa_fieldcat-seltext_m = 'CLIENTE'.

  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'RAZON'.
  wa_fieldcat-tabname = 'IT_FILE_MSG'.
  wa_fieldcat-seltext_m = 'RAZON'.

  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'ZOBSERVACIONES'.
  wa_fieldcat-tabname = 'IT_FILE_MSG'.
  wa_fieldcat-seltext_m = 'OBSERVACIONES'.

  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'MSG'.
  wa_fieldcat-tabname = 'IT_FILE_MSG'.
  wa_fieldcat-seltext_m = 'MENSAJE'.

  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

ENDFORM.                    " F_ALV
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
      i_callback_program = sy-repid
      is_layout          = wa_layout
      it_fieldcat        = it_fieldcat
    TABLES
      t_outtab           = it_file_msg
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.                    " F_MOSTRAR_ALV
