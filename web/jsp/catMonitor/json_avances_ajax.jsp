<%-- 
    Document   : json_avances_ajax
    Created on : 15/08/2016, 09:27:22 AM
    Author     : gloria
--%>

<%@page import="com.tsp.gespro.Services.DataUbicacion"%>
<%@page import="com.tsp.gespro.dto.Ubicacion"%>
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
    String proyectoId = request.getParameter("proyecto_id") != null ? new String(request.getParameter("proyecto_id").getBytes("ISO-8859-1"), "UTF-8") : "";

    if (proyectoId != "") {

        Allservices allservices = new Allservices();
        String where = "where id_proyecto=" + proyectoId;

        //Obtengo la lista de actividades de el proyecto.
        where = "WHERE id_proyecto=" + proyectoId;
        List<Actividad> actividades = allservices.QueryActividadDAO(where);

        // Creo una lista de actividades, donde obtenga los objetos
        // completos de actividad, punto y proyecto.
        List<ActividadFullObject> actividadesFull;
        actividadesFull = allservices.getActividadesFull(actividades);

        // Agrupamos los avances por ciudad.
        ArrayList<String> listaDeCiudades = new ArrayList();
        String json = "{\"ciudades\":{";

        for (ActividadFullObject actividadFull : actividadesFull) {
            DataUbicacion ubi=actividadFull.getUbicacion();
            if(ubi!=null){
              String ciudad=actividadFull.getUbicacion().getCiudad();
              if(ciudad!=null && ciudad!=""){
                if (!listaDeCiudades.contains(ciudad)) {
                  listaDeCiudades.add(actividadFull.getUbicacion().getCiudad());
                 }
              }
            } 
        }
        int indice = -1;
        for (String ciudad : listaDeCiudades) {
            indice++;
            float sumaDeAvance = 0;
            int contador = 0;
            for (ActividadFullObject actividadFull : actividadesFull) {
                if (ciudad.equalsIgnoreCase(actividadFull.getUbicacion().getCiudad())) {
                    contador++;
                    sumaDeAvance += actividadFull.getActividad().getAvance();
                }
            }
            json += "\""+ciudad+"\":"+sumaDeAvance/(contador);
            if (listaDeCiudades.size() == indice+1) {
            } else {
                json += ",";
            }
        }
        
        // Agrupamos los avances por ciudad.
        ArrayList<String> listaDeEstados = new ArrayList();

        for (ActividadFullObject actividadFull : actividadesFull) {
            DataUbicacion ubi=actividadFull.getUbicacion();
            if(ubi!=null){
                String estado=actividadFull.getUbicacion().getEstado();
                if(estado!=null && estado!=""){
                    if (!listaDeEstados.contains(estado)) {
                        listaDeEstados.add(actividadFull.getUbicacion().getEstado());
                    }
                }
            } 
        }
        
        json+="},\"regiones\":{";
        indice = -1;
        for (String estado : listaDeEstados) {
            indice++;
            float sumaDeAvance = 0;
            int contador = 0;
            for (ActividadFullObject actividadFull : actividadesFull) {
                if (estado.equalsIgnoreCase(actividadFull.getUbicacion().getEstado())) {
                    contador++;
                    sumaDeAvance += actividadFull.getActividad().getAvance();
                }
            }
            json += "\""+estado+"\":"+sumaDeAvance/(contador);
            if (listaDeEstados.size() == indice+1) {
            } else {
                json += ",";
            }
        }
     json+="}}";
     response.setContentType("application/json");
     out.print(json);
    }

%>