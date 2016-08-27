<%-- 
    Document   : json_avances_ajax
    Created on : 15/08/2016, 09:27:22 AM
    Author     : gloria
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="com.tsp.gespro.Services.ActividadFullObject"%>
<%@page import="com.tsp.gespro.hibernate.pojo.Actividad"%>
<%@page import="com.tsp.gespro.hibernate.dao.PuntoDAO"%>
<%@page import="com.tsp.gespro.hibernate.pojo.Punto"%>
<%@page import="com.tsp.gespro.hibernate.pojo.Coberturaproyecto"%>
<%@page import="com.tsp.gespro.hibernate.dao.CoberturaProyectoDAO"%>
<%@page import="com.tsp.gespro.hibernate.dao.ProyectoDAO"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="java.util.List"%>
<%@page import="com.tsp.gespro.Services.Allservices"%>
<%@page import="com.tsp.gespro.hibernate.pojo.Proyecto"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String proyectoId = request.getParameter("proyecto_id") != null ? new String(request.getParameter("proyecto_id").getBytes("ISO-8859-1"), "UTF-8"): "";
    
    if(proyectoId!=""){
    
       Allservices allservices=new Allservices();
       String where="where id_proyecto="+proyectoId;
       
       //Obtengo la lista de actividades de el proyecto.
       where="WHERE id_proyecto="+proyectoId;
       List <Actividad> actividades=allservices.QueryActividadDAO(where);
       
       // Creo una lista de actividades, donde obtenga los objetos
       // completos de actividad, punto y proyecto.
       List <ActividadFullObject> actividadesFull;
       actividadesFull=allservices.getActividadesFull(actividades);
       
       // Agrupamos los avances por ciudad.
        
    }
    
    
    
    /***
    String json="";
    for(int i=0;i< proyectos.size();i++){
       Gson gson = new Gson();
       String jsonResponse = gson.toJson(proyectos.get(i));
    }***/

%>
