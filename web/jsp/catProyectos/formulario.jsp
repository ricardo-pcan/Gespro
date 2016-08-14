<%-- 
    Document   : formulario
    Created on : 07/08/2016, 09:05:02 PM
    Author     : Fabian
--%>

<%@page import="com.tsp.gespro.hibernate.pojo.HibernateUtil"%>
<%@page import="org.hibernate.Session"%>
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
                
            function guardarPromotor(){ 
                    $.ajax({
                        type: "POST",
                        url: "promotor_ajax.jsp",
                        data: $("#frm_promotor").serialize(),
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
                                                javascript:window.location.reload();
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
        function guardarProducto(){ 
                    $.ajax({
                        type: "POST",
                        url: "productos_ajax.jsp",
                        data: $("#frm_productos").serialize(),
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
                                                javascript:window.location.reload();
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
        <jsp:useBean id="usuariosModel" class="com.tsp.gespro.hibernate.dao.UsuariosDAO"/>
        <jsp:useBean id="clienteModel" class="com.tsp.gespro.hibernate.dao.ClienteDAO"/>
        <jsp:useBean id="promotorproyectoModel" class="com.tsp.gespro.hibernate.dao.PromotorproyectoDAO"/>
        <jsp:useBean id="Services" class="com.tsp.gespro.Services.Allservices"/>
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
                            <form action="" method="post" id="frm_action">
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
                                    <div id="action_buttons">
                                        <p>
                                            <input type="submit" id="enviar" value="Guardar" class="btn"/>
                                            <input type="button" id="regresar" value="Regresar" onclick="history.back();"/>
                                        </p>
                                    </div>                                       
                                </div>
                                    
                            </form>
                        </div>
                                    
                        <!-- End left column window -->
                        
                        <c:if test="${not empty param.id}">
                        <div class="column_right">
                            <div class="header">
                                <span>
                                    Promotores del Proyecto
                                </span>
                            </div>
                            <br class="clear"/>
                            <div class="content">
                                <form id="frm_promotor" class="has-validation-callback" style="display: none">
                                    <input type="hidden" id="idProyecto" name="idProyecto"  value="${ not empty obj.idProyecto ? obj.idProyecto :"0"}" />
                                    <p>
                                    <label>Asignar Promotor:</label>
                                    <c:set var="whereuser" value="where id_usuarios not in (select p.idUser from Promotorproyecto as p where p.idProyecto = ${obj.idProyecto}) and id_roles = 4"/>
                                    <c:set var="promotoresproy" value="${Services.QueryUsuariosDAO(whereuser)}"/>
                                    <select id="idUsuario" name="idUsuario">
                                        <option value="0" >Seleccione un Promotor</option>
                                        <c:forEach items="${promotoresproy}" var="item">
                                            <option value="${item.idUsuarios}" >${item.userName}</option>
                                        </c:forEach>
                                    </select>
                                    <input  value="Agregar" type="submit" id="enviar"  class="btn"/>
                                    </p>

                                </form>
                                    <div style="max-height:300px;text-align: right;">
                                        <a id="btnAgregarPromotor">Agregar Promotor</a><br><br>
                                        <table class="data" width="100%" cellpadding="0" cellspacing="0">
                                            <thead>
                                                <tr>
                                                    <th>Promotor</th>
                                                    <th>Acciones</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:set var="where" value="where idProyecto = ${obj.idProyecto}"/>
                                                <c:set var="promotorespro" value="${Services.QueryPromotorProyecto(where)}"/>
                                                <c:forEach items="${promotorespro}" var="item">
                                                    <c:set var="usuario" value="${usuariosModel.getById(item.idUser)}"/>
                                                    <tr>
                                                        <td>${usuario.userName}</td>
                                                        <td>${item.idUser}</td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                        </div>
                        <br>
                        <br>
                        <br>
                        <div class="column_right">
                            <div class="header">
                                <span>
                                    Productos del Proyecto
                                </span>
                            </div>
                            <br class="clear"/>
                            
                            <div class="content">
                                <form  style="display:none" id="frm_productos" class="has-validation-callback">
                                    <input type="hidden" id="idProyectoProducto" name="idProyectoProducto" value="${param.id}"/>
                                    <p>
                                        <label>* Nombre:</label><br>
                                        <input maxlength="45" type="text" id="nombreProducto" name="nombreProducto" style="width:300px"
                                               data-validation="length"
                                               data-validation-length="1-45"
                                               data-validation-error-msg="El nombre debe tener de 1 a 45 caracteres."
                                               required
                                               />
                                    </p>
                                    <br/>
                                    <p>
                                        <label>Descripcion:</label><br>
                                        <textarea  id="descripcionProducto" name="descripcionProducto" style="width:300px;">
                                        </textarea>
                                    </p>
                                    <br/> 
                                    <div id="action_buttons">
                                        <p>
                                            <input type="submit" value="Guardar" class="btn"/>
                                        </p>
                                    </div>   
                                </form>
                                    <div style="text-align: right">
                                        <a id="btnAgregarProductos">Agregar Producto</a><br><br>
                                        <table class="data" width="100%" cellpadding="0" cellspacing="0">
                                            <thead>
                                                <tr>
                                                    <th>Producto</th>
                                                    <th>Descripcion</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:set var="where" value="where id_proyecto = ${param.id}"/>
                                                <c:set var="productosProyecto" value="${Services.QueryProductosDAO(where)}"/>
                                                <c:if test="${empty productosProyecto}" >
                                                    <tr>
                                                        <td colspan="2">No se han registrado productos</td>
                                                    </tr>
                                                </c:if>
                                                <c:if test="${not empty productosProyecto}" >
                                                    <c:forEach items="${productosProyecto}" var="productoProyecto">
                                                        <tr>
                                                            <td>${productoProyecto.nombre}</td>
                                                            <td>${productoProyecto.descripcion}</td>
                                                        </tr>
                                                    </c:forEach>
                                                </c:if>
                                            </tbody>
                                        </table>
                                    </div>
                            </div>
                        </div>                      
                        </c:if>
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
            $("#btnAgregarProductos").click(function(){
                $("#frm_productos").show("slow");
                $(this).hide("fast");
            });
            $("#btnAgregarPromotor").click(function(){
                $("#frm_promotor").show("slow");
                $(this).hide("fast");
            });
            $("#frm_action").submit(function(e){
               e.preventDefault();
               guardar();
            });
            $("#frm_promotor").submit(function(e){
               e.preventDefault();
               guardarPromotor();
            });
            $("#frm_productos").submit(function(e){
               e.preventDefault();
               guardarProducto();
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