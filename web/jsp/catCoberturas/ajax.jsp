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
<%@page import="com.tsp.gespro.hibernate.dao.PuntoDAO"%>
<%@page import="com.tsp.gespro.hibernate.pojo.Punto"%>
<%@page import="com.tsp.gespro.util.GenericValidator"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:useBean id="user" scope="session" class="com.tsp.gespro.bo.UsuarioBO"/>
<%
    // Crear objeto que almacenará los datos a actulizar de el usuario.
    Cobertura cobertura= new Cobertura();
    CoberturaDAO coberturaDAO = new CoberturaDAO();
    // Si el id viene que el request parsearlo a integer.
    Integer id = request.getParameter("id") != null ? new Integer(request.getParameter("id")): 0;
    String ciudades=(request.getParameter("ciudades") != null ? new String(request.getParameter("ciudades")) : "" );
    String guardarLugares=(request.getParameter("guardarLugares") != null ? new String(request.getParameter("guardarLugares")) : "" );
    String longitudes=(request.getParameter("longitudes") != null ? new String(request.getParameter("longitudes").getBytes("ISO-8859-1"),"UTF-8") : "" );
    String latitudes=(request.getParameter("latitudes") != null ? new String(request.getParameter("latitudes").getBytes("ISO-8859-1"),"UTF-8") : "" );
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
     
       Integer idCobertura=0;
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
                idCobertura=coberturaDAO.guardar(cobertura);
                message = "<--EXITO-->" + "Se guardó correctamente.";
                status = true;
            }
           }
       }catch(HibernateException e){
           message = "<--ERROR-->" + "Ocurrió un error al actualizar." + e.getMessage();
       }
       json = "{ status:" + (status ? "true":"false") +", message:'" + message + "'}";
       out.print(json);
       if(ciudades!="" && latitudes!="" && longitudes != "" && idCobertura!=0 && guardarLugares=="1"){
           int countPoints=ciudades.length();
           String[] ciudad = ciudades.substring(0,countPoints).split(",");
           String[] longitud= longitudes.substring(0,countPoints).split(",");
           String[] latitud = latitudes.substring(0,countPoints).split(",");
           Punto punto= new Punto();
           PuntoDAO puntoDao = new PuntoDAO();
           if(id!=0){
               idCobertura=id;
           }
           for(int i=0;i< ciudad.length;i+=2)
            {
               
               punto.setIdCobertura(idCobertura);
               punto.setLugar(ciudad[i].toString());
               punto.setLatitud(latitud[i].toString());
               punto.setLongitud(longitud[i].toString());
               punto.setDescripcion("");
               puntoDao.guardar(punto);
            }
       }
           
%>