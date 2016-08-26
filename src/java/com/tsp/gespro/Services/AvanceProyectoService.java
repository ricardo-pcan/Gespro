/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.tsp.gespro.Services;

import com.google.gson.Gson;
import java.util.AbstractList;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author gloria
 */
public class AvanceProyectoService {
    public String getAvancesRegiones(List<ActividadFullObject> lista){
        List<ActividadFullObject> ciudades=lista;
        List<ActividadFullObject> grupoCiudad=lista;
        List<ActividadFullObject> estados=lista;
         List<ActividadFullObject> grupoEstado=lista;
        AvanceProyecto ciudad=new AvanceProyecto();
        AvanceProyecto estado=new AvanceProyecto();
      
        float terminada=100;
        int terminadas=0;
        int noTerminadas=0;
        int total=0;
        if(lista!=null){
            for(ActividadFullObject obj:lista){
               
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
