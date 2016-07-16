/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.tsp.gespro.importa;

import com.tsp.gespro.bo.CategoriaBO;
import com.tsp.gespro.bo.ClienteBO;
import com.tsp.gespro.bo.ClienteCategoriaBO;
import com.tsp.gespro.bo.EmpresaBO;
import com.tsp.gespro.bo.UsuarioBO;
import com.tsp.gespro.dto.Categoria;
import com.tsp.gespro.dto.Cliente;
import com.tsp.gespro.dto.ClienteCategoria;
import com.tsp.gespro.dto.ClientePk;
import com.tsp.gespro.dto.Concepto;
import com.tsp.gespro.dto.Usuarios;
import com.tsp.gespro.dto.UsuariosPk;
import com.tsp.gespro.dto.EmpresaPermisoAplicacion;
import com.tsp.gespro.exceptions.UsuariosDaoException;
import com.tsp.gespro.exceptions.EmpresaPermisoAplicacionDaoException;
import com.tsp.gespro.jdbc.CategoriaDaoImpl;
import com.tsp.gespro.jdbc.ClienteDaoImpl;
import com.tsp.gespro.jdbc.ConceptoDaoImpl;
import com.tsp.gespro.jdbc.UsuariosDaoImpl;
import com.tsp.gespro.jdbc.EmpresaPermisoAplicacionDaoImpl;
import com.tsp.gespro.jdbc.ResourceManager;
import com.tsp.gespro.util.GenericValidator;
import java.io.File;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import jxl.Sheet;
import jxl.Workbook;
import jxl.WorkbookSettings;

/**
 *
 * @author HpPyme
 */
public class ReadClientesExcel {
    
    
    public String logActualizacionInsertado = "";    
    
    //Lista para cargar datos desde excel   
    List<Cliente> listClientes = new ArrayList<Cliente>(); 
        
    
    //Columna correspondiente en excel
    private final int NOMBRE_COMERCIAL = 0;
    private final int CONTACTO = 1;
    private final int TELEFONO = 2;
    private final int CALLE = 3;
    private final int NUMERO_EXTERIOR = 4;
    private final int NUMERO_INTERIOR = 5;
    private final int COLONIA = 6;
    private final int CODIGO_POSTAL = 7;
    private final int PAIS = 8;
    private final int ESTADO = 9;
    private final int MUNICIPIO_DELEGACION = 10;
    private final int CORREO_ELECTRONICO = 11;
    private final int LATITUD = 12;
    private final int LONGITUD = 13;
    private final int CATEGORIA = 14;
    
    //Nombres para log
    public static final String NOMBRE_COMERCIAL_NAME = "NOMBRE COMERCIAL";
    public static final String CONTACTO_NAME = "CONTACTO";    
    public static final String TELEFONO_NAME = "TELEFONO";
    public static final String CALLE_NAME = "CALLE";
    public static final String NUMERO_EXTERIOR_NAME = "NUMERO EXTERIOR";
    public static final String NUMERO_INTERIOR_NAME = "NUMERO INTERIOR";
    public static final String COLONIA_NAME = "COLONIA";
    public static final String CODIGO_POSTAL_NAME = "CODIGO POSTAL";
    public static final String PAIS_NAME = "PAIS";
    public static final String ESTADO_NAME = "ESTADO";
    public static final String MUNICIPIO_DELEGACION_NAME = "MUNICIPIO / DELEGACION";
    public static final String CORREO_ELECTRONICO_NAME = "CORREO ELECTRONICO";  
    public static final String LATITUD_NAME = "LATITUD";
    public static final String LONGITUD_NAME = "LONGITUD";
    public static final String CATEGORIA_NAME = "CATEGORIA";
        
    private UsuarioBO usuarioBO = null;
    private Connection conn = null;

    public Connection getConn() {
        if (conn==null){
            if (usuarioBO!=null){
                conn = usuarioBO.getConn();
            }else{
                try {
                    conn = ResourceManager.getConnection();
                } catch (SQLException ex) {}
            }
        }else{
            try {
                if (conn.isClosed()){
                    conn = ResourceManager.getConnection();
                }
            } catch (SQLException ex) {}
        }
        return conn;
    }

    public void setConn(Connection conn) {
        this.conn = conn;
    }
    
    
    
    
    
    /**
     * Metodo que inserta los registros leidos desde excel
     * @param archivoOrigen
     * @return int Estatus Carga 1- CARGA COMPLETA, 2- CARGA INCOMPLETA (CON ERRORES), 3- OTRO
     */

    public String leerArchivoExcelClientes(String archivoOrigen, int idEmpresa) {
        
        //1 crear lista tipo Cliente importar
        //2 cargar lista con datos leidos del excel     
        //3 Mapear a obj propios e insercion a bd                
             
        Cliente clienteExcel = null;  
        
        GenericValidator gc = new GenericValidator();
        
        try{
            
            WorkbookSettings ws = new WorkbookSettings();
            ws.setEncoding("ISO-8859-1");
            
            Workbook archivoExcel = Workbook.getWorkbook(new File(archivoOrigen),ws); 
           
            System.out.println("Número de Hojas\t" + archivoExcel.getNumberOfSheets()); 
            for (int sheetNo = 0; sheetNo < archivoExcel.getNumberOfSheets(); sheetNo++) // Recorre cada hoja                                                                                                                                                       
            { 
                
                Sheet hoja = archivoExcel.getSheet(sheetNo); 
                int numColumnas = hoja.getColumns(); 
                int numFilas = hoja.getRows(); 
                String data; 
                String columnName = "";
                /*int dataInt =0;
                double dataDouble = 0;*/
                
                System.out.println("Nombre de la Hoja\t" + archivoExcel.getSheet(sheetNo).getName()); 
                System.out.println("Filas\t" + numFilas); 
                System.out.println("Columnas\t" + numColumnas); 
              
                 
                for (int fila = 1; fila < numFilas; fila++) { // Recorre cada fila de la hoja 
                    
                    System.out.println("----------------");
                    //Creamos obj cliente                                      
                    clienteExcel =  new Cliente();
                                        
                    for (int columna = 0; columna < numColumnas; columna++) { // Recorre cada columna de la fila 
                        
                        //Data =  info dentro de celda
                        data = hoja.getCell(columna,fila ).getContents(); 
                        
                        
                       //System.out.println(" |  FILA: " + fila + "   --  Columna:  " + columna + "  ***Data: " + data );                        
                        
                        try{
                            
                            switch(columna){

                                case NOMBRE_COMERCIAL:
                                    columnName = NOMBRE_COMERCIAL_NAME;//para log
                                    
                                    if(!data.trim().equals("")){
                                        
                                        if(gc.isValidString(data, 1, 300)){
                                            clienteExcel.setNombreComercial(data);
                                        }else{
                                            throw new Exception("For input string: '"+data+"'. Mínimo 1 y máximo 300 caracteres.");
                                        }                                        
                                        
                                    }else{
                                        throw new Exception("For input string: '"+data+"'. No puede quedar vacio.");
                                    }   
                                break;
                                
                                case CONTACTO:
                                    columnName = CONTACTO_NAME;//para log
                                    
                                    if(!data.trim().equals("")){ 
                                        if(gc.isValidString(data, 0, 100)){
                                             clienteExcel.setContacto(data);
                                        }else{
                                            throw new Exception("For input string: '"+data+"'. Máximo 100 caracteres.");
                                        }
                                    }else{
                                         clienteExcel.setContacto("Campo por llenar");
                                    }   
                                    
                                break; 
                                                                
                                case TELEFONO:
                                    columnName = TELEFONO_NAME;//para log
                                    
                                    if(!data.trim().equals("")){
                                        if(gc.isNumeric(data, 7, 10)){
                                            clienteExcel.setTelefono(data);                                         
                                        }else{
                                            throw new Exception("For input string: '"+data+"'. Mínimo 7 y máximo 10 números.");   
                                        }
                                        
                                    }else{
                                         clienteExcel.setTelefono("Campo por llenar");
                                    } 
                                break;
                                case CALLE:
                                    columnName = CALLE_NAME;//para log
                                    
                                    
                                    if(!data.trim().equals("")){ 
                                        if(gc.isValidString(data, 1, 100)){
                                             clienteExcel.setCalle(data);
                                        }else{
                                            throw new Exception("For input string: '"+data+"'. Mínimo 1 y máximo 100 caracteres.");
                                        }
                                    }else{
                                          throw new Exception("For input string: '"+data+"'. No puede quedar vacio.");
                                    }
                                    
                                     
                                break;
                                case NUMERO_EXTERIOR:
                                    columnName = NUMERO_EXTERIOR_NAME;//para log
                                    
                                    if(!data.trim().equals("")){ 
                                        if(gc.isValidString(data, 1, 30)){
                                             clienteExcel.setNumero(data);
                                        }else{
                                            throw new Exception("For input string: '"+data+"'. Mínimo 1 y máximo 30 caracteres.");
                                        }
                                    }else{
                                         clienteExcel.setNumero("S/N");
                                    }                                    
                                  
                                break;
                                case NUMERO_INTERIOR:
                                    columnName = NUMERO_INTERIOR_NAME;//para log
                                    
                                    
                                    if(!data.trim().equals("")){ 
                                        if(gc.isValidString(data, 0, 30)){
                                             clienteExcel.setNumeroInterior(data);
                                        }else{
                                            throw new Exception("For input string: '"+data+"'. Máximo 30 caracteres.");
                                        }
                                    }else{
                                         clienteExcel.setNumeroInterior("S/N");
                                    }                                    
                                     
                                break;
                                case COLONIA:
                                    columnName = COLONIA_NAME;//para log
                                    
                                    if(!data.trim().equals("")){ 
                                        if(gc.isValidString(data, 1, 100)){
                                              clienteExcel.setColonia(data);
                                        }else{
                                            throw new Exception("For input string: '"+data+"'. Mínimo 1 y máximo 100 caracteres.");
                                        }
                                    }else{
                                         throw new Exception("For input string: '"+data+"'. No puede quedar vacio.");
                                    }                                    
                                    
                                break;
                                case CODIGO_POSTAL:
                                    columnName = CODIGO_POSTAL_NAME;//para log
                                                                                                           
                                    if(!data.trim().equals("")){ 
                                        
                                        if(gc.isCodigoPostal(data)){
                                              clienteExcel.setCodigoPostal(data);
                                        }else{
                                            throw new Exception("For input string: '"+data+"'. Máximo 5 números.");
                                        }
                                    }else{
                                         throw new Exception("For input string: '"+data+"'. No puede quedar vacio.");
                                    }                                             
                                    
                                break;
                                
                                case PAIS:
                                    columnName = PAIS_NAME;//para log
                                    
                                    if(!data.trim().equals("")){ 
                                        if(gc.isValidString(data, 1, 100)){
                                              clienteExcel.setPais(data);
                                        }else{
                                            throw new Exception("For input string: '"+data+"'. Mínimo 1 y máximo 100 caracteres.");
                                        }
                                    }else{
                                         throw new Exception("For input string: '"+data+"'. No puede quedar vacio.");
                                    }   
                                    
                                break;  
                                
                                case ESTADO:
                                    columnName = ESTADO_NAME;//para log
                                    
                                    if(!data.trim().equals("")){ 
                                        if(gc.isValidString(data, 1, 100)){
                                              clienteExcel.setEstado(data);
                                        }else{
                                            throw new Exception("For input string: '"+data+"'. Mínimo 1 y máximo 100 caracteres.");
                                        }
                                    }else{
                                         throw new Exception("For input string: '"+data+"'. No puede quedar vacio.");
                                    }
                                    
                                    
                                break; 
                                
                                case MUNICIPIO_DELEGACION:
                                    columnName = MUNICIPIO_DELEGACION_NAME;//para log
                                    
                                    
                                    if(!data.trim().equals("")){ 
                                        if(gc.isValidString(data, 1, 100)){
                                              clienteExcel.setMunicipio(data);
                                        }else{
                                            throw new Exception("For input string: '"+data+"'. Mínimo 1 y máximo 100 caracteres.");
                                        }
                                    }else{
                                         throw new Exception("For input string: '"+data+"'. No puede quedar vacio.");
                                    }                                     
                                    
                                break;   
                                
                                case CORREO_ELECTRONICO:
                                    columnName = CORREO_ELECTRONICO_NAME;//para log
                                    
                                    
                                    if(!data.trim().equals("")){ 
                                        if(gc.isEmail(data)){
                                             clienteExcel.setCorreo(data);
                                        }else{
                                            throw new Exception("For input string: '"+data+"'. Estructura incorrecta (correo@generico.com)" );
                                        }
                                    }else{
                                         clienteExcel.setCorreo("correo@generico.com");
                                    }                                    
                                     
                                break; 
                                                                    
                                case LATITUD:
                                    columnName = LATITUD_NAME;//para log

                                    try{
                                        clienteExcel.setLatitud((Double.parseDouble(data)));
                                    }catch(Exception e){
                                        clienteExcel.setLatitud(0);
                                    } 
                                break;
                                case LONGITUD:
                                    columnName = LONGITUD_NAME;//para log

                                    try{
                                        clienteExcel.setLongitud((Double.parseDouble(data)));
                                    }catch(Exception e){
                                        clienteExcel.setLongitud(0);
                                    } 
                                break;
                                
                                case CATEGORIA:
                                    columnName = CATEGORIA_NAME;//para log
                                                                        
                                    if(!data.trim().equals("")){ 
                                        if(gc.isValidString(data, 1, 100)){
                                            //BUSCAMOS EL ID DE CATEGORIA:
                                            ClienteCategoria categoria = null;
                                            ClienteCategoriaBO categoriaBO = new ClienteCategoriaBO(this.conn);
                                            try{
                                                categoria = categoriaBO.findClienteCategorias(0, idEmpresa, 0, 0, " AND NOMBRE_CLASIFICACION = '" + data + "' AND ID_ESTATUS = 1 ")[0];
                                                clienteExcel.setIdCategoria(categoria.getIdCategoria());
                                            }catch(Exception e){
                                                clienteExcel.setIdCategoria(0);
                                            }                                            
                                        }else{
                                            clienteExcel.setIdCategoria(0);
                                        }
                                    }else{
                                         clienteExcel.setIdCategoria(0);
                                    }                                     
                                    
                                break;
                                
                            }//switch                           
                            
                            
                        }catch(Exception e){
                            //Aqui log
                            //e.printStackTrace();
                            logActualizacionInsertado += "No se pudo leer el Cliente.  Registro número: "+ (fila+1) +" Columna: " + columnName + ", Error: "+e.getMessage()+" <br/>";            
                        }
                        
                        
                    }//for columnas
                    
                    System.out.println("\n"); 
                    listClientes.add(clienteExcel);
                    
                }//for filas
                
            }//for sheets
            
        }catch (Exception ioe){ 
            ioe.printStackTrace(); 
        }
        
        
        return logActualizacionInsertado;
        
    }
    
    
    public String insertaClientesExcel(long idEmpresa, int idUsuario){
        
        String logActualizacionInsertadoLocal = "";
        int i = 1; 
        ClienteDaoImpl clienteDaoImpl = new ClienteDaoImpl();
        GenericValidator gc = new GenericValidator();        
        EmpresaBO empresaBO = new EmpresaBO(this.conn);
                
        for(Cliente item:listClientes){
        
        
            
            i ++;
            System.out.println("-------- registro"+ i);
            
            
            //************INSERTAMOS LOS REGISTROS DE LOS CLIENTES
            try{
                
                
                ClienteBO clienteBO = new ClienteBO(this.conn);
                Cliente clienteExiste = null;


                try{
                     System.out.println("BUSCANDO.-....................");    
                    clienteExiste = clienteBO.getClienteByNombreComercialSocial(idEmpresa,item.getNombreComercial());                
                }catch(Exception e){
                   //e.printStackTrace();
                   //logActualizacionInsertado += "No se pudo actualizar el regitro del Concepto.  Registro número: "+ i +", Error: "+e.getMessage()+". <br/>";            
                }
                
                
                //SI NO EXISTE LO INSERTAMOS
                if(clienteExiste==null){ 
                    
                    
                  System.out.println("CREAR CLIENTE...");    

                  
                 
                    if((!item.getNombreComercial().trim().equals(""))){//cliente normal
                        System.out.println("Normal...");

                        Cliente clienteNuevo = new Cliente();                            
                            
                        clienteNuevo.setIdEmpresa((int)idEmpresa);

                        clienteNuevo.setIdCategoria(item.getIdCategoria());
                        clienteNuevo.setIdEstatus(1);                           
                        clienteNuevo.setNombreComercial(item.getNombreComercial());
                        
                        clienteNuevo.setCalle(item.getCalle()); 
                        
                        clienteNuevo.setTelefono(item.getTelefono());                                                    
                        clienteNuevo.setNumero(item.getNumero());
                        clienteNuevo.setNumeroInterior(item.getNumeroInterior());
                        clienteNuevo.setCodigoPostal(item.getCodigoPostal());
                        clienteNuevo.setColonia(item.getColonia());
                        clienteNuevo.setMunicipio(item.getMunicipio());
                        clienteNuevo.setEstado(item.getEstado());
                        clienteNuevo.setPais(item.getPais());             
                        clienteNuevo.setCorreo(item.getCorreo());
                        clienteNuevo.setContacto(item.getContacto());
                        clienteNuevo.setLatitud(item.getLatitud());
                        clienteNuevo.setLongitud(item.getLongitud());
                        clienteNuevo.setIdCategoria(item.getIdCategoria());
                        clienteNuevo.setIdUsuarioAlta(idUsuario);
                        clienteNuevo.setFechaRegistro(new Date());

                        //insert
                        ClientePk clientePk = clienteDaoImpl.insert(clienteNuevo);
                        
                        /////relacionamos al vendedor con el cliente, en caso de que lo hayan capturado
                        //Relacion con vendedor
                        if (item.getIdEstatus()>0){
                            
                        }
                        /////
                        

                    }else{//cliente Express                    
                        System.out.println("Express...");                          

                            Cliente clienteNuevo = new Cliente();                            
                            
                            clienteNuevo.setIdEmpresa((int)idEmpresa);
                            clienteNuevo.setIdCategoria(item.getIdCategoria());
                            clienteNuevo.setIdEstatus(3);                           
                            clienteNuevo.setNombreComercial(item.getNombreComercial());
                            
                            clienteNuevo.setCalle(item.getCalle()); 
                            clienteNuevo.setTelefono(item.getTelefono());                           
                            clienteNuevo.setNumero(item.getNumero());
                            clienteNuevo.setNumeroInterior(item.getNumeroInterior());
                            clienteNuevo.setCodigoPostal(item.getCodigoPostal());
                            clienteNuevo.setColonia(item.getColonia());
                            clienteNuevo.setMunicipio(item.getMunicipio());
                            clienteNuevo.setEstado(item.getEstado());
                            clienteNuevo.setPais(item.getPais());        
                            clienteNuevo.setCorreo(item.getCorreo());
                            clienteNuevo.setContacto(item.getContacto());
                            clienteNuevo.setNombreComercial(item.getNombreComercial());
                            clienteNuevo.setLatitud(item.getLatitud());
                            clienteNuevo.setLongitud(item.getLongitud()); 
                            clienteNuevo.setIdUsuarioAlta(idUsuario);
                            clienteNuevo.setFechaRegistro(new Date());
                            
                            //insert
                            ClientePk clientePk = clienteDaoImpl.insert(clienteNuevo);
                            
                            /////relacionamos al vendedor con el cliente, en caso de que lo hayan capturado
                            //Relacion con vendedor
                            if (item.getIdEstatus()>0){
                                
                            }
                            /////
                            

                    }                
                  
                    
                    
                }else{//SI EXISTE LO ACTUALIZAMOS
                    
                     System.out.println("ACTUALIZAR CLIENTE...");                                             
                            
                        //clienteExiste.setIdEmpresa((int)idEmpresa);
                        //clienteExiste.setIdEstatus(3);                           
                        //clienteExiste.setRazonSocial(item.getRazonSocial());
                       
                        clienteExiste.setIdCategoria(item.getIdCategoria());
                        clienteExiste.setCalle(item.getCalle()); 
                        
                        clienteExiste.setTelefono(item.getTelefono());                            
                        clienteExiste.setNumero(item.getNumero());
                        clienteExiste.setNumeroInterior(item.getNumeroInterior());
                        clienteExiste.setCodigoPostal(item.getCodigoPostal());
                        clienteExiste.setColonia(item.getColonia());
                        clienteExiste.setMunicipio(item.getMunicipio());
                        clienteExiste.setEstado(item.getEstado());
                        clienteExiste.setPais(item.getPais());          
                        clienteExiste.setCorreo(item.getCorreo());
                        clienteExiste.setContacto(item.getContacto());                    
                        clienteExiste.setNombreComercial(item.getNombreComercial());
                        clienteExiste.setLatitud(item.getLatitud());
                        clienteExiste.setLongitud(item.getLongitud());                     
                    
                        //insert
                        clienteDaoImpl.update(clienteExiste.createPk(),clienteExiste );
                        
                        /////
                        //Relacion con vendedor
                        if (item.getIdEstatus()>0){
                            
                        }
                        /////
                        
                        
                }
                
            }catch(Exception ex){
                System.out.println("Problemas al guardar Cliente");
                logActualizacionInsertado += "No se pudo insertar / actualizar el regitro del Cliente.  Registro número: "+ i +", Error: "+ex.getMessage()+". <br/>";            
            }
            
            //************FIN REGISTROS DE LOS CONCEPTOS 
            
            
            
        }
        
        
        
        return logActualizacionInsertado;
    }
    
    public Usuarios getUsuariosGenericoByUsuariosNombre(String nombreUsuarios, int idEmpresa) throws Exception{
        Usuarios empleado = null;
        nombreUsuarios = nombreUsuarios.trim();
        nombreUsuarios = nombreUsuarios.replaceAll("  "," ");
        nombreUsuarios = nombreUsuarios.replaceAll("   "," ");
        //"CONCAT(NOMBRE,APELLIDO_PATERNO,APELLIDO_MATERNO) LIKE '%" + nombreUsuarios + "%';
        
        //nombreUsuarios = nombreUsuarios.replaceAll("\\s", "%");
        
        try{
            UsuariosDaoImpl empleadoDaoImpl = new UsuariosDaoImpl();
            empleado = empleadoDaoImpl.findByDynamicWhere("CONCAT_WS(' ',NOMBRE,APELLIDO_PATERNO,APELLIDO_MATERNO) LIKE '%" +nombreUsuarios+"%' AND ID_EMPRESA = " + idEmpresa, new Object[0])[0];
            /*if (empleado==null){
                throw new Exception("No hay empleado con ese nombre");
            }*/
        }catch(UsuariosDaoException  e){
            e.printStackTrace();
            throw new Exception("No hay empleado con ese nombre");
        }
        
        return empleado;
    }
    
}
