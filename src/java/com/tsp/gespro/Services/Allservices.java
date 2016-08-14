package com.tsp.gespro.Services;

import java.util.List;

import com.tsp.gespro.hibernate.pojo.HibernateUtil;
import org.hibernate.Session;
import com.tsp.gespro.hibernate.pojo.Promotorproyecto;
import com.tsp.gespro.hibernate.dao.PromotorproyectoDAO;
import com.tsp.gespro.hibernate.pojo.Producto;
import com.tsp.gespro.hibernate.dao.ProductoDAO;
import com.tsp.gespro.hibernate.pojo.Usuarios;
import com.tsp.gespro.hibernate.pojo.Proyecto;
import com.tsp.gespro.hibernate.dao.UsuariosDAO;
import com.tsp.gespro.hibernate.dao.ProyectoDAO;
import com.tsp.gespro.hibernate.pojo.Producto;
import org.hibernate.Session;
import org.hibernate.Transaction;

public class Allservices {
    
    private static PromotorproyectoDAO promotorproyectoDAO;
    private static UsuariosDAO usuariosDAO;
    private static ProyectoDAO proyectoDAO;    
    private static ProductoDAO productoDAO;

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
    
    public List queryProyectoDAO(String where) {

        List<Proyecto> lista = null;
        Session session = null;

        try {
            session = HibernateUtil.getSessionFactory().openSession();
            Transaction tx = session.beginTransaction();
            String query = "from Proyecto " + where;
            lista = session.createQuery(query).list();
        } finally {
            session.close();
        }
        
        return lista;
    }
    
    public List queryPromotorProyectoDAO(String where) {

        List<Promotorproyecto> lista = null;
        Session session = null;

        try {
            session = HibernateUtil.getSessionFactory().openSession();
            Transaction tx = session.beginTransaction();
            String query = "from Promotorproyecto " + where;
            lista = session.createQuery(query).list();
        } finally {
            session.close();
        }
        
        return lista;
    }

    public List QueryProductosDAO(String where){  
        
            List<Producto> lista = null;  
            Session session = null;

        try 
        { 
            session = HibernateUtil.getSessionFactory().openSession(); 
            Transaction tx = session.beginTransaction(); 
            String query = "from Producto "+where;
            lista = session.createQuery(query).list(); 
        }
        finally 
        { 
            session.close(); 
        }  

        return lista; 
    }
}
