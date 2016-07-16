/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.tsp.gespro.bo;

import com.tsp.gespro.dto.EstanteriaDescripcion;
import com.tsp.gespro.exceptions.EstanteriaDescripcionDaoException;
import com.tsp.gespro.jdbc.EstanteriaDescripcionDaoImpl;
import java.sql.Connection;

/**
 *
 * @author leonardo
 */
public class EstanteriaDescripcionBO {
    
    private EstanteriaDescripcion estanteriaDescripcion = null;

    public EstanteriaDescripcion getEstanteriaDescripcion() {
        return estanteriaDescripcion;
    }

    public void setEstanteriaDescripcion(EstanteriaDescripcion estanteriaDescripcion) {
        this.estanteriaDescripcion = estanteriaDescripcion;
    }
    
    private Connection conn = null;

    public Connection getConn() {
        return conn;
    }

    public void setConn(Connection conn) {
        this.conn = conn;
    }
    
    public EstanteriaDescripcionBO(Connection conn){
        this.conn = conn;
    }
    
    public EstanteriaDescripcionBO(int idEstanteriaDescripcion, Connection conn){        
        this.conn = conn;
        try{
            EstanteriaDescripcionDaoImpl EstanteriaDescripcionDaoImpl = new EstanteriaDescripcionDaoImpl(this.conn);
            this.estanteriaDescripcion = EstanteriaDescripcionDaoImpl.findByPrimaryKey(idEstanteriaDescripcion);
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    
    public EstanteriaDescripcion findEstanteriaDescripcionbyId(int idEstanteriaDescripcion) throws Exception{
        EstanteriaDescripcion EstanteriaDescripcion = null;
        
        try{
            EstanteriaDescripcionDaoImpl EstanteriaDescripcionDaoImpl = new EstanteriaDescripcionDaoImpl(this.conn);
            EstanteriaDescripcion = EstanteriaDescripcionDaoImpl.findByPrimaryKey(idEstanteriaDescripcion);
            if (EstanteriaDescripcion==null){
                throw new Exception("No se encontro ninguna EstanteriaDescripcion que corresponda con los parámetros específicados.");
            }
            if (EstanteriaDescripcion.getIdEstanteria()<=0){
                throw new Exception("No se encontro ninguna EstanteriaDescripcion que corresponda con los parámetros específicados.");
            }
        }catch(Exception e){
            throw new Exception("Ocurrió un error inesperado mientras se intentaba recuperar la información de la EstanteriaDescripcion del usuario. Error: " + e.getMessage());
        }
        
        return EstanteriaDescripcion;
    }
        
    /**
     * Realiza una búsqueda por ID EstanteriaDescripcion en busca de
     * coincidencias
     * @param idEstanteriaDescripcion ID Del Usuario para filtrar, -1 para mostrar todos los registros
     * @param idEmpresa ID de la Empresa a filtrar estanteriaDescripcions, -1 para evitar filtro
     *  @param minLimit Limite inferior de la paginación (Desde) 0 en caso de no existir limite inferior
     * @param maxLimit Limite superior de la paginación (Hasta) 0 en caso de no existir limite superior
     * @param filtroBusqueda Cadena con un filtro de búsqueda personalizado
     * @return DTO EstanteriaDescripcion
     */
    public EstanteriaDescripcion[] findEstanteriaDescripcions(int idEstanteriaDescripcion, int idEstanteria, int idCompetencia, int minLimit,int maxLimit, String filtroBusqueda) {
        EstanteriaDescripcion[] estanteriaDescripcionDto = new EstanteriaDescripcion[0];
        EstanteriaDescripcionDaoImpl estanteriaDescripcionDao = new EstanteriaDescripcionDaoImpl(this.conn);
        try {
            String sqlFiltro="";
            if (idEstanteriaDescripcion>0){
                sqlFiltro ="ID_DESCRIPCION = " + idEstanteriaDescripcion + " ";
            }else{
                sqlFiltro ="ID_DESCRIPCION>0 ";
            }
            if (idEstanteria > 0){                
                sqlFiltro += " AND ID_ESTANTERIA = "+idEstanteria;
            }
            
            if(idCompetencia > 0){
                sqlFiltro +=" AND ID_COMPETENCIA  = " + idCompetencia;
            }
                        
            if (!filtroBusqueda.trim().equals("")){
                sqlFiltro += filtroBusqueda;
            }
            
            if (minLimit<0)
                minLimit=0;
            
            String sqlLimit="";
            if ((minLimit>0 && maxLimit>0) || (minLimit==0 && maxLimit>0))
                sqlLimit = " LIMIT " + minLimit + "," + maxLimit;
            
            estanteriaDescripcionDto = estanteriaDescripcionDao.findByDynamicWhere( 
                    sqlFiltro
                    + " ORDER BY ID_DESCRIPCION ASC"
                    + sqlLimit
                    , new Object[0]);
            
        } catch (Exception ex) {
            System.out.println("Error de consulta a Base de Datos: " + ex.toString());
            ex.printStackTrace();
        }
        
        return estanteriaDescripcionDto;
    }
    
}


