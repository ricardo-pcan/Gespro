/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.tsp.gespro.hibernate.dao;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;
import com.tsp.gespro.hibernate.pojo.UsuarioMonitor;
import com.tsp.gespro.hibernate.pojo.HibernateUtil;
import java.util.List;

/**
 *
 * @author gloria
 */
public class UsuarioMonitorDAO {
    
    private Session sesion; 
    private Transaction tx;  

    public long guardar(UsuarioMonitor object) throws HibernateException 
    { 
        long id = 0;  

        try 
        { 
            iniciaOperacion(); 
            id = (Long) sesion.save(object); 
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

    public void actualizar(UsuarioMonitor object) throws HibernateException 
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

    public void elimina(UsuarioMonitor object) throws HibernateException 
    { 
        try 
        { 
            iniciaOperacion(); 
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

    public UsuarioMonitor get(long id) throws HibernateException 
    { 
        UsuarioMonitor object = null;  
        try 
        { 
            iniciaOperacion(); 
            object = (UsuarioMonitor) sesion.get(UsuarioMonitor.class, id); 
        } finally 
        { 
            sesion.close(); 
        }  

        return object; 
    }  

    public List lista() throws HibernateException 
    { 
        List<UsuarioMonitor> lista = null;  

        try 
        { 
            iniciaOperacion(); 
            lista = sesion.createQuery("from UsuarioMonitor").list(); 
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
