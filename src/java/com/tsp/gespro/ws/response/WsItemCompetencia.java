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
public class WsItemCompetencia implements Serializable {
    
    private int idCompetencia;
    private String nombre;
    private String descripcion;

    /**
     * @return the idCompetencia
     */
    public int getIdCompetencia() {
        return idCompetencia;
    }

    /**
     * @param idCompetencia the idCompetencia to set
     */
    public void setIdCompetencia(int idCompetencia) {
        this.idCompetencia = idCompetencia;
    }

    /**
     * @return the nombre
     */
    public String getNombre() {
        return nombre;
    }

    /**
     * @param nombre the nombre to set
     */
    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    /**
     * @return the descripcion
     */
    public String getDescripcion() {
        return descripcion;
    }

    /**
     * @param descripcion the descripcion to set
     */
    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }
    
    
}
