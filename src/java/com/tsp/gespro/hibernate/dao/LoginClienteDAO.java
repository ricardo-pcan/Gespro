/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.tsp.gespro.hibernate.dao;

import com.tsp.gespro.bo.ClienteBO;
import com.tsp.gespro.dto.Cliente;
import com.tsp.gespro.dto.DatosUsuario;
import com.tsp.gespro.dto.DatosUsuarioPk;
import com.tsp.gespro.dto.Estatus;
import com.tsp.gespro.dto.Ldap;
import com.tsp.gespro.dto.LdapPk;
import com.tsp.gespro.dto.Roles;
import com.tsp.gespro.hibernate.pojo.HibernateUtil;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;
import com.tsp.gespro.hibernate.pojo.LoginCliente;
import com.tsp.gespro.hibernate.pojo.UsuarioMonitor;
import com.tsp.gespro.hibernate.pojo.Usuarios;
import com.tsp.gespro.jdbc.DatosUsuarioDaoImpl;
import com.tsp.gespro.jdbc.EstatusDaoImpl;
import com.tsp.gespro.jdbc.LdapDaoImpl;
import com.tsp.gespro.jdbc.RolesDaoImpl;
import com.tsp.gespro.mail.TspMailBO;
import com.tsp.gespro.util.Encrypter;
import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.sql.Connection;
import java.util.Date;
import java.util.HashMap;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author edgar
 */
public class LoginClienteDAO {

    private Session sesion;
    private Transaction tx;
    private Connection conn;

    public LoginClienteDAO(Connection conn) {
        this.conn = conn;
    }

    public LoginClienteDAO() {
    }

    public String guardarCambios(String userName, String password, int idCliente) {
        LoginCliente loginCliente = getByIdCliente(idCliente);
        UsuariosDAO usuariosDAO = new UsuariosDAO();
        LdapDaoImpl ldi = new LdapDaoImpl(conn);
        DatosUsuarioDaoImpl datosUsuarioDaoImpl = new DatosUsuarioDaoImpl(conn);
        ClienteBO clienteBO = new ClienteBO(conn);
        Cliente clientesDto = null;
        clienteBO = new ClienteBO(idCliente, conn);
        clientesDto = clienteBO.getCliente();
        EstatusDaoImpl estatusDaoImpl = new EstatusDaoImpl(conn);
        Encrypter datoEnc =  new Encrypter();
        datoEnc.setMd5(true);
        String pwdCodificado="";
        try {
            pwdCodificado = datoEnc.encodeString2(password);
        } catch (IOException ex) {
            Logger.getLogger(LoginClienteDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        if (loginCliente != null) {
            System.out.println("idCliente: "+loginCliente.getIdCliente());
            System.out.println("idUsuario: "+loginCliente.getIdUsuario());
            Usuarios usuario = usuariosDAO.getById(loginCliente.getIdUsuario());
            Ldap ldap;
            try {
                ldap = ldi.findByPrimaryKey(usuario.getIdLdap());
                ldap.setPassword(pwdCodificado);
                ldi.update(ldap.createPk(), ldap);
            } catch (Exception e) {
                e.printStackTrace();
                return "Error al crear credenciales";
            }
            usuario.setUserName(userName);
            usuariosDAO.actualizar(usuario);
        } else {
            Usuarios usuario = new Usuarios();
            RolesDaoImpl rolesDaoImpl = new RolesDaoImpl(conn);
            try {
                Roles rol = rolesDaoImpl.findWhereNombreEquals("CLIENTE")[0];
                Ldap ldap = new Ldap();                
                ldap.setPassword(pwdCodificado);
                ldap.setUsuario(userName);
                ldap.setFirmado(0);
                LdapPk ldapPk = ldi.insert(ldap);
                DatosUsuario datosUsuario = new DatosUsuario();
                datosUsuario.setNombre(clientesDto.getNombreComercial());
                datosUsuario.setCorreo(clientesDto.getCorreo());
                datosUsuario.setTelefono(clientesDto.getTelefono());
                DatosUsuarioPk usuarioPk = datosUsuarioDaoImpl.insert(datosUsuario);
                Estatus estatus = estatusDaoImpl.findWhereNombreEquals("ACTIVO")[0];
                usuario.setIdLdap(ldapPk.getIdLdap());
                usuario.setUserName(userName);
                usuario.setIdRoles(rol.getIdRoles());
                usuario.setIdEmpresa(clientesDto.getIdEmpresa());
                usuario.setFechaUltimoAcceso(new Date());
                usuario.setIdDatosUsuario(usuarioPk.getIdDatosUsuario());
                usuario.setIdEstatus(estatus.getIdEstatus());
                int idUsuario = usuariosDAO.guardar(usuario);
                loginCliente = new LoginCliente(idCliente, idUsuario);
                guardar(loginCliente);
            } catch (Exception e) {
                e.printStackTrace();
                return "Error al crear credenciales";
            }

        }
        String email = clientesDto.getCorreo();
        enviarCorreoConCredenciales(userName, password, email);
        return "";
    }

    public Ldap getCredenciales(int idCliente) {
        Ldap ldap = null;
        LoginCliente loginCliente = getByIdCliente(idCliente);
        UsuariosDAO usuariosDAO = new UsuariosDAO();
        try {
            System.out.println("idCliente: "+loginCliente.getIdCliente());
            System.out.println("idUsuario: "+loginCliente.getIdUsuario());
            if (loginCliente != null) {
                Usuarios usuario = usuariosDAO.getById(loginCliente.getIdUsuario());
                LdapDaoImpl ldi = new LdapDaoImpl(conn);
                ldap=ldi.findByPrimaryKey(usuario.getIdLdap());
            } else {
                return null;
            }

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
        return ldap;
    }

    public void enviarCorreoConCredenciales(String username, String password, String email) {
        try {
            TspMailBO mail = new TspMailBO();
            //String contenido ="<b>Tus credenciales :</b><br/><br/>Usuario: <h3>"+ obj.getEmail() +"</h3><br/>Password: <h3>"+ obj.getPassword()+"</h3>";
            Map<String, String> input = new HashMap<String, String>();
            input.put("Usuario1", username);
            input.put("Pass1", password);
            String workingDir = System.getProperty("user.dir");
            String contenido = readEmailFromHtml(workingDir + "/web/WEB-INF/templates/correo-GESPRO.HTML", input);
            if (!contenido.isEmpty()) {
                try {
                    String correoContacto = email;
                    mail.addTo(correoContacto, correoContacto);
                } catch (Exception e) {
                }
                mail.setConfigurationMovilpyme();
                mail.addMessageMovilpyme(contenido, 1);
                mail.setFrom(mail.getUSER(), mail.getFROM_NAME());
                mail.send("Hola, tenemos tus credenciales GESPRO! " + username);
                System.out.println("Enviando correo....");
            }
        } catch (Exception ex) {
            System.out.println("No se pudo enviar el correo de credenciales. Error: " + ex.getMessage());
        }
    }

    //Method to replace the values for keys
    protected String readEmailFromHtml(String filePath, Map<String, String> input) throws FileNotFoundException {
        String msg = readContentFromFile(filePath);
        try {
            Set<Map.Entry<String, String>> entries = input.entrySet();
            for (Map.Entry<String, String> entry : entries) {
                msg = msg.replace(entry.getKey().trim(), entry.getValue().trim());
            }
        } catch (Exception ex) {
            System.out.println("Error al leer el template. Error: " + ex.getMessage());
        }
        return msg;
    }

    private String readContentFromFile(String fileName) {
        StringBuilder contents = new StringBuilder();

        try {
            try (BufferedReader reader = new BufferedReader(new FileReader(fileName))) {
                String line = null;
                while ((line = reader.readLine()) != null) {
                    contents.append(line);
                    contents.append(System.getProperty("line.separator"));
                }
            }
        } catch (IOException ex) {
            System.out.println("Error al leer el template. Error: " + ex.getMessage());
        }
        return contents.toString();
    }

    public Integer guardar(LoginCliente object) throws HibernateException {
        Integer id = 0;
        try {
            iniciaOperacion();
            id = (Integer) sesion.save(object);
            tx.commit();
        } catch (HibernateException he) {
            manejaExcepcion(he);
            throw he;
        } finally {
            sesion.close();
        }

        return id;
    }

    public void actualizar(LoginCliente object) throws HibernateException {
        try {

            iniciaOperacion();
            sesion.update(object);
            tx.commit();

        } catch (HibernateException he) {
            manejaExcepcion(he);
            throw he;
        } finally {
            sesion.close();
        }
    }

    public void eliminar(int id) throws HibernateException {
        try {
            iniciaOperacion();
            LoginCliente object = (LoginCliente) sesion.get(LoginCliente.class, id);
            sesion.delete(object);
            tx.commit();
        } catch (HibernateException he) {
            manejaExcepcion(he);
            throw he;
        } finally {
            sesion.close();
        }
    }

    public LoginCliente getById(int id) throws HibernateException {

        LoginCliente object = null;
        try {
            iniciaOperacion();
            object = (LoginCliente) sesion.get(LoginCliente.class, id);
        } finally {
            sesion.close();
        }

        return object;
    }

    public LoginCliente getByIdCliente(int idCliente) throws HibernateException {

        LoginCliente object = null;
        try {
            iniciaOperacion();
            object = (LoginCliente) sesion.createQuery("from LoginCliente where idCliente=:idCliente").
                    setParameter("idCliente", idCliente).uniqueResult();
        } finally {
            sesion.close();
        }

        return object;
    }
    public LoginCliente getByIdUsuario(int idUsuario) throws HibernateException {

        LoginCliente object = null;
        try {
            iniciaOperacion();
            object = (LoginCliente) sesion.createQuery("from LoginCliente where idUsuario=:idUsuario").
                    setParameter("idUsuario", idUsuario).uniqueResult();
        } finally {
            sesion.close();
        }

        return object;
    }

    public List lista(int idUsuario) throws HibernateException {
        List<LoginCliente> lista = null;

        try {
            iniciaOperacion();
            lista = sesion.createQuery("from LoginCliente where idUsuario=:idUsuario").setParameter("idUsuario", idUsuario).list();
        } finally {
            sesion.close();
        }

        return lista;
    }

    public List getLista(int idUsuario) {
        return lista(idUsuario);
    }

    private void iniciaOperacion() throws HibernateException {
        sesion = HibernateUtil.getSessionFactory().openSession();
        tx = sesion.beginTransaction();
    }

    private void manejaExcepcion(HibernateException he) throws HibernateException {
        tx.rollback();
        throw new HibernateException("Ocurrió un error en la capa de acceso a datos", he);
    }
}
