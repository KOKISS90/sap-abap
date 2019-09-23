*&---------------------------------------------------------------------*
*& Report  Z_IS_ANTO
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT  z_is_anto.


INCLUDE z_is_anto_top.
INCLUDE z_is_anto_scr.
INCLUDE z_is_anto_forms.

START-OF-SELECTION.

PERFORM f_select.
PERFORM f_formulario.
