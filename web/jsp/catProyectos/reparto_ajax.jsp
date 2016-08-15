<%-- 
    Document   : ajax
    Created on : 17/07/2016, 08:51:11 PM
    Author     : gloria
--%>

<%@page import="com.tsp.gespro.Services.Allservices"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="org.hibernate.HibernateException"%>
<%@page import="com.tsp.gespro.hibernate.dao.RepartoDAO"%>
<%@page import="com.tsp.gespro.hibernate.pojo.Reparto"%>
<%@page import="com.tsp.gespro.hibernate.dao.PuntoDAO"%>
<%@page import="com.tsp.gespro.hibernate.dao.RepartoDAO"%>
<%@page import="com.tsp.gespro.hibernate.pojo.Punto"%>
<%@page import="com.tsp.gespro.hibernate.pojo.Reparto"%>
<%@page import="com.tsp.gespro.util.GenericValidator"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:useBean id="user" scope="session" class="com.tsp.gespro.bo.UsuarioBO"/>
<%
    // Si el id viene que el request parsearlo a integer.
    String message = "";
    String json = "";
    boolean status = false;

    String idProyecto = request.getParameter("id_proyecto");
    String[] idLugar = request.getParameterValues("id_lugar[]");
    String[] idProducto = request.getParameterValues("id_producto[]");
    String[] cantidad = request.getParameterValues("cantidad[]");
    RepartoDAO repartoDao = new RepartoDAO();
    // Guardamos los nuevos puntos
    if (idProyecto != null && idLugar != null && idProducto != null && cantidad != null) {
        for (int i = 0; i < idProducto.length; i ++) {
            Reparto reparto = new Reparto();
            reparto.setIdProyecto(Integer.parseInt(idProyecto.toString()));
            reparto.setIdLugar(Integer.parseInt(idLugar[i].toString()));
            reparto.setIdProducto(Integer.parseInt(idProducto[i].toString()));
            reparto.setCantidad(Float.parseFloat(cantidad[i].toString()));
            repartoDao.guardar(reparto);
        }
        
     status = true;
    }
    json = "{ status:" + (status ? "true" : "false") + ", message:'" + message + "'}";
    out.print(json);

%>