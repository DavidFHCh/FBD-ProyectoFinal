
import control.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

/**
 * Conexión a la base de datos.
 * @author Turbo Solutions
 */
public class Conexion {
    
    //Objetos para la comunicacion y ejecucion de consultas SQL
    private Connection con;
    private Statement stmt;
    private ResultSet rs;
    
    //Constructor vacío
    public Conexion() {
        stmt = null;
        con = null;
        rs = null;
    }

    /**
     * Metodo que nos abre la conexion con una base de datos 
     * específica.
     */
    public void conectar()
            throws Exception {
        
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            String connectionUrl = "jdbc:sqlserver://localhost;" + //o la ip del servidor y su puerto
                                    "databaseName=semovi;" +
                                    "user=sa;" +
                                    "password=huevos1"; 
            con = DriverManager.getConnection(connectionUrl);
        } catch (ClassNotFoundException | SQLException e) {
            System.out.println("SQLException: " + e.getMessage() + " conectar =(");
        }
    }

    /**
     * Metodo que nos permite cerrar la conexion con la base de datos.
     * El método debe ser invocado en la capa de Control.
     */
    public void desconectar()
            throws SQLException {
        try {
            con.close();
        } catch (SQLException e) {
            System.out.println("SQLException: " + e.getMessage() + " desconectar =(");
        }
    }

}
