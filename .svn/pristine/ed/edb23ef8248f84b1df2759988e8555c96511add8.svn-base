
<%@page import="com.tsp.gespro.bo.DatosUsuarioBO"%>
<%@page import="com.tsp.gespro.dto.DatosUsuario"%>
<%@page import="com.tsp.gespro.bo.UsuarioBO"%>
<%@page import="com.tsp.gespro.jdbc.DatosUsuarioDaoImpl"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.tsp.gespro.bo.RolesBO"%>
<%@page import="com.tsp.gespro.bo.UsuariosBO"%>
<%@page import="com.tsp.gespro.dto.Usuarios"%>
<%@page import="com.tsp.gespro.factory.RutaDaoFactory"%>
<%@page import="com.tsp.gespro.dto.Ruta"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:useBean id="user" scope="session" class="com.tsp.gespro.bo.UsuarioBO"/>

<%
//Verifica si el cliente tiene acceso a este topico
if (user == null || !user.permissionToTopicByURL(request.getRequestURI().replace(request.getContextPath(), ""))) {
    response.sendRedirect("../../jsp/inicio/login.jsp?action=loginRequired&urlSource=" + request.getRequestURI() + "?" + request.getQueryString());
    response.flushBuffer();
} else {

    int idEmpresa = user.getUser().getIdEmpresa();

    /*
     * Parámetros
     */
    int idRuta = 0;
    try {
        idRuta = Integer.parseInt(request.getParameter("idRuta"));
    } catch (NumberFormatException e) {
    }

    Ruta rutaDto = RutaDaoFactory.create(user.getConn()).findByPrimaryKey(idRuta);
    Usuarios[] promotoresDto = new UsuariosBO(user.getConn()).findUsuariosByRol(idEmpresa, RolesBO.ROL_GESPRO);
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
            
            function grabar(){
                if(validar()){
                    $.ajax({
                        type: "POST",
                        url: "logistica_asignar_ajax.jsp",
                        data: $("#frm_action").serialize(),
                        beforeSend: function(objeto){
                            $("#action_buttons").fadeOut("slow");
                            $("#ajax_loading").html('<div style=""><center>Procesando...<br/><img src="../../images/ajax_loader.gif" alt="Cargando.." /></center></div>');
                            $("#ajax_loading").fadeIn("slow");
                        },
                        success: function(datos){
                            if(datos.indexOf("--EXITO-->", 0)>0){
                               $("#ajax_message").html(datos);
                               $("#ajax_loading").fadeOut("slow");
                               $("#ajax_message").fadeIn("slow");
                               apprise('<center><img src=../../images/info.png> <br/>'+ datos +'</center>',{'animate':true},
                                        function(r){
                                            location.href = "logistica.jsp";
                                        });
                           }else{
                               $("#ajax_loading").fadeOut("slow");
                               $("#ajax_message").html(datos);
                               $("#ajax_message").fadeIn("slow");
                               $("#action_buttons").fadeIn("slow");
                               $.scrollTo('#inner',800);
                           }
                        }
                    });
                }
            }

            function validar(){
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
    </head>
    <body>
        <div class="content_wrapper">

            <jsp:include page="../include/header.jsp" flush="true"/>

            <jsp:include page="../include/leftContent.jsp"/>

            <!-- Inicio de Contenido -->
            <div id="content">

                <div class="inner">
                    <h1>Logística</h1>

                    <div id="ajax_loading" class="alert_info" style="display: none;"></div>
                    <div id="ajax_message" class="alert_warning" style="display: none;"></div>

                    <!--TODO EL CONTENIDO VA AQUÍ-->
                    <form action="" method="post" id="frm_action">
                    <div class="twocolumn">
                        <div class="column_left">
                            <div class="header">
                                <span>
                                    <img src="../../images/icon_logistica.png" alt="icon"/>
                                    Asignar ruta a promotor
                                </span>
                            </div>
                            <br class="clear"/>
                            <div class="content">
                                    <input type="hidden" id="idRuta" name="idRuta" value="<%=rutaDto!=null?rutaDto.getIdRuta():"" %>" />
                                    <p>
                                        <label>Nombre:</label><br/>
                                        <%=rutaDto.getNombreRuta() %>
                                    </p>
                                    <p>
                                        <label>Comentarios:</label><br/>
                                        <%=rutaDto.getComentarioRuta().replaceAll("\n", "<br/>") %>
                                    </p>
                                    <p>
                                        <label>Fecha de registro:</label><br/>
                                        <%=new SimpleDateFormat("dd/MM/yyyy HH:mm").format(rutaDto.getFhRegRuta()) %>
                                    </p>
                                    <p>
                                        <label>*Vendedor:</label><br/>
                                        <select id="cmb_id_promotor" name="cmb_id_promotor">
                                            <option value="">Sin asignar</option>
                                        <%
                                        for(Usuarios promotor : promotoresDto){
                                            DatosUsuario datosUsuario = new DatosUsuarioBO(promotor.getIdDatosUsuario(),user.getConn()).getDatosUsuario();
                                            out.print("<option "+(promotor.getIdUsuarios()==rutaDto.getIdUsuario()?"selected":"")+" value=\""+promotor.getIdUsuarios()+"\">"+datosUsuario.getApellidoPat() + " " + datosUsuario.getApellidoMat() + " " + datosUsuario.getNombre() +"</option>");
                                        }
                                        %>
                                        </select>
                                    </p>
                                    <br/>
                                    <br/>
                                    <div id="action_buttons">
                                        <p>
                                            <input type="button" id="enviar" value="Guardar" onclick="grabar();"/>
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


    </body>
</html>
<%}%>
