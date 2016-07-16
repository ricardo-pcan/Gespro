/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.tsp.gespro.ws.response;

import java.io.Serializable;

/**
 *
 * @author leonardo
 */
public class WsItemConceptoRegistroFotograficoResponse  extends WSResponseInsert  implements Serializable{
    
    
    private int idDetalleConceptoRegistroFotografico;    

    public int getIdDetalleConceptoRegistroFotografico() {
        return idDetalleConceptoRegistroFotografico;
    }

    public void setIdDetalleConceptoRegistroFotografico(int idDetalleConceptoRegistroFotografico) {
        this.idDetalleConceptoRegistroFotografico = idDetalleConceptoRegistroFotografico;
    }

    
    
}
