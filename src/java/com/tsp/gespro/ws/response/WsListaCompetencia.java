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
public class WsListaCompetencia {
    
    private ArrayList<WsItemCompetencia> lista;

    public WsListaCompetencia(){
        lista = new ArrayList<WsItemCompetencia>();
    }

    public void addItem(WsItemCompetencia data){
        this.lista.add(data);
    }

    public WsItemCompetencia getItem(int pos){
        return this.lista.get(pos);
    }
    
    public ArrayList<WsItemCompetencia> getLista() {
        return lista;
    }
}
