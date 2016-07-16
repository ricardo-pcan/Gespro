/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.tsp.gespro.bo;

import com.tsp.gespro.dto.DetalleHorario;
import com.tsp.gespro.jdbc.DetalleHorarioDaoImpl;
import java.sql.Connection;

/**
 *
 * @author HpPyme
 */
public class DetalleHorarioBO {
    
    private Connection conn = null;
    private DetalleHorario detalleHorario = null;

    public Connection getConn() {
        return conn;
    }

    public void setConn(Connection conn) {
        this.conn = conn;
    }

    public DetalleHorario getDetalleHorario() {
        return detalleHorario;
    }

    public void setDetalleHorario(DetalleHorario detalleHorario) {
        this.detalleHorario = detalleHorario;
    }
    
    

    public DetalleHorarioBO(Connection conn) {
        this.conn = conn;
    }
    
    
    public DetalleHorarioBO(int idDetalleHorario, Connection conn){        
        this.conn = conn;
        try{
            DetalleHorarioDaoImpl DetalleHorarioDao = new DetalleHorarioDaoImpl(this.conn);
            this.detalleHorario = DetalleHorarioDao.findByPrimaryKey(idDetalleHorario);
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    
   public DetalleHorario[] findDetalleHorariobyId(int idHorario) throws Exception{
        DetalleHorario[] detalleHorario = new DetalleHorario[0];
        
        try{
            DetalleHorarioDaoImpl DetalleHorarioDaoImpl = new DetalleHorarioDaoImpl(this.conn);
            detalleHorario = DetalleHorarioDaoImpl.findWhereIdHorarioEquals(idHorario);
            if (detalleHorario==null){
                throw new Exception("No se encontro ninguna Detalle de Horario que corresponda con los parámetros específicados.");
            }
            if (detalleHorario.length<=0){
                throw new Exception("No se encontro ninguna Detalle de Horario que corresponda con los parámetros específicados.");
            }
        }catch(Exception e){
            throw new Exception("Ocurrió un error inesperado mientras se intentaba recuperar la información de la Marca del usuario. Error: " + e.getMessage());
        }
        
        return detalleHorario;
    }
    
    
    /**
     * Realiza una búsqueda por ID Horario en busca de
     * coincidencias
     * @param idHorario ID Del horario para filtrar, -1 para mostrar todos los registros    
     * @param minLimit Limite inferior de la paginación (Desde) 0 en caso de no existir limite inferior
     * @param maxLimit Limite superior de la paginación (Hasta) 0 en caso de no existir limite superior
     * @param filtroBusqueda Cadena con un filtro de búsqueda personalizado
     * @return DTO Marca
     */
    public DetalleHorario[] findDetalleHorario(int idHorario, int minLimit,int maxLimit, String filtroBusqueda) {
        DetalleHorario[] detalleHorario = new DetalleHorario[0];
        DetalleHorarioDaoImpl detalleHorarioDao = new DetalleHorarioDaoImpl(this.conn);
        try {
            String sqlFiltro="";
            if (idHorario>0){
                sqlFiltro ="ID_HORARIO=" + idHorario + "  ";
            }else{
                sqlFiltro ="ID_HORARIO>0 ";
            }            
            
            if (!filtroBusqueda.trim().equals("")){
                sqlFiltro += filtroBusqueda;
            }
            
            if (minLimit<0)
                minLimit=0;
            
            String sqlLimit="";
            if ((minLimit>0 && maxLimit>0) || (minLimit==0 && maxLimit>0))
                sqlLimit = " LIMIT " + minLimit + "," + maxLimit;
            
            detalleHorario = detalleHorarioDao.findByDynamicWhere( 
                    sqlFiltro
                    + " ORDER BY ID_DETALLE_HORARIO ASC"
                    + sqlLimit
                    , new Object[0]);
            
        } catch (Exception ex) {
            System.out.println("Error de consulta a Base de Datos: " + ex.toString());
            ex.printStackTrace();
        }
        
        return detalleHorario;
    }
    
    
    
}
