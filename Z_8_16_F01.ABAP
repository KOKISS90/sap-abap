*&---------------------------------------------------------------------*
*&  Include           Z_EJ8_ANTO_INTRODUCING_16_F01
*&---------------------------------------------------------------------*

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




*&---------------------------------------------------------------------*
*&      Form  F_BROWSER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_browser .

  CALL METHOD cl_gui_frontend_services=>directory_browse
    EXPORTING
      window_title         = 'Seleccione la carpeta donde desea descargar el archivo:'
      initial_folder       = 'C:'
    CHANGING
      selected_folder      = p_bajar
    EXCEPTIONS
      cntl_error           = 1
      error_no_gui         = 2
      not_supported_by_gui = 3
      OTHERS               = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.                    " F_BROWSER
*&---------------------------------------------------------------------*
*&      Form  F_BAJAR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_bajar .
  DATA v_nombrearch TYPE string. "VARIABLE PARA PONER EN EL GUI_DOWNLOAD QUE SE USARA PARA PONERLE NOMBRE AL ARCHIVO DESCARGADO

  CONCATENATE p_bajar
  '\'
  sy-uname '_'
  sy-datum
  sy-timlo
  '.TXT.'
  INTO v_nombrearch.

  CALL METHOD cl_gui_frontend_services=>gui_download
    EXPORTING
      filename                = v_nombrearch "SE CREA UNA VARIABLE TIPO STRING PARA PONERLE NOMBRE AL ARCHIVO
    CHANGING
      data_tab                = it_nueva "ACA VA LA TABLA INTERNA DONDE SE CARGARON LOS DATOS EN EL SELECT/LOOP
    EXCEPTIONS
      file_write_error        = 1
      no_batch                = 2
      gui_refuse_filetransfer = 3
      invalid_type            = 4
      no_authority            = 5
      unknown_error           = 6
      header_not_allowed      = 7
      separator_not_allowed   = 8
      filesize_not_allowed    = 9
      header_too_long         = 10
      dp_error_create         = 11
      dp_error_send           = 12
      dp_error_write          = 13
      unknown_dp_error        = 14
      access_denied           = 15
      dp_out_of_memory        = 16
      disk_full               = 17
      dp_timeout              = 18
      file_not_found          = 19
      dataprovider_exception  = 20
      control_flush_error     = 21
      not_supported_by_gui    = 22
      error_no_gui            = 23
      OTHERS                  = 24.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.



ENDFORM.                    " F_BAJAR
