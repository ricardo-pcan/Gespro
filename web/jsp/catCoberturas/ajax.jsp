<%-- 
    Document   : ajax
    Created on : 17/07/2016, 08:51:11 PM
    Author     : gloria
--%>

<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="org.hibernate.HibernateException"%>
<%@page import="com.tsp.gespro.hibernate.dao.CoberturaDAO"%>
<%@page import="com.tsp.gespro.hibernate.pojo.Cobertura"%>
<%@page import="com.tsp.gespro.util.GenericValidator"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:useBean id="user" scope="session" class="com.tsp.gespro.bo.UsuarioBO"/>
<%
    // Crear objeto que almacenará los datos a actulizar de el usuario.
    Cobertura cobertura= new Cobertura();
    CoberturaDAO coberturaDAO = new CoberturaDAO();
    // Si el id viene que el request parsearlo a integer.
    Integer id = request.getParameter("id") != null ? new Integer(request.getParameter("id")): 0;
    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
    String message = "";
    String json = "";
    boolean status = false;
    
    try{
        // Setear los datos que vienen en el request a un objeto de el tipo
        // UsuarioMonitor para poder actulizarlos o crearlos.
        cobertura.setNombre(request.getParameter("nombre") != null ? new String(request.getParameter("nombre").getBytes("ISO-8859-1"), "UTF-8"): "");
        cobertura.setIdProyecto(request.getParameter("proyecto_id") != null ? Integer.parseInt(request.getParameter("proyecto_id")): 0);

    }catch(Exception ex){
        message = "<--ERROR1-->" + ex.getMessage();
    }
     
   
       try{ 
           if(cobertura.getNombre().equals("")){
               message = "<--ERROR-->" + "Simbolo y nombre son obligatorios.";
           }else{
            if(id!=0){
                cobertura.setIdCobertura(id);
                coberturaDAO.actualizar(cobertura);
                message = "<--EXITO-->" +"La actualización fue exitosa.";
                status = true;
            }else{
                coberturaDAO.guardar(cobertura);
                message = "<--EXITO-->" + "Se guardó correctamente.";
                status = true;
            }
           }
       }catch(HibernateException e){
           message = "<--ERROR-->" + "Ocurrió un error al actualizar." + e.getMessage();
       }
       json = "{ status:" + (status ? "true":"false") +", message:'" + message + "'}";
       out.print(json);
           
%>