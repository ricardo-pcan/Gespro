/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.tsp.gespro.bo;

import com.tsp.gespro.dto.Prospecto;
import com.tsp.gespro.jdbc.ProspectoDaoImpl;
import java.sql.Connection;

/**
 *
 * @author ISCesarMartinez
 */
public class ProspectoBO {
    private Prospecto prospecto  = null;

    public Prospecto getProspecto() {
        return prospecto;
    }

    public void setProspecto(Prospecto prospecto) {
        this.prospecto = prospecto;
    }
    
    private Connection conn = null;

    public Connection getConn() {
        return conn;
    }

    public void setConn(Connection conn) {
        this.conn = conn;
    }
    
    public ProspectoBO(Connection conn){
        this.conn = conn;
    }
    
    public ProspectoBO(int idProspecto, Connection conn){        
        this.conn = conn;
        try{
            ProspectoDaoImpl ProspectoDaoImpl = new ProspectoDaoImpl(this.conn);
            this.prospecto = ProspectoDaoImpl.findByPrimaryKey(idProspecto);
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    public Prospecto findProspectobyId(int idProspecto) throws Exception{
        Prospecto prospecto = null;
        
        try{
            ProspectoDaoImpl prospectoDaoImpl = new ProspectoDaoImpl(this.conn);
            prospecto = prospectoDaoImpl.findByPrimaryKey(idProspecto);
            if (prospecto==null){
                throw new Exception("No se encontro ningun prospecto que corresponda según los parámetros específicados.");
            }
            if (prospecto.getIdProspecto()<=0){
                throw new Exception("No se encontro ningun prospecto que corresponda según los parámetros específicados.");
            }
        }catch(Exception e){
            throw new Exception("Ocurrió un error inesperado mientras se intentaba recuperar la información de Prospecto del usuario. Error: " + e.getMessage());
        }
        
        return prospecto;
    }
    
    
    /**
     * Realiza una búsqueda por ID Prospecto en busca de
     * coincidencias
     * @param idProspecto ID Del Prospecto para filtrar, -1 para mostrar todos los registros
     * @param idEmpresa ID de la Empresa a filtrar prospecto, -1 para evitar filtro
     *  @param minLimit Limite inferior de la paginación (Desde) 0 en caso de no existir limite inferior
     * @param maxLimit Limite superior de la paginación (Hasta) 0 en caso de no existir limite superior
     * @param filtroBusqueda Cadena con un filtro de búsqueda personalizado
     * @return DTO Prospecto
     */
    public Prospecto[] findProspecto(int idProspecto, int idEmpresa, int minLimit,int maxLimit, String filtroBusqueda) {
        Prospecto[] prospectoDto = new Prospecto[0];
        ProspectoDaoImpl prospectoDao = new ProspectoDaoImpl(this.conn);
        try {
            String sqlFiltro="";
            if (idProspecto>0){
                sqlFiltro ="ID_PROSPECTO=" + idProspecto + " AND ";
            }else{
                sqlFiltro ="ID_PROSPECTO>0 AND";
            }
            if (idEmpresa>0){
                //sqlFiltro +=" ID_EMPRESA=" + idEmpresa;
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
            
            prospectoDto = prospectoDao.findByDynamicWhere( 
                    sqlFiltro
                    + " ORDER BY RAZON_SOCIAL ASC"
                    + sqlLimit
                    , new Object[0]);
            
        } catch (Exception ex) {
            System.out.println("Error de consulta a Base de Datos: " + ex.toString());
            ex.printStackTrace();
        }
        
        return prospectoDto;
    }
    
    public String getProspectosByIdHTMLCombo(int idEmpresa, int idSeleccionado){
        String strHTMLCombo ="";

        try{
            Prospecto[] clientesDto = findProspecto(-1, idEmpresa, 0, 0, " AND ID_ESTATUS!=2 ");
            
            for (Prospecto itemProspecto:clientesDto){
                try{
                    String selectedStr="";

                    if (idSeleccionado==itemProspecto.getIdProspecto())
                        selectedStr = " selected ";

                    strHTMLCombo += "<option value='"+itemProspecto.getIdProspecto()+"' "
                            + selectedStr
                            + "title='"+itemProspecto.getRazonSocial()+"'>"
                            + itemProspecto.getRazonSocial()
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
