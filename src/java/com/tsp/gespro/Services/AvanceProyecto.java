/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.tsp.gespro.Services;

import com.tsp.gespro.hibernate.pojo.Cliente;
import com.tsp.gespro.hibernate.pojo.Proyecto;

/**
 *
 * @author gloria
 */
public class AvanceProyecto {
    private String ciudad;
    private String estado;
    private String avanceCiudad;
    private String avanceEstado;

    /**
     * @return the ciudad
     */
    public String getCiudad() {
        return ciudad;
    }

    /**
     * @param ciudad the ciudad to set
     */
    public void setCiudad(String ciudad) {
        this.ciudad = ciudad;
    }

    /**
     * @return the estado
     */
    public String getEstado() {
        return estado;
    }

    /**
     * @param estado the estado to set
     */
    public void setEstado(String estado) {
        this.estado = estado;
    }

    /**
     * @return the avanceCiudad
     */
    public String getAvanceCiudad() {
        return avanceCiudad;
    }

    /**
     * @param avanceCiudad the avanceCiudad to set
     */
    public void setAvanceCiudad(String avanceCiudad) {
        this.avanceCiudad = avanceCiudad;
    }

    /**
     * @return the avanceEstado
     */
    public String getAvanceEstado() {
        return avanceEstado;
    }

    /**
     * @param avanceEstado the avanceEstado to set
     */
    public void setAvanceEstado(String avanceEstado) {
        this.avanceEstado = avanceEstado;
    }
}
