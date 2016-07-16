
<%@page import="com.tsp.gespro.dto.Ruta"%>
<%@page import="com.tsp.gespro.factory.RutaDaoFactory"%>
<%@page import="com.tsp.gespro.dao.RutaDao"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:useBean id="user" scope="session" class="com.tsp.gespro.bo.UsuarioBO"/>
<%
    int idRuta = 0;
    try{
        idRuta = Integer.parseInt(request.getParameter("idRuta"));
    }catch(Exception e){}
    int idPromotor = 0;
    try{
        idPromotor = Integer.parseInt(request.getParameter("cmb_id_promotor"));
    }catch(Exception e){}
    if(idRuta>0){
    
        RutaDao rutaDao = RutaDaoFactory.create(user.getConn());
        try{
            Ruta rutaDto = rutaDao.findByPrimaryKey(idRuta);
            if(idPromotor>0){
                rutaDto.setIdUsuario(idPromotor);
            }else{
                rutaDto.setIdUsuarioNull(true);
            }
            
            rutaDao.update(rutaDto.createPk(),rutaDto);
            
            out.print("<!--EXITO-->Registro actualizado satisfactoriamente");
            
        }catch(Exception e){
            out.print("<!--ERROR-->No se pudo actualizar el registro. Informe del error al administrador del sistema: " + e.toString());
        }
    }else{
        out.print("<!--ERROR-->No se pudo actualizar el registro. No se recibió un objeto.");
    }
%>
