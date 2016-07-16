/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.tsp.gespro.importa;

import com.tsp.gespro.bo.ConceptoBO;
import com.tsp.gespro.bo.ExistenciaAlmacenBO;
import com.tsp.gespro.bo.UsuarioBO;
import com.tsp.gespro.dto.Cliente;
import com.tsp.gespro.dto.Concepto;
import com.tsp.gespro.dto.ConceptoPk;
import com.tsp.gespro.dto.ExistenciaAlmacen;
import com.tsp.gespro.jdbc.ConceptoDaoImpl;
import com.tsp.gespro.jdbc.ExistenciaAlmacenDaoImpl;
import com.tsp.gespro.jdbc.ResourceManager;
import java.io.File;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import jxl.Sheet;
import jxl.Workbook;
import jxl.WorkbookSettings;

/**
 *
 * @author HpPyme
 */
public class ReadConceptosExcel {
    
    
    public String logActualizacionInsertado = "";
    
    
    //Lista para cargar datos desde excel   
    List<Concepto> listConceptos = new ArrayList<Concepto>(); 
    //List<ExistenciaAlmacen> listExistenciaAlmacen = new ArrayList<ExistenciaAlmacen>(); 
    
    //Columna correspondiente en excel
    private final int NOMBRE = 0;
    private final int DESCRIPCION = 1;
    private final int CODIGO = 2;
    private final int CLAVE = 3;
    private final int PRECIO_UNITARIO = 4;
    private final int UNITARIO_HASTA_X_UNIDADES = 5;
    private final int PRECIO_MEDIO_MAYOREO = 6;
    private final int MEDIO_DESDE_X_UNIDADES = 7;
    private final int MEDIO_HASTA_Y_UNIDADES = 8;
    private final int PRECIO_MAYOREO = 9;
    private final int MAYOREO_DESDE_Y_UNIDADES = 10;
    private final int PRECIO_DOCENA = 11;
    private final int PRECIO_ESPECIAL = 12;
    private final int PRECIO_COMPRA = 13;
    private final int PRECIO_MINIMO_VENTA = 14;
    private final int STOCK_MINIMO = 15;
    private final int VOLUMEN = 16;
    private final int PESO = 17;
    private final int OBSERVACIONES = 18;   
    private final int PRECIO_UNITARIO_GRANEL = 19;
    private final int PRECIO_MEDIO_MAYOREO_GRANEL = 20;
    private final int PRECIO_MAYOREO_GRANEL = 21;
    private final int PRECIO_ESPECIAL_GRANEL = 22;
    private final int STOCK_INICIAL = 23;
    private final int NOMBRE_ALMACEN = 24;
    

    
    //Nombres para log
    public static final String NOMBRE_NAME = "NOMBRE";
    public static final String DESCRIPCION_NAME = "DESCRIPCION";
    public static final String CODIGO_NAME = "CODIGO";
    public static final String CLAVE_NAME = "CLAVE";
    public static final String PRECIO_UNITARIO_NAME = "PRECIO UNITARIO";
    public static final String UNITARIO_HASTA_X_UNIDADES_NAME = "HASTA X (UNIDADES)";
    public static final String PRECIO_MEDIO_MAYOREO_NAME = "PRECIO MEDIO MAYOREO";
    public static final String MEDIO_DESDE_X_UNIDADES_NAME = "DESDE X+1  (UNIDADES)";
    public static final String MEDIO_HASTA_Y_UNIDADES_NAME = "HASTA Y (UNIDADES)";
    public static final String PRECIO_MAYOREO_NAME = "PRECIO MAYOREO";
    public static final String MAYOREO_DESDE_Y_UNIDADES_NAME = "DESDE Y+1 (UNIDADES)";
    public static final String PRECIO_DOCENA_NAME = "PRECIO DOCENA";
    public static final String PRECIO_ESPECIAL_NAME = "PRECIO ESPECIAL";
    public static final String PRECIO_COMPRA_NAME = "PRECIO COMPRA";
    public static final String PRECIO_MINIMO_VENTA_NAME = "PRECIO MINIMO VENTA";
    public static final String STOCK_MINIMO_NAME = "STOCK MINIMO";
    public static final String VOLUMEN_NAME = "VOLUMEN";
    public static final String PESO_NAME = "PESO";
    public static final String OBSERVACIONES_NAME = "OBSERVACIONES";   
    public static final String PRECIO_UNITARIO_GRANEL_NAME = "PRECIO UNITARIO GRANEL";
    public static final String PRECIO_MEDIO_MAYOREO_GRANEL_NAME = "PRECIO MEDIO MAYOREO GRANEL";
    public static final String PRECIO_MAYOREO_GRANEL_NAME = "PRECIO MAYOREO GRANEL";
    public static final String PRECIO_ESPECIAL_GRANEL_NAME = "PRECIO ESPECIAL GRANEL";
    public static final String STOCK_INICIAL_NAME = "STOCK INICIAL";
    public static final String NOMBRE_ALMACEN_NAME = "NOMBRE ALMACEN";
    
    
    
    
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

    public String leerArchivoExcelConceptos(String archivoOrigen , int idEmpresa) {           
        
        
        //1 crear lista tipo Cliente importar
        //2 cargar lista con datos leidos del excel     
        //3 Mapear a obj propios e insercion a bd                
             
        Concepto conceptoExcel = null;  
        
        
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
                    conceptoExcel =  new Concepto();
                    
                    for (int columna = 0; columna < numColumnas; columna++) { // Recorre cada columna de la fila 
                    
                        
                        
                        //Data =  info dentro de celda
                        data = hoja.getCell(columna,fila ).getContents(); 
                        
                        //System.out.println(" |  FILA: " + fila + "   --  Columna:  " + columna + "  ***Data: " + data );
                        
                        try{
                            switch(columna){

                                case NOMBRE:
                                    columnName = NOMBRE_NAME;//para log
                                    
                                    if(!data.trim().equals("")){
                                        conceptoExcel.setNombre(data);
                                    }else{
                                         throw new Exception("For input string: '"+data+"'. No puede quedar vacio.");
                                    } 
                                break;
                                case DESCRIPCION:
                                    columnName = DESCRIPCION_NAME;//para log  
                                    if(!data.trim().equals("")){
                                        conceptoExcel.setDescripcion(data);       
                                    }else{
                                         throw new Exception("For input string: '"+data+"'. No puede quedar vacio.");
                                    }
                                break;
                                case CODIGO:
                                    columnName = CODIGO_NAME ;//para log
                                    try{
                                        conceptoExcel.setIdentificacion(data);
                                    }catch(Exception e){
                                        conceptoExcel.setIdentificacion("");
                                    }                                    
                                break;
                                case CLAVE:
                                    columnName = CLAVE_NAME;//para log
                                    try{
                                        conceptoExcel.setClave(data);
                                    }catch(Exception e){   
                                        conceptoExcel.setClave("");
                                    }                                    
                                break;
                                case PRECIO_UNITARIO:
                                    columnName = PRECIO_UNITARIO_NAME;//para log
                                    if(!data.trim().equals("")){
                                         if(Float.parseFloat(data)>0 ){ 
                                            conceptoExcel.setPrecio(Float.parseFloat(data));
                                         }else{
                                             throw new Exception("For input string: '"+data+"'. Debe ser mayor a 0");
                                         }                                        
                                    }else{
                                        throw new Exception("For input string: '"+data+"'. No puede quedar vacio");
                                    }
                                    
                                break;
                                case UNITARIO_HASTA_X_UNIDADES:
                                    columnName = UNITARIO_HASTA_X_UNIDADES_NAME;//para log
                                    try{
                                        conceptoExcel.setMaxMenudeo(Double.parseDouble(data));
                                    }catch(Exception e){
                                        conceptoExcel.setMaxMenudeo(0);
                                    }                                    
                                break;
                                case PRECIO_MEDIO_MAYOREO:
                                    columnName = PRECIO_MEDIO_MAYOREO_NAME;//para log
                                    try{
                                        conceptoExcel.setPrecioMedioMayoreo(Double.parseDouble(data));
                                    }catch(Exception e){
                                        conceptoExcel.setPrecioMedioMayoreo(0);
                                    }                                    
                                break;
                                case MEDIO_DESDE_X_UNIDADES:
                                    columnName = MEDIO_DESDE_X_UNIDADES_NAME;//para log
                                    try{
                                        conceptoExcel.setMinMedioMayoreo(Double.parseDouble(data));
                                    }catch(Exception e){
                                        conceptoExcel.setMinMedioMayoreo(0);
                                    }                                    
                                break;
                                case MEDIO_HASTA_Y_UNIDADES:
                                    columnName = MEDIO_HASTA_Y_UNIDADES_NAME;//para log
                                    try{
                                        conceptoExcel.setMaxMedioMayoreo(Double.parseDouble(data));
                                    }catch(Exception e){
                                        conceptoExcel.setMaxMedioMayoreo(0);
                                    }                                        
                                break;
                                case PRECIO_MAYOREO:
                                    columnName = PRECIO_MAYOREO_NAME;//para log
                                    try{
                                        conceptoExcel.setPrecioMayoreo(Double.parseDouble(data));
                                    }catch(Exception e){
                                        conceptoExcel.setPrecioMayoreo(0);
                                    }
                                break;
                                case MAYOREO_DESDE_Y_UNIDADES:
                                    columnName = MAYOREO_DESDE_Y_UNIDADES_NAME;//para log
                                    try{
                                        conceptoExcel.setMinMayoreo(Double.parseDouble(data)); 
                                    }catch(Exception e){
                                        conceptoExcel.setMinMayoreo(0); 
                                    }
                                break; 
                                case PRECIO_DOCENA:
                                    columnName = PRECIO_DOCENA_NAME;//para log
                                    try{
                                        conceptoExcel.setPrecioDocena(Double.parseDouble(data));                                    
                                    }catch(Exception e){
                                        conceptoExcel.setPrecioDocena(0); 
                                    }
                                break;
                                case PRECIO_ESPECIAL:
                                    columnName = PRECIO_ESPECIAL_NAME;//para log
                                    try{
                                        conceptoExcel.setPrecioEspecial(Double.parseDouble(data));                                    
                                    }catch(Exception e){
                                        conceptoExcel.setPrecioEspecial(0);        
                                    }
                                break;
                                case PRECIO_COMPRA:
                                    columnName = PRECIO_COMPRA_NAME;//para log
                                    try{
                                        conceptoExcel.setPrecioCompra(Float.parseFloat(data));                                    
                                    }catch(Exception e){
                                        conceptoExcel.setPrecioCompra(0);  
                                    }
                                break;
                                case PRECIO_MINIMO_VENTA:
                                    columnName = PRECIO_MINIMO_VENTA_NAME;//para log
                                    try{
                                        conceptoExcel.setPrecioMinimoVenta(Double.parseDouble(data));   
                                    }catch(Exception e){
                                        conceptoExcel.setPrecioMinimoVenta(0);    
                                    }                                        
                                break;
                                case STOCK_MINIMO:
                                    columnName = STOCK_MINIMO_NAME;//para log
                                    try{
                                        conceptoExcel.setStockMinimo(Double.parseDouble(data)); 
                                    }catch(Exception e){
                                        conceptoExcel.setStockMinimo(0);     
                                    }
                                break;
                                case VOLUMEN:
                                    columnName = VOLUMEN_NAME;//para log
                                    try{
                                        conceptoExcel.setVolumen(Double.parseDouble(data));                                    
                                    }catch(Exception e){
                                        conceptoExcel.setVolumen(0); 
                                    }
                                break;
                                case PESO:
                                    columnName = PESO_NAME;//para log
                                    try{
                                        conceptoExcel.setPeso(Double.parseDouble(data));                                    
                                    }catch(Exception e){
                                        conceptoExcel.setPeso(0);     
                                    }
                                break;
                                case OBSERVACIONES:
                                    columnName = OBSERVACIONES_NAME;//para log
                                    try{
                                        conceptoExcel.setObservaciones(data);  
                                    }catch(Exception e){
                                        conceptoExcel.setObservaciones("");   
                                    }
                                break;                                
                                case PRECIO_UNITARIO_GRANEL:
                                    columnName = PRECIO_UNITARIO_GRANEL_NAME;//para log
                                    try{
                                        conceptoExcel.setPrecioUnitarioGranel(Double.parseDouble(data));                                    
                                    }catch(Exception e){
                                        conceptoExcel.setPrecioUnitarioGranel(0);      
                                    }                                        
                                break;
                                case PRECIO_MEDIO_MAYOREO_GRANEL:
                                    columnName = PRECIO_MEDIO_MAYOREO_GRANEL_NAME;//para log
                                    try{
                                        conceptoExcel.setPrecioMedioGranel(Double.parseDouble(data));                                    
                                    }catch(Exception e){
                                         conceptoExcel.setPrecioMedioGranel(0);         
                                    } 
                                break;
                                case PRECIO_MAYOREO_GRANEL:
                                    columnName = PRECIO_MAYOREO_GRANEL_NAME;//para log
                                    try{
                                        conceptoExcel.setPrecioMayoreoGranel(Double.parseDouble(data)); 
                                    }catch(Exception e){
                                         conceptoExcel.setPrecioMayoreoGranel(0);       
                                    }
                                break;
                                case PRECIO_ESPECIAL_GRANEL:
                                    columnName = PRECIO_ESPECIAL_GRANEL_NAME;//para log
                                    try{
                                        conceptoExcel.setPrecioEspecialGranel(Double.parseDouble(data));     
                                    }catch(Exception e){
                                        conceptoExcel.setPrecioEspecialGranel(0);      
                                    }
                                break;
                                case STOCK_INICIAL:
                                    columnName = STOCK_INICIAL_NAME;//para log
                                    try{
                                        conceptoExcel.setNumArticulosDisponibles(Double.parseDouble(data));     
                                    }catch(Exception e){
                                        conceptoExcel.setNumArticulosDisponibles(0);      
                                    }
                                break;
                                
                                
                            }//switch   
                        }catch(Exception e){
                            //Aqui log
                            //e.printStackTrace();
                            logActualizacionInsertado += "No se pudo leer el Producto.  Registro numero: "+ (fila+1) +" Columna: " + columnName + ", Error: "+e.getMessage()+" <br/>";            
                        }                        
                        

                    }//for columna 
                    
                    System.out.println("\n"); 
                    listConceptos.add(conceptoExcel);
                }//for fila
                
            }//for hoja
            
        }catch (Exception ioe){ 
            ioe.printStackTrace(); 
        }
        
        return logActualizacionInsertado;
    }
    
    
    
    public String insertaConceptosExcel(long idEmpresa){
        
        logActualizacionInsertado = "";
        int i = 1; 
        ConceptoDaoImpl conceptoDaoImpl = new ConceptoDaoImpl(this.conn);
              
        for(Concepto item:listConceptos){
            
            i ++;
            System.out.println("-------- registro"+ i);
            
            
            //************INSERTAMOS LOS REGISTROS DE LOS CONCEPTOS
            
            try{
                ConceptoBO conceptoBO = new ConceptoBO(this.conn);
                Concepto conceptoExiste = null;


                try{
                    conceptoExiste = conceptoBO.getConceptoByNombre(idEmpresa,item.getNombre());                
                }catch(Exception e){
                   //e.printStackTrace();
                   //logActualizacionInsertado += "No se pudo actualizar el regitro del Concepto.  Registro numero: "+ i +", Error: "+e.getMessage()+". <br/>";            
                }

                //SI NO EXISTE LO INSERTAMOS
                if(conceptoExiste==null){                
                  System.out.println("CREAR PRODUCTO...");    

                  Concepto conceptoNuevo = new Concepto();

                  String nombreEncriptado = "";
                  try{
                      nombreEncriptado = conceptoBO.encripta(item.getNombre());
                  }catch(Exception e){}


                  conceptoNuevo.setIdEmpresa((int)idEmpresa);
                  conceptoNuevo.setIdEstatus(1);
                  conceptoNuevo.setNombreDesencriptado(item.getNombre());
                  conceptoNuevo.setDesglosePiezas(1);
                  conceptoNuevo.setFechaAlta(new Date());
                  conceptoNuevo.setIdMarca(-1);                  
                  conceptoNuevo.setIdEmbalaje(-1);
                  conceptoNuevo.setIdImpuesto(-1);
                  conceptoNuevo.setIdCategoria(-1);
                  conceptoNuevo.setIdSubcategoria(-1);
                  conceptoNuevo.setIdSubcategoria2(-1);
                  conceptoNuevo.setIdSubcategoria3(-1);
                  conceptoNuevo.setIdSubcategoria4(-1);
                  conceptoNuevo.setNumeroLote("");
                  conceptoNuevo.setFechaCaducidad(null);

                  conceptoNuevo.setNombre(nombreEncriptado);
                  conceptoNuevo.setDescripcion(item.getDescripcion());
                  conceptoNuevo.setIdentificacion(item.getIdentificacion());
                  conceptoNuevo.setClave(item.getClave());
                  conceptoNuevo.setPrecio(item.getPrecio());
                  conceptoNuevo.setMaxMenudeo(item.getMaxMenudeo());
                  conceptoNuevo.setPrecioMedioMayoreo(item.getPrecioMedioMayoreo());
                  conceptoNuevo.setMinMedioMayoreo(item.getMinMedioMayoreo());
                  conceptoNuevo.setMaxMedioMayoreo(item.getMaxMedioMayoreo());
                  conceptoNuevo.setPrecioMayoreo(item.getPrecioMayoreo());
                  conceptoNuevo.setMinMayoreo(item.getMinMayoreo());
                  conceptoNuevo.setPrecioDocena(item.getPrecioDocena());
                  conceptoNuevo.setPrecioEspecial(item.getPrecioEspecial());
                  conceptoNuevo.setPrecioCompra(item.getPrecioCompra());
                  conceptoNuevo.setPrecioMinimoVenta(item.getPrecioMinimoVenta());
                  conceptoNuevo.setStockMinimo(item.getStockMinimo());
                  if(item.getStockMinimo()>0){
                      conceptoNuevo.setStockAvisoMin((short)1);
                  }else{
                      conceptoNuevo.setStockAvisoMin((short)-1);
                  }
                  conceptoNuevo.setVolumen(item.getVolumen());
                  conceptoNuevo.setPeso(item.getPeso());
                  conceptoNuevo.setObservaciones(item.getObservaciones());
                  conceptoNuevo.setPrecioUnitarioGranel(item.getPrecioUnitarioGranel());
                  conceptoNuevo.setPrecioMedioGranel(item.getPrecioMedioGranel());
                  conceptoNuevo.setPrecioMayoreoGranel(item.getPrecioMayoreoGranel());
                  conceptoNuevo.setPrecioEspecialGranel(item.getPrecioEspecialGranel());
                  conceptoNuevo.setNumArticulosDisponibles(item.getNumArticulosDisponibles());

                  //insert
                  ConceptoPk conceptoInsertado = conceptoDaoImpl.insert(conceptoNuevo);
                                                      
                }else{//SI EXISTE LO ACTUALIZAMOS
                      System.out.println("ACTUALIZAR PRODUCTO...");     

                      
                      if(conceptoExiste != null){
                                String nombreEncriptado = "";
                          try{
                              nombreEncriptado = conceptoBO.encripta(item.getNombre());
                          }catch(Exception e){}


                          //conceptoExiste.setIdEmpresa((int)idEmpresa);
                          conceptoExiste.setIdEstatus(1);
                          //conceptoExiste.setNombreDesencriptado(item.getNombre());
                          //conceptoExiste.setDesglosePiezas(1);
                          //conceptoNuevo.setFechaAlta(new Date());
                          

                          //conceptoNuevo.setNombre(nombreEncriptado);
                          conceptoExiste.setDescripcion(item.getDescripcion());
                          conceptoExiste.setIdentificacion(item.getIdentificacion());
                          conceptoExiste.setClave(item.getClave());
                          conceptoExiste.setPrecio(item.getPrecio());
                          conceptoExiste.setMaxMenudeo(item.getMaxMenudeo());
                          conceptoExiste.setPrecioMedioMayoreo(item.getPrecioMedioMayoreo());
                          conceptoExiste.setMinMedioMayoreo(item.getMinMedioMayoreo());
                          conceptoExiste.setMaxMedioMayoreo(item.getMaxMedioMayoreo());
                          conceptoExiste.setPrecioMayoreo(item.getPrecioMayoreo());
                          conceptoExiste.setMinMayoreo(item.getMinMayoreo());
                          conceptoExiste.setPrecioDocena(item.getPrecioDocena());
                          conceptoExiste.setPrecioEspecial(item.getPrecioEspecial());
                          conceptoExiste.setPrecioCompra(item.getPrecioCompra());
                          conceptoExiste.setPrecioMinimoVenta(item.getPrecioMinimoVenta());
                          conceptoExiste.setStockMinimo(item.getStockMinimo());
                          if(item.getStockMinimo()>0){
                              conceptoExiste.setStockAvisoMin((short)1);
                          }else{
                              conceptoExiste.setStockAvisoMin((short)-1);
                          }
                          conceptoExiste.setVolumen(item.getVolumen());
                          conceptoExiste.setPeso(item.getPeso());
                          conceptoExiste.setObservaciones(item.getObservaciones());
                          conceptoExiste.setPrecioUnitarioGranel(item.getPrecioUnitarioGranel());
                          conceptoExiste.setPrecioMedioGranel(item.getPrecioMedioGranel());
                          conceptoExiste.setPrecioMayoreoGranel(item.getPrecioMayoreoGranel());
                          conceptoExiste.setPrecioEspecialGranel(item.getPrecioEspecialGranel());

                          
                          //update
                          conceptoDaoImpl.update(conceptoExiste.createPk(), conceptoExiste);
                          
                   }

                }
            
            }catch(Exception ex){
                System.out.println("Problemas al guardar Concepto");
                logActualizacionInsertado += "No se pudo insertar / actualizar el regitro del Concepto.  Registro numero: "+ i +", Error: "+ex.getMessage()+". <br/>";            
            }
            
            //************FIN REGISTROS DE LOS CONCEPTOS 
            
            
            
            
        }//for
        
        
          return logActualizacionInsertado;
    }
    
    
}
