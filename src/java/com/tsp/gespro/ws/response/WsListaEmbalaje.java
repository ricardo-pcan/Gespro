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
public class WsListaEmbalaje {
    
    private ArrayList<WsItemEmbalaje> lista;

    public WsListaEmbalaje(){
        lista = new ArrayList<WsItemEmbalaje>();
    }

    public void addItem(WsItemEmbalaje data){
        this.lista.add(data);
    }

    public WsItemEmbalaje getItem(int pos){
        return this.lista.get(pos);
    }
    
    public ArrayList<WsItemEmbalaje> getLista() {
        return lista;
    }
}
