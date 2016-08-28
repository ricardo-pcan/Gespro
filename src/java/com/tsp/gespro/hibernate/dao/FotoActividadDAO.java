/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.tsp.gespro.hibernate.dao;

import com.tsp.gespro.hibernate.pojo.FotoActividad;
import com.tsp.gespro.hibernate.pojo.HibernateUtil;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author gloria
 */
public class FotoActividadDAO {
    private Session sesion; 
    private Transaction tx;  
    
    public FotoActividadDAO(){
    }
    
    public Integer guardar(FotoActividad object) throws HibernateException 
    { 
        Integer id = 0;  
        try 
        { 
            iniciaOperacion();
            id= (Integer) sesion.save(object); 
            tx.commit(); 
        } catch (HibernateException he) 
        { 
            manejaExcepcion(he); 
            throw he; 
        } finally 
        { 
            sesion.close(); 
        }  

        return id; 
    }  

    public void actualizar(FotoActividad object) throws HibernateException 
    { 
        try 
        { 
            
            iniciaOperacion(); 
            sesion.update(object); 
            tx.commit(); 
            
        } catch (HibernateException he) 
        { 
            manejaExcepcion(he); 
            throw he; 
        } finally 
        { 
            sesion.close(); 
        } 
    }  

    public void eliminar(int id) throws HibernateException 
    { 
        try 
        { 
            iniciaOperacion(); 
            FotoActividad object = (FotoActividad) sesion.get(FotoActividad.class,id); 
            sesion.delete(object); 
            tx.commit(); 
        } catch (HibernateException he) 
        {   
            manejaExcepcion(he); 
            throw he; 
        } finally 
        { 
            sesion.close(); 
        } 
    }  

    public FotoActividad getById(int id) throws HibernateException 
    { 
       
        FotoActividad object = null;  
        try 
        { 
            iniciaOperacion(); 
            object = (FotoActividad) sesion.get(FotoActividad.class,id);
        } finally 
        { 
            sesion.close(); 
        }  

        return object; 
    }  

    public List lista() throws HibernateException 
    { 
        List<FotoActividad> lista = null;  

        try 
        { 
            iniciaOperacion(); 
            lista = sesion.createQuery("from FotoActividad").list(); 
        }
        finally 
        { 
            sesion.close(); 
        }  

        return lista; 
    }
  
    public List getLista()
    { 
        return lista(); 
    }    
     
    private void iniciaOperacion() throws HibernateException 
    { 
        sesion = HibernateUtil.getSessionFactory().openSession(); 
        tx = sesion.beginTransaction(); 
    }  

    private void manejaExcepcion(HibernateException he) throws HibernateException 
    { 
        tx.rollback(); 
        throw new HibernateException("Ocurrió un error en la capa de acceso a datos", he); 
    }
}
