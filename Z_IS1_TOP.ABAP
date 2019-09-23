*&---------------------------------------------------------------------*
*&  Include           Z_IS_ANTO_TOP
*&---------------------------------------------------------------------*
tables: spfli, sflight.

Types: BEGIN OF ty_sflight,
  carrid type sflight-carrid,
  connid type sflight-connid,
  fldate type sflight-fldate,
  price type sflight-price,
  currency type sflight-currency,
  end of ty_sflight,

  BEGIN OF ty_spfli,
    carrid type spfli-carrid,
    connid type spfli-connid,
    cityfrom type spfli-cityfrom,
    cityto type spfli-cityto,
    end of ty_spfli.


DATA:
* TABLA FINAL HECHA CON UNA ESTRUCTURA
      it_tbl TYPE TABLE OF zstr_is_anto,
      wa_tbl TYPE zstr_is_anto,
* TABLAS DECLARADAS PARA USAR EN LOS SELECTS
      it_sflight TYPE TABLE OF ty_SFLIGHT,
      wa_sflight TYPE ty_SFLIGHT,
      it_spfli TYPE TABLE OF TY_spfli,
      wa_spfli TYPE ty_SPFLI,
* VARIABLES Y CONSTANTES
      v_nombre TYPE c LENGTH 30,
      lv_funcion TYPE rs38l_fnam.
