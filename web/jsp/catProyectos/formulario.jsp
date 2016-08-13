<%-- 
    Document   : formulario
    Created on : 07/08/2016, 09:05:02 PM
    Author     : Fabian
--%>

<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:directive.page import="com.tsp.gespro.hibernate.dao.ProyectoDAO"/>
<jsp:directive.page import="com.tsp.gespro.hibernate.pojo.Proyecto"/>
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

        <jsp:include page="../include/keyWordSEO.jsp" />
        <jsp:include page="../include/skinCSS.jsp" />
        <jsp:include page="../include/jsFunctions.jsp"/>
       
        <script type="text/javascript">
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
                                                javascript:window.location.href = "catProyectos.jsp";
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
        <jsp:useBean id="helper" class="com.tsp.gespro.hibernate.dao.ProyectoDAO"/>
        <jsp:useBean id="productosModel" class="com.tsp.gespro.hibernate.dao.ProductoDAO"/>
        <!--- @obj : Objeto de moneda a editar --->
        <c:set var="obj" value="${Proyecto}"/>
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
                    <h1>Proyecto</h1>

                    <div id="ajax_loading" class="alert_info" style="display: none;"></div>
                    <div id="ajax_message" class="alert_warning" style="display: none;"></div>

                    <!--TODO EL CONTENIDO VA AQUÍ-->
                    <form action="" method="post" id="frm_action">
                    <div class="twocolumn">
                        <div class="column_left">
                            <div class="header">
                                <span>                                    
                                    <img src="../../images/icon_users.png" alt="icon"/>
                                    ${not empty param.id ? "Editar Proyecto:" : "Nuevo Proyecto"}
                                    ${not empty param.id ? param.id : ""}
                                </span>
                            </div>
                            <br class="clear"/>
                            <div class="content">
                                    <input type="hidden" id="id" name="id" value="${ not empty obj.idProyecto ? obj.idProyecto :"0"}" />
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
                                        <label>* Fecha Inicio:</label><br/>
                                        <input maxlength="10" type="text" id="fechaInicio" name="fechaInicio" style="width:300px;"
                                               value="${not empty obj.fechaInicio ? obj.fechaInicio : ""}"
                                               data-validation-error-msg="El simbolo es requerido,ingrese uno."
                                               required=""
                                               placeholder="YYYY/MM/DD"
                                               />
                                    </p>
                                    <br/>
                                    <p>
                                        <label>* Fecha Programada:</label><br/>
                                        <input maxlength="10" type="text" id="fechaProgramada" name="fechaProgramada" style="width:300px;"
                                               value="${not empty obj.fechaProgramada ? obj.fechaProgramada : ""}"
                                               data-validation-error-msg="El simbolo es requerido,ingrese uno."
                                               required=""
                                               placeholder="YYYY/MM/DD"
                                               />
                                    </p>
                                    <br/>
                                    <p>
                                        <label>* Fecha Real:</label><br/>
                                        <input maxlength="10" type="text" id="fechaReal" name="fechaReal" style="width:300px;"
                                               value="${not empty obj.fechaReal ? obj.fechaReal : ""}"
                                               data-validation-error-msg="El simbolo es requerido,ingrese uno."
                                               required=""
                                               placeholder="YYYY/MM/DD"
                                               />
                                    </p>
                                    <br/>                                    
                                    <p>
                                        <label>Cliente:</label><br/>
                                        <input maxlength="45" type="text" id="idCliente" name="idCliente" style="width:300px;"
                                               value="${not empty obj.idCliente ? obj.idCliente : ""}"
                                               />
                                    </p>
                                    <br/>                                  
                                    <p>
                                        <label>Avance:</label><br/>
                                        <input maxlength="45" type="text" id="avance" name="avance" style="width:300px;"
                                               value="${not empty obj.avance ? obj.avance : ""}"
                                               />
                                    </p>
                                    <br/>                      
                                    
                                    <c:set var="estatus" value="${not empty obj.status ? obj.status : 0}"/>
                                    <p>
                                        <label>Estatus</label><br/>
                                        <input type="checkbox" id="status" name="status" ${estatus == 1 ? "checked":""}/>
                                    </p>
                                    <br/>    
                                    <c:set var="productos" value="${productosModel.lista()}"/>
                                    <c:set var="idproductos" value="${not empty obj.idProducto ? obj.idProducto : 0}"/>
                                    <p>
                                        <label>Producto</label><br/>
                                        <select  id="idProducto" name="idProducto" style="width:300px;">
                                            <option value="0">Selecciona un producto</option>
                                            <c:forEach items="${productos}" var="item">
                                                <option value="${item.idProducto}" ${item.idProducto == idproductos ? "selected":""}>${item.nombre}</option>
                                            </c:forEach>
                                        </select>
                                        <br>
                                        <br>
                                        <a href="productos_form.jsp?idproyecto=true">Agregar Nuevo Producto</a>
                                    </p>
                                    <br/> 
                                    <div id="action_buttons">
                                        <p>
                                            <input type="submit" id="enviar" value="Guardar" class="btn"/>
                                            <input type="button" id="regresar" value="Regresar" onclick="history.back();"/>
                                        </p>
                                    </div>                                       
                            </div>
                        </div>
                        <!-- End left column window -->
                        
                        <div class="column_right">
                            <div class="header">
                                <span>
                                    Promotores
                                </span>
                            </div>
                        </div>
                    </div>
                    </form>
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
            $('#checkActivo').change(function() {
                if($(this).is(":checked")) {
                   $("#activo").val("true");
                }else{
                   $("#activo").val("false");
                }      
            });
        });
        </script>
    </body>
</html>