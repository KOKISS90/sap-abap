*&---------------------------------------------------------------------*
*&  Include           Z_EJ8_ANTO_INTRODUCING_16_SCR
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& SELECTION-SCREEN SELECT-OPTIONS PARAMETERS
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
SELECTION-SCREEN SKIP.

PARAMETERS: p_chk AS CHECKBOX.
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-002.
PARAMETERS: p_bajar TYPE string.
SELECTION-SCREEN SKIP.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE text-003.
SELECT-OPTIONS: so_conid FOR spfli-connid.
SELECTION-SCREEN END OF BLOCK b3.
SELECTION-SCREEN END OF BLOCK b2.
SELECTION-SCREEN SKIP.

SELECTION-SCREEN END OF BLOCK b1.
