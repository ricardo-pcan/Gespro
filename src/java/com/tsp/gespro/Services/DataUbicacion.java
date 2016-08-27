/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.tsp.gespro.Services;

/**
 *
 * @author gloria
 */
public class DataUbicacion {
   private String ciudad;
   private String estado;
   private String nombreCortoCiudad;
   private String nombrCortoEstado;
   private double lat;
   private double lng;

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
     * @return the nombreCortoCiudad
     */
    public String getNombreCortoCiudad() {
        return nombreCortoCiudad;
    }

    /**
     * @param nombreCortoCiudad the nombreCortoCiudad to set
     */
    public void setNombreCortoCiudad(String nombreCortoCiudad) {
        this.nombreCortoCiudad = nombreCortoCiudad;
    }

    /**
     * @return the nombrCortoEstado
     */
    public String getNombrCortoEstado() {
        return nombrCortoEstado;
    }

    /**
     * @param nombrCortoEstado the nombrCortoEstado to set
     */
    public void setNombrCortoEstado(String nombrCortoEstado) {
        this.nombrCortoEstado = nombrCortoEstado;
    }

    /**
     * @return the lat
     */
    public double getLat() {
        return lat;
    }

    /**
     * @param lat the lat to set
     */
    public void setLat(double lat) {
        this.lat = lat;
    }

    /**
     * @return the lng
     */
    public double getLng() {
        return lng;
    }

    /**
     * @param lng the lng to set
     */
    public void setLng(double lng) {
        this.lng = lng;
    }
}
