<%@page import="com.tsp.gespro.bo.PasswordBO"%>
<%@page import="com.tsp.gespro.dto.Cliente"%>
<%@page import="com.tsp.gespro.bo.ClienteBO"%>
<%@page import="com.tsp.gespro.dto.Ldap"%>
<%@page import="com.tsp.gespro.hibernate.dao.LoginClienteDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:useBean id="user" scope="session" class="com.tsp.gespro.bo.UsuarioBO"/>

<%
//Verifica si el cliente tiene acceso a este topico
    if (user == null || !user.permissionToTopicByURL(request.getRequestURI().replace(request.getContextPath(), ""))) {
        response.sendRedirect("../../jsp/inicio/login.jsp?action=loginRequired&urlSource=" + request.getRequestURI() + "?" + request.getQueryString());
        response.flushBuffer();
    } else {
        /*
         * Parámetros
         */
        int idCliente = 0;
        try {
            idCliente = Integer.parseInt(request.getParameter("idCliente"));
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
        int paginaActual = 1;
        try {
            paginaActual = Integer.parseInt(request.getParameter("pagina"));
        } catch (Exception e) {
        }
        LoginClienteDAO loginClienteDAO=new LoginClienteDAO(user.getConn());
        Ldap ldap=loginClienteDAO.getCredenciales(idCliente);
        String password="";
        String username="";
        
        ClienteBO clienteBO = new ClienteBO(user.getConn());
        Cliente clientesDto = null;
        clienteBO = new ClienteBO(idCliente, user.getConn());
        clientesDto = clienteBO.getCliente();
        if(ldap==null){
            password = new PasswordBO().generateValidPassword();
            username=clientesDto.getNombreComercial().replaceAll("\\s", "");
        }else{
            username=ldap.getUsuario();
        }
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
                    console.log($("#frm_action").serialize());
                    $.ajax({
                        type: "POST",
                        url: "ajaxEnviarCredenciales.jsp",
                        data: $("#frm_action").serialize(),
                        success: function (datos) {
                            if (datos.indexOf("--EXITO-->", 0) > 0) {
                                $("#ajax_message").html(datos);
                                                        $("#ajax_loading").fadeOut("slow");
                                                        $("#ajax_message").fadeIn("slow");
                                                        apprise('<center><img src=../../images/info.png> <br/>' + datos + '</center>', {'animate': true},
                                                                function (r) {            
                                                                    location.href = "catClientes_list.jsp?pagina=" + "<%=paginaActual%>";
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
                 if(!$("#username").val()){
                    apprise('<center><img src=../../images/warning.png> <br/>El nombre de usuario no debe ser vacio</center>',{'animate':true});
                    $("#username").focus();
                    return false;
                 }else if(($("#password").val()!=$("#passwordConfirmation").val())){
                     apprise('<center><img src=../../images/warning.png> <br/>El password no coincide con la confirmacion</center>',{'animate':true});
                    $("#password").focus();
                    return false;
                 }else if(!$("#password").val()){
                     apprise('<center><img src=../../images/warning.png> <br/>El password no debe ir en blanco</center>',{'animate':true});
                    $("#password").focus();
                    return false;
                 }
                 
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
                    <h1>Catálogos</h1>

                    <div id="ajax_loading" class="alert_info" style="display: none;"></div>
                    <div id="ajax_message" class="alert_warning" style="display: none;"></div>

                    <!--TODO EL CONTENIDO VA AQUÍ-->
                    <form action="" method="post" id="frm_action">
                        <div class="twocolumn">
                            <div class="column_left">
                                <div class="header">
                                    <span>
                                        <img src="../../images/icon_cliente.png" alt="icon"/>                                        
                                            Login para Cliente <%=clientesDto.getNombreComercial()%>                                      
                                    </span>
                                </div>
                                <br class="clear"/>
                                <div class="content">
                                    <input type="hidden" id="idCliente" name="idCliente" value="<%=clientesDto != null ? clientesDto.getIdCliente() : ""%>" />
                                    <p>
                                        <label id="usernameLabel">Usuario: </label><br/>
                                        <input maxlength="200" type="text" id="username" name="username" style="width:300px;"
                                               value="<%= username%>"/>
                                        <br/>
                                        <label id="passwordLabel">Password: </label><br/>
                                        <input maxlength="200" type="text" id="password" name="password" style="width:300px;"
                                               value="<%=ldap==null?password:""%>"/><br/>
                                        <label id="passwordLabel">Confirmar password: </label><br/>
                                        <input maxlength="200" type="text" id="passwordConfirmation" name="passwordConfirmation" style="width:300px;"
                                               value="<%=ldap==null?password:""%>"/>
                                    </p>
                                    <br/>
                                </div>
                                    <div id="action_buttons">
                                        <p>
                                            <input type="button" id="enviar" value="Enviar credenciales" onclick="grabar();"/>
                                            <input type="button" id="regresar" value="Regresar" onclick="history.back();"/>
                                        </p>
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


    </body>
</html>
<%}%>