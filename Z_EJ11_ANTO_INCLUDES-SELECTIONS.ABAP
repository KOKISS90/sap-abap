*&---------------------------------------------------------------------*
*&  Include           Z_EJ11_ANTO_SELECTIONS
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.

SELECTION-SCREEN SKIP.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-002.
SELECT-OPTIONS: so_kunnr FOR zclientes-kunnr.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN SKIP.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE text-004.
PARAMETERS: rb1_entr RADIOBUTTON GROUP gr1,
            rb2_entr RADIOBUTTON GROUP gr1.
SELECTION-SCREEN END OF BLOCK b3.

SELECTION-SCREEN SKIP.

SELECTION-SCREEN END OF BLOCK b1.
