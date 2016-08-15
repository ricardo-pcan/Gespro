<%-- 
    Document   : formulario
    Created on : 07/08/2016, 09:05:02 PM
    Author     : Fabian
--%>

<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:directive.page import="com.tsp.gespro.hibernate.dao.ActividadDAO"/>
<jsp:directive.page import="com.tsp.gespro.hibernate.pojo.Actividad"/>
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
        
        
        <c:if test="${not empty param.idProyecto}">
            <fmt:parseNumber var="idProyecto" integerOnly="true" type="number" value="${param.idProyecto}" />
        </c:if>

        <script type="text/javascript">
            function guardar(){ 
                    $.ajax({
                        type: "POST",
                        url: "actividad_ajax.jsp",
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
                                                    javascript:window.location.href = 'proyectos_tasks.jsp?idProyecto=${idProyecto}';
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
        <jsp:useBean id="actividadModel" class="com.tsp.gespro.hibernate.dao.ActividadDAO"/>
        <jsp:useBean id="usuariosModel" class="com.tsp.gespro.hibernate.dao.UsuariosDAO"/>
        <jsp:useBean id="Services" class="com.tsp.gespro.Services.Allservices"/>
        <!--- @obj : Objeto de moneda a editar --->
        <c:set var="obj" value="${Actividad}"/>
        <c:if test="${not empty param.id}">
            <fmt:parseNumber var="id" integerOnly="true" type="number" value="${param.id}" />
            <c:set var="obj" value="${actividadModel.getById(id)}"/>
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
                                    ${not empty param.id ? "Editar Actividad: " : "Nuevo Actividad"}
                                    ${not empty param.id ? obj.actividad : ""}
                                </span>
                            </div>
                            <br class="clear"/>
                            <div class="content">
                                    <input type="hidden" id="id" name="idActividad" value="${ not empty obj.idActividad ? obj.idActividad :"0"}" />
                                    <input type="hidden" id="id" name="idProyecto" value="${ not empty idProyecto ? idProyecto :"0"}" />
                                    <p>
                                        <label>* Nombre:</label><br/>
                                        <input maxlength="45" type="text" id="actividad" name="actividad" style="width:300px"
                                               value="${not empty obj.actividad ? obj.actividad : ""}"
                                               data-validation="length"
                                               data-validation-length="1-45"
                                               data-validation-error-msg="El nombre debe tener de 1 a 45 caracteres."
                                               required
                                               />
                                    </p>
                                    <br/>
                                    <p>
                                        <label>Descripcion:</label><br/>
                                        <textarea id="descripcion" name="descripcion" style="width:300px;" >${not empty obj.descripcion ? obj.descripcion : ""}</textarea>
                                    </p>
                                    <br/> 
                                    <p>
                                        <label>Tipo de Tarea</label><br/>
                                        <input type="radio" id="tipoActividad1" name="tipoActividad" value ="1" ${not empty obj.tipoActividad ? (obj.tipoActividad == 1 ? "checked" : "") : ""}/> Reparto
                                        <input type="radio" id="tipoActividad2" name="tipoActividad" value ="0" ${not empty obj.tipoActividad ? (obj.tipoActividad == 0 ? "checked" : "") : ""}/> Actividad
                                    </p>
                                    <br/> 
                                    <p>
                                        <label>Promotor</label><br/>
                                        <select name="idUser" id="idUser" >
                                            <c:set var="where" value="where idProyecto = ${not empty param.idProyecto ? param.idProyecto :0}"/>
                                            <c:set var="promotorespro" value="${Services.QueryPromotorProyecto(where)}"/>
                                            <option value="0">Seleccionar Promotor</option>
                                            <c:forEach items="${promotorespro}" var="item">
                                                <c:set var="usuario" value="${usuariosModel.getById(item.idUser)}"/>
                                                <option value="${item.idUser}" ${item.idUser == usuario.idUsuarios ? "selected" : ""}>${usuario.userName}</option>
                                            </c:forEach>
                                        </select>
                                    </p>
                                    <br/> 
                                    <p>
                                        <label>Lugar:</label><br/>
                                        <input maxlength="45" type="text" id="idPunto" name="idPunto" style="width:300px"
                                               value="${not empty obj.idPunto ? obj.idPunto : ""}"
                                               />
                                    </p>
                                    <br>
                                    <p>
                                        <label>Avance</label><br/>
                                        <input maxlength="45" type="text" id="avance" name="avance" style="width:300px"
                                               value="${not empty obj.avance ? obj.avance : ""}"
                                               />
                                    </p>
                                    <br>
                                    <c:if test="${not empty obj.checkin}">
                                    <p>
                                        <label>Fecha Terminada</label><br/>
                                        <input maxlength="45" type="text" id="checkin" name="checkin" style="width:300px"
                                               value="${not empty obj.checkin ? obj.checkin : ""}"
                                               disabled
                                               />
                                    </p>
                                    </c:if>
                                    <br>
                                    <p>
                                        <label>Producto</label><br/>
                                            <c:set var="where" value="where id_proyecto = ${param.idProyecto}"/>
                                            <c:set var="productosProyecto" value="${Services.QueryProductosDAO(where)}"/>
                                            <select id="idProducto" name="idProducto" style="width:300px">
                                                <option value="0">Selecciona un producto</option>
                                                <c:forEach items="${productosProyecto}" var="productoProyecto">
                                                    <option value="${productoProyecto.idProducto}" ${obj.idProducto == productoProyecto.idProducto ? "selected" : ""}>${productoProyecto.nombre}</option>
                                                </c:forEach>
                                            </select>
                                    </p>
                                    <br>
                                    <p>
                                        <label>Cantidad</label><br/>
                                        <input maxlength="45" type="text" id="cantidad" name="cantidad" style="width:300px"
                                               value="${not empty obj.cantidad ? obj.cantidad : ""}"
                                               />
                                    </p>
                                    <br>
                                    
                                    <c:if test="${not empty obj.recibio}">
                                    <p>
                                        <label>Recibio</label><br/>
                                        <input maxlength="45" type="text" id="recibio" name="recibio" style="width:300px"
                                               value="${not empty obj.recibio ? obj.recibio : ""}"
                                               />
                                    </p>
                                    <br>
                                    </c:if>
                                    
                                    <c:if test="${not empty obj.comentarios}">
                                    <p>
                                        <label>Comentario</label><br/>
                                        <textarea id="comentarios" name="comentarios" style="width:300px" rows="4">
                                            ${not empty obj.comentarios ? obj.comentarios : ""}
                                        </textarea>
                                    </p>
                                    <br>
                                    
                                    </c:if>
                                    <div id="action_buttons">
                                        <p>
                                            <input type="submit" id="enviar" value="Guardar" class="btn"/>
                                            <input type="button" id="regresar" value="Regresar" onclick="history.back();"/>
                                        </p>
                                    </div>                                       
                            </div>
                        </div>
                        <!-- End left column window -->
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
            $("input[name=tipoActividad]").ready(function(){
                var option = ($("#tipoActividad1").is(":checked")) ? 1:(($("#tipoActividad2").is(":checked"))?0:2);
                if(option==0){
                    $("#idProducto").attr("disabled",true).parent("p").hide();
                    $("#cantidad").attr("disabled",true).parent("p").hide();
                }
                $("#tipoActividad1").click(function(){
                        $("#idProducto").attr("disabled",false).parent("p").show("slow");
                        $("#cantidad").attr("disabled",false).parent("p").show("slow");
                });
                $("#tipoActividad2").click(function(){
                        $("#idProducto").attr("disabled",true).parent("p").hide("slow");
                        $("#cantidad").attr("disabled",true).parent("p").hide("slow");
                });
            });
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