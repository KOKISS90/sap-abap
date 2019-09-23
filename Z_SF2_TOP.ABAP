*&---------------------------------------------------------------------*
*&  Include           Z_EJ_CELE_ANTO_TOP
*&---------------------------------------------------------------------*
TABLES: vbrk, kna1, vbrp.
*&---------------------------------------------------------------------*
*&  TYPES
*&---------------------------------------------------------------------*
TYPES:

*  BEGIN OF ty_dat,
*    vbeln TYPE vbrk-vbeln,
*    fkdat TYPE vbrk-fkdat,
*    kunag TYPE vbrk-kunag,
*    waerk TYPE vbrk-waerk,
*    name1 TYPE kna1-name1,
*    stras TYPE kna1-stras,
*    ort01 TYPE kna1-ort01,
*    END OF ty_dat,

  BEGIN OF ty_mai,
    vbeln TYPE vbrp-vbeln,
    matnr TYPE vbrp-matnr,
    fklmg TYPE vbrp-fklmg,
    meins TYPE vbrp-meins,
    arktx TYPE vbrp-arktx,
    netwr TYPE vbrp-netwr,
    mwsbp TYPE vbrp-mwsbp,
    END OF ty_mai.



DATA: it_datos TYPE TABLE OF zstr_cele_anto_b,
      wa_datos TYPE zstr_cele_anto_b,
      it_main TYPE TABLE OF zstr_cele_anto,
      wa_main TYPE zstr_cele_anto,
*      it_dat TYPE TABLE OF ty_dat,
*      wa_dat TYPE ty_dat,
      it_mai TYPE TABLE OF ty_mai,
      wa_mai TYPE ty_mai.
