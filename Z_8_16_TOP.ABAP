*&---------------------------------------------------------------------*
*&  Include           Z_EJ8_ANTO_INTRODUCING_16_TOP
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& TABLES
*&---------------------------------------------------------------------*
TABLES: spfli,
        scarr.
*&---------------------------------------------------------------------*
*& TYPES
*&---------------------------------------------------------------------*
TYPES: BEGIN OF ty_spfli,
         carrid TYPE spfli-carrid,
         connid TYPE spfli-connid,
         cityfrom TYPE spfli-cityfrom,
         cityto TYPE spfli-cityto,
       END OF ty_spfli,

       BEGIN OF ty_scarr,
         carrid TYPE scarr-carrid,
         carrname TYPE scarr-carrname,
         END OF ty_scarr,

       BEGIN OF ty_nueva,
         carrid TYPE spfli-carrid,
         connid TYPE spfli-connid,
         carrname TYPE scarr-carrname,
         cityfrom TYPE spfli-cityfrom,
         cityto TYPE spfli-cityto,
         END OF ty_nueva.
TYPES: ity_scarr TYPE TABLE OF ty_scarr,
       ity_spfli  TYPE TABLE OF ty_spfli.
*&---------------------------------------------------------------------*
*& DATA
*&---------------------------------------------------------------------*
DATA: wa_spfli TYPE ty_spfli,
      it_spfli TYPE ity_spfli,
      wa_scarr TYPE ty_scarr,
      it_scarr TYPE ity_scarr,
      wa_nueva TYPE ty_nueva,
      it_nueva TYPE TABLE OF ty_nueva.
