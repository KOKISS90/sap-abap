*&---------------------------------------------------------------------*
*& Report  ZWRITE
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  zwrite.

DATA: lv_datum TYPE sy-datum,
      lv_fecha TYPE c LENGTH 10,
      lv_anio   TYPE c LENGTH 4,
      lv_dia   TYPE c LENGTH 2,
      lv_mes   TYPE c LENGTH 2.


lv_datum = '20190114'.

CLEAR: lv_fecha.

WRITE lv_datum TO lv_fecha.

WRITE lv_fecha.

ULINE.

lv_anio = lv_datum(4).
lv_mes = lv_datum+4(2).
lv_dia = lv_datum+6(2).

CLEAR: lv_fecha.
CONCATENATE lv_dia lv_mes lv_anio INTO lv_fecha SEPARATED BY '.'.

WRITE lv_fecha.

ULINE.

CLEAR: lv_fecha.
CONCATENATE  lv_datum+6(2) lv_datum+4(2)  lv_datum(4) INTO lv_fecha SEPARATED BY '.'.

WRITE lv_fecha.
