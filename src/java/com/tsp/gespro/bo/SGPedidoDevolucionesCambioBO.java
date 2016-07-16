/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.tsp.gespro.bo;

import com.tsp.gespro.dto.SgfensPedidoDevolucionCambio;
import com.tsp.gespro.jdbc.SgfensPedidoDevolucionCambioDaoImpl;
import java.sql.Connection;

/**
 *
 * @author MOVILPYME
 */
public class SGPedidoDevolucionesCambioBO {
    private SgfensPedidoDevolucionCambio devolucion = null;

    public static int ID_CLASIFICACION_NO_SOLICITADO_CLIENTE = 1;
    public static int ID_CLASIFICACION_NO_VENDIDO = 2;
    public static int ID_CLASIFICACION_OTRO = 3;
    public static int ID_CLASIFICACION_CADUCO = 4;
    public static int ID_CLASIFICACION_MAL_ESTADO = 5;
    public static int ID_CLASIFICACION_SOLICITADO_CLIENTE = 6;

    public static int ID_TIPO_DEVOLUCION = 1;
    public static int ID_TIPO_CAMBIO = 2;
        
    /**
     * @return the devolucion
     */
    public SgfensPedidoDevolucionCambio getSgfensPedidoDevolucionCambio() {
        return devolucion;
    }
    
    private Connection conn = null;

    public Connection getConn() {
        return conn;
    }

    public void setConn(Connection conn) {
        this.conn = conn;
    }
    
    public SGPedidoDevolucionesCambioBO(Connection conn){
        this.conn = conn;
    }
    
    public SGPedidoDevolucionesCambioBO(int idSgfensPedidoDevolucionCambio, Connection conn){        
        this.conn = conn;
        try{
            SgfensPedidoDevolucionCambioDaoImpl SgfensProspectoDaoImpl = new SgfensPedidoDevolucionCambioDaoImpl(this.conn);
            this.devolucion = SgfensProspectoDaoImpl.findByPrimaryKey(idSgfensPedidoDevolucionCambio);
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    
    public SgfensPedidoDevolucionCambio findProspectobyId(int idPedidoDevolucionCambio) throws Exception{
        SgfensPedidoDevolucionCambio devolucion = null;
        
        try{
            SgfensPedidoDevolucionCambioDaoImpl pedidoDevolucionCambioDao = new SgfensPedidoDevolucionCambioDaoImpl(this.conn);
            devolucion = pedidoDevolucionCambioDao.findByPrimaryKey(idPedidoDevolucionCambio);
            if(devolucion == null){
                throw new Exception("No se encontro ninguna devolución o cambio que corresponda según los parámetros específicados.");
            }
            if(devolucion.getIdPedidoDevolCambio() <= 0){
                throw new Exception("No se encontro ninguna devolución o cambio que corresponda según los parámetros específicados.");
            }
        }catch(Exception e){
            throw new Exception("Ocurrió un error inesperado mientras se intentaba recuperar la información de Prospecto del usuario. Error: " + e.getMessage());
        }
        
        return devolucion;
    }
    
    /*
    Metodo para obetener un array de cambio/devolucion de un pedido
    */
    
    public SgfensPedidoDevolucionCambio[] findCambioDevByIdPedido(int idPedido, int tipoMovimiento, Connection conn) throws Exception{
        SgfensPedidoDevolucionCambio[] devoluciones = null;
        
        try{
            SgfensPedidoDevolucionCambioDaoImpl pedidoDevolucionCambioDao = new SgfensPedidoDevolucionCambioDaoImpl(this.conn);
            devoluciones = pedidoDevolucionCambioDao.findByDynamicWhere("ID_PEDIDO = "+idPedido+ " AND ID_TIPO =" + tipoMovimiento,null);
            if(devoluciones == null){
                throw new Exception("No se encontro ninguna devolución o cambio que corresponda según los parámetros específicados.");
            }           
        }catch(Exception e){
            throw new Exception("Ocurrió un error inesperado mientras se intentaba recuperar la información de Prospecto del usuario. Error: " + e.getMessage());
        }
        
        return devoluciones;
    }
    
    
    /*
    Metodo para obtener un array de cambio/devolucion de un pedido
    */
    
    public SgfensPedidoDevolucionCambio[] findCambioDevByIdPedido(int idPedido , Connection conn) throws Exception{
        SgfensPedidoDevolucionCambio[] devoluciones = null;
        
        try{
            SgfensPedidoDevolucionCambioDaoImpl pedidoDevolucionCambioDao = new SgfensPedidoDevolucionCambioDaoImpl(this.conn);
            devoluciones = pedidoDevolucionCambioDao.findByDynamicWhere("ID_PEDIDO = "+idPedido + " AND ID_ESTATUS = 1 " ,null);
            if(devoluciones == null){
                throw new Exception("No se encontro ninguna devolución o cambio que corresponda según los parámetros específicados.");
            }           
        }catch(Exception e){
            throw new Exception("Ocurrió un error inesperado mientras se intentaba recuperar la información de Prospecto del usuario. Error: " + e.getMessage());
        }
        
        return devoluciones;
    }
    
    
    
     /*
    Metodo para obtener un array de cambio/devolucion de un pedido
    */
    
    public SgfensPedidoDevolucionCambio[] findCambioDevByEmpleado(Connection conn, int idEmpleado , String filtroBusqueda ) throws Exception{
        SgfensPedidoDevolucionCambio[] devoluciones = null;
        
        try{
            SgfensPedidoDevolucionCambioDaoImpl pedidoDevolucionCambioDao = new SgfensPedidoDevolucionCambioDaoImpl(this.conn);
            devoluciones = pedidoDevolucionCambioDao.findByDynamicWhere("ID_EMPLEADO = "+idEmpleado + "  " + filtroBusqueda ,null);
            if(devoluciones == null){
                throw new Exception("No se encontro ninguna devolución o cambio que corresponda según los parámetros específicados.");
            }           
        }catch(Exception e){
            throw new Exception("Ocurrió un error inesperado mientras se intentaba recuperar la información de Prospecto del usuario. Error: " + e.getMessage());
        }
        
        return devoluciones;
    }
    
    
}
