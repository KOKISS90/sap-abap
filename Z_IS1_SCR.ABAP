*&---------------------------------------------------------------------*
*&  Include           Z_IS_ANTO_SCR
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
SELECTION-SCREEN SKIP.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-002.
PARAMETERS: p_aline TYPE sflight-carrid DEFAULT 'LH'.
SELECTION-SCREEN SKIP.
SELECT-OPTIONS: so_price FOR sflight-price.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN SKIP.

SELECTION-SCREEN END OF BLOCK b1.
