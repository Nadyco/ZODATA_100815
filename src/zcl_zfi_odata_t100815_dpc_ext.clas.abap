CLASS zcl_zfi_odata_t100815_dpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcl_zfi_odata_t100815_dpc
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS /iwbep/if_mgw_appl_srv_runtime~get_expanded_entityset REDEFINITION.


  PROTECTED SECTION.
    "METODOS ZHEADER - ZBKPF_LG
    METHODS zheaderset_create_entity REDEFINITION.
    METHODS zheaderset_get_entity    REDEFINITION.
    METHODS zheaderset_get_entityset REDEFINITION.
    METHODS zheaderset_update_entity REDEFINITION.
    METHODS zheaderset_delete_entity REDEFINITION.



    "METODOS ZSEGMENT - ZBSEG_LG
    METHODS zsegmentset_create_entity REDEFINITION.
    METHODS zsegmentset_get_entity    REDEFINITION.
    METHODS zsegmentset_get_entityset REDEFINITION.
    METHODS zsegmentset_update_entity REDEFINITION.
    METHODS zsegmentset_delete_entity REDEFINITION.



  PRIVATE SECTION.
ENDCLASS.


CLASS zcl_zfi_odata_t100815_dpc_ext IMPLEMENTATION.
***************************************************************
  METHOD zheaderset_create_entity.

    DATA ls_bkpf TYPE zbkpf_lg.

    io_data_provider->read_entry_data(  IMPORTING   es_data = ls_bkpf ).

    INSERT zbkpf_lg FROM ls_bkpf.
    IF sy-subrc EQ 0.
      er_entity = ls_bkpf.
    ELSE.

      DATA(ls_message) = VALUE scx_t100key( msgid = 'SY'
                                            msgno = '002'
                                            attr1 = 'ERROR CREATE ENTITY: ZHEADER - ZBKPG_LG').

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          textid = ls_message.

    ENDIF.

  ENDMETHOD.

  METHOD zsegmentset_create_entity.

    DATA ls_bseg TYPE zbseg_lg.

    io_data_provider->read_entry_data(  IMPORTING   es_data = ls_bseg ).

    INSERT zbseg_lg FROM ls_bseg.
    IF sy-subrc EQ 0.
      er_entity = ls_bseg.
    ELSE.

      DATA(ls_message) = VALUE scx_t100key( msgid = 'SY'
                                            msgno = '002'
                                            attr1 = 'ERROR CREATE ENTITY: ZSEGMENT -ZBSEG_LG').

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          textid = ls_message.

    ENDIF.

  ENDMETHOD.

***************************************************************
  METHOD zheaderset_get_entity.

    DATA(lv_bukrs) =  it_key_tab[ name = 'Bukrs' ]-value.
    DATA(lv_belnr) =  it_key_tab[ name = 'Belnr' ]-value.
    DATA(lv_gjahr) =  it_key_tab[ name = 'Gjahr' ]-value.

    SELECT SINGLE FROM zbkpf_lg
    FIELDS *
    WHERE bukrs = @lv_bukrs
     AND belnr  = @lv_belnr
     AND gjahr  = @lv_gjahr
    INTO @er_entity.
    IF sy-subrc <> 0.

      DATA(ls_message) = VALUE scx_t100key( msgid = 'SY'
                                            msgno = '002'
                                            attr1 = 'ERROR METODO GET_ENTITY :  ZHEADER - ZBKPG_LG').

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          textid = ls_message.

    ENDIF.
  ENDMETHOD.

  METHOD zsegmentset_get_entity.

    DATA(lv_bukrs) =  it_key_tab[ name = 'Bukrs' ]-value.
    DATA(lv_belnr) =  it_key_tab[ name = 'Belnr' ]-value.
    DATA(lv_gjahr) =  it_key_tab[ name = 'Gjahr' ]-value.
    DATA(lv_buzei) =  it_key_tab[ name = 'Buzei' ]-value.

    SELECT SINGLE FROM zbseg_lg
    FIELDS *
    WHERE bukrs = @lv_bukrs
     AND belnr  = @lv_belnr
     AND gjahr  = @lv_gjahr
     AND buzei  = @lv_buzei
    INTO @er_entity.
    IF sy-subrc <> 0.

      DATA(ls_message) = VALUE scx_t100key( msgid = 'SY'
                                            msgno = '002'
                                            attr1 = 'ERROR METODO GET_ENTITY :  ZSEGMENT - ZBSEG_LG').

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          textid = ls_message.

    ENDIF.
  ENDMETHOD.

***************************************************************
  METHOD zheaderset_get_entityset.

    DATA: lt_bkpf TYPE zcl_zfi_odata_t100815_mpc=>tt_zheader.

    SELECT  FROM zbkpf_lg
    FIELDS *
    INTO TABLE @lt_bkpf.
    IF sy-subrc EQ 0.
      et_entityset = lt_bkpf.
    ELSE.

      DATA(ls_message) = VALUE scx_t100key( msgid = 'SY'
                                             msgno = '002'
                                             attr1 = 'ERROR METODO GET_ENTITYSET: :  ZHEADER - ZBKPG_LG').

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          textid = ls_message.

    ENDIF.


  ENDMETHOD.

  METHOD zsegmentset_get_entityset.

    DATA: lt_bseg TYPE zcl_zfi_odata_t100815_mpc=>tt_zsegment.

    SELECT  FROM zbseg_lg
    FIELDS *
    INTO TABLE @lt_bseg.
    IF sy-subrc EQ 0.
      et_entityset = lt_bseg.
    ELSE.

      DATA(ls_message) = VALUE scx_t100key( msgid = 'SY'
                                             msgno = '002'
                                             attr1 = 'ERROR METODO GET_ENTITYSET: :  ZSEGMENT - ZBSEG_LG').

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          textid = ls_message.

    ENDIF.


  ENDMETHOD.

***************************************************************
  METHOD zheaderset_update_entity.

    DATA: ls_header_odata TYPE zbkpf_lg. " para obtener los datos de la peticion

**  recupero los valores de los campos claves para recuperar el registro de la BD
    DATA(lv_bukrs) =  it_key_tab[ name = 'Bukrs' ]-value.
    DATA(lv_belnr) =  it_key_tab[ name = 'Belnr' ]-value.
    DATA(lv_gjahr) =  it_key_tab[ name = 'Gjahr' ]-value.


    " OBTENGO LOS DATOS DE LA BASE DE DATOS CON LAS CLAVES
***  De esta manera se cuales son los valores actuales en D
    SELECT SINGLE FROM zbkpf_lg
      FIELDS *
      WHERE bukrs = @lv_bukrs
        AND belnr = @lv_belnr
        AND gjahr = @lv_gjahr
        INTO @DATA(ls_bkpf_lg_ddbb).

    IF sy-subrc = 0.
**  si se encontro un registro

      "se obtienen los datos de la peticion
      io_data_provider->read_entry_data( IMPORTING es_data = ls_header_odata ).

** guardo en la estructura update creada (ls_bkpf_lg_update) los datos finales a actualizar en cada campo

      DATA(ls_bkpf_lg_update) = VALUE zbkpf_lg( bukrs = lv_bukrs "se toma el campo clave
                                                belnr = lv_belnr "se toma el campo clave
                                                gjahr = lv_gjahr "se toma el campo clave


" Cuando desde la peticion odata (ls_header_odata ), tengo el valor del campo BLART vacio
" se deja el valor de la base de datos (ls_bkpf_lg_ddbb) sino se asigna el valor de la peticion
" la misma logica aplica para los demas campos NO CLAVES

                      Blart = COND #( WHEN ls_header_odata-Blart IS NOT INITIAL
                                                  THEN ls_header_odata-Blart
                                                  ELSE ls_bkpf_lg_ddbb-Blart )

                      Bldat = COND #( WHEN ls_header_odata-Bldat IS NOT INITIAL
                                                  THEN ls_header_odata-Bldat
                                                  ELSE ls_bkpf_lg_ddbb-Bldat )

                      Budat  = COND #( WHEN ls_header_odata-Budat IS NOT INITIAL
                                                  THEN ls_header_odata-Budat
                                                  ELSE ls_bkpf_lg_ddbb-Budat )

                      Monat = COND #( WHEN ls_header_odata-Monat IS NOT INITIAL
                                                  THEN ls_header_odata-Monat
                                                  ELSE ls_bkpf_lg_ddbb-Monat )

                      Cpudt  = COND #( WHEN ls_header_odata-Cpudt IS NOT INITIAL
                                                  THEN ls_header_odata-Cpudt
                                                  ELSE ls_bkpf_lg_ddbb-Cpudt )

                      Cputm = COND #( WHEN ls_header_odata-Cputm IS NOT INITIAL
                                                  THEN ls_header_odata-cputm
                                                  ELSE ls_bkpf_lg_ddbb-Cputm )

                      Aedat  = COND #( WHEN ls_header_odata-Aedat IS NOT INITIAL
                                                  THEN ls_header_odata-Aedat
                                                  ELSE ls_bkpf_lg_ddbb-Aedat )

                      Upddt = COND #( WHEN ls_header_odata-Upddt IS NOT INITIAL
                                                  THEN ls_header_odata-Upddt
                                                  ELSE ls_bkpf_lg_ddbb-Upddt )

                      Wwert = COND #( WHEN ls_header_odata-Usnam IS NOT INITIAL
                                                  THEN ls_header_odata-Wwert
                                                  ELSE ls_bkpf_lg_ddbb-Wwert )

                      Usnam = COND #( WHEN ls_header_odata-Aedat IS NOT INITIAL
                                                  THEN ls_header_odata-Usnam
                                                  ELSE ls_bkpf_lg_ddbb-Usnam )

                      Tcode = COND #( WHEN ls_header_odata-Tcode IS NOT INITIAL
                                                  THEN ls_header_odata-Tcode
                                                  ELSE ls_bkpf_lg_ddbb-Tcode )

                      Bvorg = COND #( WHEN ls_header_odata-Bvorg  IS NOT INITIAL
                                                  THEN ls_header_odata-Bvorg
                                                  ELSE ls_bkpf_lg_ddbb-Bvorg  )

                      Xblnr = COND #( WHEN ls_header_odata-Xblnr IS NOT INITIAL
                                                  THEN ls_header_odata-Xblnr
                                                  ELSE ls_bkpf_lg_ddbb-Xblnr )

                      Dbblg = COND #( WHEN ls_header_odata-Dbblg IS NOT INITIAL
                                                  THEN ls_header_odata-Dbblg
                                                  ELSE ls_bkpf_lg_ddbb-Dbblg )

           ).

**    se actualiza la tabla de base de datos con la estructura creada previamente
      UPDATE zbkpf_lg FROM ls_bkpf_lg_update.
      IF sy-subrc EQ 0.
        er_entity = ls_header_odata.
      ELSE.
        DATA(lv_exception) = abap_true.
      ENDIF.

    ELSE.
      lv_exception = abap_true.
    ENDIF.


    IF lv_exception EQ abap_true.

      DATA(ls_message) = VALUE scx_t100key( msgid = 'SY'
                                            msgno = '002'
                                            attr1 = 'ERROR METODO UPDATE ENTITY: ZHEADER - ZBKPF_LG' ).
      RAISE EXCEPTION TYPE /iwbep/cx_epm_busi_exception
        EXPORTING
          textid = ls_message.

    ENDIF.

  ENDMETHOD.

  METHOD zsegmentset_update_entity.

    DATA: ls_segment_peticion TYPE zbseg_lg. " para obtener los datos de la peticion

**  recupero los valores de los campos claves para recuperar el registro de la BD
    DATA(lv_bukrs) =  it_key_tab[ name = 'Bukrs' ]-value.
    DATA(lv_belnr) =  it_key_tab[ name = 'Belnr' ]-value.
    DATA(lv_gjahr) =  it_key_tab[ name = 'Gjahr' ]-value.
    DATA(lv_buzei) =  it_key_tab[ name = 'Buzei' ]-value.


    " OBTENGO LOS DATOS DE LA BASE DE DATOS CON LAS CLAVES
***  De esta manera se cuales son los valores actuales en D
    SELECT SINGLE FROM zbseg_lg
      FIELDS *
      WHERE bukrs = @lv_bukrs
        AND belnr = @lv_belnr
        AND gjahr = @lv_gjahr
        INTO @DATA(ls_bseg_lg_ddbb).

    IF sy-subrc = 0.
**  si se encontro un registro

      "se obtienen los datos de la peticion
      io_data_provider->read_entry_data( IMPORTING es_data = ls_segment_peticion ).

** guardo en la estructura update creada (ls_bkpf_lg_update) los datos finales a actualizar en cada campo

      DATA(ls_bseg_lg_update) = VALUE zbseg_lg( bukrs = lv_bukrs "se toma el campo clave
                                                belnr = lv_belnr "se toma el campo clave
                                                gjahr = lv_gjahr "se toma el campo clave
                                                buzei = lv_buzei "se toma el campo clave

" Cuando desde la peticion odata (ls_header_odata ), tengo el valor del campo BLART vacio
" se deja el valor de la base de datos (ls_bkpf_lg_ddbb) sino se asigna el valor de la peticion
" la misma logica aplica para los demas campos NO CLAVES

               buzid = COND #( WHEN ls_segment_peticion-buzid IS NOT INITIAL
                                                                  THEN ls_segment_peticion-buzid
                                                                  ELSE ls_bseg_lg_ddbb-buzid )


                Augdt = COND #( WHEN ls_segment_peticion-Augdt IS NOT INITIAL
                                                                  THEN ls_segment_peticion-Augdt
                                                                  ELSE ls_bseg_lg_ddbb-Augdt )

                Augcp = COND #( WHEN ls_segment_peticion-Augcp IS NOT INITIAL
                                                                  THEN ls_segment_peticion-Augcp
                                                                  ELSE ls_bseg_lg_ddbb-Augcp )

                Augbl = COND #( WHEN ls_segment_peticion-Augbl IS NOT INITIAL
                                                                  THEN ls_segment_peticion-Augbl
                                                                  ELSE ls_bseg_lg_ddbb-Augbl )

                Bschl = COND #( WHEN ls_segment_peticion-Bschl IS NOT INITIAL
                                                                  THEN ls_segment_peticion-Bschl
                                                                  ELSE ls_bseg_lg_ddbb-Bschl )

                Koart = COND #( WHEN ls_segment_peticion-Koart IS NOT INITIAL
                                                                  THEN ls_segment_peticion-Koart
                                                                  ELSE ls_bseg_lg_ddbb-Koart )

                Umskz = COND #( WHEN ls_segment_peticion-Umskz IS NOT INITIAL
                                                                  THEN ls_segment_peticion-Umskz
                                                                  ELSE ls_bseg_lg_ddbb-Umskz )

                Umsks  = COND #( WHEN ls_segment_peticion-Umsks  IS NOT INITIAL
                                                                  THEN ls_segment_peticion-Umsks
                                                                  ELSE ls_bseg_lg_ddbb-Umsks )

                Zumsk = COND #( WHEN ls_segment_peticion-zumsk IS NOT INITIAL
                                                                  THEN ls_segment_peticion-zumsk
                                                                  ELSE ls_bseg_lg_ddbb-zumsk )

                Shkzg = COND #( WHEN ls_segment_peticion-shkzg IS NOT INITIAL
                                                                  THEN ls_segment_peticion-shkzg
                                                                  ELSE ls_bseg_lg_ddbb-shkzg )

                Gsber = COND #( WHEN ls_segment_peticion-Gsber IS NOT INITIAL
                                                                  THEN ls_segment_peticion-Gsber
                                                                  ELSE ls_bseg_lg_ddbb-Gsber )

                Pargb = COND #( WHEN ls_segment_peticion-Pargb IS NOT INITIAL
                                                                  THEN ls_segment_peticion-Pargb
                                                                  ELSE ls_bseg_lg_ddbb-Pargb )

                Tax_Country = COND #( WHEN ls_segment_peticion-Tax_Country IS NOT INITIAL
                                                                  THEN ls_segment_peticion-Tax_Country
                                                                  ELSE ls_bseg_lg_ddbb-Tax_Country )


           ).

**    se actualiza la tabla de base de datos con la estructura creada previamente
      UPDATE zbseg_lg FROM ls_bseg_lg_update.
      IF sy-subrc EQ 0.
        er_entity = ls_segment_peticion.
      ELSE.
        DATA(lv_exception) = abap_true.
      ENDIF.

    ELSE.
      lv_exception = abap_true.
    ENDIF.


    IF lv_exception EQ abap_true.

      DATA(ls_message) = VALUE scx_t100key( msgid = 'SY'
                                            msgno = '002'
                                            attr1 = 'ERROR METODO UPDATE ENTITY: ZSEGMENT - ZBSEG_LG' ).
      RAISE EXCEPTION TYPE /iwbep/cx_epm_busi_exception
        EXPORTING
          textid = ls_message.

    ENDIF.
  ENDMETHOD.

***************************************************************
  METHOD zheaderset_delete_entity.

** recuperamos los campos claves del registro que se va a eliminar
    DATA(lv_bukrs) =  it_key_tab[ name = 'Bukrs' ]-value.
    DATA(lv_belnr) =  it_key_tab[ name = 'Belnr' ]-value.
    DATA(lv_gjahr) =  it_key_tab[ name = 'Gjahr' ]-value.

*************************************************************************************
** OTRA FORMA DE OBTENER LAS CLAVES ES USANDO CONTIENE VARIOS METODOS ADEMAS DE
** GET_KEYS
    DATA(lt_key) = !io_tech_request_context->get_keys(  ).

**  el nombre que va entre corchetes [], el que se encuentra en la columna
    DATA(lv_bukrs_tmp) =  lt_key[ name = 'BUKRS' ]-value.
    DATA(lv_belnr_tmp) =  lt_key[ name = 'BELNR' ]-value.
    DATA(lv_gjahr_tmp) =  lt_key[ name = 'GJAHR' ]-value.

*************************************************************************************

**  ELIMINAMOS EL REGISTRO QUE CUMPLA CON LA CLAVE DE LA PETICION
    DELETE FROM zbkpf_lg  WHERE bukrs = @lv_bukrs AND
                                belnr = @lv_belnr AND
                                gjahr = @lv_gjahr.

    IF sy-subrc NE 0.
**    SI DIO ERROR SE MUESTRA UN MENSAJE DE ERROR
      DATA(ls_message) = VALUE scx_t100key( msgid = 'SY'
                                               msgno = '002'
                                               attr1 = 'ERROR METODO DELETE ENTITY: ZHEADER - ZBKPF_LG' ).
      RAISE EXCEPTION TYPE /iwbep/cx_epm_busi_exception
        EXPORTING
          textid = ls_message.
    ENDIF.
  ENDMETHOD.

  METHOD zsegmentset_delete_entity.

** recuperamos los campos claves del registro que se va a eliminar
    DATA(lv_bukrs) =  it_key_tab[ name = 'Bukrs' ]-value.
    DATA(lv_belnr) =  it_key_tab[ name = 'Belnr' ]-value.
    DATA(lv_gjahr) =  it_key_tab[ name = 'Gjahr' ]-value.
    DATA(lv_buzei) =  it_key_tab[ name = 'Buzei' ]-value.


**  ELIMINAMOS EL REGISTRO QUE CUMPLA CON LA CLAVE DE LA PETICION
    DELETE FROM zbseg_lg  WHERE bukrs = @lv_bukrs AND
                                belnr = @lv_belnr AND
                                gjahr = @lv_gjahr AND
                                buzei = @lv_buzei.

    IF sy-subrc NE 0.
**    SI DIO ERROR SE MUESTRA UN MENSAJE DE ERROR
      DATA(ls_message) = VALUE scx_t100key( msgid = 'SY'
                                               msgno = '002'
                                               attr1 = 'ERROR METODO DELETE ENTITY: ZSEGMENT - ZBSEG_LG' ).
      RAISE EXCEPTION TYPE /iwbep/cx_epm_busi_exception
        EXPORTING
          textid = ls_message.
    ENDIF.
  ENDMETHOD.

***************************************************************
  METHOD /iwbep/if_mgw_appl_srv_runtime~get_expanded_entityset.

**  realizamos un CASE para poder determinar desde que entidad se esta
**  haciendo la llamada

** se recibe el nombre de la entidad set
    CASE iv_entity_set_name.
      WHEN 'ZheaderSet'.
        "entidad cabecera zbkpf_lg

        SELECT FROM zbkpf_lg FIELDS *
        INTO TABLE  @DATA(lt_bkpf_lg).

        IF sy-subcs = 0.
*        con el siguiente metodo movemos los datos
          copy_data_to_ref(  EXPORTING   is_data = lt_bkpf_lg
                             CHANGING    cr_data = er_entityset ).
        ENDIF.


      WHEN 'ZsegmentSet'.
        "entidad de segmentos zbseg_lg

**  recupero los valores de los campos claves para recuperar el registro de la BD
        DATA(lv_bukrs) =  it_key_tab[ name = 'Bukrs' ]-value.
        DATA(lv_belnr) =  it_key_tab[ name = 'Belnr' ]-value.
        DATA(lv_gjahr) =  it_key_tab[ name = 'Gjahr' ]-value.

**  Recuperamos los datos de la BD con los campos claves
        SELECT FROM zbseg_lg
        FIELDS *
        WHERE bukrs = @lv_bukrs AND
              belnr = @lv_belnr AND
              gjahr = @lv_gjahr
        INTO TABLE @DATA(lt_bseg_lg).

        IF sy-subcs = 0.
*        con el siguiente metodo movemos los datos
          copy_data_to_ref(  EXPORTING   is_data = lt_bseg_lg
                             CHANGING    cr_data = er_entityset ).
        ENDIF.

    ENDCASE.
  ENDMETHOD.

ENDCLASS.
