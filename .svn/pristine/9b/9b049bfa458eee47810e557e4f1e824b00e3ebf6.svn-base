/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.tsp.gespro.bo;

import com.tsp.gespro.dto.EstadoEmpleado;
import com.tsp.gespro.dto.EstadoEmpleado;
import com.tsp.gespro.exceptions.EstadoEmpleadoDaoException;
import com.tsp.gespro.jdbc.EstadoEmpleadoDaoImpl;
import com.tsp.gespro.jdbc.EstadoEmpleadoDaoImpl;
import java.sql.Connection;

/**
 *
 * @author leonardo Montes de Oca
 */
public class EstadoEmpleadoBO {
    private EstadoEmpleado EstadoEmpleado  = null;

    public EstadoEmpleado getEstado() {
        return EstadoEmpleado;
    }

    public void setEstado(EstadoEmpleado estado) {
        this.EstadoEmpleado = estado;
    }
    
    
    private Connection conn = null;

    public Connection getConn() {
        return conn;
    }

    public void setConn(Connection conn) {
        this.conn = conn;
    }
    
    public EstadoEmpleadoBO(Connection conn){
        this.conn = conn;
    }
    
    public EstadoEmpleadoBO(int idEstado, Connection conn){        
        this.conn = conn;
        try{
            EstadoEmpleadoDaoImpl EstadoDaoImpl = new EstadoEmpleadoDaoImpl(this.conn);
            this.EstadoEmpleado = EstadoDaoImpl.findByPrimaryKey(idEstado);
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    
    public EstadoEmpleado findEstadobyId(int idEstado) throws Exception{
        EstadoEmpleado EstadoEmpleado = null;
        
        try{
            EstadoEmpleadoDaoImpl EstadoDaoImpl = new EstadoEmpleadoDaoImpl(this.conn);
            EstadoEmpleado = EstadoDaoImpl.findByPrimaryKey(idEstado);
            if (EstadoEmpleado==null){
                throw new Exception("No se encontro ningun Estado que corresponda con los parámetros específicados.");
            }
            if (EstadoEmpleado.getIdEstado()<=0){
                throw new Exception("No se encontro ningun Estado que corresponda con los parámetros específicados.");
            }
        }catch(Exception e){
            throw new Exception("Ocurrió un error inesperado mientras se intentaba recuperar la información de los Estados.  Error: " + e.getMessage());
        }
        
        return EstadoEmpleado;
    }
    
    public EstadoEmpleado getEstadoGenericoByEstado(long idEstado) throws Exception{
        EstadoEmpleado EstadoEmpleado = null;
        
        try{
            EstadoEmpleadoDaoImpl EstadoEmpleadoDaoImpl = new EstadoEmpleadoDaoImpl(this.conn);
            EstadoEmpleado = EstadoEmpleadoDaoImpl.findByDynamicWhere("ID_EMPRESA=" +idEstado + " AND GENERICO = 1", new Object[0])[0];
            if (EstadoEmpleado==null){
                throw new Exception("La empresa no tiene creado un Estado Génerico");
            }
        }catch(EstadoEmpleadoDaoException e){
            e.printStackTrace();
            throw new Exception("La empresa no tiene creado un Estado Génerico");
        }
        
        return EstadoEmpleado;
    }
    
    /**
     * Realiza una búsqueda por ID Estado en busca de
     * coincidencias
     * @param idEstado ID Del Estado para filtrar, -1 para mostrar todos los registros
     * @param idEstado ID de la Estado a filtrar Estado, -1 para evitar filtro
     *  @param minLimit Limite inferior de la paginación (Desde) 0 en caso de no existir limite inferior
     * @param maxLimit Limite superior de la paginación (Hasta) 0 en caso de no existir limite superior
     * @param filtroBusqueda Cadena con un filtro de búsqueda personalizado
     * @return DTO Estado
     */
    public EstadoEmpleado[] findEstados(long idEstado, long idEmplesa, int minLimit,int maxLimit, String filtroBusqueda) {
        EstadoEmpleado[] estadoDto = new EstadoEmpleado[0];
        EstadoEmpleadoDaoImpl estadoDao = new EstadoEmpleadoDaoImpl(this.conn);
        try {
            String sqlFiltro="";
            if (idEstado>0){
                sqlFiltro ="ID_ESTADO=" + idEstado + " ";
            }else{
                sqlFiltro ="ID_ESTADO>0 ";
            }
            
            if (!filtroBusqueda.trim().equals("")){
                sqlFiltro += filtroBusqueda;
            }
            
            if (minLimit<0)
                minLimit=0;
            
            String sqlLimit="";
            if ((minLimit>0 && maxLimit>0) || (minLimit==0 && maxLimit>0))
                sqlLimit = " LIMIT " + minLimit + "," + maxLimit;
            
            estadoDto = estadoDao.findByDynamicWhere( 
                    sqlFiltro
                    + " ORDER BY NOMBRE ASC"
                    + sqlLimit
                    , new Object[0]);
            
        } catch (Exception ex) {
            System.out.println("Error de consulta a Base de Datos: " + ex.toString());
            ex.printStackTrace();
        }
        
        return estadoDto;
    }
    
    public String getEstadosByIdHTMLCombo(long idEmpresa, long idSeleccionado){
        String strHTMLCombo ="";

        try{
            
            String filtro = "";
            if(idSeleccionado>0){
                filtro += "AND ID_ESTADO = " + idSeleccionado +" " ;
            }
            
            EstadoEmpleado[] estadosDto = findEstados(-1, idEmpresa, 0, 0, filtro );
            
            for (EstadoEmpleado itemEstado:estadosDto){
                //if(itemEstado.getIdEstado() == 1 || itemEstado.getIdEstado() == 2 || itemEstado.getIdEstado() == 3 || itemEstado.getIdEstado() == 7 || itemEstado.getIdEstado() == 9){
                try{
                    String selectedStr="";

                    if (idSeleccionado==itemEstado.getIdEstado())
                        selectedStr = " selected ";

                    strHTMLCombo += "<option value='"+itemEstado.getIdEstado()+"' "
                            + selectedStr
                            + "title='"+itemEstado.getDescripcion()+"'>"
                            + itemEstado.getNombre()
                            +"</option>";
                }catch(Exception ex){
                    ex.printStackTrace();
                }
                //}
            }
        }catch(Exception e){
            e.printStackTrace();
        }

        return strHTMLCombo;
    }
}
