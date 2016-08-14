<%-- 
    Document   : catProyectos
    Created on : 07/08/2016, 07:55:43 PM
    Author     : Fabian
--%>

<%@page import="com.tsp.gespro.hibernate.pojo.Proyecto"%>
<%@page import="com.tsp.gespro.Services.Allservices"%>
<%@page import="com.tsp.gespro.report.ReportBO"%>
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
// Obtener parametros
String buscar = request.getParameter("q")!=null? new String(request.getParameter("q").getBytes("ISO-8859-1"),"UTF-8") :"";    //

// crear consulta de filtro
String filtroBusqueda = ""; //"AND ID_ESTATUS=1 ";
if (!buscar.trim().equals("")) {
    filtroBusqueda += " WHERE (NOMBRE LIKE '%" + buscar + "%')";
}
String filtroBusquedaEncoded = java.net.URLEncoder.encode(filtroBusqueda, "UTF-8");
Allservices allservices = new Allservices();
List<Proyecto> proyectos = allservices.queryProyectoDAO(filtroBusqueda);
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><jsp:include page="../include/titleApp.jsp" /></title>
        <jsp:include page="../include/keyWordSEO.jsp" />
        <jsp:include page="../include/skinCSS.jsp" />
        <jsp:include page="../include/jsFunctions.jsp"/>
    </head>
    <body>
        <!--- Inicialización de variables --->
        <jsp:useBean id="productos" class="com.tsp.gespro.hibernate.dao.ProductoDAO"/>
        <jsp:useBean id="clienteModel" class="com.tsp.gespro.hibernate.dao.ClienteDAO"/>
        <!--- @formulario --->
        <c:set var="formulario" value="formulario.jsp"/> 
        
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
                                <img src="../../images/icon_validaXML.png" alt="icon"/>
                                Proyectos
                            </span>
                            <div class="switch" style="width:500px">
                                <table width="500px" cellpadding="0" cellspacing="0">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <div id="search">
                                                <form action="catProyectos.jsp" id="search_form" name="search_form" method="get">                                                                                                                                                

                                                        <input type="text" id="q" name="q" title="Buscar por nombre" class="" style="width: 70%; float: left; "
                                                               value="<%=buscar%>"/>
                                                        <input type="image" src="../../images/Search-32_2.png" id="buscar" name="buscar"  value="" style="cursor: pointer; width: 30px; height: 25px; float: left"/>

                                                </form>
                                                </div>
                                            </td>
                                            <td class="clear">&nbsp;&nbsp;&nbsp;</td>
                                           
                                            <td>
                                                <input type="button" id="nuevo" name="nuevo" class="right_switch" value="Crear Nuevo" 
                                                        style="float: right; width: 100px;" onclick="javascript:window.location.href='${formulario}'"/>
                                            </td>                                           
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <br class="clear"/>
                        
                        <div class="content">
                            <form id="form_data" name="form_data" action="" method="post">
                                <table class="data" width="100%" cellpadding="0" cellspacing="0">
                                    <thead>
                                        <tr>
                                            <th>ID Proyecto</th>
                                            <th>Nombre</th>
                                            <th>Inicio</th>
                                            <th>Programada</th>
                                            <th>Real</th>
                                            <th>Cliente</th>
                                            <th>Avance %</th>
                                            <th>Estatus</th>
                                            <th>Acciones</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="<%=proyectos%>" var="item">
                                         <tr>
                                            <td>${item.idProyecto}</td>
                                            <td>${item.nombre}</td>
                                            <td>${item.fechaInicio}</td>
                                            <td>${item.fechaProgramada}</td>
                                            <td>${item.fechaReal}</td>
                                            <c:set var="clientes" value="${clienteModel.getById(item.idCliente)}"/>
                                            <td>${clientes.nombreComercial}</td>
                                            <td>${item.avance}</td>
                                            <td>${item.status == 1 ? "Activo": "Inactivo"}</td>
                                            <td>
                                               <a href="${formulario}?id=${item.idProyecto}"><img src="../../images/icon_edit.png" alt="editar" class="help" title="Editar"/></a>
                                                &nbsp;&nbsp;
                                            </td>
                                          </tr>
                                       </c:forEach>
                                    </tbody>
                                </table>
                            </form>
                             <!-- INCLUDE OPCIONES DE EXPORTACIÓN-->
                            <jsp:include page="../include/reportExportOptions.jsp" flush="true">
                                <jsp:param name="idReport" value="<%= ReportBO.PROYECTO_REPORT %>" />
                                <jsp:param name="parametrosCustom" value="<%= filtroBusquedaEncoded %>" />
                            </jsp:include>
                            <!-- FIN INCLUDE OPCIONES DE EXPORTACIÓN-->
                        </div>
                    </div>

                </div>

                <jsp:include page="../include/footer.jsp"/>
            </div>
            <!-- Fin de Contenido-->
        </div>
        
    </body>
</html>