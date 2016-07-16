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
public class ConsultaEmpleadoResponse extends WSResponse{
    
   private ArrayList<WsItemEmpleado> listaEmpleado;
    private int totalRegistros = 0;


    public ArrayList<WsItemEmpleado> getListaEmpleado() {
        if (listaEmpleado==null)
            listaEmpleado = new ArrayList<WsItemEmpleado>();
        return listaEmpleado;
    }

    public void setListaEmpleado(ArrayList<WsItemEmpleado> listaEmpleado) {
        this.listaEmpleado = listaEmpleado;
    }

    public int getTotalRegistros() {
        return totalRegistros;
    }

    public void setTotalRegistros(int totalRegistros) {
        this.totalRegistros = totalRegistros;
    }
    
    
}