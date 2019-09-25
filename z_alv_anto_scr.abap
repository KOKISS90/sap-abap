*&---------------------------------------------------------------------*
*&  Include           Z_ALV_ANTO_SCR
*&---------------------------------------------------------------------*
  SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
  SELECTION-SCREEN SKIP.
  PARAMETERS: p_bukrs TYPE ekko-bukrs OBLIGATORY DEFAULT '3000'.
  SELECTION-SCREEN SKIP.
  SELECT-OPTIONS: so_ebeln FOR ekko-ebeln.
  SELECTION-SCREEN SKIP.
  SELECT-OPTIONS: so_lifnr FOR ekko-lifnr.
  SELECTION-SCREEN SKIP.
  SELECTION-SCREEN END OF BLOCK b1.
