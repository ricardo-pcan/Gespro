/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.tsp.gespro.ws.request;

import java.util.Date;

/**
 *
 * @author ISCesarMartinez
 
 Clase POJO contenedora de datos básicos del usuario/empleado 
 en sesión móvil que accede al web service
 */
public class UsuarioDtoRequest {
    
    private int idUsuario;
    private String usuarioUsuario;
    private String usuarioPassword;
    
    private String dispositivoIMEI;
    
    private String ubicacionLatitud;
    private String ubicacionLongitud;
    
    private Date fechaHora;

    private double porcentajeBateria;

    public UsuarioDtoRequest() {
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public String getUsuarioUsuario() {
        return usuarioUsuario;
    }

    public void setUsuarioUsuario(String usuarioUsuario) {
        this.usuarioUsuario = usuarioUsuario;
    }

    public String getUsuarioPassword() {
        return usuarioPassword;
    }

    public void setUsuarioPassword(String usuarioPassword) {
        this.usuarioPassword = usuarioPassword;
    }

    public String getDispositivoIMEI() {
        return dispositivoIMEI;
    }

    public void setDispositivoIMEI(String dispositivoIMEI) {
        this.dispositivoIMEI = dispositivoIMEI;
    }

    public String getUbicacionLatitud() {
        return ubicacionLatitud;
    }

    public void setUbicacionLatitud(String ubicacionLatitud) {
        this.ubicacionLatitud = ubicacionLatitud;
    }

    public String getUbicacionLongitud() {
        return ubicacionLongitud;
    }

    public void setUbicacionLongitud(String ubicacionLongitud) {
        this.ubicacionLongitud = ubicacionLongitud;
    }

    public Date getFechaHora() {
        return fechaHora;
    }

    public void setFechaHora(Date fechaHora) {
        this.fechaHora = fechaHora;
    }

    public double getPorcentajeBateria() {
        return porcentajeBateria;
    }

    public void setPorcentajeBateria(double porcentajeBateria) {
        this.porcentajeBateria = porcentajeBateria;
    }
    
}
