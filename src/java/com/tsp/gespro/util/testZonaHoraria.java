/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.tsp.gespro.util;

import com.tsp.gespro.bo.ZonaHorariaBO;
import com.tsp.gespro.jdbc.ResourceManager;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Calendar;
import java.util.Date;

/**
 *
 * @author leonardo
 */
public class testZonaHoraria {
    
    public static void main (String args[]) throws SQLException, Exception{
        ZonaHorariaBO horariaBO = new ZonaHorariaBO();
        
        Connection conn = ResourceManager.getConnection();
        
        Calendar fechaHoraPais = ZonaHorariaBO.DateZonaHorariaByIdEmpresa(conn, new Date(), 1);
        //Date fechaHoraPais = ZonaHorariaBO.DateZonaHorariaByIdEmpresa(conn, new Date(), 1);
        
        
        System.out.println("--- AHORITA: " + new Date());
        System.out.println("--- EN PAIS: " + fechaHoraPais.getTime());
        
        
    }
    
}
