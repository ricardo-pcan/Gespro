/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.tsp.gespro.ws.request;

import java.util.Date;

/**
 *
 * @author leonardo
 */
public class DegustacionDtoRequest {
    
    private int idDegustacion;
    private int idUsuario;
    //private int idEmpresa;
    private int idConcepto;
    private int idCliente;
    private int idCheck;
    private int idEstatus; //1 ACTIVO, 2 INACTIVO, 3 CERRADO
    private double cantidad;
    private double cantidadCierre;
    private String comentariosCierre;
    private Date fechaApertura;
    private Date fechaCierre;

    /**
     * @return the idDegustacion
     */
    public int getIdDegustacion() {
        return idDegustacion;
    }

    /**
     * @param idDegustacion the idDegustacion to set
     */
    public void setIdDegustacion(int idDegustacion) {
        this.idDegustacion = idDegustacion;
    }

    /**
     * @return the idUsuario
     */
    public int getIdUsuario() {
        return idUsuario;
    }

    /**
     * @param idUsuario the idUsuario to set
     */
    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    /**
     * @return the idEmpresa
     */
    /*public int getIdEmpresa() {
        return idEmpresa;
    }*/

    /**
     * @param idEmpresa the idEmpresa to set
     */
    /*public void setIdEmpresa(int idEmpresa) {
        this.idEmpresa = idEmpresa;
    }*/

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
     * @return the idCliente
     */
    public int getIdCliente() {
        return idCliente;
    }

    /**
     * @param idCliente the idCliente to set
     */
    public void setIdCliente(int idCliente) {
        this.idCliente = idCliente;
    }

    /**
     * @return the idCheck
     */
    public int getIdCheck() {
        return idCheck;
    }

    /**
     * @param idCheck the idCheck to set
     */
    public void setIdCheck(int idCheck) {
        this.idCheck = idCheck;
    }

    /**
     * @return the idEstatus
     */
    public int getIdEstatus() {
        return idEstatus;
    }

    /**
     * @param idEstatus the idEstatus to set
     */
    public void setIdEstatus(int idEstatus) {
        this.idEstatus = idEstatus;
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

    /**
     * @return the cantidadCierre
     */
    public double getCantidadCierre() {
        return cantidadCierre;
    }

    /**
     * @param cantidadCierre the cantidadCierre to set
     */
    public void setCantidadCierre(double cantidadCierre) {
        this.cantidadCierre = cantidadCierre;
    }

    /**
     * @return the comentariosCierre
     */
    public String getComentariosCierre() {
        return comentariosCierre;
    }

    /**
     * @param comentariosCierre the comentariosCierre to set
     */
    public void setComentariosCierre(String comentariosCierre) {
        this.comentariosCierre = comentariosCierre;
    }

    /**
     * @return the fechaApertura
     */
    public Date getFechaApertura() {
        return fechaApertura;
    }

    /**
     * @param fechaApertura the fechaApertura to set
     */
    public void setFechaApertura(Date fechaApertura) {
        this.fechaApertura = fechaApertura;
    }

    /**
     * @return the fechaCierre
     */
    public Date getFechaCierre() {
        return fechaCierre;
    }

    /**
     * @param fechaCierre the fechaCierre to set
     */
    public void setFechaCierre(Date fechaCierre) {
        this.fechaCierre = fechaCierre;
    }
    
}
