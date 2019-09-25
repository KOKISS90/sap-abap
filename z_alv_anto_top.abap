*&---------------------------------------------------------------------*
*&  Include           Z_ALV_ANTO_TOP
*&---------------------------------------------------------------------*

TABLES: ekko.

TYPE-POOLS slis.

TYPES: BEGIN OF ty_ekfa,
  bukrs TYPE ekko-bukrs,
  ebeln TYPE ekko-ebeln,
  bsart TYPE ekko-bsart,
  lifnr TYPE ekko-lifnr,
  name1 TYPE lfa1-name1,
  END OF ty_ekfa,

  BEGIN OF ty_ekpo,
    ebeln TYPE ekpo-ebeln,
    ebelp TYPE ekpo-ebelp,
    matnr TYPE ekpo-matnr,
    werks TYPE ekpo-werks,
    menge TYPE ekpo-menge,
    meins TYPE ekpo-meins,
    END OF ty_ekpo,

    BEGIN OF ty_final,
      ebeln TYPE ekko-ebeln,
      bsart TYPE ekko-bsart,
      lifnr TYPE ekko-lifnr,
      name1 TYPE lfa1-name1,
      ebelp TYPE ekpo-ebelp,
      matnr TYPE ekpo-matnr,
      werks TYPE ekpo-werks,
      menge TYPE ekpo-menge,
      meins TYPE ekpo-meins,
    END OF ty_final.

DATA: it_ekfa TYPE TABLE OF ty_ekfa,
      wa_ekfa TYPE ty_ekfa,
      it_ekpo TYPE TABLE OF ty_ekpo,
      wa_ekpo TYPE ty_ekpo,
      it_final TYPE TABLE OF ty_final,
      wa_final TYPE ty_final.

DATA: wa_layout TYPE slis_layout_alv,
      it_fieldcat TYPE slis_t_fieldcat_alv,
      wa_fieldcat TYPE slis_fieldcat_alv.
