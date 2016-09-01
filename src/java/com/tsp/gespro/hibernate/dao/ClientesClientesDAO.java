/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.tsp.gespro.hibernate.dao;
import com.tsp.gespro.hibernate.pojo.ClientesClientes;
import com.tsp.gespro.hibernate.pojo.HibernateUtil;
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
    public List exist(String where) throws HibernateException 
    { 
        List<ClientesClientes> lista = null; 
        int id=0;

        try 
        { 
            iniciaOperacion(); 
            lista = sesion.createQuery("from ClientesClientes "+where).list();
        }
        finally 
        { 
            sesion.close(); 
        }  

        return lista; 
    }
   
    public String clientesIdMatriz() throws HibernateException 
    { 
        List<ClientesClientes> lista = null; 
        String idClientes="";

        try 
        { 
            iniciaOperacion(); 
            lista = sesion.createQuery("from ClientesClientes where cliente_id=cliente_sucursal_id ").list();
            if(lista!=null && lista.size()>0){
              for(ClientesClientes obj: lista){
                  idClientes+=obj.getClienteId()+",";
              }
              idClientes+=idClientes.substring(0,idClientes.length()-1);
            }
            
        }
        finally 
        { 
            sesion.close(); 
        }  

        return idClientes; 
    }
    
    
    public void crearRelacionClientes(int idCliente,int idClienteSucursal, int tipo){
        
        // Eliminamos todos los registros existentes con estos clientes.
        String where="where cliente_id="+idCliente+" AND cliente_sucursal_id="+idCliente;
        where+="OR cliente_id="+idCliente;
        List<ClientesClientes> relacionesExistentes= exist(where);
        for(ClientesClientes relacion:relacionesExistentes){
            System.out.print("Borrando " + relacion.getId());
            eliminar(relacion.getId());
        }
        
        System.out.print("Params");
        System.out.print(idCliente);
        System.out.print(idClienteSucursal);
        System.out.print(tipo);
        // Si es 1 quiere decir, que es matriz
       if(tipo==1){
            System.out.print("Entra a uno");
            ClientesClientes relacionClientes=new ClientesClientes();
            relacionClientes.setClienteId(idCliente);
            relacionClientes.setClienteSucursalId(idCliente);
            guardar(relacionClientes);
       }
       
       // Si es 0 quiere decir que no es matriz y tienen su sucursal matriz.
       if(tipo==0){
           System.out.print("Entra a 0");
            ClientesClientes relacionClientes=new ClientesClientes();
            relacionClientes.setClienteId(idCliente);
            relacionClientes.setClienteSucursalId(idClienteSucursal);
            guardar(relacionClientes);
        }
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
