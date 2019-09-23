*&---------------------------------------------------------------------*
*& Report  Z_EJ_CELE_ANTO
*&---------------------------------------------------------------------*
REPORT  z_ej_cele_anto.
*&---------------------------------------------------------------------*
*& INCLUDES
*&---------------------------------------------------------------------*
INCLUDE: z_ej_cele_anto_top.
INCLUDE: z_ej_cele_anto_scr.
INCLUDE: z_ej_cele_anto_f01.

START-OF-SELECTION.

PERFORM f_selects.
PERFORM f_smartform.
