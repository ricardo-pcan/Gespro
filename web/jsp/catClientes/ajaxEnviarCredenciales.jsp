<%@page import="com.tsp.gespro.hibernate.dao.LoginClienteDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:useBean id="user" scope="session" class="com.tsp.gespro.bo.UsuarioBO"/>
<%
    try{
        String msgError="";
        String username=request.getParameter("username");
        String password=request.getParameter("password");
        int idCliente=Integer.parseInt(request.getParameter("idCliente"));
        LoginClienteDAO lcdao=new LoginClienteDAO(user.getConn());
        msgError=lcdao.guardarCambios(username, password, idCliente);
        if(msgError.isEmpty()){
            out.print("<--EXITO-->" + "Se guardó correctamente. ");
        }else{
            out.print("<!--ERROR-->"+msgError);
        }
       
    }catch(Exception ex){
        out.print("<--ERROR-->" + ex.getMessage());
    }
           
%>