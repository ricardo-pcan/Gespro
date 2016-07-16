/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.tsp.gespro.bo;

import com.tsp.gespro.dto.Competencia;
import com.tsp.gespro.exceptions.CompetenciaDaoException;
import com.tsp.gespro.jdbc.CompetenciaDaoImpl;
import java.sql.Connection;

/**
 *
 * @author Leonardo
 */
public class CompetenciaBO {
    private Competencia competencia = null;

    public Competencia getCompetencia() {
        return competencia;
    }

    public void setCompetencia(Competencia competencia) {
        this.competencia = competencia;
    }
    
    private Connection conn = null;

    public Connection getConn() {
        return conn;
    }

    public void setConn(Connection conn) {
        this.conn = conn;
    }
    
    public CompetenciaBO(Connection conn){
        this.conn = conn;
    }
       
    
    public CompetenciaBO(int idCompetencia, Connection conn){
        this.conn = conn;
        try{
            CompetenciaDaoImpl CompetenciaDaoImpl = new CompetenciaDaoImpl(this.conn);
            this.competencia = CompetenciaDaoImpl.findByPrimaryKey(idCompetencia);
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    
    public Competencia findMarcabyId(int idCompetencia) throws Exception{
        Competencia Competencia = null;
        
        try{
            CompetenciaDaoImpl CompetenciaDaoImpl = new CompetenciaDaoImpl(this.conn);
            Competencia = CompetenciaDaoImpl.findByPrimaryKey(idCompetencia);
            if (Competencia==null){
                throw new Exception("No se encontro ningun Competencia que corresponda con los parámetros específicados.");
            }
            if (Competencia.getIdCompetencia()<=0){
                throw new Exception("No se encontro ningun Competencia que corresponda con los parámetros específicados.");
            }
        }catch(Exception e){
            throw new Exception("Ocurrió un error inesperado mientras se intentaba recuperar la información del Competencia del usuario. Error: " + e.getMessage());
        }
        
        return Competencia;
    }
    
    public Competencia getCompetenciaGenericoByEmpresa(int idEmpresa) throws Exception{
        Competencia competencia = null;
        
        try{
            CompetenciaDaoImpl competenciaDaoImpl = new CompetenciaDaoImpl(this.conn);
            competencia = competenciaDaoImpl.findByDynamicWhere("ID_EMPRESA=" +idEmpresa + " AND ID_ESTATUS = 1", new Object[0])[0];
            if (competencia==null){
                throw new Exception("La empresa no tiene creada algun Competencia");
            }
        }catch(CompetenciaDaoException  e){
            e.printStackTrace();
            throw new Exception("La empresa no tiene creada algun Competencia");
        }
        
        return competencia;
    }
    
    /**
     * Realiza una búsqueda por ID Competencia en busca de
     * coincidencias
     * @param idMarca ID Del Usuario para filtrar, -1 para mostrar todos los registros
     * @param idEmpresa ID de la Empresa a filtrar marcas, -1 para evitar filtro
     *  @param minLimit Limite inferior de la paginación (Desde) 0 en caso de no existir limite inferior
     * @param maxLimit Limite superior de la paginación (Hasta) 0 en caso de no existir limite superior
     * @param filtroBusqueda Cadena con un filtro de búsqueda personalizado
     * @return DTO Marca
     */
    public Competencia[] findCompetencias(int idCompetencia, int idEmpresa, int minLimit,int maxLimit, String filtroBusqueda) {
        Competencia[] competenciaDto = new Competencia[0];
        CompetenciaDaoImpl competenciaDao = new CompetenciaDaoImpl(this.conn);
        try {
            String sqlFiltro="";
            if (idCompetencia>0){
                sqlFiltro ="ID_COMPETENCIA=" + idCompetencia + " AND ";
            }else{
                sqlFiltro ="ID_COMPETENCIA>0 AND";
            }
            if (idEmpresa>0){                
                sqlFiltro += " ID_EMPRESA IN (SELECT ID_EMPRESA FROM EMPRESA WHERE ID_EMPRESA_PADRE = " + idEmpresa + " OR ID_EMPRESA= " + idEmpresa + ")";
            }else{
                sqlFiltro +=" ID_EMPRESA>0";
            }
            
            if (!filtroBusqueda.trim().equals("")){
                sqlFiltro += filtroBusqueda;
            }
            
            if (minLimit<0)
                minLimit=0;
            
            String sqlLimit="";
            if ((minLimit>0 && maxLimit>0) || (minLimit==0 && maxLimit>0))
                sqlLimit = " LIMIT " + minLimit + "," + maxLimit;
            
            competenciaDto = competenciaDao.findByDynamicWhere( 
                    sqlFiltro
                    + " ORDER BY NOMBRE ASC"
                    + sqlLimit
                    , new Object[0]);
            
        } catch (Exception ex) {
            System.out.println("Error de consulta a Base de Datos: " + ex.toString());
            ex.printStackTrace();
        }
        
        return competenciaDto;
    }
    
    /**
     * Realiza una búsqueda por ID Competencia en busca de
     * coincidencias
     * @param idCompetencia ID Del Usuario para filtrar, -1 para mostrar todos los registros
     * @param idEmpresa ID de la Empresa a filtrar competencias, -1 para evitar filtro     
     * @return String de cada uno de los competencias
     */
    
        public String getCompetenciasByIdHTMLCombo(int idEmpresa, int idSeleccionado){
        String strHTMLCombo ="";

        try{
            Competencia[] competenciasDto = findCompetencias(-1, idEmpresa, 0, 0, " AND ID_ESTATUS!=2 ");
            
            for (Competencia competencia:competenciasDto){
                try{
                    //Categoria datosCategoria = new CategoriaDaoImpl(this.conn).findByPrimaryKey(categoria.getIdCategoria());
                    String selectedStr="";

                    if (idSeleccionado==competencia.getIdCompetencia())
                        selectedStr = " selected ";

                    strHTMLCombo += "<option value='"+competencia.getIdCompetencia()+"' "
                            + selectedStr
                            + "title='"+competencia.getDescripcion()+"'>"
                            + competencia.getNombre()
                            +"</option>";
                }catch(Exception ex){
                    ex.printStackTrace();
                }
            }
        }catch(Exception e){
            e.printStackTrace();
        }

        return strHTMLCombo;
    }
    
}
    

