package javafxapplication2;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.CallableStatement;
import java.sql.Date;
import java.sql.Time;
import java.time.LocalDate;


/**
 * Conexion a la base de datos.
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
     * @throws java.lang.Exception
     */
    public void conectar()
            throws Exception {
        
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            String connectionUrl = "jdbc:sqlserver://192.168.0.37;" + //o la ip del servidor y su puerto
                                    "databaseName=semovi;" +
                                    "user=sa;" +
                                    "password=12345"; 
            con = DriverManager.getConnection(connectionUrl);
        } catch (ClassNotFoundException | SQLException e) {
            System.out.println("SQLException: " + e.getMessage() + " conectar =(");
        }
    }

    /**
     * Metodo que nos permite cerrar la conexion con la base de datos.
     * El método debe ser invocado en la capa de Control.
     * @throws java.sql.SQLException
     */
    public void desconectar()
            throws SQLException {
        try {
            con.close();
        } catch (SQLException e) {
            System.out.println("SQLException: " + e.getMessage() + " desconectar =(");
        }
    }
    
    public static void regPlaca (String plate, LocalDate date, String rfc, String serial) throws SQLException {
        Connection dbConnection = null;
	CallableStatement callableStatement = null;

        Date sqlDate = Date.valueOf(date);
        
	String getDBUSERByUserIdSql = "{call expPlaca(?,?,?,?)}";

	try {
            Conexion conex = new Conexion();
            conex.conectar();
            dbConnection = conex.con;
            callableStatement = dbConnection.prepareCall(getDBUSERByUserIdSql);

            callableStatement.setString(1, plate);
            callableStatement.setDate(2, sqlDate);
            callableStatement.setString(3, rfc);
            callableStatement.setString(4, serial);

            // execute getDBUSERByUserId store procedure
            callableStatement.executeUpdate();

        } catch (Exception e) {

            System.out.println(e.getMessage());

        } finally {

            if (callableStatement != null) {
                callableStatement.close();
            }

            if (dbConnection != null) {
                dbConnection.close();
            }
	}
    }
    
    public static void regTarjeta (int vig, LocalDate date, String plate, String rfc) throws SQLException {
        Connection dbConnection = null;
	CallableStatement callableStatement = null;

        Date sqlDate = Date.valueOf(date);
        
	String getDBUSERByUserIdSql = "{call expTarjeta(?,?,?,?)}";

	try {
            Conexion conex = new Conexion();
            conex.conectar();
            dbConnection = conex.con;
            callableStatement = dbConnection.prepareCall(getDBUSERByUserIdSql);

            callableStatement.setInt(1, vig);
            callableStatement.setDate(2, sqlDate);
            callableStatement.setString(3, plate);
            callableStatement.setString(4, rfc);

            // execute getDBUSERByUserId store procedure
            callableStatement.executeUpdate();

        } catch (Exception e) {

            System.out.println(e.getMessage());

        } finally {

            if (callableStatement != null) {
                callableStatement.close();
            }

            if (dbConnection != null) {
                dbConnection.close();
            }
	}
    }
    
    public static void regLicencia (String tipo, String vigencia, String rfc, LocalDate date) throws SQLException {
        Connection dbConnection = null;
	CallableStatement callableStatement = null;

        Date sqlDate = Date.valueOf(date);
        
	String getDBUSERByUserIdSql = "{call expLicencia(?,?,?,?)}";

	try {
            Conexion conex = new Conexion();
            conex.conectar();
            dbConnection = conex.con;
            callableStatement = dbConnection.prepareCall(getDBUSERByUserIdSql);

            callableStatement.setString(1, tipo);
            callableStatement.setString(2, vigencia);
            callableStatement.setDate(3, sqlDate);
            callableStatement.setString(4, rfc);

            // execute getDBUSERByUserId store procedure
            callableStatement.executeUpdate();

        } catch (Exception e) {

            System.out.println(e.getMessage());

        } finally {

            if (callableStatement != null) {
                callableStatement.close();
            }

            if (dbConnection != null) {
                dbConnection.close();
            }
	}
    }
    
    public static void regMultaAgente (LocalDate date, int hour, int min, int art, Float money,
        String street, String num, String col, String zc, String numRegPer, int lic, int card) throws SQLException {
        Connection dbConnection = null;
	CallableStatement callableStatement = null;

        Date sqlDate = Date.valueOf(date);
        Time time = new Time(hour, min, 0);
        
	String getDBUSERByUserIdSql = "{call regMultaAgente(?,?,?,?,?,?,?,?,?,?,?)}";

	try {
            Conexion conex = new Conexion();
            conex.conectar();
            dbConnection = conex.con;
            callableStatement = dbConnection.prepareCall(getDBUSERByUserIdSql);

            callableStatement.setDate(1, sqlDate);
            callableStatement.setTime(2, time);
            callableStatement.setInt(3, art);
            callableStatement.setFloat(4, money);
            callableStatement.setString(5, street);
            callableStatement.setString(6, num);
            callableStatement.setString(7, col);
            callableStatement.setString(8, zc);
            callableStatement.setString(9, numRegPer);
            callableStatement.setInt(10, lic);
            callableStatement.setInt(11, card);

            // execute getDBUSERByUserId store procedure
            callableStatement.executeUpdate();

        } catch (Exception e) {

            System.out.println(e.getMessage());

        } finally {

            if (callableStatement != null) {
                callableStatement.close();
            }

            if (dbConnection != null) {
                dbConnection.close();
            }
	}
    }
    
    public static ResultSet preCon(int con) throws SQLException{
        Connection dbConnection = null;
	CallableStatement callableStatement = null;
        ResultSet ret = null;
        
        String proc = "{CALL c" + con + "}";
        
	try {
            Conexion conex = new Conexion();

            conex.conectar();

            dbConnection = conex.con;

            callableStatement = dbConnection.prepareCall(proc);

            callableStatement.execute();
            ret = callableStatement.getResultSet();

                        
            
        } catch (Exception e) {

            System.out.println(e.getMessage());

        } finally {
			/*
			//No cerrar porque crashea Windows y se muere tu perro.
            if (callableStatement != null) {
                callableStatement.close();
            }
			
            if (dbConnection != null) {
                dbConnection.close();
            }
            */
	}
        return ret;
    }

    /**
     * Llama al procedure para consultas multas
     * @param param El parámetro del procedure, ya sea el RFC o la Placa
     */
    public static ResultSet getMultas(String param) throws SQLException{
        Connection dbConnection = null;
    CallableStatement callableStatement = null;
        ResultSet ret = null;
        
        String proc = "{CALL Multas(?)}";
        
    try {
            Conexion conex = new Conexion();

            conex.conectar();

            dbConnection = conex.con;

            callableStatement = dbConnection.prepareCall(proc);
            callableStatement.setString(1,param);

            callableStatement.execute();
            ret = callableStatement.getResultSet();

                        
            
        } catch (Exception e) {

            System.out.println(e.getMessage());

        } finally {
            /*
            //No cerrar porque crashea Windows y se muere tu perro.
            if (callableStatement != null) {
                callableStatement.close();
            }
            
            if (dbConnection != null) {
                dbConnection.close();
            }
            */
    }
        return ret;
    }
}