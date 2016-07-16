/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.tsp.gespro.ws.response;

import com.tsp.gespro.ws.WSResponse;
import java.util.ArrayList;

/**
 *
 * @author leonardo
 */
public class ConsultaCompetenciaResponse extends WSResponse{
    
   private ArrayList<WsItemCompetencia> listaCompetencia;
    private int totalRegistros = 0;


    public ArrayList<WsItemCompetencia> getListaCompetencia() {
        if (listaCompetencia==null)
            listaCompetencia = new ArrayList<WsItemCompetencia>();
        return listaCompetencia;
    }

    public void setListaCompetencia(ArrayList<WsItemCompetencia> listaCompetencia) {
        this.listaCompetencia = listaCompetencia;
    }

    public int getTotalRegistros() {
        return totalRegistros;
    }

    public void setTotalRegistros(int totalRegistros) {
        this.totalRegistros = totalRegistros;
    }
    
    
}