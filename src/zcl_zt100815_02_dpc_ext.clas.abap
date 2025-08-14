CLASS zcl_zt100815_02_dpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcl_zt100815_02_dpc
  CREATE PUBLIC .

  PUBLIC SECTION.
  PROTECTED SECTION.
    "METODOS PARA ENTIDAD  CUSTOMERS
    METHODS: customersset_create_entity  REDEFINITION. "POST
    METHODS  customersset_get_entity     REDEFINITION. "GET
    METHODS  customersset_get_entityset  REDEFINITION. "GET
    METHODS  customersset_update_entity  REDEFINITION. "PUT

    "METODOS PARA ENTIDAD  ORDERS
    METHODS ordersset_create_entity  REDEFINITION. "POST
    METHODS ordersset_get_entity     REDEFINITION. "GET
    METHODS ordersset_get_entityset  REDEFINITION. "GET
    METHODS ordersset_update_entity  REDEFINITION.  "PUT

    "METODOS PARA ENTIDAD  PAYMENTS
    METHODS paymentsset_creatE_entity  REDEFINITION.  "POST
    METHODS paymentsset_get_entity     REDEFINITION.  "GET
    METHODS paymentsset_get_entityset  REDEFINITION.  "GET
    METHODS paymentsset_update_entity  REDEFINITION.  " PUT

  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_zt100815_02_dpc_ext IMPLEMENTATION.

  METHOD customersset_create_entity.

    DATA ls_customer TYPE zcustomer_815.

    io_data_provider->read_entry_data(  IMPORTING   es_data = ls_customer ).

    INSERT zcustomer_815 FROM ls_customer.
    IF sy-subrc EQ 0.
      er_entity = ls_customer.
    ELSE.

      DATA(ls_message) = VALUE scx_t100key( msgid = 'SY'
                                            msgno = '002'
                                            attr1 = 'ERROR METODO Crear Cusotmers').

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          textid = ls_message.

    ENDIF.
  ENDMETHOD.

  METHOD paymentsset_create_entity.

    DATA ls_payments TYPE zpaymnets_815.

    io_data_provider->read_entry_data(  IMPORTING   es_data = ls_payments ).

    INSERT zpaymnets_815 FROM ls_payments.
    IF sy-subrc EQ 0.
      er_entity = ls_payments.
    ELSE.

      DATA(ls_message) = VALUE scx_t100key( msgid = 'SY'
                                            msgno = '002'
                                            attr1 = 'ERROR METODO Crear Payments').

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          textid = ls_message.

    ENDIF.
  ENDMETHOD.


  METHOD ordersset_create_entity.

    DATA ls_orders TYPE zorders_815." tipo de la entidad definida en el odata

    io_data_provider->read_entry_data(  IMPORTING   es_data = ls_orders ).

    INSERT zorders_815 FROM ls_orders.
    IF sy-subrc EQ 0.
      er_entity = ls_orders.
    ELSE.

      DATA(ls_message) = VALUE scx_t100key( msgid = 'SY'
                                            msgno = '002'
                                            attr1 = 'ERROR METODO Crear Orders').

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          textid = ls_message.

    ENDIF.

  ENDMETHOD.


  METHOD customersset_get_entity.

    " la tabla  !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
    " contiene el o los valores que se recuperan de la llamada

    DATA(lv_customerid) = it_key_tab[ name = 'Customerid' ]-value.

    "  !ER_ENTITY type ZCL_ZT100815_02_MPC=>TS_CUSTOMERS
    "  es del mismo tipo que la tabla de base de datos

* se recuperarian los datos de la base de datos y se debe asignar
* a la estructura de el modelado odata>

    SELECT SINGLE FROM zcustomer_815
      FIELDS *
      WHERE customerid = @lv_customerid
      INTO @er_entity.


  ENDMETHOD.

  METHOD ordersset_get_entity.

    " la tabla  !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
    " contiene el o los valores que se recuperan de la llamada

    DATA(lv_Orderid) = it_key_tab[ name = 'Orderid' ]-value.

    "  !ER_ENTITY type ZCL_ZT100815_02_MPC=>TS_CUSTOMERS
    "  es del mismo tipo que la tabla de base de datos

* se recuperarian los datos de la base de datos y se debe asignar
* a la estructura de el modelado odata>

    SELECT SINGLE FROM zorders_815
      FIELDS *
      WHERE Orderid = @lv_Orderid
      INTO @er_entity.

  ENDMETHOD.

  METHOD paymentsset_get_entity.

    " la tabla  !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
    " contiene el o los valores que se recuperan de la llamada

    DATA(lv_Paymentid) = it_key_tab[ name = 'Paymentid' ]-value.

    "  !ER_ENTITY type ZCL_ZT100815_02_MPC=>TS_CUSTOMERS
    "  es del mismo tipo que la tabla de base de datos

* se recuperarian los datos de la base de datos y se debe asignar
* a la estructura de el modelado odata>

    SELECT SINGLE FROM zpaymnets_815
      FIELDS *
      WHERE Paymentid = @lv_Paymentid
      INTO @er_entity.


  ENDMETHOD.

  METHOD customersset_get_entityset.

*   se recuperarian los datos de la base de datos y se debe asignar
* a la estructura de el modelado odata>

    SELECT FROM zcustomer_815
      FIELDS *
       INTO TABLE @et_entityset.
    IF sy-subrc <> 0.
      DATA(ls_message) = VALUE scx_t100key( msgid = 'SY'
                                             msgno = '002'
                                             attr1 = 'No existen clientes en tabla ZCUSTOMER_815').

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          textid = ls_message.
    ENDIF.


  ENDMETHOD.

  METHOD paymentsset_get_entityset.

    SELECT FROM zpaymnets_815
     FIELDS *
     INTO TABLE @ET_entitySET.

    IF sy-subrc <> 0.
      DATA(ls_message) = VALUE scx_t100key( msgid = 'SY'
                                             msgno = '002'
                                             attr1 = 'No existen pagos en tabla ZPAYMENTS_815').

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          textid = ls_message.
    ENDIF.

  ENDMETHOD.

  METHOD ordersset_get_entityset.


    SELECT FROM zORDERS_815
     FIELDS *
     INTO TABLE @ET_entitySET.
    IF sy-subrc <> 0.
      DATA(ls_message) = VALUE scx_t100key( msgid = 'SY'
                                             msgno = '002'
                                             attr1 = 'No existen ordenes en tabla ZORDERS_815').

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          textid = ls_message.
    ENDIF.
  ENDMETHOD.

  METHOD customersset_update_entity.

    DATA ls_customer TYPE zcustomer_815.

    io_data_provider->read_entry_data(  IMPORTING   es_data = ls_customer ).

    UPDATE zcustomer_815 FROM ls_customer.
    IF sy-subrc EQ 0.
      er_entity = ls_customer.
    ELSE.

      DATA(ls_message) = VALUE scx_t100key( msgid = 'SY'
                                            msgno = '002'
                                            attr1 = 'ERROR METODO Update Cusotmers').

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          textid = ls_message.

    ENDIF.


  ENDMETHOD.

  METHOD ordersset_update_entity.

    DATA ls_orders TYPE zorders_815." tipo de la entidad definida en el odata

    io_data_provider->read_entry_data(  IMPORTING   es_data = ls_orders ).

    UPDATE zorders_815 FROM ls_orders.
    IF sy-subrc EQ 0.
      er_entity = ls_orders.
    ELSE.

      DATA(ls_message) = VALUE scx_t100key( msgid = 'SY'
                                            msgno = '002'
                                            attr1 = 'ERROR METODO Update Orders').

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          textid = ls_message.

    ENDIF.

  ENDMETHOD.

  METHOD paymentsset_update_entity.

    DATA ls_payments TYPE zpaymnets_815.

    io_data_provider->read_entry_data(  IMPORTING   es_data = ls_payments ).

    UPDATE zpaymnets_815 FROM ls_payments.
    IF sy-subrc EQ 0.
      er_entity = ls_payments.
    ELSE.

      DATA(ls_message) = VALUE scx_t100key( msgid = 'SY'
                                            msgno = '002'
                                            attr1 = 'ERROR METODO Update Payments').

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          textid = ls_message.

    ENDIF.
  ENDMETHOD.

ENDCLASS.
