class ZCL_WEBSERVICE_T100815 definition
  public
  final
  create public .

public section.

  interfaces IF_HTTP_EXTENSION .
protected section.
private section.
ENDCLASS.



CLASS ZCL_WEBSERVICE_T100815 IMPLEMENTATION.


  METHOD if_http_extension~handle_request.

    DATA: lv_x_json TYPE  xstring.
    DATA: lv_werks  TYPE marc-werks.

***   obtenemos el parametro centro de la URL
    lv_werks = server->request->get_form_field( name  = 'Centro' ).

    SELECT FROM zmara_lg AS a
    INNER JOIN  zmarc_lg AS b
    ON a~matnr EQ b~matnr
    FIELDS *
    WHERE a~matnr = b~matnr
      AND b~werks EQ @lv_werks
     INTO TABLE @DATA(available_data).

*** usamos la clase estandar CL_SXML_STRING_WRITER y el metodo
*** CREATE para obtener la instancia
    DATA(lo_json_out) = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_json ).

*** Realizamos la transformacionn
    CALL TRANSFORMATION id SOURCE available_data = available_data[]
                   RESULT XML lo_json_out.

*** se usa la clase cl_abap_codepage para obtener el string
    DATA(lv_json_response) = cl_abap_codepage=>convert_from( lo_json_out->get_output( ) ).

*** como necesitamos enviar los datos en formato xstring usamos la funcion
*** SCMS_STRING_TO_XSTRING
    CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
      EXPORTING
        text   = lv_json_response
*       MIMETYPE       = ' '
*       ENCODING       =
      IMPORTING
        buffer = lv_x_json
      EXCEPTIONS
        failed = 1
        OTHERS = 2.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

***  Headers
    server->response->set_header_field(
      EXPORTING
        name  = 'Content-type'                 " Name of the header field
        value = 'application/json'             " HTTP header field value
    ).

*** Encoding
    server->response->set_header_field(
      EXPORTING
        name  = 'encoding'          " Name of the header field
        value = 'UTF-8'             " HTTP header field value
    ).

** envio de datos
    server->response->set_data(
      EXPORTING
        data               =   lv_x_json                               " Binary data
*      offset             = 0                                        " Offset into binary data
*      length             = -1                                       " Length of binary data
*      vscan_scan_always  = if_http_entity=>co_content_check_profile " Virus Scan Always (A = Always, N = Never, space = Internal)
*      virus_scan_profile = '/SIHTTP/HTTP_DOWNLOAD'                  " Virus Scan Profile
    ).

  ENDMETHOD.
ENDCLASS.
