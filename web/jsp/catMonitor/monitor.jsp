<%-- 
    Document   : mapa
    Created on : 13-ago-2016, 15:18:23
    Author     : zesk8
--%>

<%@page import="com.tsp.gespro.hibernate.pojo.Usuarios"%>
<%@page import="com.tsp.gespro.Services.Allservices"%>
<%@page import="com.tsp.gespro.hibernate.pojo.LoginCliente"%>
<%@page import="com.tsp.gespro.hibernate.dao.LoginClienteDAO"%>
<%@page import="com.tsp.gespro.dto.Roles"%>
<%@page import="com.tsp.gespro.jdbc.RolesDaoImpl"%>
<%@page import="com.tsp.gespro.hibernate.dao.ProyectoDAO"%>
<%@page import="com.tsp.gespro.hibernate.pojo.Proyecto"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:useBean id="user" scope="session" class="com.tsp.gespro.bo.UsuarioBO"/>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Monitor de Proyectos</title>
        <script   src="https://code.jquery.com/jquery-1.11.0.min.js"   integrity="sha256-spTpc4lvj4dOkKjrGokIrHkJgNA0xMS98Pw9N7ir9oI="   crossorigin="anonymous"></script>  
        <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
        <script type="text/javascript" src="https://www.google.com/jsapi"></script>
        <!-- Latest compiled and minified CSS -->
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
        <!-- Optional theme -->
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css" integrity="sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp" crossorigin="anonymous">

        <!-- Latest compiled and minified JavaScript -->
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
        <%
            List<Proyecto> proyectoList = new ProyectoDAO().lista();
            List<Usuarios> promotores=new Allservices().QueryUsuariosDAO("where ID_ROLES=4");
            RolesDaoImpl rolesDaoImpl=new RolesDaoImpl(user.getConn());
            Roles rol=rolesDaoImpl.findByPrimaryKey(user.getUser().getIdRoles());
            if(rol.getNombre().equals("CLIENTE")){
                LoginClienteDAO loginClienteDAO=new LoginClienteDAO(user.getConn());
                LoginCliente lc=loginClienteDAO.getByIdUsuario(user.getUser().getIdUsuarios());
                proyectoList = new ProyectoDAO().getListByIdClient(lc.getIdCliente());
                String promotoresID="(";
                for(Proyecto proyecto: proyectoList){
                    if(proyecto.getIdPromotor()!=null){
                        promotoresID+= String.valueOf(proyecto.getIdProyecto())+",";
                    }  
                }
                promotoresID=promotoresID.substring(0,promotoresID.length()-1);
                promotoresID+=")";
                promotores=new Allservices().QueryUsuariosDAO("where ID_USUARIOS in " + promotoresID);
            }
        %>
        
    </head>
    <body>
        <div class="container-fluid">
            <div class="row">
              <div class="col-md-12 text-center">
                   <h1>Avance de proyectos</h1>
                   <a href="../../jsp/inicio/main.jsp"><b>Regresar<b></a>
              </div>
            </div>
            <div class="row">
              <div class="col-md-1"></div>
              <div class="col-md-5">
                  <form class="form-inline">
                    <div class="form-group">
                      <label for="proyecto">Proyecto</label>
                      <select id="selector-proyecto" name="proyecto_id" class="form-control">
                                            <option value="0">Seleccione un proyecto</option>
                                            <%
                                            for(Proyecto proyecto:proyectoList) {%>
                                                <option value="<%=proyecto.getIdProyecto()%>"> <%=proyecto.getNombre()%> </option>
                                            <%  
                                            }
                                            %>
                     </select>
                    </div>
                     <div class="form-group">
                      <label for="promotores">Promotores</label>
                      <select id="selector-proyecto" name="promotor_id" class="form-control">
                                            <option value="0">Seleccione un promotor</option>
                                            <%
                                            for(Usuarios promo: promotores) {%>
                                                <option value="<%= promo.getIdUsuarios() %>"> <%= promo.getUserName() %> </option>
                                            <%  
                                            }
                                            %>
                     </select>
                    </div>
                    <button id="myBtn" type="submit" class="btn btn-primary">Buscar avance</button>
                  </form>
              </div>
              <div class="col-md-5">
              </div>
              <div class="col-md-1"></div>
            </div>
            <div class="row">
              <div class="col-md-1"></div>
              <div class="col-md-5">
                <h1>Avance por estado</h1>
                <div id="regions_div"></div>
              </div>
              <div class="col-md-5">
                <h1>Avance por ciudad</h1>
                <div id="chart_div"></div>
              </div>
              <div class="col-md-1"></div>
            </div>
            <div class="row">
              <div class="col-md-1"></div>
              <div class="col-md-5">
               <table class="table table-sm">
                <thead>
                  <tr>
                    <th>#</th>
                    <th>Proyecto</th>
                    <th>Avance</th>
                    <th></th>
                  </tr>
                </thead>
                <tbody>
                  <%
                     for(Proyecto pro:proyectoList){                       
                  %>
                  <tr>
                      <th scope="row"><%= pro.getIdProyecto()%></th>
                    <td><%= pro.getNombre()%></td>
                    <td><%= pro.getAvance() %> %</td>
                    <td><button href="#myModal" id="openBtn" data-toggle="modal" type="button" class="btn btn-link">Actividades</button></td>
                  </tr>
                  <%}%>
                </tbody>
              </table>
              </div>
              
              <div class="col-md-5">
                <table class="table table-sm">
                <thead>
                  <tr>
                    <th>#</th>
                    <th>Proyecto</th>
                    <th>Avance</th>
                    <th></th>
                  </tr>
                </thead>
                <tbody>
                  <%
                     for(Proyecto pro:proyectoList){                       
                  %>
                  <tr>
                      <th scope="row"><%= pro.getIdProyecto()%></th>
                    <td><%= pro.getNombre()%></td>
                    <td><%= pro.getAvance() %> %</td>
                    <td><button href="#myModal" id="openBtn" data-toggle="modal" type="button" class="btn btn-link">Actividades</button></td>
                  </tr>
                  <%}%>
                </tbody>
              </table>
              </div>
              <div class="col-md-1"></div>
            </div>
        </div>
        
        <script type="text/javascript">
            google.load("maps", "3", {other_params: "key=AIzaSyA6cb9XFRRlRZbkOAvgjoRiGTOuKbemoJ0"});
            google.charts.load('current', {'packages':['geochart']});
            /**
             * Draw regions maps
             * @type Array Regions array
             * @returns {void}
             */
            function drawRegionsMap(regionsArray) {
                var data = google.visualization.arrayToDataTable(regionsArray);
                var options = {
                    region: 'MX',
                    resolution: 'provinces',
                    colorAxis: {colors: ['#70ad47', '#ffc000', '#ed7d31']}
                };
                var chart = new google.visualization.GeoChart(document.getElementById('regions_div'));

                chart.draw(data, options);
            }
            /**
             * Draw markers array
             * @type Array Markers array
             * @returns {void}
             */
            function drawMarkersMap(markersArray) {
                var data = google.visualization.arrayToDataTable(markersArray);
                var options = {
                    region: 'MX',
                    displayMode: 'markers',
                    resolution: 'provinces',
                    colorAxis: {colors: ['#70ad47', '#ffc000', '#ed7d31']}
                };
                var chart = new google.visualization.GeoChart(document.getElementById('chart_div'));
                chart.draw(data, options);
            }
            /** 
             * Get map info from end-point and show maps
             * @returns {void}
             */
            function printMaps() {
                var regionsArray = [
                    ['State', 'Avance']
                ];
                var markersArray = [
                    ['City',   'Avace']
                ];
                var xhttp;
                // Create XHTTP object
                xhttp = new XMLHttpRequest();
                xhttp.onreadystatechange = function() {
                    var data;
                    var regions;
                    var cities;
                    // Fill markers and regions if status response was 200
                    if (xhttp.readyState == 4 && xhttp.status == 200) {
                        data = JSON.parse(xhttp.responseText);
                        regions = data.regiones;
                        cities = data.ciudades;
                        // Fill regions array
                        Object.keys(regions).map(function(key) {
                            regionsArray.push([key, regions[key]]);
                        });
                        // Fill cities array
                        Object.keys(cities).map(function(key) {
                            markersArray.push([key, cities[key]]);
                        });
                        drawRegionsMap(regionsArray);
                        drawMarkersMap(markersArray);
                    }
                };
                // Change direction for real call
                xhttp.open('GET', 'https://zesk8.firebaseio.com/users.json', true);
                xhttp.send();
                //$.get("json_avances_ajax.jsp", function(data, status){
                    //console.log("Data: " + data + "\nStatus: " + status);
               // });
                
            }
            // Add event to show maps
            document.getElementById("myBtn").addEventListener("click", printMaps);
            printMaps();
        </script>
<div class="modal fade" id="myModal">
<div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
          <h3 class="modal-title">Actividades</h3>
        </div>
        <div class="modal-body">
		  <h5 class="text-center">Estás son las actividades de los proyectos en curso.</h5>
          <table class="table table-striped" id="tblGrid">
            <thead id="tblHead">
              <tr>
                <th>Actividad</th>
                <th>Descripción</th>
                <th class="text-right">Avance</th>
              </tr>
            </thead>
            <tbody>
              <tr><td>Long Island, NY, USA</td>
                <td>3</td>
                <td class="text-right">45001</td>
              </tr>
              <tr><td>Chicago, Illinois, USA</td>
                <td>5</td>
                <td class="text-right">76455</td>
              </tr>
              <tr><td>New York, New York, USA</td>
                <td>10</td>
                <td class="text-right">39097</td>
              </tr>
            </tbody>
          </table>
	</div>
        <div class="modal-footer">
          <button type="button" class="btn btn-default " data-dismiss="modal">Close</button>
        </div>			
      </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
  </div><!-- /.modal -->
    </body>
</html>
