/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.tsp.gespro.ws;

import com.tsp.gespro.exceptions.EstanteriaDescripcionDaoException;
import com.tsp.gespro.jdbc.ResourceManager;
import java.sql.Connection;
import java.sql.PreparedStatement;

/**
 *
 * @author leonardo
 */
public class testDelete {
    public static void main(String args[]) throws EstanteriaDescripcionDaoException{
        deleteEstanteriaDescripcion(" DELETE FROM estanteria_descripcion WHERE ID_ESTANTERIA = 3 " , null);
    }
    
    public static void deleteEstanteriaDescripcion(String SQL_DELETE, Connection connec) throws EstanteriaDescripcionDaoException
	{
		long t1 = System.currentTimeMillis();
		// declare variables
		final boolean isConnSupplied = (connec != null);
		Connection conn = null;
		PreparedStatement stmt = null;
		
		try {
			// get the user-specified connection or get a connection from the ResourceManager
			conn = isConnSupplied ? connec : ResourceManager.getConnection();
		
			System.out.println( "Executing " + SQL_DELETE);
			stmt = conn.prepareStatement( SQL_DELETE );
			//stmt.setInt( 1, pk.getIdDescripcion() );
			int rows = stmt.executeUpdate();
			long t2 = System.currentTimeMillis();
			System.out.println( rows + " rows affected (" + (t2-t1) + " ms)" );
		}
		catch (Exception _e) {
			_e.printStackTrace();
			throw new EstanteriaDescripcionDaoException( "Exception: " + _e.getMessage(), _e );
		}
		finally {
			ResourceManager.close(stmt);
			if (!isConnSupplied) {
				ResourceManager.close(conn);
			}
		
		}
}
}
