package com.tsp.gespro.ws.request;

/**
 *
 * @author ISCesarMartinez  poseidon24@hotmail.com
 * @date 13-jun-2013 
 */
public class ModificarPedidoRequest {

    private int idServerPedido;
    private int idEstatusPedido;
    private int idTipoPedido;
    private WsItemConceptoRequest[] wsItemConceptoRequest;

    public int getIdTipoPedido() {
        return idTipoPedido;
    }

    public void setIdTipoPedido(int idTipoPedido) {
        this.idTipoPedido = idTipoPedido;
    }

    public int getIdEstatusPedido() {
        return idEstatusPedido;
    }

    public void setIdEstatusPedido(int idEstatusPedido) {
        this.idEstatusPedido = idEstatusPedido;
    }

    public int getIdServerPedido() {
        return idServerPedido;
    }

    public void setIdServerPedido(int idServerPedido) {
        this.idServerPedido = idServerPedido;
    }

    public WsItemConceptoRequest[] getWsItemConceptoRequest() {
        return wsItemConceptoRequest;
    }

    public void setWsItemConceptoRequest(WsItemConceptoRequest[] wsItemConceptoRequest) {
        this.wsItemConceptoRequest = wsItemConceptoRequest;
    }
        
}