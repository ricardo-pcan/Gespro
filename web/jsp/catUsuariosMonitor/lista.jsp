<%-- 
    Document   : lista
    Created on : 16/07/2016, 04:42:43 PM
    Author     : gloria
--%>

<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:directive.page import="com.tsp.gespro.hibernate.dao.*"/>
<jsp:directive.page import="java.util.List"/>
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
        <jsp:include page="../include/keyWordSEO.jsp" />

        <title><jsp:include page="../include/titleApp.jsp" /></title>

        <jsp:include page="../include/skinCSS.jsp" />

        <jsp:include page="../include/jsFunctions.jsp"/>
        <title>Usuarios monitor</title>
    </head>
    <body>
        <!--- Inicialización de variables --->
        <jsp:useBean id="helper" class="com.tsp.gespro.hibernate.dao.UsuarioMonitorDAO"/>
        <!--- @lista --->
        <c:set var="lista" value="${helper.lista}"/>
        <!--- @formulario --->
        <c:set var="formulario" value="../catUsuariosMonitor/formulario.jsp"/>
        
        <div class="content_wrapper">

            <jsp:include page="../include/header.jsp" flush="true"/>

            <jsp:include page="../include/leftContent.jsp"/>

            <!-- Inicio de Contenido -->
            <div id="content">

                <div class="inner">
                    <h1>Administración</h1>
                    
                    <div id="ajax_loading" class="alert_info" style="display: none;"></div>
                    <div id="ajax_message" class="alert_warning" style="display: none;"></div>
                   
                    <div class="onecolumn">
                  
                    </div>

                    <div class="onecolumn">
                        <div class="header">
                            <span>
                                <img src="../../images/icon_users.png" alt="icon"/>
                                Usuarios monitor
                            </span>                          
                        </div>
                        <br class="clear"/>
                        
                        <div class="content">
                            <form id="form_data" name="form_data" action="" method="post">
                                <table class="data" width="100%" cellpadding="0" cellspacing="0">
                                    <thead>
                                        <tr>
                                            <th>Nombre</th>
                                            <th>Apellido Paterno</th>
                                            <th>Apellido Materno</th>
                                            <th>email</th>
                                            <th>Acciones</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                       <c:forEach items="${lista}" var="item">
                                         <tr class="${ item.activo ? "" : "inactive"}">
                                            <td>${item.nombre}</td>
                                            <td>${item.apellidoPaterno}</td>
                                            <td>${item.apellidoMaterno}</td>
                                            <td>${item.email}</td>
                                            <td>
                                               <a href="${formulario}?id=${item.id}"><img src="../../images/icon_edit.png" alt="editar" class="help" title="Editar"/></a>
                                                &nbsp;&nbsp;
                                                <a href="#" onclick=""><img src="../../images/icon_email.png" alt="reestablecer" class="help" title="Generar nueva credencial"/></a>
                                            </td>
                                          </tr>
                                       </c:forEach>
                                    </tbody>
                                </table>
                            </form>
                        </div>
                    </div>

                </div>

                <jsp:include page="../include/footer.jsp"/>
            </div>
            <!-- Fin de Contenido-->
        </div>
    </body>
</html>
