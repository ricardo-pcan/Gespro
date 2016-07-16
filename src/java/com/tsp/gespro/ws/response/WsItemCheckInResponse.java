/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.tsp.gespro.ws.response;

import java.io.Serializable;

/**
 *
 * @author HpPyme
 */
public class WsItemCheckInResponse extends WSResponseInsert  implements Serializable{
    
    
    private int incidencia;    

    public int getIncidencia() {
        return incidencia;
    }

    public void setIncidencia(int incidencia) {
        this.incidencia = incidencia;
    }

    

}
