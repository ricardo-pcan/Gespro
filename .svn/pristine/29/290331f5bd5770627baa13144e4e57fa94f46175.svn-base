/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.tsp.gespro.bo;

import com.tsp.gespro.dto.Empresa;
import com.tsp.gespro.dto.EmpresaPermisoAplicacion;
import com.tsp.gespro.dto.Ubicacion;
import com.tsp.gespro.exceptions.EmpresaDaoException;
import com.tsp.gespro.jdbc.EmpresaDaoImpl;
import com.tsp.gespro.jdbc.EmpresaPermisoAplicacionDaoImpl;
import com.tsp.gespro.util.Encrypter;
import java.io.IOException;
import java.sql.Connection;

/**
 *
 * @author ISCesarMartinez
 */
public class EmpresaBO {
    private Empresa empresa = null;
    private Ubicacion ubicacion = null;

    public Empresa getEmpresa() {
        return empresa;
    }

    public void setEmpresa(Empresa empresa) {
        this.empresa = empresa;
    }

    public Ubicacion getUbicacion() {
        return ubicacion;
    }

    public void setUbicacion(Ubicacion ubicacion) {
        this.ubicacion = ubicacion;
    }
    
    private Connection conn = null;

    public Connection getConn() {
        return conn;
    }

    public void setConn(Connection conn) {
        this.conn = conn;
    }
    
    public EmpresaBO(int idEmpresa, Connection conn){
        this.conn = conn;
        try{
            EmpresaDaoImpl EmpresaDaoImpl = new EmpresaDaoImpl(this.conn);
            this.empresa = EmpresaDaoImpl.findByPrimaryKey(idEmpresa);
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    
    public EmpresaBO(Connection conn){
        this.conn = conn;
    }
    
    public Empresa findEmpresabyId(long idEmpresa) throws Exception{
        Empresa empresa = null;
        
        try{
            EmpresaDaoImpl empresaDaoImpl = new EmpresaDaoImpl(this.conn);
            empresa = empresaDaoImpl.findByPrimaryKey((int)idEmpresa);
            if (empresa==null){
                throw new Exception("No se encontro ninguna empresa que corresponda al usuario según los parámetros específicados.");
            }
            if (empresa.getIdEmpresa()<=0){
                throw new Exception("No se encontro ninguna empresa que corresponda al usuario según los parámetros específicados.");
            }
        }catch(Exception e){
            throw new Exception("Ocurrió un error inesperado mientras se intentaba recuperar la información de Empresa del usuario. Error: " + e.getMessage());
        }
        
        return empresa;
    }
    
     public Empresa getEmpresaGenericoByEmpresa(int idEmpresa) throws Exception{
        Empresa empresa = null;
        
        try{
            EmpresaDaoImpl empresaDaoImpl = new EmpresaDaoImpl(this.conn);
            empresa = empresaDaoImpl.findByDynamicWhere("ID_EMPRESA=" +idEmpresa + " AND ID_ESTATUS = 1", new Object[0])[0];
            if (empresa==null){
                throw new Exception("La empresa no tiene creada alguna Sucursal");
            }
        }catch(EmpresaDaoException  e){
            e.printStackTrace();
            throw new Exception("La empresa no tiene creada alguna Sucursal");
        }
        
        return empresa;
    }
     
     /**
     * Realiza una búsqueda por ID Empresa en busca de
     * coincidencias
     * @param idEmpresaSucursal ID Del Usuario para filtrar, -1 para mostrar todos los registros
     * @param idEmpresa ID de la Empresa a filtrar marcas, -1 para evitar filtro
     *  @param minLimit Limite inferior de la paginación (Desde) 0 en caso de no existir limite inferior
     * @param maxLimit Limite superior de la paginación (Hasta) 0 en caso de no existir limite superior
     * @param filtroBusqueda Cadena con un filtro de búsqueda personalizado
     * @return DTO Marca
     */
    public Empresa[] findEmpresas(int idEmpresaBuscada, int idEmpresa, int minLimit,int maxLimit, String filtroBusqueda) {
        Empresa[] marcaDto = new Empresa[0];
        EmpresaDaoImpl marcaDao = new EmpresaDaoImpl(this.conn);
        try {
            String sqlFiltro="";
            if (idEmpresaBuscada>0){
                sqlFiltro ="ID_EMPRESA_PADRE=" + idEmpresaBuscada + " AND ";
            }else{
                sqlFiltro ="ID_EMPRESA_PADRE>0 AND";
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
            
            marcaDto = marcaDao.findByDynamicWhere( 
                    sqlFiltro
                    + " ORDER BY NOMBRE_COMERCIAL ASC"
                    + sqlLimit
                    , new Object[0]);
            
        } catch (Exception ex) {
            System.out.println("Error de consulta a Base de Datos: " + ex.toString());
            ex.printStackTrace();
        }
        
        return marcaDto;
    }
    
    
    /**
     * Expresa si la empresa y sucursales tienen acceso al aplicativo
     * SGFENS - Pretoriano Soft.
     * @return true en caso de tener acceso, false en caso contrario
     */
    public boolean haveAccessApp(int idEmpresa){
        boolean haveAccess = false;
        
        try{
            idEmpresa = getEmpresaMatriz(idEmpresa).getIdEmpresa();
            
            EmpresaPermisoAplicacion empresaPermisoAplicacionDto = new EmpresaPermisoAplicacionDaoImpl(this.conn).findByPrimaryKey(idEmpresa);
            if (empresaPermisoAplicacionDto!=null){
                if (empresaPermisoAplicacionDto.getAccesoGespro()==(short)1)
                    haveAccess = true;
                if (empresaPermisoAplicacionDto.getAccesoGespro()==(short)2)
                    haveAccess = true;
                if (empresaPermisoAplicacionDto.getAccesoGespro()==(short)3)
                    haveAccess = true;
            }
        }catch(Exception ex){
            ex.printStackTrace();
        }
        
        return haveAccess;
    }

    public String getEmpresasByIdHTMLCombo(int idEmpresa, int idSeleccionado){
        String strHTMLCombo ="";        

        try{
            Empresa[] Empresa = findEmpresas(-1, idEmpresa, 0, 0, " AND ID_ESTATUS!=2 ");
            
            for (Empresa empresaItem:Empresa){
                try{
                    //Categoria datosCategoria = new CategoriaDaoImpl(this.conn).findByPrimaryKey(categoria.getIdCategoria());
                    String selectedStr="";

                    if (idSeleccionado==empresaItem.getIdEmpresa())
                        selectedStr = " selected ";

                    strHTMLCombo += "<option value='"+empresaItem.getIdEmpresa()+"' "
                            + selectedStr
                            + "title='"+empresaItem.getRazonSocial()+"'>"
                            +  empresaItem.getRazonSocial() + " - " + empresaItem.getNombreComercial()
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
    
    public String getEmpresasByIdHTMLCombo(int idEmpresa, int idSeleccionado, String filtroBusqueda){
        String strHTMLCombo ="";        

        try{
            //Empresa[] Empresa = findEmpresas(-1, idEmpresa, 0, 0, " AND ID_ESTATUS!=2 ");
            Empresa[] Empresa = findEmpresas(-1, idEmpresa, 0, 0, filtroBusqueda);
            
            for (Empresa empresaItem:Empresa){
                try{
                    //Categoria datosCategoria = new CategoriaDaoImpl(this.conn).findByPrimaryKey(categoria.getIdCategoria());
                    String selectedStr="";

                    if (idSeleccionado==empresaItem.getIdEmpresa())
                        selectedStr = " selected ";

                    strHTMLCombo += "<option value='"+empresaItem.getIdEmpresa()+"' "
                            + selectedStr
                            + "title='"+empresaItem.getRazonSocial()+"'>"
                            +  empresaItem.getRazonSocial() + " - " + empresaItem.getNombreComercial()
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
     * Recupera la Empresa Matriz que corresponda a la empresa indicada
     * En caso de ser la propia empresa matriz se retorna la misma.
     */
    public Empresa getEmpresaMatriz(long idEmpresa) throws Exception{
        Empresa empresaDto = findEmpresabyId(idEmpresa);
        
        if ((empresaDto.getIdEmpresa() != empresaDto.getIdEmpresaPadre())
               && empresaDto.getIdEmpresaPadre()>0 ){
            //Si el ID Empresa Padre es mayor a 0 y diferente del ID de empresa actual
            // indica que es una sucursal, por lo tanto buscamos su matriz
            empresaDto = findEmpresabyId(empresaDto.getIdEmpresaPadre());
        }
        
        return empresaDto;
    }
    
    
    
    
     //metodoo para ver cuantos usuarios tiene la empresa 
    /*public int cuentaUsuariosEmpresa(){
        Empresa[] empresas = findEmpresas(0, 0, 0, 0, " AND ID_VENDEDOR = -1 AND ID_FRANQUICIATARIO = -1 ");
        //VEMOS A QUE EMPRESA LO METEMOS, PARA ESO CONTAMOS EL NUMERO DE USUARIOS QUE TIENE PARA VER DONDE LA METEMOS:
        int idEmpresaSeleccionada = -1;
        for(Empresa emp : empresas){
            Usuarios[] users = new UsuariosBO().getUsuariosByEmpresa(emp.getIdEmpresa());            
            if(users.length < 5){
                idEmpresaSeleccionada = emp.getIdEmpresa();
            }
        }
        return idEmpresaSeleccionada;        
    }*/
    
    
    //metodo para encriptar los productos que se crean para los usuarios del EvcDemo.
    public String encripta(String dato) throws IOException{
         Encrypter encripter = new Encrypter();
         return encripter.encodeString2(dato);        
    }
    
    
    public Empresa getEmpresaByRazonSocial(String nombreComercial) throws Exception {
        Empresa empresa = null;

        try {
            EmpresaDaoImpl empresaDaoImpl = new EmpresaDaoImpl(this.conn);
            empresa = empresaDaoImpl.findByDynamicWhere(" RAZON_SOCIAL ='" + nombreComercial + "'", new Object[0])[0];
            if (empresa == null) {
                throw new Exception("La empresa no Existe");
            }
        } catch (EmpresaDaoException e) {
            e.printStackTrace();
            throw new Exception("La empresa no Existe");
        }

        return empresa;
    }
}
