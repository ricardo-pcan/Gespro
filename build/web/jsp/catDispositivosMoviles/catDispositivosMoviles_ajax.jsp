<%-- 
    Document   : catDispositivosMoviles_ajax
    Created on : 08/01/2013, 12:10:01 PM
    Author     : Leonardo Montes de Oca, leonarzeta@hotmail.com
--%>


<%@page import="com.tsp.gespro.dto.Usuarios"%>
<%@page import="com.tsp.gespro.bo.UsuariosBO"%>
<%@page import="com.tsp.gespro.jdbc.EmpresaPermisoAplicacionDaoImpl"%>
<%@page import="com.tsp.gespro.dto.Empresa"%>
<%@page import="com.tsp.gespro.dto.EmpresaPermisoAplicacion"%>

<%@page import="com.tsp.gespro.bo.EmpresaBO"%>
<%@page import="java.util.regex.Matcher"%>
<%@page import="com.tsp.gespro.bo.DispositivoMovilBO"%>
<%@page import="com.tsp.gespro.mail.TspMailBO"%>
<%@page import="com.tsp.gespro.util.Encrypter"%>
<%@page import="com.tsp.gespro.jdbc.LdapDaoImpl"%>
<%@page import="com.tsp.gespro.dto.Ldap"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Date"%>
<%@page import="com.tsp.gespro.jdbc.DispositivoMovilDaoImpl"%>
<%@page import="com.tsp.gespro.dto.DispositivoMovil"%>
<%@page import="com.tsp.gespro.util.GenericValidator"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:useBean id="user" scope="session" class="com.tsp.gespro.bo.UsuarioBO"/>
<%
    String mode = "";
    
    int idEmpresa = user.getUser().getIdEmpresa();
    
    /*
    * Parámetros
    */
    int idDispositivoMovil = -1;
    String imeiDispositivoMovil ="";
    String marcaDispositivoMovil = "";
    String modeloDispositivoMovil = "";
    String numSerieDispositivoMovil = "";
    String aliasDispositivoMovil = "";
    int asignadoDispositivoMovil = 0;
    int estatus = 2;//deshabilitado
    int activadorDesactivador = 0;
    int idSucursalEmpresaAsignado = -1;
    
    /*
    * Recepción de valores
    */
    mode = request.getParameter("mode")!=null?request.getParameter("mode"):"";    
    if (mode.equals("2")){ //SI ES 2 ES PARA BORRAR
           //todo codigo paracambiar estatus           
           try{
            idDispositivoMovil = Integer.parseInt(request.getParameter("idDispositivo"));
           }catch(NumberFormatException ex){}           
            DispositivoMovilBO dispositivoMovilBO = new DispositivoMovilBO(idDispositivoMovil,user.getConn());
            DispositivoMovil dispositivoMovilDto = dispositivoMovilBO.getDispositivoMovil();
            dispositivoMovilDto.setIdEstatus(2);
            try{
                new DispositivoMovilDaoImpl(user.getConn()).update(dispositivoMovilDto.createPk(), dispositivoMovilDto);
                out.print("<!--EXITO-->Registro borrado satisfactoriamente");
            }catch(Exception ex){
                out.print("<!--ERROR-->No se pudo borrar el registro. Informe del error al administrador del sistema: " + ex.toString());
                ex.printStackTrace();
            }                   
    } else if (mode.equals("3")){ //SI ES 3 ES PARA ACTIVAR O DESACTIVAR EL DISPOSITIVO
           //todo codigo paracambiar estatus           
           try{
            idDispositivoMovil = Integer.parseInt(request.getParameter("idDispositivo"));               
           }catch(NumberFormatException ex){}           
           try{            
            activadorDesactivador = Integer.parseInt(request.getParameter("activadorDesactivador"));
           }catch(NumberFormatException ex){}
            DispositivoMovilBO dispositivoMovilBO = new DispositivoMovilBO(idDispositivoMovil,user.getConn());
            DispositivoMovil dispositivoMovilDto = dispositivoMovilBO.getDispositivoMovil();
            //dispositivoMovilDto.setActivado(activadorDesactivador);
            try{
                new DispositivoMovilDaoImpl(user.getConn()).update(dispositivoMovilDto.createPk(), dispositivoMovilDto);
                if(activadorDesactivador==0){
                    out.print("<!--EXITO-->Registro desactivado satisfactoriamente");
                }else if (activadorDesactivador==1){
                    out.print("<!--EXITO-->Registro activado satisfactoriamente");
                }                
            }catch(Exception ex){
                out.print("<!--ERROR-->No se pudo activar/desactivar el registro. Informe del error al administrador del sistema: " + ex.toString());
                ex.printStackTrace();
            }                   
    }else if (mode.equals("4")){//PARA REPORTAR EL MOVIL COMO ROBADO
        try{
            idDispositivoMovil = Integer.parseInt(request.getParameter("idDispositivo"));               
           }catch(NumberFormatException ex){} 
        DispositivoMovilBO dispositivoMovilBO = new DispositivoMovilBO(idDispositivoMovil,user.getConn());
        DispositivoMovil dispositivoMovilDto = dispositivoMovilBO.getDispositivoMovil();
        dispositivoMovilDto.setReporteRobo(1);
        try{
            new DispositivoMovilDaoImpl(user.getConn()).update(dispositivoMovilDto.createPk(), dispositivoMovilDto);
            out.print("<!--EXITO-->Registro reportado satisfactoriamente");
        }catch(Exception ex){
            out.print("<!--ERROR-->No se pudo reportar el registro. Informe del error al administrador del sistema: " + ex.toString());
            ex.printStackTrace();
        }     
    }
    else{
        
    
    try{
        idDispositivoMovil = Integer.parseInt(request.getParameter("idDispositivoMovil"));
    }catch(NumberFormatException ex){}
    imeiDispositivoMovil = request.getParameter("imeiDispositivoMovil")!=null?new String(request.getParameter("imeiDispositivoMovil").getBytes("ISO-8859-1"),"UTF-8"):"";
    marcaDispositivoMovil = request.getParameter("marcaDispositivoMovil")!=null?new String(request.getParameter("marcaDispositivoMovil").getBytes("ISO-8859-1"),"UTF-8"):"";    
    modeloDispositivoMovil = request.getParameter("modeloDispositivoMovil")!=null?new String(request.getParameter("modeloDispositivoMovil").getBytes("ISO-8859-1"),"UTF-8"):"";    
    numSerieDispositivoMovil = request.getParameter("numSerieDispositivoMovil")!=null?new String(request.getParameter("numSerieDispositivoMovil").getBytes("ISO-8859-1"),"UTF-8"):"";       
    aliasDispositivoMovil = request.getParameter("aliasDispositivoMovil")!=null?new String(request.getParameter("aliasDispositivoMovil").getBytes("ISO-8859-1"),"UTF-8"):"";       
    try{
        asignadoDispositivoMovil = Integer.parseInt(request.getParameter("asignadoDispositivoMovil"));
    }catch(NumberFormatException ex){}   
    try{
        estatus = Integer.parseInt(request.getParameter("estatus"));
    }catch(NumberFormatException ex){}   
    try{
        idSucursalEmpresaAsignado = Integer.parseInt(request.getParameter("idSucursalEmpresaAsignado"));
    }catch(NumberFormatException ex){}
    
    /*
    * Validaciones del servidor
    */
    String msgError = "";
    GenericValidator gc = new GenericValidator();    
    if(!gc.isValidString(imeiDispositivoMovil, 1, 16))
        msgError += "<ul>El dato 'IMEI' es requerido.";   
    if(idDispositivoMovil <= 0 && (!mode.equals("")))
        msgError += "<ul>El dato ID 'DispositivoMovil' es requerido";
    /*
    if(idVendedor<=0)
        msgError += "<ul>El dato 'Vendedor' es requerido";
 * */

    if(msgError.equals("")){
        if(idDispositivoMovil>0){
            if (mode.equals("1")){
            /*
            * Editar
            */
                DispositivoMovilBO dispositivoMovilBO = new DispositivoMovilBO(idDispositivoMovil,user.getConn());
                DispositivoMovil dispositivoMovilDto = dispositivoMovilBO.getDispositivoMovil();
                
                dispositivoMovilDto.setIdEstatus(estatus);
                dispositivoMovilDto.setImei(imeiDispositivoMovil);
                dispositivoMovilDto.setMarca(marcaDispositivoMovil);
                dispositivoMovilDto.setModelo(modeloDispositivoMovil);
                dispositivoMovilDto.setNumeroSerie(numSerieDispositivoMovil.trim()); 
                dispositivoMovilDto.setAliasTelefono(aliasDispositivoMovil);
                //dispositivoMovilDto.setIdEmpresa(idEmpresa);
                if(idSucursalEmpresaAsignado<0)
                    dispositivoMovilDto.setIdEmpresa(idEmpresa);
                else
                    dispositivoMovilDto.setIdEmpresa(idSucursalEmpresaAsignado);
                
                try{
                    new DispositivoMovilDaoImpl(user.getConn()).update(dispositivoMovilDto.createPk(), dispositivoMovilDto);

                    out.print("<!--EXITO-->Registro actualizado satisfactoriamente");
                }catch(Exception ex){
                    out.print("<!--ERROR-->No se pudo actualizar el registro. Informe del error al administrador del sistema: " + ex.toString());
                    ex.printStackTrace();
                }
                
            }else{
                out.print("<!--ERROR-->Acción no válida.");
            }
        }else{
            /*
            *  Nuevo
            */
            
            //////////VALIDAMOS CUANTOS REGISTROS TIENE PARA VER SI LO DEJAMOS CREAR O NO, DEPENDIENDO DEL PAQUETE:
            /*
            EmpresaBO empresaBO = new EmpresaBO(user.getConn());
            EmpresaPermisoAplicacion empresaPermisoAplicacionDto = new EmpresaPermisoAplicacionDaoImpl(user.getConn()).findByPrimaryKey(empresaBO.getEmpresaMatriz(user.getUser().getIdEmpresa()).getIdEmpresa());     
            //RECUPERAMOS LA LONGITUD DEL NUMERO DE RESGITROS QUE SE ENCUANTRAN CREADOS CON ESTATUS ACTIVO
            DispositivoMovilBO ubo = new DispositivoMovilBO(user.getConn());
            DispositivoMovil[] lista = new DispositivoMovil[0];
            lista = ubo.findDispositivosMoviles(0, empresaBO.getEmpresaMatriz(user.getUser().getIdEmpresa()).getIdEmpresa(), 0, 0, "");
            
            UsuariosBO usuariosBO = new UsuariosBO();
            Usuarios[] listaUsuarios = new Usuarios[0];
            listaUsuarios = usuariosBO.findUsuarios(-1, empresaBO.getEmpresaMatriz(user.getUser().getIdEmpresa()).getIdEmpresa(), 0, 0, " AND ID_ESTATUS <> 2 ");
            
            System.out.println("---------------DISPOSITIVOS MOVILES: "+lista.length);
            System.out.println("---------------USUARIOS: "+listaUsuarios.length);
            
            int licenciasUsadas = 0;
            licenciasUsadas = lista.length + listaUsuarios.length;
            
            
            System.out.println("---------------LICENCIAS USADAS: "+licenciasUsadas);
            //////////
            if(licenciasUsadas < empresaPermisoAplicacionDto.getAccesoSgfensNumLicenciasMoviles()){  */
                try {                

                    /**
                     * Creamos el registro de DispositivoMovil
                     */
                    DispositivoMovil dispositivoMovilDto = new DispositivoMovil();
                    DispositivoMovilDaoImpl dispositivosMovilesDaoImpl = new DispositivoMovilDaoImpl(user.getConn());             

                    dispositivoMovilDto.setIdEstatus(estatus);
                    dispositivoMovilDto.setImei(imeiDispositivoMovil);
                    dispositivoMovilDto.setMarca(marcaDispositivoMovil);
                    dispositivoMovilDto.setModelo(modeloDispositivoMovil);
                    dispositivoMovilDto.setNumeroSerie(numSerieDispositivoMovil.trim());
                    dispositivoMovilDto.setAliasTelefono(aliasDispositivoMovil);
                    //dispositivoMovilDto.setAsignado(asignadoDispositivoMovil);
                    //dispositivoMovilDto.setIdEmpresa(idEmpresa);
                    if(idSucursalEmpresaAsignado<0)
                        dispositivoMovilDto.setIdEmpresa(idEmpresa);
                    else
                        dispositivoMovilDto.setIdEmpresa(idSucursalEmpresaAsignado);

                    /**
                     * Realizamos el insert
                     */
                    dispositivosMovilesDaoImpl.insert(dispositivoMovilDto);
                    
/*                    //Consumo de Creditos Operacion
                    try{
                        BitacoraCreditosOperacionBO bcoBO = new BitacoraCreditosOperacionBO(user.getConn());
                        bcoBO.registraDescuento(user.getUser(), 
                                BitacoraCreditosOperacionBO.CONSUMO_ACCION_REGISTRO_DISP_MOVIL, 
                                null, 0, 0, 0, 
                                "Registro de Dispositivo Movil", null, true);
                    }catch(Exception ex){
                        ex.printStackTrace();
                    }
*/
                    out.print("<!--EXITO-->Registro creado satisfactoriamente.<br/>");

                }catch(Exception e){
                    e.printStackTrace();
                    msgError += "Ocurrio un error al guardar el registro: " + e.toString() ;
                }
            /*}else{
                out.print("<!--ERROR-->No se permite crear mas dispositivos. Ya no tiene licencias disponibles.");
            }*/
        }
    }else{
        out.print("<!--ERROR-->"+msgError);
    }
 }
%>