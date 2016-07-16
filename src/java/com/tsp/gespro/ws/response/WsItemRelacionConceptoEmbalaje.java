/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.tsp.gespro.ws.response;

/**
 *
 * @author leonardo
 */
public class WsItemRelacionConceptoEmbalaje {
    
    private int idRelacion;
    private int idConcepto;
    private int idEmbalaje;
    private double cantidad;

    /**
     * @return the idRelacion
     */
    public int getIdRelacion() {
        return idRelacion;
    }

    /**
     * @param idRelacion the idRelacion to set
     */
    public void setIdRelacion(int idRelacion) {
        this.idRelacion = idRelacion;
    }

    /**
     * @return the idConcepto
     */
    public int getIdConcepto() {
        return idConcepto;
    }

    /**
     * @param idConcepto the idConcepto to set
     */
    public void setIdConcepto(int idConcepto) {
        this.idConcepto = idConcepto;
    }

    /**
     * @return the idEmbalaje
     */
    public int getIdEmbalaje() {
        return idEmbalaje;
    }

    /**
     * @param idEmbalaje the idEmbalaje to set
     */
    public void setIdEmbalaje(int idEmbalaje) {
        this.idEmbalaje = idEmbalaje;
    }

    /**
     * @return the cantidad
     */
    public double getCantidad() {
        return cantidad;
    }

    /**
     * @param cantidad the cantidad to set
     */
    public void setCantidad(double cantidad) {
        this.cantidad = cantidad;
    }
    
}
