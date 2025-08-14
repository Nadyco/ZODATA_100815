class ZCL_ZT100815_01_DPC_EXT definition
  public
  inheriting from ZCL_ZT100815_01_DPC
  create public .

public section.

protected section.
METHODS po_headersset_get_entityset REDEFINITION.
private section.
ENDCLASS.



CLASS ZCL_ZT100815_01_DPC_EXT IMPLEMENTATION.


  METHOD po_headersset_get_entityset.
*********************************************************
* INSIDE OUT --> DE ADENTRO HACIA AFUERA
*********************************************************
*    DATA: lt_headers TYPE STANDARD TABLE OF bapiekko,
*          lt_items   TYPE STANDARD TABLE OF bapiekpo.
*
**/ AGREGAMOS EL CODIFO A IMPLEMENTAR
*    CALL FUNCTION 'BAPI_PO_GET_LIST'
*      EXPORTING
*        rel_group                  = '01'
*        rel_code                   = 'Z1'
**       ITEMS_FOR_RELEASE          = 'X'
*      TABLES
*        po_headers                 = LT_HEAders
*        po_items                   = lt_items
**       RETURN                     =
*      EXCEPTIONS
*        rel_code_missing           = 1
*        rel_authority_check_failed = 2
*        OTHERS                     = 3.
*    IF sy-subrc <> 0.
** Implement suitable error handling here
*    ENDIF.
*
**/ devuelve los valores a la salida
*    et_entityset[] = LT_HEAders[].

*********************************************************
* OUTSIDE IN--> DE AFUERA HACIA ADENTRO
*********************************************************


  ENDMETHOD.
ENDCLASS.
