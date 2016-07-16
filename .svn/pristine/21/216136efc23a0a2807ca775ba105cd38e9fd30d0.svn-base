/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.tsp.gespro.bo;

/**
 *
 * @author ISCesarMartinez  poseidon24@hotmail.com
 * @date 14-dic-2012 
 */
public class SGEstatusPedidoBO {

    public static final int ESTATUS_PENDIENTE = 1;
    public static final int ESTATUS_ENTREGADO = 2;
    public static final int ESTATUS_CANCELADO = 3;
    public static final int ESTATUS_ENTREGADO_PARCIAL = 4;
    
    public static final String ESTATUS_PENDIENTE_NAME = "Pendiente por Entregar";
    public static final String ESTATUS_ENTREGADO_NAME = "Entregado";
    public static final String ESTATUS_CANCELADO_NAME = "Cancelado";
    public static final String ESTATUS_ENTREGADO_PARCIAL_NAME = "Entregado Parcialmente";
    
     /**
     * Obtiene el nombre escrito (cadena) de un Estatus de Pedido por medio de su ID
     * @return Cadena con el nombre descriptivo del Estatus de Pedido
     */
    public static String getEstatusName(int idEstatusPedido){
        String estatusName="";
        switch (idEstatusPedido){
            case ESTATUS_PENDIENTE:
                return ESTATUS_PENDIENTE_NAME;
            case ESTATUS_ENTREGADO:
                return ESTATUS_ENTREGADO_NAME;
            case ESTATUS_CANCELADO:
                return ESTATUS_CANCELADO_NAME;
            case ESTATUS_ENTREGADO_PARCIAL:
                return ESTATUS_ENTREGADO_PARCIAL_NAME;
            default:
                estatusName ="Estatus de pedido no Existente";
        }
        return estatusName;
    }    
    
}
