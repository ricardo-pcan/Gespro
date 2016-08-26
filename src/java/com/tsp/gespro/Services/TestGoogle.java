/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.tsp.gespro.Services;

/**
 *
 * @author gloria
 */
public class TestGoogle {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        double lat=17.993453;
        double lng=-92.955093;
        ClientGoogleServicesAPI obj=new ClientGoogleServicesAPI();
        try{
            DataUbicacion ubi=obj.getCiudadRegion(lat, lng);
        }catch(Exception e){
            System.out.print("Error : "+ e.getMessage());
            e.printStackTrace();
        }
        
    }
}
