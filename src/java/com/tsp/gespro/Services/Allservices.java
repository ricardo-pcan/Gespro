package com.tsp.gespro.Services;

import java.util.List;

import com.tsp.gespro.hibernate.pojo.HibernateUtil;
import org.hibernate.Session;
import com.tsp.gespro.hibernate.pojo.Promotorproyecto;
import com.tsp.gespro.hibernate.dao.PromotorproyectoDAO;
import com.tsp.gespro.hibernate.pojo.Usuarios;
import com.tsp.gespro.hibernate.dao.UsuariosDAO;
import org.hibernate.Session;
import org.hibernate.Transaction;

public class Allservices {
    
    private static PromotorproyectoDAO promotorproyectoDAO;
    private static UsuariosDAO usuariosDAO;

    public Allservices() {
    }
    
    public List QueryPromotorProyecto(String where){  
        
            List<Promotorproyecto> lista = null;  
            Session session = null;

        try 
        { 
            session = HibernateUtil.getSessionFactory().openSession(); 
            Transaction tx = session.beginTransaction(); 
            String query = "from Promotorproyecto "+where;
            lista = session.createQuery(query).list(); 
        }
        finally 
        { 
            session.close(); 
        }  

        return lista; 
    }
    
    
    public List QueryUsuariosDAO(String where){  
        
            List<Usuarios> lista = null;  
            Session session = null;

        try 
        { 
            session = HibernateUtil.getSessionFactory().openSession(); 
            Transaction tx = session.beginTransaction(); 
            String query = "from Usuarios "+where;
            lista = session.createQuery(query).list(); 
        }
        finally 
        { 
            session.close(); 
        }  

        return lista; 
    }
    
}
