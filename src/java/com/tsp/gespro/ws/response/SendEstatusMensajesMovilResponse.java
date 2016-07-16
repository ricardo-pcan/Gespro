/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.tsp.gespro.ws.response;

import com.tsp.gespro.ws.WSResponse;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author ISCesarMartinez  poseidon24@hotmail.com
 * @date 31-ene-2013 
 */
public class SendEstatusMensajesMovilResponse extends WSResponse {

    int parametroTiempoMinutosActualiza = 30;
    List<WsItemSendMensajeResponse> wsItemSendMensajeResponse = null;

    public int getParametroTiempoMinutosActualiza() {
        return parametroTiempoMinutosActualiza;
    }

    public void setParametroTiempoMinutosActualiza(int parametroTiempoMinutosActualiza) {
        this.parametroTiempoMinutosActualiza = parametroTiempoMinutosActualiza;
    }

    public List<WsItemSendMensajeResponse> getWsItemSendMensajeResponse() {
        if (wsItemSendMensajeResponse==null)
            wsItemSendMensajeResponse = new ArrayList<WsItemSendMensajeResponse>();
        return wsItemSendMensajeResponse;
    }

    public void setWsItemSendMensajeResponse(List<WsItemSendMensajeResponse> wsItemSendMensajeResponse) {
        this.wsItemSendMensajeResponse = wsItemSendMensajeResponse;
    }
            
}
