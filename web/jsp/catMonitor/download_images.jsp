<%@page import="java.io.File"%>
<%@page import="com.tsp.gespro.hibernate.pojo.Actividad"%>
<%@page import="com.tsp.gespro.hibernate.dao.ActividadDAO"%>
<%@page import="com.tsp.gespro.config.Configuration"%>
<%@page import="java.util.zip.ZipEntry"%>
<%@page import="java.util.zip.ZipOutputStream"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.util.List"%>
<%@page import="com.tsp.gespro.Services.Allservices"%>
<%@page import="com.tsp.gespro.hibernate.pojo.FotoActividad"%>
<% 
    String idActividad = request.getParameter("idActividad") != null ? request.getParameter("idActividad") : "";
    Allservices services = new Allservices();
    List<FotoActividad> fotoActividad = services.queryFotoActividad("WHERE idActividad = "+idActividad);
    Configuration appConfig = new Configuration();
    appConfig.setApp_content_path("/Users/fabmac/Mio/Gespro/web/");
    ActividadDAO actividadDAO= new ActividadDAO();
    Actividad objActividad= new Actividad();
    objActividad = actividadDAO.getById(Integer.parseInt(idActividad));

    File folderPictures = new File(appConfig.getApp_content_path() +"pictures");
    File folderZip = new File(appConfig.getApp_content_path() +"files");
    if(!folderPictures.exists()){
        folderPictures.mkdir();
    }
    if(!folderZip.exists()){
        folderZip.mkdir();
    }
        
    String ubicacionImagenesProspectos = appConfig.getApp_content_path() +"pictures/proyectos/"+objActividad.getIdProyecto()+"/actividades/"+objActividad.getIdActividad()+"/";
    String filezipName= appConfig.getApp_content_path() +"files/Actividad"+objActividad.getIdActividad()+"pictures.zip";

    FileOutputStream fos = null;
    ZipOutputStream zipos = null;
    fos = new FileOutputStream(filezipName);
    zipos = new ZipOutputStream(fos);
    
    byte[] buffer = new byte[2048];
    try {
        if(fotoActividad.size()>0){
            for(FotoActividad foto: fotoActividad){
                out.print(foto.getIdActividad());
                String pFile = ubicacionImagenesProspectos+foto.getFoto();
                File file = new File(pFile);
                FileInputStream fis = null;
                fis = new FileInputStream(pFile);
                ZipEntry zipEntry = new ZipEntry(file.getName());
                zipos.putNextEntry(zipEntry);        
                int len = 0;
                // zippear
                while ((len = fis.read(buffer, 0, 1024)) != -1)
                    zipos.write(buffer, 0, len);
                
                out.print(fis);
                out.print(pFile);
                fis.close();
                zipos.closeEntry();
            }
            
            response.setHeader("Content-Disposition", "attachment; filename=Actividad"+objActividad.getIdActividad()+"pictures.zip");
            zipos.flush();
            zipos.close();
        }else{
            File archivo = new File(filezipName);
            archivo.delete();
            %>
            <script>
                alert("No hay imagenes a descargar");
                javascript:window.location.href = 'monitor_log_report.jsp?idProyecto=<% out.print(objActividad.getIdProyecto()); %>';
            </script>
            <%
        }
    }catch (Exception e) {
            throw e;
    } finally {
            zipos.close();
            fos.close();
    }

%>
