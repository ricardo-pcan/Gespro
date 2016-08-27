<%-- 
    Document   : proyectos_tasks
    Created on : 07/08/2016, 07:55:43 PM
    Author     : Fabian
--%>

<%@page import="com.tsp.gespro.hibernate.pojo.Proyecto"%>
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
if(request.getParameter("idProyecto")!=null){
    Integer idProyecto = request.getParameter("idProyecto") != null ? new Integer(request.getParameter("idProyecto")): 0;
    ProyectoDAO proyectodao = new ProyectoDAO();
    Proyecto proyecto = proyectodao.getById(idProyecto);
}else{
    
}
    
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><jsp:include page="../include/titleApp.jsp" /></title>
        <jsp:include page="../include/keyWordSEO.jsp" />
        <jsp:include page="../include/skinCSS.jsp" />
        <jsp:include page="../include/jsFunctions.jsp"/>
        <style>
            body{
                background-image: none;
            }
            #content{
                margin-left:  20px;
            }
            .title_resumen{
                font-size: 20px;
            }
            .info_resumen{
                font-weight: normal;
            }
        </style>
    </head>
    <body>
        <!--- Inicialización de variables --->
        <jsp:useBean id="actividad" class="com.tsp.gespro.hibernate.dao.ActividadDAO"/>
        <jsp:useBean id="productoModel" class="com.tsp.gespro.hibernate.dao.ProductoDAO"/>
        <jsp:useBean id="usuariosModel" class="com.tsp.gespro.hibernate.dao.UsuariosDAO"/>
        <jsp:useBean id="puntoModel" class="com.tsp.gespro.hibernate.dao.PuntoDAO"/>
        <jsp:useBean id="services" class="com.tsp.gespro.Services.Allservices"/>
        
        <!--- @lista --->
            <c:set var="where" value="where id_proyecto = ${not empty param.idProyecto ? param.idProyecto : 0}${not empty param.tipo ? param.tipo : ''}"/>
        <c:set var="lista" value="${services.QueryActividadDAO(where)}"/>
        <!--- @formulario --->
        <c:set var="formulario" value="actividad_form.jsp"/> 
        
        <div class="content_wrapper">


            <!-- Inicio de Contenido -->
            <div id="content">

                <div class="inner">
                    <h1>Proyecto</h1>
                    
                    <div id="ajax_loading" class="alert_info" style="display: none;"></div>
                    <div id="ajax_message" class="alert_warning" style="display: none;"></div>

                    <div class="twocolumn">
                        <div class="column_left">
                        <div class="header">
                            <span>
                                <img src="../../images/icon_validaXML.png" alt="icon"/>
                                Actividades
                            </span>
                            <div class="switch" style="width:450px">
                                <table width="450px" cellpadding="0" cellspacing="0">
                                    <tbody>
                                        <tr>
                                           
                                            <td>
                                                <form action="monitor_log_report.jsp?idProyecto=${param.idProyecto}" id="action_filter" method="POST">
                                                    <input type="radio" name="tipo" value=" and avance <> 50"/> Todos
                                                    <input type="radio" name="tipo" value=" and avance = 0"/> Activas
                                                    <input type="radio" name="tipo" value=" and avance = 100"/> Terminadas
                                                </form>
                                            </td>
                                            <td>
                                                <input type="button" id="nuevo" name="nuevo" class="right_switch" value="Regresar" 
                                                        style="float: right; width: 100px;" onclick="history.back()"/>&nbsp;&nbsp;
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
                                            <th>Nombre</th>
                                            <th>Usuario</th>
                                            <th>Lugar</th>
                                            <th>Tipo</th>
                                            <th>Acciones</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                       <c:forEach items="${lista}" var="item">
                                         <tr>
                                            <td>${item.actividad}</td>
                                            <c:set var="user" value="${usuariosModel.getById(item.idUser)}"/>
                                            <td>${user.userName}</td>
                                            <c:set var="punto" value="${puntoModel.getById(item.idPunto)}"/>
                                            <td>${punto.lugar}</td>
                                            <td>${item.tipoActividad == 1 ? "Entrega" : "Actividad"}</td>
                                            <c:set var="producto" value="${productoModel.getById(item.idProducto)}" />
                                            <td>
                                                <a id="${item.idActividad}" class="show_resumen" ><img src="../../images/icon_edit.png" alt="editar" class="help" title="Editar"/></a>
                                                <a  idact="${item.idActividad}" id="map_${item.idActividad}" class="show_ubicacion" ><img src="../../images/icon_edit.png" alt="editar" class="help" title="Ver Ubicacion"/></a>
                                           
                                                <input type="hidden" id="producto_${item.idActividad}" value="${producto != null ? producto.nombre: "-"}" />
                                                <input type="hidden" id="checkin_${item.idActividad}" value="${item.checkin != null ? item.checkin  :"No terminada"}" />
                                                <input type="hidden" id="recibio_${item.idActividad}" value="${item.recibio != null ? item.recibio  :"-"}" />
                                                <input type="hidden" id="cantidad_${item.idActividad}" value="${item.cantidad != null ? (item.cantidad > 0 ? item.cantidad : "-") :"-"}" />
                                                <input type="hidden" id="comentarios_${item.idActividad}" value="${item.comentarios != null ? item.comentarios :"-"}" />
                                                <input type="hidden" id="tipo_${item.idActividad}" value="${item.tipoActividad}" />
                                                <input type="hidden" id="lat_${item.idActividad}" value="${punto.latitud}" />
                                                <input type="hidden" id="lon_${item.idActividad}" value="${punto.longitud}" />
                                            </td>
                                          </tr>
                                       </c:forEach>
                                    </tbody>
                                </table>
                            </form>
                        </div>
                        </div>
                           <div class="column_right" style="display: block">
                                <div class="header">
                                    <span>
                                        <label id="detalles_tittle">Ubicacion</label>
                                    </span>
                                    <div class="switch" style="float: right">X</div>
                                </div>
                                <br class="clear"/>
                                <div id="detalles" class="content">
                                    <div id="contenido_detalles"></div>
                                        <div id="map_canvas" style="height: 400px;width: auto;">
                                            <img src="../../images/maps/ajax-loader.gif" alt="Cargando" style="margin: auto;"/>
                                        </div>
                                </div>
                            </div>
                    </div>
                    <div class="onecolumn">
                        <div class="header">
                            <span>
                                <img src="../../images/icon_validaXML.png" alt="icon">
                                Imagenes
                            </span>
                            <div class="switch" style="width:500px">
                                
                            </div>
                        </div>
                    </div>
                                                    
            <script>
                var id_map= 'map_canvas';
                var markerRoute;
                $(document).ready(function(){
                    $("input[name=tipo]").click(function(){
                        $("#action_filter").submit();
                    });
                    $(".show_ubicacion").click(function(){
                        $(".column_right").hide("fast");
                        $("#contenido_detalles").hide("fast");
                        $("#map_canvas").css("visibility","visible");
                        limpiarMapa();
                        var lat = $("#lat_"+$(this).attr('idact')).val();
                        var lon = $("#lon_"+$(this).attr('idact')).val();
                        crearMarcadorBasico(lat,lon);
                        $(".column_right").show("slow");
                        $("#map_canvas").show("slow");
                    });
                    $(".show_resumen").click(function(){
                        $(".column_right").hide("fast");
                        $("#map_canvas").hide("fast");
                        $("#contenido_detalles").html("");
                        
                        $("#detalles_tittle").html("Resumen");
                        var tiempo = {};
                        if($("#checkin_"+$(this).attr("id")).val()=='No terminada'){
                             tiempo[0] = $("#checkin_"+$(this).attr("id")).val();
                             tiempo[1] = $("#checkin_"+$(this).attr("id")).val();
                        }else{
                             tiempo = $("#checkin_"+$(this).attr("id")).val().split(" ");
                        }
                        var cadena = "<label class='title_resumen'>Fecha Realizada</label><br>";
                        cadena += "<label class='info_resumen'>"+tiempo[0]+"</label><br><br>";
                        cadena += "<label class='title_resumen'>Hora</label><br>";
                        cadena += "<label class='info_resumen'>"+tiempo[1]+"</label><br><br>";
                        cadena += "<label class='title_resumen'>Comentario</label><br>";
                        cadena += "<label class='info_resumen'>"+$("#comentarios_"+$(this).attr("id")).val()+"</label><br><br>";
                        if($("#tipo_"+$(this).attr("id")).val()==1){
                            cadena += "<label class='title_resumen'>Producto</label><br>";
                            cadena += "<label class='info_resumen'>"+$("#producto_"+$(this).attr("id")).val()+"</label><br><br>";
                            cadena += "<label class='title_resumen'>Cantidad</label><br>";
                            cadena += "<label class='info_resumen'>"+$("#cantidad_"+$(this).attr("id")).val()+"</label><br><br>";
                            cadena += "<label class='title_resumen'>Recibio</label><br>";
                            cadena += "<label class='info_resumen'>"+$("#recibio_"+$(this).attr("id")).val()+"</label><br><br>";
                        }
                        $("#contenido_detalles").html(cadena);
                        $("#contenido_detalles").show("fast")
                        $(".column_right").show("slow");
                    });
                });
            var map;
            var poly;
                        
            var directionDisplay;
            var directionsService;
            var directionsResult;
            
            var markerRoute = [];
            var global = [];
            var latLngRoute = [];
            var stops = [];  
            var geocoder ;
            var infowindow ;
            
            function limpiarMapa() {
                
                 
                var rendererOptions = {
                    draggable: true
                };
                directionsDisplay.setMap(null);
                //directionsDisplay = new google.maps.DirectionsRenderer(rendererOptions);
                
                if(markerRoute){
                    for(var i = 0, marcador; marcador = markerRoute[i]; i ++){
                        marcador.setMap(null);
                    }
                    markerRoute = [];
                    
                }
            
            }
            
            function initialize() {
                
                var rendererOptions = {
                    draggable: true
                };
            
                directionsService = new google.maps.DirectionsService();
                directionsDisplay = new google.maps.DirectionsRenderer(rendererOptions);
                
                geocoder = new google.maps.Geocoder;
                infowindow = new google.maps.InfoWindow;
                
                var leon = new google.maps.LatLng(21.123619,-101.680496);
                var mexico = new google.maps.LatLng(23.634501,-102.552784);
                var inicio = new google.maps.LatLng(19.433733654546185,-99.13178443908691);
                var mapOptions = {
                  zoom: 15,
                  center: inicio,
                  mapTypeId: google.maps.MapTypeId.ROADMAP,
                  draggableCursor:'crosshair'
                };

                map = new google.maps.Map(document.getElementById(id_map),
                    mapOptions);
                
                map.controls[google.maps.ControlPosition.TOP_RIGHT].push(
                FullScreenControl(map, 'Pantalla Completa',
                'Salir Pantalla Completa'));
                    
                google.maps.event.addListener(map, 'click', function(event) {
                    crearMarcadorBasico(event.latLng);
                });
                
                directionsDisplay.setMap(map);
            }
            
            function loadScript() {
                var script = document.createElement('script');
                script.type = 'text/javascript';
                script.src = 'https://maps.googleapis.com/maps/api/js?v=3&' +
                    'callback=initialize&key=AIzaSyDzMx9Abj9GxfPeqIvUc_Sh46ZmzIreljQ';
                document.body.appendChild(script);
            }
            window.onload = loadScript;
            
            function crearMarcadorBasico(lat,lon){
                var latlng = {lat: parseFloat(lat), lng: parseFloat(lon)};
                geocoder.geocode({'location': latlng}, function(results, status) {
                    if (status === google.maps.GeocoderStatus.OK) {
                      if (results[1]) {
                        map.setZoom(11);
                        var marker = new google.maps.Marker({
                          position: latlng,
                          map: map
                        });
                        markerRoute[0]= marker;
                        infowindow.setContent(results[1].formatted_address);
                        map.setCenter(results[0]);
                        infowindow.open(map, marker);
                      } else {
                        window.alert('No results found');
                      }
                    } else {
                      window.alert('Geocoder failed due to: ' + status);
                    }
              });
            }
            </script>
                </div>

                <jsp:include page="../include/footer.jsp"/>
            </div>
            <!-- Fin de Contenido-->
        </div>

    </body>
</html>