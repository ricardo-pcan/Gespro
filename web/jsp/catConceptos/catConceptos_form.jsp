<%-- 
    Document   : catProductos_form
    Created on : 22/11/2012, 10:13:30 AM
    Author     : Leonardo
--%>

<%@page import="com.tsp.gespro.jdbc.EmpresaPermisoAplicacionDaoImpl"%>
<%@page import="com.tsp.gespro.dto.EmpresaPermisoAplicacion"%>
<%@page import="com.tsp.gespro.bo.ExistenciaAlmacenBO"%>
<%@page import="com.tsp.gespro.bo.EmpresaBO"%>
<%@page import="com.tsp.gespro.dto.Empresa"%>
<%@page import="com.tsp.gespro.config.Configuration"%>
<%@page import="com.tsp.gespro.util.DateManage"%>
<%@page import="com.tsp.gespro.bo.RolesBO"%>
<%@page import="com.tsp.gespro.bo.UsuarioBO"%>
<%@page import="com.tsp.gespro.bo.ConceptoBO"%>
<%@page import="com.tsp.gespro.bo.CategoriaBO"%>
<%@page import="com.tsp.gespro.bo.EmbalajeBO"%>
<%@page import="com.tsp.gespro.bo.MarcaBO"%>
<%@page import="com.tsp.gespro.jdbc.ConceptoDaoImpl"%>
<%@page import="com.tsp.gespro.dto.Concepto"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:useBean id="user" scope="session" class="com.tsp.gespro.bo.UsuarioBO"/>

<%
//Verifica si el cliente tiene acceso a este topico
    if (user == null || !user.permissionToTopicByURL(request.getRequestURI().replace(request.getContextPath(), ""))) {
        response.sendRedirect("../../jsp/inicio/login.jsp?action=loginRequired&urlSource=" + request.getRequestURI() + "?" + request.getQueryString());
        response.flushBuffer();
    } else {

        int paginaActual = 1;
        try {
            paginaActual = Integer.parseInt(request.getParameter("pagina"));
        } catch (Exception e) {
        }

        int idEmpresa = user.getUser().getIdEmpresa();

        /*
         * Parámetros
         */
        int idConcepto = 0;
        try {
            idConcepto = Integer.parseInt(request.getParameter("idConcepto"));
        } catch (NumberFormatException e) {
        }

        /*
         *   0/"" = nuevo
         *   1 = editar/consultar
         *   2 = eliminar  
         */
        String mode = request.getParameter("acc") != null ? request.getParameter("acc") : "";

        ConceptoBO conceptoBO = new ConceptoBO(user.getConn());
        Concepto conceptosDto = null;
        ExistenciaAlmacenBO exisAlmBO = new ExistenciaAlmacenBO(user.getConn());
        double stockGral = 0;

        if (idConcepto > 0) {
            conceptoBO = new ConceptoBO(idConcepto, user.getConn());
            conceptosDto = conceptoBO.getConcepto();
            //Obtenemos stock gral del prod
            //stockGral = exisAlmBO.getExistenciaGeneralByEmpresaProducto(idEmpresa, conceptosDto.getIdConcepto());
        }

        String parameter1 = "idConcepto";

        Configuration appConfig = new Configuration();

        Empresa empresaDto = new EmpresaBO(idEmpresa, user.getConn()).getEmpresa();
        
        EmpresaBO empresaBO = new EmpresaBO(user.getConn());
        EmpresaPermisoAplicacion empresaPermisoAplicacionDto = new EmpresaPermisoAplicacionDaoImpl(user.getConn()).findByPrimaryKey(empresaBO.getEmpresaMatriz(user.getUser().getIdEmpresa()).getIdEmpresa());
        
       /* String verificadorSesionGuiaCerrada = "0";
        String cssDatosObligatorios = "border:3px solid red;";//variable para colocar el css del recuadro que encierra al input para la guia interactiva
        try{
            if(session.getAttribute("sesionCerrada")!= null){
                verificadorSesionGuiaCerrada = (String)session.getAttribute("sesionCerrada");
            }
        }catch(Exception e){}*/
        
        session.setAttribute("RelacionConceptoEmbalajeSesion", null);
        session.setAttribute("RelacionConceptoCompetenciaSesion", null);        
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <jsp:include page="../include/keyWordSEO.jsp" />

        <title><jsp:include page="../include/titleApp.jsp" /></title>

        <jsp:include page="../include/skinCSS.jsp" />

        <jsp:include page="../include/jsFunctions.jsp"/>

        <script type="text/javascript">

            function grabar() {
                if (validar()) {
                    $.ajax({
                        type: "POST",
                        url: "catConceptos_ajax.jsp",
                        data: $("#frm_action").serialize(),
                        beforeSend: function(objeto) {
                            $("#action_buttons").fadeOut("slow");
                            $("#ajax_loading").html('<div style=""><center>Procesando...<br/><img src="../../images/ajax_loader.gif" alt="Cargando.." /></center></div>');
                            $("#ajax_loading").fadeIn("slow");
                        },
                        success: function(datos) {
                            if (datos.indexOf("--EXITO-->", 0) > 0) {
                                $("#ajax_message").html(datos);
                                $("#ajax_loading").fadeOut("slow");
                                $("#ajax_message").fadeIn("slow");
                                $.scrollTo('#inner', 800);
                                apprise('<center><img src=../../images/info.png> <br/>' + datos + '</center>', {'animate': true},
                                function(r) {
                                    location.href = "catConceptos_list.jsp?pagina=" + "<%=paginaActual%>";
                                });
                            } else {
                                $("#ajax_loading").fadeOut("slow");
                                $("#ajax_message").html(datos);
                                $("#ajax_message").fadeIn("slow");
                                $("#action_buttons").fadeIn("slow");
                                $.scrollTo('#inner', 800);
                            }
                        }
                    });
                }
            }

            function validar() {
                /*
                 if(jQuery.trim($("#nombre").val())==""){
                 apprise('<center><img src=../../images/warning.png> <br/>El dato "nombre de contacto" es requerido</center>',{'animate':true});
                 $("#nombre_contacto").focus();
                 return false;
                 }
                 */
                return true;
            }
        </script>
        <script type="text/javascript">

            function mostrarCalendario() {
                $("#fecha_caducidad").datepicker({
                    minDate: +1,
                    gotoCurrent: true,
                    changeMonth: true,
                    beforeShow: function(input, datepicker) {
                        setTimeout(function() {
                            $(datepicker.dpDiv).css('zIndex', 100);
                        }, 500)
                    }
                });
            }


            function dinamicList(idList) {

                var idElement;
                var optionDefault = '<option value="-1">Selecciona una Subcategoria</option>';


                if (idList == 1) {
                    idElement = $('#categoriaConcepto').val();
                    $("#subCategoria2Concepto").empty();
                    $("#subCategoria3Concepto").empty();
                    $("#subCategoria4Concepto").empty();
                } else if (idList == 2) {
                    idElement = $('#subCategoriaConcepto').val();
                    $("#subCategoria3Concepto").empty();
                    $("#subCategoria4Concepto").empty();
                } else if (idList == 3) {
                    idElement = $('#subCategoria2Concepto').val();
                    $("#subCategoria4Concepto").empty();
                } else if (idList == 4) {
                    idElement = $('#subCategoria3Concepto').val();
                }


                $.ajax({
                    type: "POST",
                    url: "catConceptos_ajax.jsp",
                    data: {mode: "combos", idElement: idElement},
                    success: function(datos) {
                        if (idList == 1) {
                            $("#subCategoriaConcepto").empty();
                            $("#subCategoriaConcepto").append(optionDefault);
                            $("#subCategoriaConcepto").append(datos.trim());
                        } else if (idList == 2) {
                            $("#subCategoria2Concepto").empty();
                            $("#subCategoria2Concepto").append(optionDefault);
                            $("#subCategoria2Concepto").append(datos.trim());
                        } else if (idList == 3) {
                            $("#subCategoria3Concepto").empty();
                            $("#subCategoria3Concepto").append(optionDefault);
                            $("#subCategoria3Concepto").append(datos.trim());
                        } else if (idList == 4) {
                            $("#subCategoria4Concepto").empty();
                            $("#subCategoria4Concepto").append(optionDefault);
                            $("#subCategoria4Concepto").append(datos.trim());
                        }
                    }
                });


            }

            function recuperarNombreArchivoImagen(nombreImagen) {
                $('#nombreArchivoImagen').val('' + nombreImagen);
            }

            function validaDescuento(dscnto) {
                if (dscnto == 1) {
                    $("#montoComision").val("0.0");
                } else if (dscnto == 2) {
                    $("#porcentajeComision").val("0.0");
                }
            }

        </script>
    </head>
    <body>
        <div class="content_wrapper">

            <jsp:include page="../include/header.jsp" flush="true"/>

            <jsp:include page="../include/leftContent.jsp"/>

            <!-- Inicio de Contenido -->
            <div id="content">

                <div class="inner">
                    <h1>Concepto</h1>

                    <div id="ajax_loading" class="alert_info" style="display: none;"></div>
                    <div id="ajax_message" class="alert_warning" style="display: none;"></div>

                    <!--TODO EL CONTENIDO VA AQUÍ-->
                    <form action="" method="post" id="frm_action">
                        <div class="twocolumn">


                            <!-- Start left column window -->
                            <div class="column_left">
                                <div class="header">
                                    <span>
                                        <img src="../../images/icon_producto.png" alt="icon"/>
                                        <% if (conceptosDto != null) {%>
                                        Editar Concepto ID <%=conceptosDto != null ? conceptosDto.getIdConcepto() : ""%>
                                        <%} else {%>
                                        Concepto
                                        <%}%>
                                    </span>
                                </div>
                                <br class="clear"/>
                                <div class="content">
                                    <input type="hidden" id="idConcepto" name="idConcepto" value="<%=conceptosDto != null ? conceptosDto.getIdConcepto() : ""%>" />
                                    <input type="hidden" id="mode" name="mode" value="<%=mode%>" />
                                    <input type="hidden" id="rfcEmpresa" name="rfcEmpresa" value="<%=empresaDto.getRfc()%>" />

                                    <p>
                                        <label>*Nombre:</label><br/>
                                        <input maxlength="100" type="text" id="nombreConcepto" name="nombreConcepto" style="width:300px;"
                                               value="<%=conceptosDto != null ? conceptoBO.getConcepto().getNombre(): ""%>"
                                               <%=conceptosDto != null ? "readonly" : ""%>/>
                                    </p>
                                    <br/>
                                    <p>
                                        <label>Descripción:</label><br/>
                                        <input maxlength="2000" type="text" id="descripcion" name="descripcion" style="width:300px;"
                                               value="<%=conceptosDto != null ? conceptoBO.getConcepto().getDescripcion() : ""%>"/>
                                    </p>
                                    <br/> 
                                    <p>
                                        <label>Código:</label><br/>
                                        <input maxlength="50" type="text" id="skuConcepto" name="skuConcepto" style="width:300px;"
                                               value="<%=conceptosDto != null ? conceptoBO.getConcepto().getIdentificacion() : ""%>"/>
                                    </p>
                                    <br/>
                                    <p>
                                        <label>Clave</label><br/>
                                        <input maxlength="50" type="text" id="claveConcepto" name="claveConcepto" style="width:300px"
                                               value="<%=conceptosDto != null ? conceptoBO.getConcepto().getClave() : ""%>"/>
                                    </p>
                                    <br/>
                                    <p>
                                        <label>*Precio Menudeo/Unitario:</label><br/>
                                        <input maxlength="16" type="text" id="precioConcepto" name="precioConcepto" style="width:300px;"
                                               value="<%=conceptosDto != null ? conceptoBO.getConcepto().getPrecio() : "0"%>"
                                               onkeypress="return validateNumber(event);"/>                                        
                                    </p>
                                    <br/>
                                    <!--<p>
                                        <label>Precio de Compra:</label><br/>
                                        <input maxlength="16" type="text" id="precioCompraConcepto" name="precioCompraConcepto" style="width:300px"
                                               value="<%=conceptosDto != null ? conceptoBO.getConcepto().getPrecioCompra() : "0"%>"
                                               onkeypress="return validateNumber(event);"/>
                                    </p>-->                                    
                                    <!--<br/> 
                                    <p>
                                        <label>Precio Minimo de Venta:</label><br/>
                                        <input maxlength="16" type="text" id="precioMinimoVenta" name="precioMinimoVenta" style="width:300px"
                                               value="<%=conceptosDto != null ? conceptoBO.getConcepto().getPrecioMinimoVenta() : "0"%>"
                                               onkeypress="return validateNumber(event);"/>
                                    </p>                                    
                                    <br/>-->
                                    <p>
                                        <label>Marca:</label><br/>
                                        <select size="1" id="marcaConcepto" name="marcaConcepto" style="width:300px" >
                                            <option value="-1">Selecciona una Marca</option>
                                            <%
                                                out.print(new MarcaBO(user.getConn()).getMarcasByIdHTMLCombo(idEmpresa, (conceptosDto != null ? conceptosDto.getIdMarca() : -1)));
                                            %>
                                        </select>
                                        <!-- <input maxlength="200" type="text" id="marcaConcepto" name="marcaConcepto" style="width:300px"
                                               value="<//%=conceptosDto != null ? conceptoBO.getConcepto().getIdMarca() : ""%>"/> -->
                                    </p>
                                    <br/>
                                    <p>
                                        <label>Embalaje:</label><br/>
                                        <input maxlength="50" type="text" id="embalaConcepto" name="embalaConcepto" style="width:300px"
                                               value="Listado de Embalajes" readonly/>
                                        <a href="../../jsp/catConceptos/catConceptoEmbalajes_list.jsp?idConcepto=<%=conceptosDto!=null?conceptosDto.getIdConcepto():"0" %>" 
                                           id="btn_embalaje_concepto" title="Embalajes" class="modalbox_iframe">
                                            <img src="../../images/icon_embalaje.png" alt="Embalajes" class="help" title="Embalajes"/><br/>
                                        </a>
                                    </p>
                                    <br/>
                                    <p>
                                        <label>Competencia:</label><br/>
                                        <input maxlength="50" type="text" id="competenciaConcepto" name="competenciaConcepto" style="width:300px"
                                               value="Listado de Competencia" readonly/>
                                        <a href="../../jsp/catConceptos/catConceptoCompetencias_list.jsp?idConcepto=<%=conceptosDto!=null?conceptosDto.getIdConcepto():"0" %>" 
                                           id="btn_competencia_concepto" title="Competencia" class="modalbox_iframe">
                                            <img src="../../images/icon_proveedor.png" alt="Competencia" class="help" title="Competencia"/><br/>
                                        </a>
                                    </p>
                                    <br/>
                                    <p>
                                        <input type="checkbox" class="checkbox" <%=conceptosDto != null ? (conceptosDto.getIdEstatus() == 1 ? "checked" : "") : "checked"%> id="estatus" name="estatus" value="1"> <label for="estatus">Activo</label>
                                    </p>                                                                   

                                    <br/><br/>

                                    <div id="action_buttons">
                                        <p>
                                            <input type="button" id="enviar" value="Guardar" onclick="grabar();"/>
                                            <input type="button" id="regresar" value="Regresar" onclick="history.back();"/>
                                        </p>
                                    </div>                                    

                                </div>
                            </div>
                            <!-- End left column window -->



                            <!--Columna derecha-->
                            <!--<div class="column_right">
                                <div class="header">
                                    <span>

                                    </span>
                                </div>  
                                <br class="clear"/>
                                <div class="content">
                                    <p>
                                        <label>Stock General:</label><br/>
                                        <input maxlength="10" type="text" id="stockConcepto" name="stockConcepto" style="width:300px"
                                               value="<%=stockGral%>" readonly/>
                                    </p>
                                    <br/>
                                    
                                    <p>
                                        <label>Stock Inicial:</label><br/>
                                        <input maxlength="10" type="text" id="stockInicial" name="stockInicial" style="width:300px"
                                               value="<%=stockGral%>" />
                                    </p>
                                    <br/>
                                                                                                            
                                    
                                    <//%
                                        boolean isAGranel = false;
                                        try {
                                            isAGranel = (conceptosDto != null ? ((conceptosDto.getPrecioUnitarioGranel() > 0 || conceptosDto.getPrecioMedioGranel() > 0 || conceptosDto.getPrecioMayoreoGranel() > 0 || conceptosDto.getPrecioEspecialGranel() > 0) ? true : false) : false);
                                        } catch (Exception ex) {
                                        }
                                    %>
                                    <p>
                                        <input id="chk_isagranel" name="chk_isagranel" type="checkbox" class="checkbox" onchange="$('#div_isagranel').toggle();"
                                               <//%= isAGranel ? "checked" : ""%> > 
                                        <label for="q_venta_a_granel">Venta a Granel</label>
                                    </p>
                                    <div id="div_isagranel" style="display: <//%= isAGranel ? "block" : "none"%> ;">
                                        <p>
                                            <label>*Precio Menudeo/Unitario a Granel:</label><br/>
                                            <input maxlength="16" type="text" id="precioConceptoGranelUnitario" name="precioConceptoGranelUnitario" style="width:300px"
                                                   value="<//%=conceptosDto != null ? conceptoBO.getConcepto().getPrecioUnitarioGranel() : "0"%>"
                                                   onkeypress="return validateNumber(event);"/>
                                            <a href="../../jsp/catConceptos/catConceptos_precioPorCliente_form.jsp?tipoPrecio=UnitarioGranel&idConcepto=<%=conceptosDto!=null?conceptosDto.getIdConcepto():"0" %>" id="btn_precio_cliente" title="Busqueda Avanzada"
                                                        class="modalbox_iframe">
                                             <img src="../../images/icon_clienteDeuda.png" alt="Precio Unitario por Cliente" class="help" title="Precio Unitario por Cliente"/><br/>
                                            </a>
                                        </p>
                                        
                                        <p>
                                            <label>*Precio Medio Mayoreo a Granel:</label><br/>
                                            <input maxlength="16" type="text" id="precioConceptoGranelMedio" name="precioConceptoGranelMedio" style="width:300px"
                                                   value="<//%=conceptosDto != null ? conceptoBO.getConcepto().getPrecioMedioGranel() : "0"%>"
                                                   onkeypress="return validateNumber(event);"/>
                                            <a href="../../jsp/catConceptos/catConceptos_precioPorCliente_form.jsp?tipoPrecio=MedioGranel&idConcepto=<%=conceptosDto!=null?conceptosDto.getIdConcepto():"0" %>" id="btn_precio_cliente" title="Busqueda Avanzada"
                                                        class="modalbox_iframe">
                                             <img src="../../images/icon_clienteDeuda.png" alt="Precio Medio por Cliente" class="help" title="Precio Medio por Cliente"/><br/>
                                            </a>
                                        </p>
                                        
                                        <p>
                                            <label>*Precio Mayoreo a Granel:</label><br/>
                                            <input maxlength="16" type="text" id="precioConceptoGranelMayoreo" name="precioConceptoGranelMayoreo" style="width:300px"
                                                   value="<//%=conceptosDto != null ? conceptoBO.getConcepto().getPrecioMayoreoGranel() : "0"%>"
                                                   onkeypress="return validateNumber(event);"/>
                                            <a href="../../jsp/catConceptos/catConceptos_precioPorCliente_form.jsp?tipoPrecio=MayoreoGranel&idConcepto=<%=conceptosDto!=null?conceptosDto.getIdConcepto():"0" %>" id="btn_precio_cliente" title="Busqueda Avanzada"
                                                        class="modalbox_iframe">
                                             <img src="../../images/icon_clienteDeuda.png" alt="Precio Mayoreo por Cliente" class="help" title="Precio Mayoreo por Cliente"/><br/>
                                            </a>
                                        </p>
                                        
                                        <p>
                                            <label>*Precio Especial a Granel:</label><br/>
                                            <input maxlength="16" type="text" id="precioConceptoGranelEspecial" name="precioConceptoGranelEspecial" style="width:300px"
                                                   value="<//%=conceptosDto != null ? conceptoBO.getConcepto().getPrecioEspecialGranel() : "0"%>"
                                                   onkeypress="return validateNumber(event);"/>
                                            <a href="../../jsp/catConceptos/catConceptos_precioPorCliente_form.jsp?tipoPrecio=EspecialGranel&idConcepto=<%=conceptosDto!=null?conceptosDto.getIdConcepto():"0" %>" id="btn_precio_cliente" title="Busqueda Avanzada"
                                                        class="modalbox_iframe">
                                             <img src="../../images/icon_clienteDeuda.png" alt="Precio Especial por Cliente" class="help" title="Precio Especial por Cliente"/><br/>
                                            </a>
                                        </p>                                        
                                    </div>
                                                                            
                                        
                                    <br/>
                                    <p>
                                        <label>Desglose de Piezas:</label><br/>
                                        <input maxlength="10" type="text" id="desglosePiezas" name="desglosePiezas" style="width:300px"
                                               value="<//%=conceptosDto != null ? conceptoBO.getConcepto().getDesglosePiezas() : "1"%>"
                                               onkeypress="return validateNumber(event);"/>
                                    </p>
                                    <br/>
                                    <p>
                                        <label>Descripcion Corta:</label><br/>
                                        <input maxlength="50" type="text" id="descrCortaConcepto" name="descrCortaConcepto" style="width:300px"
                                               value="<//%=conceptosDto != null ? conceptoBO.getConcepto().getDescripcionCorta() : ""%>"/>
                                    </p>
                                    <br/>
                                    <!--<p>
                                        <label>Almacen:</label><br/>
                                        <select size="1" id="almacenConcepto" name="almacenConcepto" style="width:300px" >
                                        <option value="-1">Seleccione un Almacen</option>-->
                                    
                                    <!--</select>-->
                                    <!-- <input maxlength="200" type="text" id="almacenConcepto" name="almacenConcepto" style="width:300px"
                                           value="<%//=conceptosDto!=null?conceptoBO.getConcepto().getIdAlmacen():"" %>"/> -->
                                    <!-- </p>
                                     <br/> -->
                          <!--          <p>
                                        <label>Stock Minimo:</label><br/>
                                        <input maxlength="16" type="text" id="stockMinimoConcepto" name="stockMinimoConcepto" style="width:300px"
                                               value="<//%=conceptosDto != null ? conceptoBO.getConcepto().getStockMinimo() : "0"%>"
                                               onkeypress="return validateNumber(event);"/>
                                        &nbsp;
                                        <label>Aviso:</label>
                                        <input type="checkbox" class="checkbox" <//%=conceptosDto != null ? (conceptosDto.getStockAvisoMin() == (short) 1 ? "checked" : "") : "checked"%> id="avisoStockConcepto" name="avisoStockConcepto" value="1"> <label for="estatus">Activo</label>
                                        <!-- <input maxlength="200" type="text" id="avisoStockConcepto" name="avisoStockConcepto" style="width:300px"
                                               value="<//%=conceptosDto != null ? conceptoBO.getConcepto().getStockAvisoMin() : ""%>"/> -->
                         <!--           </p>
                                       
                                    </br>
                                    <//%
                                        boolean isPerecedero = false;
                                        try {
                                            isPerecedero = (conceptosDto != null ? ((!conceptosDto.getNumeroLote().equals("") || conceptosDto.getFechaCaducidad() != null) ? true : false) : false);
                                        } catch (Exception ex) {
                                        }
                                    %>
                                    <p>
                                        <input id="chk_isperecedero" name="chk_isperecedero" type="checkbox" class="checkbox" onchange="$('#div_isperecedero').toggle();"
                                               <//%= isPerecedero ? "checked" : ""%> > 
                                        <label for="q_nivel_min_stock">Perecedero</label>
                                    </p>
                                    <div id="div_isperecedero" style="display: <//%= isPerecedero ? "block" : "none"%> ;">
                                        <p>
                                            <label>Numero de Lote:</label><br/>
                                            <input maxlength="30" type="text" id="loteConcepto" name="loteConcepto" style="width:300px"
                                                   value="<//%=conceptosDto != null ? conceptoBO.getConcepto().getNumeroLote() : ""%>"/>
                                        </p>
                                        
                                        <p>
                                            <label>Fecha Caducidad:</label><br/>
                                            <input type="text" name="fecha_caducidad" id="fecha_caducidad" size="30" readonly
                                                   value="<//%=conceptosDto != null ? DateManage.formatDateToNormal(conceptoBO.getConcepto().getFechaCaducidad()) : ""%>"/>
                                        </p>
                                    </div>                                   
                                </div>
                            </div>-->
                            <!--Fin Columna derecha-->
                           
                            
                            <div class="column_right">
                                <div class="header">
                                    <span>                                                                  
                                        Imagen del Producto                                   
                                    </span>
                                </div>
                                <br class="clear"/>
                                <div class="content">                                    
                                    <p>
                                    <div>
                                        <label>*Subir Archivo (.jpg)</label><br/>
                                        <iframe src="../file/uploadSingleForm.jsp?id=archivoImagen&validate=jpg&queryCustom=isImagenConceptoAdjunto=1" 
                                                id="iframe_archivos_jpg" 
                                                name="iframe_archivos_jpg" 
                                                style="border: none; float: top;" scrolling="no" 
                                                height="40" width="100%"  >
                                            <p>Tu navegador no soporta iframes y son necesarios para el buen funcionamiento del aplicativo</p>
                                        </iframe>
                                    </div>
                                    </p>
                                    
                                    <p>
                                        <label>*Nombre Archivo:</label><br/>
                                        <input maxlength="30" type="text" id="nombreArchivoImagen" name="nombreArchivoImagen" style="width:300px"
                                               readonly value="<%=conceptosDto!=null? (conceptosDto.getImagenNombreArchivo()!=null?conceptosDto.getImagenNombreArchivo():""):"" %>"/>
                                    </p>
                                    <br/>
                                    
                                    <% if (conceptosDto!=null && empresaDto!=null) {
                                        if(conceptosDto.getImagenNombreArchivo()!=null){
                                        String rutaArchivoImagenPersonal = appConfig.getApp_content_path() + empresaDto.getRfc() + "/ImagenConcepto/" + conceptosDto.getImagenNombreArchivo();
                                        String rutaArchivoImgEncoded = java.net.URLEncoder.encode(rutaArchivoImagenPersonal, "UTF-8");
                                    %>
                                    <p>
                                        <label>Imagen</label>
                                        <div style="display: inline" >
                                            <a href="../file/download.jsp?ruta_archivo=<%=rutaArchivoImgEncoded%>">Descargar</a>
                                        </div>
                                    </p>
                                    <%}}%>
                                    

                                </div>         
                            </div>
                            
                      
                            <!--I Columna derecha-->
                            <!--<div class="column_right">
                                <div class="header">
                                    <span>                                    
                                        Datos Adicionales                              
                                    </span>
                                </div>
                                <br class="clear"/>
                                <div class="content" style="display:block;">
                                    <p>
                                        <label>Detalle del producto:</label><br/>
                                        <input type="text" id="detalleConcepto" name="detalleConcepto" style="width:300px"
                                               value="<//%=conceptosDto != null ? (conceptoBO.getConcepto().getDetalle() != null ? conceptoBO.getConcepto().getDetalle() : "") : ""%>"/>
                                    </p>
                                    <br/>
                                    <p>
                                        <label>Volumen (m3):</label><br/>
                                        <input maxlength="16" type="text" id="volumenConcepto" name="volumenConcepto" style="width:300px"
                                               value="<//%=conceptosDto != null ? conceptoBO.getConcepto().getVolumen() : "0"%>"
                                               onkeypress="return validateNumber(event);"/>
                                    </p>
                                    <br/>
                                    <p>
                                        <label>Peso (gr.):</label><br/>
                                        <input maxlength="16" type="text" id="pesoConcepto" name="pesoConcepto" style="width:300px"
                                               value="<//%=conceptosDto != null ? conceptoBO.getConcepto().getPeso() : "0"%>"
                                               onkeypress="return validateNumber(event);"/>
                                    </p>
                                    <br/>

                                    <p>
                                        <label>Observaciones:</label><br/>
                                        <input type="text" id="observacionesConcepto" name="observacionesConcepto" style="width:300px"
                                               value="<//%=conceptosDto != null ? (conceptoBO.getConcepto().getObservaciones() != null ? conceptoBO.getConcepto().getObservaciones() : "") : ""%>"/>
                                    </p>
                                    <br/>

                                    <p>
                                        <label>Impuesto:</label><br/>
                                        <input maxlength="15" type="text" id="idImpuestoConcepto" name="idImpuestoConcepto" style="width:300px"
                                               value="<//%=conceptosDto != null ? (conceptoBO.getConcepto().getImpuestoXConcepto() == 0 ? "Exento de Impuesto" : "Con Impuestos Relacionados") : ""%>" 
                                               readonly/>
                                        <//% if (conceptosDto != null) {%>    
                                        <a href="catImpuestosRelacionados_list.jsp?<//%=parameter1%>=<//%=conceptosDto != null ? conceptoBO.getConcepto().getIdConcepto() : ""%>" id="consultaImpuestos" title="Asignar Impuestos" class="modalbox_iframe">
                                            <img src="../../images/icon_agregar.png" alt="Nuevo Impuesto" class="help" title="Consultar"/><br/>
                                        </a>

                                        <//%} else {%>
                                        <br>
                                        Para cargar impuestos al concepto; primero crearlo y despues asignar impuestos
                                        <//%}%>    
                                    </p>

                                    <br/>

                                </div>
                            </div>

                            <!--Fin Columna derecha-->       

                            
                            
                            <!--Columna izquierda Precios-->
                        <div class="column_right">
                            <div class="header">
                                <span>
                                   Categorías &dArr;
                                </span>
                            </div>  
                            <br class="clear"/>
                            <div class="content" style="display: block;">     
                                <p>
                                        <label>Categoría:</label><br/>
                                        <select size="1" id="categoriaConcepto" name="categoriaConcepto" style="width:300px" onchange="dinamicList(1);" >                                        
                                                <%
                                                    out.print(new CategoriaBO(user.getConn()).getCategoriasByIdHTMLCombo(idEmpresa, (conceptosDto!=null?conceptosDto.getIdCategoria():-1) ,""));
                                                %>
                                        </select>                                       
                                    </p>
                                    <br/>
                                    <p>
                                        <label>Subcategoría 1:</label><br/>
                                        <select size="1" id="subCategoriaConcepto" name="subCategoriaConcepto" style="width:300px" onchange="dinamicList(2);">                                                                              
                                            <%
                                                    out.print(new CategoriaBO(user.getConn()).getCategoriasByIdHTMLCombo(idEmpresa, (conceptosDto!=null?conceptosDto.getIdSubcategoria():-1) , (conceptosDto!=null?" AND (id_categoria_padre <> -1 AND id_categoria_padre="+conceptosDto.getIdCategoria()+")":"") ));
                                            %>
                                        </select>                                        
                                    </p>                                    
                                    <br/> 
                                    <p>
                                        <label>Subcategoría 2:</label><br/>
                                        <select size="1" id="subCategoria2Concepto" name="subCategoria2Concepto" style="width:300px" onchange="dinamicList(3);">                                                                     
                                            <%
                                                    out.print(new CategoriaBO(user.getConn()).getCategoriasByIdHTMLCombo(idEmpresa, (conceptosDto!=null?conceptosDto.getIdSubcategoria2():-1) , (conceptosDto!=null?" AND (id_categoria_padre <> -1 AND id_categoria_padre="+conceptosDto.getIdSubcategoria()+")":"") ));
                                            %>
                                        </select>
                                        
                                    </p>                                    
                                    <br/> 
                                    <p>
                                        <label>Subcategoría 3:</label><br/>
                                        <select size="1" id="subCategoria3Concepto" name="subCategoria3Concepto" style="width:300px" onchange="dinamicList(4);">   
                                            <%
                                                    out.print(new CategoriaBO(user.getConn()).getCategoriasByIdHTMLCombo(idEmpresa, (conceptosDto!=null?conceptosDto.getIdSubcategoria3():-1) , (conceptosDto!=null?" AND (id_categoria_padre <> -1 AND id_categoria_padre="+conceptosDto.getIdSubcategoria2()+")":"") ));
                                            %>
                                        </select>
                                        
                                    </p>                                    
                                    <br/> 
                                    <p>
                                        <label>Subcategoría 4:</label><br/>
                                        <select size="1" id="subCategoria4Concepto" name="subCategoria4Concepto" style="width:300px">   
                                            <%
                                                    out.print(new CategoriaBO(user.getConn()).getCategoriasByIdHTMLCombo(idEmpresa, (conceptosDto!=null?conceptosDto.getIdSubcategoria4():-1) , (conceptosDto!=null?" AND (id_categoria_padre <> -1 AND id_categoria_padre="+conceptosDto.getIdSubcategoria3()+")":"")  ));
                                            %>
                                        </select>
                                        
                                    </p>                                    
                                    <br/>
                            </div>
                            
                        </div>
                        
                        <!--fin Columna izquierda Precios-->
                        
                            
                            
                            
                            
                             <!--Columna izquierda Precios-->
                        <div class="column_left">
                            <div class="header">
                                <span>
                                   Catálogo de Precios  &dArr;
                                </span>
                            </div>  
                            <br class="clear"/>
                            <div class="content" style="display: none;">     
                                <p>
                                    <label>Menudeo : </label><br/>
                                    Hasta: <input maxlength="16" type="text" id="maxPrecioMenudeoConcepto" name="maxPrecioMenudeoConcepto" style="width:180px"
                                           value="<%=conceptosDto!=null?conceptoBO.getConcepto().getMaxMenudeo():"0" %>"
                                           onkeypress="return validateNumber(event);"/> unidades.
                                </p>
                                <br/>  
                                <p>
                                    <label>Precio Medio Mayoreo :</label><br/>
                                    <input maxlength="16" type="text" id="precioMedioMayoreoConcepto" name="precioMedioMayoreoConcepto" style="width:300px"
                                           value="<%=conceptosDto!=null?conceptoBO.getConcepto().getPrecioMedioMayoreo():"0" %>"
                                           onkeypress="return validateNumber(event);"/>
                                    
                                </p>
                                <br/>
                                <p>
                                    <label>Medio Mayoreo: </label><br/>
                                    Desde: <input maxlength="16" type="text" id="minPrecioMedioConcepto" name="minPrecioMedioConcepto" style="width:60px"
                                           value="<%=conceptosDto!=null?conceptoBO.getConcepto().getMinMedioMayoreo():"0" %>"
                                           onkeypress="return validateNumber(event);"/> 
                                    Hasta: <input maxlength="16" type="text" id="maxPrecioMedioConcepto" name="maxPrecioMedioConcepto" style="width:60px"
                                           value="<%=conceptosDto!=null?conceptoBO.getConcepto().getMaxMedioMayoreo():"0" %>"
                                           onkeypress="return validateNumber(event);"/> unidades.
                                </p> 
                                <br/>     
                                <p>
                                    <label>Precio Mayoreo :</label><br/>
                                    <input maxlength="16" type="text" id="precioMayoreoConcepto" name="precioMayoreoConcepto" style="width:300px"
                                           value="<%=conceptosDto!=null?conceptoBO.getConcepto().getPrecioMayoreo():"0" %>"
                                           onkeypress="return validateNumber(event);"/>
                                    
                                </p>
                                <br/>
                                <p>
                                    <label>Mayoreo: </label><br/>                                    
                                    Desde: <input maxlength="16" type="text" id="minPrecioMayoreoConcepto" name="minPrecioMayoreoConcepto" style="width:180px"
                                           value="<%=conceptosDto!=null?conceptoBO.getConcepto().getMinMayoreo():"0" %>"
                                           onkeypress="return validateNumber(event);"/> unidades.
                                </p> 
                                <br/>
                                <p>
                                    <label>Precio Docena (Precio Unitario):</label><br/>
                                    <input maxlength="16" type="text" id="precioDocenaConcepto" name="precioDocenaConcepto" style="width:300px"
                                           value="<%=conceptosDto!=null?conceptoBO.getConcepto().getPrecioDocena():"0" %>"
                                           onkeypress="return validateNumber(event);"/>
                                    
                                </p>
                                <br/>
                                <p>
                                    <label>Precio Especial (Precio Unitario):</label><br/>
                                    <input maxlength="16" type="text" id="precioEspecialConcepto" name="precioEspecialConcepto" style="width:300px"
                                           value="<%=conceptosDto!=null?conceptoBO.getConcepto().getPrecioEspecial():"0" %>"
                                           onkeypress="return validateNumber(event);"/>
                                   
                                </p> 
                                
                            </div>
                            
                        </div>
                            
                                           
                            <!------------>
                            
                            
                            
                            <!--------------------->				   
                        <!--<div class="column_left">
                            <div class="header">
                                <span>
                                    Comisión por producto &dArr;
                                </span>
                            </div>  
                            <p>
                                <label>Solo en caso de manejar comisión por producto y no por vendedor.</label><br/>
                            </p>
                            <br class="clear"/>
                            <div class="content" style="display: none;">                                    
                                    <p>
                                        <label>Porcentaje Comisión:</label><br/>
                                        <input maxlength="10" type="text" id="porcentajeComision" name="porcentajeComision" style="width:300px"
                                               value="<//%=conceptosDto!=null?conceptoBO.getConcepto().getComisionPorcentaje():"0" %>"
                                               onkeypress="return validateNumber(event);" onchange="validaDescuento(1);"/>
                                    </p>
                                    <br/>
                                    <p>
                                        <label>ó</label><br/>
                                    </p>
                                    <br/>
                                    <p>
                                        <label>Monto Comisión:</label><br/>
                                        <input maxlength="50" type="text" id="montoComision" name="montoComision" style="width:300px"
                                               value="<%=conceptosDto!=null?conceptoBO.getConcepto().getComisionMonto():"0" %>"
                                               onkeypre//ss="return validateNumber(event);" onchange="validaDescuento(2);"/>
                                    </p>
                                    
                                    <br/><br/>
                            </div>
                        </div>-->
                        <!--------------------->
                                           
                          


                        </div>
                    </form>
                    <!--TODO EL CONTENIDO VA AQUÍ-->

                </div>

                <jsp:include page="../include/footer.jsp"/>
            </div>
            <!-- Fin de Contenido-->
        </div>

        <script>
            mostrarCalendario();
        </script>
    </body>
</html>
<%}%>