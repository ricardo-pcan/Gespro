/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.tsp.gespro.bo;

/**
 *
 * @author ISCesarMartinez
 */
public class RolesBO {
    
    public static final int ROL_DESARROLLO = 1;
    public static final int ROL_ADMINISTRADOR = 2;
    public static final int ROL_ADMINISTRADOR_DE_SUCURSAL = 3;
    public static final int ROL_GESPRO = 4;

    
    public static final String ROL_DESARROLLO_NAME = "Desarrollo";
    public static final String ROL_ADMINISTRADOR_NAME = "Administrador";
    public static final String ROL_ADMINISTRADOR_DE_SUCURSAL_NAME = "Director de Sucursal";
    public static final String ROL_GESPRO_NAME = "Gespro";
 
    
    /**
     * Obtiene el nombre escrito (cadena) de un Rol por medio de su ID
     * @return Cadena con el nombre descriptivo del Rol
     */
    public static String getRolName(int idRol){
        String rolName="";
        switch (idRol){
            case ROL_DESARROLLO:
                return ROL_DESARROLLO_NAME;
            case ROL_ADMINISTRADOR:
                return ROL_ADMINISTRADOR_NAME;            
            case ROL_ADMINISTRADOR_DE_SUCURSAL:
                return ROL_ADMINISTRADOR_DE_SUCURSAL_NAME;
            case ROL_GESPRO:
                return ROL_GESPRO_NAME; 
            default:
                rolName ="Rol no Existente";
        }
        return rolName;
    }
    
}
