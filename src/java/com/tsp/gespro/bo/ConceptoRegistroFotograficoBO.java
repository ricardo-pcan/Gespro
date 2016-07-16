/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.tsp.gespro.bo;

import com.tsp.gespro.dto.ConceptoRegistroFotografico;
import com.tsp.gespro.exceptions.ConceptoRegistroFotograficoDaoException;
import com.tsp.gespro.jdbc.ConceptoRegistroFotograficoDaoImpl;
import java.sql.Connection;

/**
 *
 * @author Leonardo
 */
public class ConceptoRegistroFotograficoBO {
 private ConceptoRegistroFotografico conceptoRegistroFotografico = null;

    public ConceptoRegistroFotografico getConceptoRegistroFotografico() {
        return conceptoRegistroFotografico;
    }

    public void setConceptoRegistroFotografico(ConceptoRegistroFotografico conceptoRegistroFotografico) {
        this.conceptoRegistroFotografico = conceptoRegistroFotografico;
    }
    
    private Connection conn = null;

    public Connection getConn() {
        return conn;
    }

    public void setConn(Connection conn) {
        this.conn = conn;
    }
    
    public ConceptoRegistroFotograficoBO(Connection conn){
        this.conn = conn;
    }
    
    public ConceptoRegistroFotograficoBO(int idConceptoRegistroFotografico, Connection conn){        
        this.conn = conn;
        try{
            ConceptoRegistroFotograficoDaoImpl ConceptoRegistroFotograficoDaoImpl = new ConceptoRegistroFotograficoDaoImpl(this.conn);
            this.conceptoRegistroFotografico = ConceptoRegistroFotograficoDaoImpl.findByPrimaryKey(idConceptoRegistroFotografico);
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    
    public ConceptoRegistroFotografico findConceptoRegistroFotograficobyId(int idConceptoRegistroFotografico) throws Exception{
        ConceptoRegistroFotografico ConceptoRegistroFotografico = null;
        
        try{
            ConceptoRegistroFotograficoDaoImpl ConceptoRegistroFotograficoDaoImpl = new ConceptoRegistroFotograficoDaoImpl(this.conn);
            ConceptoRegistroFotografico = ConceptoRegistroFotograficoDaoImpl.findByPrimaryKey(idConceptoRegistroFotografico);
            if (ConceptoRegistroFotografico==null){
                throw new Exception("No se encontro ninguna ConceptoRegistroFotografico que corresponda con los parámetros específicados.");
            }
            if (ConceptoRegistroFotografico.getIdRegistro()<=0){
                throw new Exception("No se encontro ninguna ConceptoRegistroFotografico que corresponda con los parámetros específicados.");
            }
        }catch(Exception e){
            throw new Exception("Ocurrió un error inesperado mientras se intentaba recuperar la información de la ConceptoRegistroFotografico del usuario. Error: " + e.getMessage());
        }
        
        return ConceptoRegistroFotografico;
    }
    
       
    /**
     * Realiza una búsqueda por ID ConceptoRegistroFotografico en busca de
     * coincidencias
     * @param idConceptoRegistroFotografico ID Del Usuario para filtrar, -1 para mostrar todos los registros
     * @param idEmpresa ID de la Empresa a filtrar conceptoRegistroFotograficos, -1 para evitar filtro
     *  @param minLimit Limite inferior de la paginación (Desde) 0 en caso de no existir limite inferior
     * @param maxLimit Limite superior de la paginación (Hasta) 0 en caso de no existir limite superior
     * @param filtroBusqueda Cadena con un filtro de búsqueda personalizado
     * @return DTO ConceptoRegistroFotografico
     */
    public ConceptoRegistroFotografico[] findConceptoRegistroFotograficos(int idConceptoRegistroFotografico, int idEmpresa, int idCliente, int idConcepto, int idUsuario, int minLimit,int maxLimit, String filtroBusqueda) {
        ConceptoRegistroFotografico[] conceptoRegistroFotograficoDto = new ConceptoRegistroFotografico[0];
        ConceptoRegistroFotograficoDaoImpl conceptoRegistroFotograficoDao = new ConceptoRegistroFotograficoDaoImpl(this.conn);
        try {
            String sqlFiltro="";
            if (idConceptoRegistroFotografico>0){
                sqlFiltro ="ID_REGISTRO=" + idConceptoRegistroFotografico + " ";
            }else{
                sqlFiltro ="ID_REGISTRO>0 ";
            }
            if (idEmpresa>0){                
                sqlFiltro += " AND ID_EMPRESA IN (SELECT ID_EMPRESA FROM EMPRESA WHERE ID_EMPRESA_PADRE = " + idEmpresa + " OR ID_EMPRESA= " + idEmpresa + ")";
            }else{
                sqlFiltro +=" AND ID_EMPRESA>0";
            }
            if(idCliente > 0){
                sqlFiltro +=" AND ID_CLIENTE = " + idCliente + " ";
            }
            if(idConcepto > 0){
                 sqlFiltro +=" AND ID_CONCEPTO = " + idConcepto + " ";
            }
            if(idUsuario > 0){
                 sqlFiltro +=" AND ID_USUARIO = " + idUsuario + " ";
            }
            
            if (!filtroBusqueda.trim().equals("")){
                sqlFiltro += filtroBusqueda;
            }
            
            if (minLimit<0)
                minLimit=0;
            
            String sqlLimit="";
            if ((minLimit>0 && maxLimit>0) || (minLimit==0 && maxLimit>0))
                sqlLimit = " LIMIT " + minLimit + "," + maxLimit;
            
            conceptoRegistroFotograficoDto = conceptoRegistroFotograficoDao.findByDynamicWhere( 
                    sqlFiltro
                    + " ORDER BY FECHA_HORA DESC"
                    + sqlLimit
                    , new Object[0]);
            
        } catch (Exception ex) {
            System.out.println("Error de consulta a Base de Datos: " + ex.toString());
            ex.printStackTrace();
        }
        
        return conceptoRegistroFotograficoDto;
    }    
}
