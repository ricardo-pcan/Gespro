/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.tsp.gespro.bo;

import com.tsp.gespro.dto.RelacionConceptoEmbalaje;
import com.tsp.gespro.exceptions.RelacionConceptoEmbalajeDaoException;
import com.tsp.gespro.jdbc.RelacionConceptoEmbalajeDaoImpl;
import java.sql.Connection;

/**
 *
 * @author Leonardo
 */
public class RelacionConceptoEmbalajeBO {
    private RelacionConceptoEmbalaje relacionConceptoEmbalaje = null;

    public RelacionConceptoEmbalaje getRelacionConceptoEmbalaje() {
        return relacionConceptoEmbalaje;
    }

    public void setRelacionConceptoEmbalaje(RelacionConceptoEmbalaje relacionConceptoEmbalaje) {
        this.relacionConceptoEmbalaje = relacionConceptoEmbalaje;
    }
    
    private Connection conn = null;

    public Connection getConn() {
        return conn;
    }

    public void setConn(Connection conn) {
        this.conn = conn;
    }
    
    public RelacionConceptoEmbalajeBO(Connection conn){
        this.conn = conn;
    }
       
    
    public RelacionConceptoEmbalajeBO(int idRelacionConceptoEmbalaje, Connection conn){
        this.conn = conn;
        try{
            RelacionConceptoEmbalajeDaoImpl RelacionConceptoEmbalajeDaoImpl = new RelacionConceptoEmbalajeDaoImpl(this.conn);
            this.relacionConceptoEmbalaje = RelacionConceptoEmbalajeDaoImpl.findByPrimaryKey(idRelacionConceptoEmbalaje);
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    
    public RelacionConceptoEmbalaje findRelacionConceptoEmbalajebyId(int idRelacionConceptoEmbalaje) throws Exception{
        RelacionConceptoEmbalaje RelacionConceptoEmbalaje = null;
        
        try{
            RelacionConceptoEmbalajeDaoImpl RelacionConceptoEmbalajeDaoImpl = new RelacionConceptoEmbalajeDaoImpl(this.conn);
            RelacionConceptoEmbalaje = RelacionConceptoEmbalajeDaoImpl.findByPrimaryKey(idRelacionConceptoEmbalaje);
            if (RelacionConceptoEmbalaje==null){
                throw new Exception("No se encontro ningun RelacionConceptoEmbalaje que corresponda con los parámetros específicados.");
            }
            if (RelacionConceptoEmbalaje.getIdRelacion()<=0){
                throw new Exception("No se encontro ningun RelacionConceptoEmbalaje que corresponda con los parámetros específicados.");
            }
        }catch(Exception e){
            throw new Exception("Ocurrió un error inesperado mientras se intentaba recuperar la información del RelacionConceptoEmbalaje del usuario. Error: " + e.getMessage());
        }
        
        return RelacionConceptoEmbalaje;
    }
   
    /**
     * Realiza una búsqueda por ID RelacionConceptoEmbalaje en busca de
     * coincidencias
     * @param idMarca ID Del Usuario para filtrar, -1 para mostrar todos los registros
     * @param idEmpresa ID de la Empresa a filtrar marcas, -1 para evitar filtro
     *  @param minLimit Limite inferior de la paginación (Desde) 0 en caso de no existir limite inferior
     * @param maxLimit Limite superior de la paginación (Hasta) 0 en caso de no existir limite superior
     * @param filtroBusqueda Cadena con un filtro de búsqueda personalizado
     * @return DTO Marca
     */
    public RelacionConceptoEmbalaje[] findRelacionConceptoEmbalajes(int idRelacionConceptoEmbalaje, int idConcepto, int idEmbalaje,  int minLimit,int maxLimit, String filtroBusqueda) {
        RelacionConceptoEmbalaje[] relacionConceptoEmbalajeDto = new RelacionConceptoEmbalaje[0];
        RelacionConceptoEmbalajeDaoImpl relacionConceptoEmbalajeDao = new RelacionConceptoEmbalajeDaoImpl(this.conn);
        try {
            String sqlFiltro="";
            if (idRelacionConceptoEmbalaje>0){
                sqlFiltro ="ID_RELACION = " + idRelacionConceptoEmbalaje + " ";
            }else{
                sqlFiltro ="ID_RELACION > 0 ";
            }
            //if (idConcepto>0){                
                sqlFiltro += " AND  ID_CONCEPTO = " + idConcepto + " ";
            //}else{
                //sqlFiltro +=" AND  ID_CONCEPTO > 0 ";
            //}
            if (idEmbalaje>0){                
                sqlFiltro += " AND  ID_EMBALAJE = " + idEmbalaje + " ";
            }else{
                sqlFiltro +=" AND  ID_EMBALAJE > 0 ";
            }
            
            if (!filtroBusqueda.trim().equals("")){
                sqlFiltro += filtroBusqueda;
            }
            
            if (minLimit<0)
                minLimit=0;
            
            String sqlLimit="";
            if ((minLimit>0 && maxLimit>0) || (minLimit==0 && maxLimit>0))
                sqlLimit = " LIMIT " + minLimit + "," + maxLimit;
            
            relacionConceptoEmbalajeDto = relacionConceptoEmbalajeDao.findByDynamicWhere( 
                    sqlFiltro
                    + " ORDER BY ID_RELACION ASC"
                    + sqlLimit
                    , new Object[0]);
            
        } catch (Exception ex) {
            System.out.println("Error de consulta a Base de Datos: " + ex.toString());
            ex.printStackTrace();
        }
        
        return relacionConceptoEmbalajeDto;
    }
        
}
    

