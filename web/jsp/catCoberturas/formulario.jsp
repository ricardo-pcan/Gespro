<%-- 
    Document   : formulario
    Created on : 07/08/2016, 09:05:02 PM
    Author     : Fabian
--%>

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
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
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
            function cargarPaises() {
                $.getJSON( "ajax/test.json", function( data ) {
                var items = [];
                $.each( data, function( key, val ) {
                    items.push( "<li id='" + key + "'>" + val + "</li>" );
                  });

                  $( "<ul/>", {
                    "class": "my-new-list",
                    html: items.join( "" )
                  }).appendTo( "body" );
                });
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
                                                javascript:window.location.href = "catCobertura_list.jsp";
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
                                        <label>* Tipo de punto:</label><br/>
                                        <input type="radio" name="punto" value="male"> Ciudad
                                        <input type="radio" name="punto" value="female"> Cliente
                                        <input type="radio" name="punto" value="other"> Lugar
                                    </p>
                                    <br/>
                                    <c:if test="${not empty obj.idCliente }" >
                                    <br/>                                    
                                    <p>
                                        <label>Cliente:</label><br/>
                                        <c:set var="cliente" value="${clienteModel.getById(obj.idCliente)}"/>
                                        <input maxlength="45" type="text" style="width:300px;"
                                               value="${not empty cliente.nombreComercial ? cliente.nombreComercial : ""}" 
                                               disabled/>
                                        <input type="hidden" id="idCliente" name="idCliente" 
                                               value="${not empty obj.idCliente ? obj.idCliente : ""}"/>
                                    </p>
                                    </c:if>
                                    <c:if test="${empty obj.idCliente }" >
                                    <br/>                                    
                                    <p>
                                        <label>Cliente:</label><br/>
                                        <c:set var="clientes" value="${clienteModel.lista()}"/>
                                        <select id="idCliente" name="idCliente" style="width:300px;">
                                            <option value="0">Seleccione un cliente</option>
                                            <c:forEach items="${clientes}" var="cliente">
                                                <option value="${cliente.idCliente}">${cliente.nombreComercial}</option>
                                            </c:forEach>
                                        </select>
                                    </p>
                                    </c:if>
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
        });
        </script>
    </body>
</html>