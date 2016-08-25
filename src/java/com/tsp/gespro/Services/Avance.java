/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.tsp.gespro.Services;

import com.google.gson.Gson;
import java.util.List;

/**
 *
 * @author gloria
 */
public class Avance {
    public String getAvancesByCiudadRegionesJSON(List<ActividadFullObject> lista){
        int totalDeActividades=lista.size();
        int actividadesTerminadas=0;
        int actividadesSinTerminar=0;
        float terminada=100;
        
        if(lista!=null){
            for(ActividadFullObject obj:lista){
                if(obj.getActividad().getAvance()==terminada){
                    actividadesTerminadas++;
                }else{
                    actividadesSinTerminar++;
                }
            }
        }
        else{
            return "{'status':'error',message:'No tiene actividades.'}";
        }
        
        String jsonBody="{\"ciudades\":{\"Chalco\":270,\"Huatulco\":2000,\"Puerto Vallarta\":1000},\"regiones\":{\"Baja california\":100,\"Nuevo león\":90,\"Oaxaca\":250}}";
        Gson gson = new Gson();
        String jsonResponse = gson.toJson(jsonBody);
        System.out.println("JSON avances por region y co");
        return jsonResponse;
    }
}
