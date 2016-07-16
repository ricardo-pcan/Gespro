/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.tsp.gespro.bo;

import com.tsp.gespro.dto.AccionBitacora;
import com.tsp.gespro.dto.Topic;
import com.tsp.gespro.exceptions.AccionBitacoraDaoException;
import com.tsp.gespro.exceptions.TopicDaoException;
import com.tsp.gespro.jdbc.AccionBitacoraDaoImpl;
import com.tsp.gespro.jdbc.TopicDaoImpl;
import java.sql.Connection;
import java.util.Date;

/**
 *
 * @author ISC César Ulises Martínez García
 */
public class AccionBitacoraBO {
    public static final int ACCION_LOGIN =1;
    public static final int ACCION_LOGOUT =2;
    public static final int ACCION_NAVEGACION =3;
    public static final int ACCION_DESCARGA =4;

    private Connection conn = null;

    public Connection getConn() {
        return conn;
    }

    public void setConn(Connection conn) {
        this.conn = conn;
    }
    
    public AccionBitacoraBO(Connection conn) {
        this.conn = conn;
    }
    
    public static String getAccionBitacoraName(int idTipoAccionBitacora){
        String name="";
        switch (idTipoAccionBitacora){
            case ACCION_LOGIN:
                return "Login";
            case ACCION_LOGOUT:
                return "Logout";
            case ACCION_NAVEGACION:
                return "Navegación";
            case ACCION_DESCARGA:
                return "Descarga";
            default:
                name ="Tipo de Acción Indefinida";
        }
        return name;
    }

    /**
     * Inserta un evento de Login en la bitacora de acciones
     * @param idUser identificador unico del usuario que efectua la acción
     * @param comentarios Comentarios adicionales
     * @return true en caso de inserción exitosa, false en caso contrario
     */
    public boolean insertAccionLogin(long idUser, String comentarios){
        boolean exito=false;
        AccionBitacora accionBitacoraDto = new AccionBitacora();
        AccionBitacoraDaoImpl accionBitacoraDaoImpl = new AccionBitacoraDaoImpl(this.conn);

        try{
            if (comentarios.equals(""))
                comentarios="Inicio de sesión";

            accionBitacoraDto.setIdTipoBitacoraAccionTipo(ACCION_LOGIN);
            accionBitacoraDto.setIdUser((int) idUser);
            accionBitacoraDto.setFechaHoraBitacoraAccion(new Date());
            accionBitacoraDto.setComentariosBitacoraAccion(comentarios);

            accionBitacoraDaoImpl.insert(accionBitacoraDto);
            exito=true;
        }catch(Exception e){

        }
        
        
        return exito;
    }

    /**
     * Inserta un evento de Logout en la bitacora de acciones
     * @param idUser identificador unico del usuario que efectua la acción
     * @param comentarios Comentarios adicionales
     * @return true en caso de inserción exitosa, false en caso contrario
     */
    public boolean insertAccionLogout(long idUser, String comentarios){
        boolean exito=false;
        AccionBitacora accionBitacoraDto = new AccionBitacora();
        AccionBitacoraDaoImpl accionBitacoraDaoImpl = new AccionBitacoraDaoImpl(this.conn);

        try{
            if (comentarios.equals(""))
                comentarios="Cierre de sesión";

            accionBitacoraDto.setIdTipoBitacoraAccionTipo(ACCION_LOGOUT);
            accionBitacoraDto.setIdUser((int) idUser);
            accionBitacoraDto.setFechaHoraBitacoraAccion(new Date());
            accionBitacoraDto.setComentariosBitacoraAccion(comentarios);

            accionBitacoraDaoImpl.insert(accionBitacoraDto);
            exito=true;
        }catch(Exception e){

        }
        return exito;
    }

    /**
     * Inserta un evento de Descarga en la bitacora de acciones
     * @param idUser identificador unico del usuario que efectua la acción
     * @param comentarios Comentarios adicionales
     * @return true en caso de inserción exitosa, false en caso contrario
     */
    public boolean insertAccionDescarga(long idUser, String comentarios){
        boolean exito=false;
        AccionBitacora accionBitacoraDto = new AccionBitacora();
        AccionBitacoraDaoImpl accionBitacoraDaoImpl = new AccionBitacoraDaoImpl(this.conn);

        try{
            if (comentarios.equals(""))
                comentarios="Descarga de archivo";

            accionBitacoraDto.setIdTipoBitacoraAccionTipo(ACCION_DESCARGA);
            accionBitacoraDto.setIdUser((int) idUser);
            accionBitacoraDto.setFechaHoraBitacoraAccion(new Date());
            accionBitacoraDto.setComentariosBitacoraAccion(comentarios);

            accionBitacoraDaoImpl.insert(accionBitacoraDto);
            exito=true;
        }catch(Exception e){

        }
        return exito;
    }

    public boolean insertAccionNavegacion(long idUser, String comentarios, String strPathTopic){
       long idTopic = (long)0;
       try {
            TopicDaoImpl topicDao = new TopicDaoImpl(this.conn);
            Topic[] topics = topicDao.findWhereUrlTopicEquals(strPathTopic);
            if (topics.length>0){
                idTopic = topics[0].getIdTopic();
            }
        } catch (TopicDaoException ex) {
            System.out.println(ex.getMessage());
        }

       return insertAccionNavegacion(idUser, comentarios, idTopic);
    }

    /**
     * Inserta un evento de navegación en la bitácora de acciones
     * @param idUser identificador único del usuario que efectúa la acción
     * @param comentarios Comentarios adicionales
     * @return true en caso de inserción exitosa, false en caso contrario
     */
    public boolean insertAccionNavegacion(long idUser, String comentarios, long idTopic){
        boolean exito=false;
        AccionBitacora accionBitacoraDto = new AccionBitacora();
        AccionBitacoraDaoImpl accionBitacoraDaoImpl = new AccionBitacoraDaoImpl(this.conn);

        try{
            if (comentarios.equals(""))
                comentarios="Navegacion en el sistema";

            accionBitacoraDto.setIdTipoBitacoraAccionTipo(ACCION_NAVEGACION);
            accionBitacoraDto.setIdUser((int) idUser);
            accionBitacoraDto.setFechaHoraBitacoraAccion(new Date());
            accionBitacoraDto.setComentariosBitacoraAccion(comentarios);
            accionBitacoraDto.setIdTopicNavegacion(idTopic);

            accionBitacoraDaoImpl.insert(accionBitacoraDto);
            exito=true;
        }catch(Exception e){

        }
        return exito;
    }

     /**
     * Regresa un arreglo de objetos AccionBitacora con los datos
     * de los registro de bitácora que corresponden a un usuario y a cierto tipo de Acción
     * @param  int idUser Identificador único del Usuario
     * @param int[] idTipoAccion Arreglo de identificadores para filtrar por tipo de Acción.
     *          Si se requiere obtener la consulta sin este filtro basta con enviar un
     *          arreglo vacío: new int[0]
     * @return Arreglo de objetos AccionBitacora
     */
    public AccionBitacora[] getBitacoraByUser(int idUser, int[] idTipoAccion){
        AccionBitacoraDaoImpl bitacoraDao = new AccionBitacoraDaoImpl(this.conn);
        AccionBitacora[] bitacora =  new AccionBitacora[0];
        try {
            String strWhereTipoAccion ="";
            int i = 1;
            //construimos parte del "where" de la consulta con el arreglo de status como filtro
            for (int idtipoAccionItem : idTipoAccion) {
                strWhereTipoAccion += " id_tipo_bitacora_accion_tipo=  " + idtipoAccionItem;
                strWhereTipoAccion += (idTipoAccion.length > 1 && i < idTipoAccion.length) ? " OR" : "";
                i++;
            }
            if (!strWhereTipoAccion.equals("")){
                strWhereTipoAccion = " AND ("+strWhereTipoAccion+")";
            }
            bitacora = bitacoraDao.findByDynamicWhere("id_user = "+idUser+" "+strWhereTipoAccion+" ORDER BY fecha_hora_bitacora_accion DESC", new Object[0]);
        } catch (AccionBitacoraDaoException ex) {
            System.out.println(ex.getMessage());
            //Logger.getLogger(AccionBitacoraBO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return bitacora;
    }

    /**
     * Regresa un arreglo de objetos AccionBitacora con los datos
     * de los registro de bitácora que corresponden A cierto tipo de Accion
     * @param  int idUser Identificador único del Usuario
     * @param int[] idTipoAccion Arreglo de identificadores para filtrar por tipo de Accion
     * @return Arreglo de objetos AccionBitacora
     */
    public AccionBitacora[] getBitacoraByTipoAccion(int[] idTipoAccion){
        AccionBitacoraDaoImpl bitacoraDao = new AccionBitacoraDaoImpl(this.conn);
        AccionBitacora[] bitacora =  new AccionBitacora[0];
        try {
            String strWhereTipoAccion ="";
            int i = 1;
            //construimos parte del "where" de la consulta con el arreglo de status como filtro
            for (int idtipoAccionItem : idTipoAccion) {
                strWhereTipoAccion += " id_tipo_bitacora_accion_tipo=  " + idtipoAccionItem;
                strWhereTipoAccion += (idTipoAccion.length > 1 && i < idTipoAccion.length) ? " OR" : "";
                i++;
            }
            bitacora = bitacoraDao.findByDynamicWhere(strWhereTipoAccion+" ORDER BY fecha_hora_bitacora_accion DESC", new Object[0]);
        } catch (AccionBitacoraDaoException ex) {
            System.out.println(ex.getMessage());
            //Logger.getLogger(AccionBitacoraBO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return bitacora;
    }
    
    /**
     * Realiza una búsqueda por ID AccionBitacora en busca de
     * coincidencias
     * @param idAccionBitacora ID De la accionBitacora para filtrar, -1 para mostrar todos los registros
     * @param idEmpresa ID de la Empresa a filtrar accionBitacora, -1 para evitar filtro
     *  @param minLimit Limite inferior de la paginación (Desde) 0 en caso de no existir limite inferior
     * @param maxLimit Limite superior de la paginación (Hasta) 0 en caso de no existir limite superior
     * @param filtroBusqueda Cadena con un filtro de búsqueda personalizado
     * @return DTO AccionBitacora
     */
    public AccionBitacora[] findAccionBitacora(int idAccionBitacora, int idEmpresa, int minLimit,int maxLimit, String filtroBusqueda) {
        AccionBitacora[] accionBitacoraDto = new AccionBitacora[0];
        AccionBitacoraDaoImpl accionBitacoraDao = new AccionBitacoraDaoImpl(this.conn);
        try {
            String sqlFiltro="";
            if (idAccionBitacora>0){
                sqlFiltro ="ID_BITACORA_ACCION=" + idAccionBitacora + " AND ";
            }else{
                sqlFiltro ="ID_BITACORA_ACCION>0 AND";
            }
            if (idEmpresa>0){
                sqlFiltro += " ID_USER IN (SELECT ID_USUARIOS AS 'ID_USER' FROM USUARIOS WHERE ID_EMPRESA IN (SELECT ID_EMPRESA FROM EMPRESA WHERE ID_EMPRESA_PADRE = " + idEmpresa + " OR ID_EMPRESA= " + idEmpresa + "))";
            }else{
                sqlFiltro +=" ID_USER>0";
            }
            
            if (!filtroBusqueda.trim().equals("")){
                sqlFiltro += filtroBusqueda;
            }
            
            if (minLimit<0)
                minLimit=0;
            
            String sqlLimit="";
            if ((minLimit>0 && maxLimit>0) || (minLimit==0 && maxLimit>0))
                sqlLimit = " LIMIT " + minLimit + "," + maxLimit;
            
            accionBitacoraDto = accionBitacoraDao.findByDynamicWhere( 
                    sqlFiltro
                    + " ORDER BY fecha_hora_bitacora_accion DESC"
                    + sqlLimit
                    , new Object[0]);
            
        } catch (Exception ex) {
            System.out.println("Error de consulta a Base de Datos: " + ex.toString());
            ex.printStackTrace();
        }
        
        return accionBitacoraDto;
    }

}
