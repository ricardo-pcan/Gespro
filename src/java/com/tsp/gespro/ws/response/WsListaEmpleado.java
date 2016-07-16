/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.tsp.gespro.ws.response;

import java.util.ArrayList;

/**
 *
 * @author leonardo
 */
public class WsListaEmpleado {
    
    private ArrayList<WsItemEmpleado> lista;

    public WsListaEmpleado(){
        lista = new ArrayList<WsItemEmpleado>();
    }

    public void addItem(WsItemEmpleado data){
        this.lista.add(data);
    }

    public WsItemEmpleado getItem(int pos){
        return this.lista.get(pos);
    }
    
    public ArrayList<WsItemEmpleado> getLista() {
        return lista;
    }
    
}
