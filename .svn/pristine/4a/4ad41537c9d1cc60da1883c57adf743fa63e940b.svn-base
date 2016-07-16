/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.tsp.gespro.bo;

import com.tsp.gespro.dto.HorarioUsuario;
import com.tsp.gespro.jdbc.HorarioUsuarioDaoImpl;
import java.sql.Connection;

/**
 *
 * @author HpPyme
 */
public class HorariosBO {
    
    
    
     private Connection conn = null;
     private HorarioUsuario horarioUsuario = null;

    public Connection getConn() {
        return conn;
    }

    public void setConn(Connection conn) {
        this.conn = conn;
    }

    public HorarioUsuario getHorarioUsuario() {
        return horarioUsuario;
    }

    public void setHorarioUsuario(HorarioUsuario horarioUsuario) {
        this.horarioUsuario = horarioUsuario;
    }

    public HorariosBO(Connection conn) {
         this.conn = conn;
    }
     
    public HorariosBO(int idHorario, Connection conn){        
        this.conn = conn;
        
        try{
            HorarioUsuarioDaoImpl horarioUsuarioDaoImpl = new HorarioUsuarioDaoImpl(this.conn);
            this.horarioUsuario = horarioUsuarioDaoImpl.findByPrimaryKey(idHorario);
        }catch(Exception e){
            e.printStackTrace();
        }
    } 
    
    
    
    /**
     * Realiza una búsqueda por ID Horario en busca de
     * coincidencias
     * @param idHorario ID Del horario para filtrar, -1 para mostrar todos los registros
     * @param idEmpresa ID de la Empresa a filtrar horarios, -1 para evitar filtro     
     * @return String de cada una de las marcas
     */
    
        public String getHorariosByIdHTMLCombo(int idEmpresa, int idSeleccionado){
        String strHTMLCombo ="";

        try{
            HorarioUsuario[] horariosDto = findHorarios(-1, idEmpresa, 0, 0, " AND ID_ESTATUS!=2 ");
            
            for (HorarioUsuario item:horariosDto){
                try{                   
                    String selectedStr="";

                    if (idSeleccionado==item.getIdHorario())
                        selectedStr = " selected ";

                    strHTMLCombo += "<option value='"+item.getIdHorario()+"' "
                            + selectedStr
                            + "title='"+item.getNombreHorario()+"'>"
                            + item.getNombreHorario()
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
    
    
    
    /**
     * Realiza una búsqueda por ID Horario en busca de
     * coincidencias
     * @param idHorario ID Del Usuario para filtrar, -1 para mostrar todos los registros
     * @param idEmpresa ID de la Empresa a filtrar marcas, -1 para evitar filtro
     *  @param minLimit Limite inferior de la paginación (Desde) 0 en caso de no existir limite inferior
     * @param maxLimit Limite superior de la paginación (Hasta) 0 en caso de no existir limite superior
     * @param filtroBusqueda Cadena con un filtro de búsqueda personalizado
     * @return DTO Marca
     */
    public HorarioUsuario[] findHorarios(int idHorario, int idEmpresa, int minLimit,int maxLimit, String filtroBusqueda) {
        HorarioUsuario[] horariosDto = new HorarioUsuario[0];
        HorarioUsuarioDaoImpl horarioDao = new HorarioUsuarioDaoImpl(this.conn);
        try {
            String sqlFiltro="";
            if (idHorario>0){
                sqlFiltro ="ID_HORARIO=" + idHorario + " AND ";
            }else{
                sqlFiltro ="ID_HORARIO>0 AND";
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
            
            horariosDto = horarioDao.findByDynamicWhere( 
                    sqlFiltro                   
                    + " ORDER BY NOMBRE_HORARIO ASC "
                    + sqlLimit
                    , new Object[0]);
            
        } catch (Exception ex) {
            System.out.println("Error de consulta a Base de Datos: " + ex.toString());
            ex.printStackTrace();
        }
        
        return horariosDto;
    }
        
    
    
}