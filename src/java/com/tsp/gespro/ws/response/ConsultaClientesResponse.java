/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.tsp.gespro.ws.response;

import com.tsp.gespro.ws.WSResponse;
import java.util.ArrayList;

/**
 *
 * @author ISCesarMartinez
 */
public class ConsultaClientesResponse extends WSResponse {
    
    private ArrayList<WsItemCliente> listaClientes; 
   
    
    public ArrayList<WsItemCliente> getListaClientes() {
        if (listaClientes==null)
            listaClientes = new ArrayList<WsItemCliente>();
        return listaClientes;
    }

    public void setListaClientes(ArrayList<WsItemCliente> listaClientes) {
        this.listaClientes = listaClientes;
    }
    
    
}
