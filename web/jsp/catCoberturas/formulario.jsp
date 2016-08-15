<%-- 
    Document   : formulario
    Created on : 07/08/2016, 09:05:02 PM
    Author     : Fabian
--%>

<%@page import="com.tsp.gespro.hibernate.dao.ProyectoDAO"%>
<%@page import="com.tsp.gespro.hibernate.pojo.Proyecto"%>
<%@page import="java.util.List"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="com.tsp.gespro.hibernate.pojo.HibernateUtil"%>
<%@page import="org.hibernate.Session"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:directive.page import="com.tsp.gespro.hibernate.dao.CoberturaDAO"/>
<jsp:directive.page import="com.tsp.gespro.hibernate.pojo.Cobertura"/>
<jsp:useBean id="user" scope="session" class="com.tsp.gespro.bo.UsuarioBO"/>
<%
//Verifica si el usuario tiene acceso a este topico
if (user == null || !user.permissionToTopicByURL(request.getRequestURI().replace(request.getContextPath(), ""))) {
    response.sendRedirect("../../jsp/inicio/login.jsp?action=loginRequired&urlSource=" + request.getRequestURI() + "?" + request.getQueryString());
    response.flushBuffer();
}
String paramId = null;
try {
    paramId = request.getParameter("id");
} catch (Exception ex) {
    paramId = "0";
}
int id;
try {
    id = Integer.parseInt(paramId);
} catch (NumberFormatException ex) {
    id = 0;
}
List<Proyecto> proyectoList = new ProyectoDAO().lista();
Cobertura cobertura = new CoberturaDAO().getById(id);
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <title><jsp:include page="../include/titleApp.jsp" /></title>
        <style>
            .right_position {
                text-align: right;
            }
            #frm_productos p {
                width: 100%;
            }
            #frm_productos p label {
                width: 20%;
            }
        </style>

        <jsp:include page="../include/keyWordSEO.jsp" />
        <jsp:include page="../include/skinCSS.jsp" />
        <jsp:include page="../include/jsFunctions.jsp"/>
       
        <script type="text/javascript">
            $(document).ready(function(){
                ocultarTipoDePuntos();
                cargarPaises();
            });
            
            function cargarPaises() {
                $.getJSON( "/Gespro/json/countriesToCities.json", function( data ) {
                    $.each( data, function( key, val ) {
                        $('#selector-pais').append($('<option>', { 
                            value: key,
                            text : key 
                        }));
                    });
                });
            }
            
            
            function cargarCiudades( pais ) {
                // limpiamos el selector
                $('#selector-ciudad')
                    .find('option')
                    .remove()
                    .end()
                    .append('<option value="0">Seleccione una ciudad</option>');
                //consultamos los paise y las ciudades
                $.getJSON( "/Gespro/json/countriesToCities.json", function( data ) {
                    $.each( data, function( key, val ) {
                        // si encontramos el pais, obtenemos las ciudades y las agremaos
                        if( key == pais ) {
                            $.each(val, function( indice, ciudad ){
                                $('#selector-ciudad').append($('<option>', { 
                                    value: ciudad,
                                    text : ciudad 
                                }));                            
                            });
                        }
                    });
                });
            }
            
            function seleccionarTipoPunto( tipoDePuntos ){
                ocultarTipoDePuntos();
                if (tipoDePuntos == "cliente") {
                    $("#contenedor-cliente").show("slow");
                }
                if (tipoDePuntos == "ciudad") {
                    $("#contenedor-pais").show("slow");
                }
            }
            
            function ocultarTipoDePuntos(){
                $("#contenedor-cliente").hide("slow");
                $("#contenedor-pais").hide("slow");
            }
            
            function guardar(){ 
                    $.ajax({
                        type: "POST",
                        url: "ajax.jsp",
                        data: $("#frm_action").serialize(),
                        beforeSend: function(objeto){
                            $("#action_buttons").fadeOut("slow");
                            $("#ajax_loading").html('<div style=""><center>Procesando...<br/><img src="../../images/ajax_loader.gif" alt="Cargando.." /></center></div>');
                            $("#ajax_loading").fadeIn("slow");
                        },
                        success: function(datos){
                            console.log("Datos");
                            console.log(datos);
                            if(datos.indexOf("--EXITO-->", 0)>0){
                               $("#ajax_message").html("Los datos se guardaron correctamente.");
                               $("#ajax_loading").fadeOut("slow");
                               $("#ajax_message").fadeIn("slow");
                               apprise('<center><img src=../../images/info.png> <br/>Los datos se guardaron correctamente.</center>',{'animate':true},
                                        function(r){
                                                javascript:window.location.href = "catCoberturas_list.jsp";
                                                parent.$.fancybox.close();  
                                        });
                           }else{
                               $("#ajax_loading").fadeOut("slow");
                               $("#ajax_message").html("Ocurrió un error al intentar guardar los datos.");
                               $("#ajax_message").fadeIn("slow");
                               $("#action_buttons").fadeIn("slow");
                           }
                        }
                    });   
                }
        </script>
    </head>
    <body>
        <!--- Inicialización de variables --->
        <jsp:useBean id="helper" class="com.tsp.gespro.hibernate.dao.CoberturaDAO"/>
        <jsp:useBean id="usuariosModel" class="com.tsp.gespro.hibernate.dao.UsuariosDAO"/>
        
        <jsp:useBean id="clienteModel" class="com.tsp.gespro.hibernate.dao.ClienteDAO"/>
        <jsp:useBean id="Services" class="com.tsp.gespro.Services.Allservices"/>
        <!--- @obj : Objeto de moneda a editar --->
        <c:set var="obj" value="${Cobertura}"/>
        <c:if test="${not empty param.id}">
            <fmt:parseNumber var="id" integerOnly="true" type="number" value="${param.id}" />
            <c:set var="obj" value="${helper.getById(id)}"/>
        </c:if>
            
           <div class="content_wrapper">
            <jsp:include page="../include/header.jsp" flush="true"/>
            <jsp:include page="../include/leftContent.jsp"/>
            <!-- Inicio de Contenido -->
            <div id="content">
                <div class="inner" id="leito">
                    <h1>Cobertura</h1>

                    <div id="ajax_loading" class="alert_info" style="display: none;"></div>
                    <div id="ajax_message" class="alert_warning" style="display: none;"></div>

                    <!--TODO EL CONTENIDO VA AQUÍ-->
                    
                    <div class="twocolumn">
                        <div class="column_left">
                            <div class="header">
                                <span>                                    
                                    <img src="../../images/camion_icono_16.png" alt="icon"/>
                                    ${not empty param.id ? "Editar Cobertura" : "Nueva Cobertura"}
                                    ${not empty param.id ? param.id : ""}
                                </span>
                            </div>
                            <br class="clear"/>
                            <form action="" method="post" id="frm_action">
                            <div class="content">
                                    <input type="hidden" id="id" name="id" value="${ not empty obj.idCobertura ? obj.idCobertura :"0"}" />
                                    <p>
                                        <label>* Nombre:</label><br/>
                                        <input maxlength="45" type="text" id="nombre" name="nombre" style="width:300px"
                                               value="${not empty obj.nombre ? obj.nombre : ""}"
                                               data-validation="length"
                                               data-validation-length="1-45"
                                               data-validation-error-msg="El nombre debe tener de 1 a 45 caracteres."
                                               required
                                               />
                                    </p>
                                    <br/>                                
                                    <p>
                                        <label>Proyecto:</label><br/>
                                        <select id="selector-proyecto" name="proyecto_id" style="width:300px;">
                                            <option value="0">Seleccione un proyecto</option>
                                            <%
                                            for(Proyecto proyecto:proyectoList) {
                                                String selected = "";
                                                if( cobertura != null && cobertura.getIdProyecto() == proyecto.getIdProyecto()){
                                                    selected = "selected";
                                                }
                                                %>
                                                <option value="<%=proyecto.getIdProyecto()%>" <%=selected%> > <%=proyecto.getNombre()%> </option>
                                                <%  
                                            }
                                            %>
                                        </select>
                                    </p>
                                    <br/>
                                    <p>
                                        <label>* Tipo de punto:</label><br/>
                                        <input type="radio" name="punto" value="ciudad"> Ciudad
                                        <input type="radio" name="punto" value="cliente"> Cliente
                                        <input type="radio" name="punto" value="lugar"> Lugar
                                    </p>
                                    <br/>
                                    <div id="contenedor-cliente">
                                        <br/>                                    
                                        <p>
                                            <label>Cliente:</label><br/>
                                            <c:set var="clientes" value="${clienteModel.lista()}"/>
                                            <select id="idCliente" name="idCliente" style="width:300px;">
                                                <option value="0">Seleccione un cliente</option>
                                                <c:forEach items="${clientes}" var="cliente">
                                                    <option value="${cliente.idCliente}">${cliente.nombreComercial}</option>
                                                </c:forEach>
                                            </select><br>
                                            <button id="boton-agregar-punto-cliente" type="button">Agregar zona de cliente</button>
                                        </p>
                                        <br/>
                                    </div>
                                    <div id="contenedor-pais">
                                        <p>
                                            <label>País:</label><br/>
                                            <select id="selector-pais" name="selector_pais" style="width:300px;">
                                                <option value="0">Seleccione un país</option>
                                            </select>
                                        </p>
                                        <p>
                                            <label>Ciudad:</label><br/>
                                            <select id="selector-ciudad" name="selector_ciudad" style="width:300px;">
                                                <option value="0">Seleccione una ciudad</option>
                                            </select>
                                        </p>
                                        <br/>
                                    </div>
                                    <div ud="contenedor-puntos">
                                        <p>
                                            <label>Zona:</label><br/>
                                            <input maxlength="45" type="text" class="punto" name="puntoNombre[]" readonly=""/>
                                            <input maxlength="45" type="text" class="punto" name="puntoLatitud[]" readonly=""/>
                                            <input maxlength="45" type="text" class="punto" name="puntoLongitud[]" readonly=""/>
                                        </p>
                                        <br/>
                                    </div>
                                    <br/>
                                    <div id="action_buttons">
                                        <p>
                                            <input type="submit" id="enviar" value="Guardar" class="btn"/>
                                            <input type="button" id="regresar" value="Regresar" onclick="history.back();"/>
                                        </p>
                                    </div>                                       
                                </div>
                                    
                            </form>
                        </div>
                    </div>
                    <!--TODO EL CONTENIDO VA AQUÍ-->

                </div>

                <jsp:include page="../include/footer.jsp"/>
            </div>
            <!-- Fin de Contenido-->
        </div>
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
        <script src="http://cdnjs.cloudflare.com/ajax/libs/jquery-form-validator/2.3.26/jquery.form-validator.min.js"></script>
        <script>

         $(document).ready(function() {
            $.validate({
                 lang: 'en',
                 modules : 'toggleDisabled',
                 disabledFormFilter : 'form.toggle-disabled',
                 showErrorDialogs : true
             });
            $("#frm_action").submit(function(e){
               e.preventDefault();
               guardar();
            });
            $( "#selector-pais" ).change(function() {
                cargarCiudades( $("#selector-pais").val() );
            });
            $('input[name=punto]').change(function() {
                var tipoDePuntos = $(this).val();
                seleccionarTipoPunto( tipoDePuntos );
            });
            $('#boton-agregar-punto-cliente').change(function() {
            });
        });
        </script>
    </body>
</html>