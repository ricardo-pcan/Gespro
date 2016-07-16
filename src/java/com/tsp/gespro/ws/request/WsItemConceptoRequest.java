/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.tsp.gespro.ws.request;

import java.util.Date;

/**
 *
 * @author ISCesarMartinez
 */
public class WsItemConceptoRequest {
    
    private int idConcepto;
    private String descripcionAlternativa=null;
    private double cantidad=0;
    private String unidad="PIEZA";
    private double precioUnitario=0;
    private double monto=0;
    private double cantidadEntregada = 0;
    private Date fechaEntrega = new Date();
    private int estatus  = 0;
    
    private double cantidadPeso = 0;
    private double cantidadEntregadaPeso = 0;
    private int idInventarioEmpleado = 0;
    
    private double aptoParaVenta = 0;
    private double noAptoParaVenta = 0;
    private int idClasificacion = 0;
    private String comentarios = "";
    

    public int getIdInventarioEmpleado() {
        return idInventarioEmpleado;
    }

    public void setIdInventarioEmpleado(int idInventarioEmpleado) {
        this.idInventarioEmpleado = idInventarioEmpleado;
    }

    public double getCantidadPeso() {
        return cantidadPeso;
    }

    public void setCantidadPeso(double cantidadPeso) {
        this.cantidadPeso = cantidadPeso;
    }

    public double getCantidadEntregadaPeso() {
        return cantidadEntregadaPeso;
    }

    public void setCantidadEntregadaPeso(double cantidadEntregadaPeso) {
        this.cantidadEntregadaPeso = cantidadEntregadaPeso;
    }
    
    
            
    public double getCantidad() {
        return cantidad;
    }

    public void setCantidad(double cantidad) {
        this.cantidad = cantidad;
    }

    public int getIdConcepto() {
        return idConcepto;
    }

    public void setIdConcepto(int idConcepto) {
        this.idConcepto = idConcepto;
    }

    public double getMonto() {
        return monto;
    }

    public void setMonto(double monto) {
        this.monto = monto;
    }

    public double getPrecioUnitario() {
        return precioUnitario;
    }

    public void setPrecioUnitario(double precioUnitario) {
        this.precioUnitario = precioUnitario;
    }

    public String getUnidad() {
        return unidad;
    }

    public void setUnidad(String unidad) {
        this.unidad = unidad;
    }

    public String getDescripcionAlternativa() {
        return descripcionAlternativa;
    }

    public void setDescripcionAlternativa(String descripcionAlternativa) {
        this.descripcionAlternativa = descripcionAlternativa;
    }

    public double getCantidadEntregada() {
        return cantidadEntregada;
    }

    public void setCantidadEntregada(double cantidadEntregada) {
        this.cantidadEntregada = cantidadEntregada;
    }

    public Date getFechaEntrega() {
        return fechaEntrega;
    }

    public void setFechaEntrega(Date fechaEntrega) {
        this.fechaEntrega = fechaEntrega;
    }

    public int getEstatus() {
        return estatus;
    }

    public void setEstatus(int estatus) {
        this.estatus = estatus;
    }

    /**
     * @return the aptoParaVenta
     */
    public double getAptoParaVenta() {
        return aptoParaVenta;
    }

    /**
     * @param aptoParaVenta the aptoParaVenta to set
     */
    public void setAptoParaVenta(double aptoParaVenta) {
        this.aptoParaVenta = aptoParaVenta;
    }

    /**
     * @return the noAptoParaVenta
     */
    public double getNoAptoParaVenta() {
        return noAptoParaVenta;
    }

    /**
     * @param noAptoParaVenta the noAptoParaVenta to set
     */
    public void setNoAptoParaVenta(double noAptoParaVenta) {
        this.noAptoParaVenta = noAptoParaVenta;
    }

    /**
     * @return the idClasificacion
     */
    public int getIdClasificacion() {
        return idClasificacion;
    }

    /**
     * @param idClasificacion the idClasificacion to set
     */
    public void setIdClasificacion(int idClasificacion) {
        this.idClasificacion = idClasificacion;
    }

    /**
     * @return the comentarios
     */
    public String getComentarios() {
        return comentarios;
    }

    /**
     * @param comentarios the comentarios to set
     */
    public void setComentarios(String comentarios) {
        this.comentarios = comentarios;
    }
    
    
    
}
