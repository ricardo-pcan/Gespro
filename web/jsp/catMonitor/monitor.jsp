<%-- 
    Document   : mapa
    Created on : 13-ago-2016, 15:18:23
    Author     : zesk8
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
        <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    </head>
    <body>
        <h1>Hello World!</h1>
        <button id="myBtn">Actualizar mapa.</button>
        <div id="regions_div" style="width: 900px; height: 500px;"></div>
        <div id="chart_div" style="width: 900px; height: 500px;"></div>
        <script type="text/javascript">
            printMaps();
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
            }
            // Add event to show maps
            document.getElementById("myBtn").addEventListener("click", printMaps);
        </script>
    </body>
</html>
