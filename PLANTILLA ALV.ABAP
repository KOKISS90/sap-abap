*&---------------------------------------------------------------------*
*& Report  ZPLANTILLA_ALV
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  zplantillas_alv.


type-pools slis.

DATA: wa_layout TYPE slis_layout_alv,
      it_fieldcat TYPE slis_t_fieldcat_alv,
      wa_fieldcat TYPE slis_fieldcat_alv.


wa_layout-zebra = 'X'.
wa_layout-colwidth_optimize = 'X'.
wa_layout-window_titlebar = ''.



wa_fieldcat-fieldname = ''.
wa_fieldcat-tabname = 'it_tabla'.
wa_fieldcat-ref_fieldname = ''.
wa_fieldcat-ref_tabname = ''.
wa_fieldcat-seltext_s = ''.
wa_fieldcat-seltext_m = ''.
wa_fieldcat-seltext_l = ''.
wa_fieldcat-outputlen = 100.
wa_fieldcat-just = ''.

APPEND wa_fieldcat TO it_fieldcat.
CLEAR wa_fieldcat.


CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
 EXPORTING
   I_CALLBACK_PROGRAM                = sy-repid
   IS_LAYOUT                         = wa_layout
   IT_FIELDCAT                       = it_fieldcat
  TABLES
    t_outtab                         = it_tabla
 EXCEPTIONS
   PROGRAM_ERROR                     = 1
   OTHERS                            = 2
          .
IF sy-subrc <> 0.
 MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
ENDIF.
