/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.tsp.gespro.hibernate.dao;

import com.tsp.gespro.Services.Allservices;
import com.tsp.gespro.hibernate.pojo.Cliente;
import com.tsp.gespro.hibernate.pojo.ClientesClientes;
import com.tsp.gespro.hibernate.pojo.HibernateUtil;
import java.util.AbstractList;
import java.util.ArrayList;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author gloria
 */
public class ClientesClientesDAO {
    private Session sesion; 
    private Transaction tx;  
    
    public ClientesClientesDAO(){
    }
    
    public Integer guardar(ClientesClientes object) throws HibernateException
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

    public void actualizar(ClientesClientes object) throws HibernateException 
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
            ClientesClientes object = (ClientesClientes) sesion.get(ClientesClientes.class,id); 
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

    public ClientesClientes getById(int id) throws HibernateException 
    { 
       
        ClientesClientes object = null;  
        try 
        { 
            iniciaOperacion(); 
            object = (ClientesClientes) sesion.get(ClientesClientes.class,id);
        } finally 
        { 
            sesion.close(); 
        }  

        return object; 
    }  

    public List lista() throws HibernateException 
    { 
        List<ClientesClientes> lista = null;  

        try 
        { 
            iniciaOperacion(); 
            lista = sesion.createQuery("from ClientesClientes").list(); 
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
    /***
     * Verifica si ya existe un registro similar, de ser así, regresa el id
     * de lo contrario, regresa un 0.
     ***/
    public int exist(String where) throws HibernateException 
    { 
        List<ClientesClientes> lista = null; 
        int id=0;

        try 
        { 
            iniciaOperacion(); 
            lista = sesion.createQuery("from ClientesClientes "+where).list();
            if(lista!=null){
                if(lista.size()>0){
                    return lista.get(0).getId();
                }
            }
        }
        finally 
        { 
            sesion.close(); 
        }  

        return id; 
    }
   
    public String ClientesIdMatriz() throws HibernateException 
    { 
        List<ClientesClientes> lista = null; 
        String idClientes="";

        try 
        { 
            iniciaOperacion(); 
            lista = sesion.createQuery("from ClientesClientes where cliente_id=cliente_sucursal_id ").list();
            if(lista!=null){
              for(ClientesClientes obj: lista){
                  idClientes+=obj.getClienteId()+",";
              }  
            }
            idClientes+=idClientes.substring(0,idClientes.length()-1);
        }
        finally 
        { 
            sesion.close(); 
        }  

        return idClientes; 
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
