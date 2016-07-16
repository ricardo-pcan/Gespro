/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.tsp.gespro.ws.response;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author ISCesar poseidon24@hotmail.com
 * @since 7/10/2014 12:29:33 PM
 */
public class ConsultaPedidosResponse extends WSResponse implements Serializable{

    private List<WsItemPedido> wsItemPedido;

    public List<WsItemPedido> getWsItemPedido() {
        if (wsItemPedido==null)
            wsItemPedido = new ArrayList<WsItemPedido>();
        return wsItemPedido;
    }

    public void setWsItemPedido(List<WsItemPedido> wsItemPedido) {
        this.wsItemPedido = wsItemPedido;
    }
    
}
