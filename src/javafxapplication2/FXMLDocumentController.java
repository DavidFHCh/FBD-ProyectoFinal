/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package javafxapplication2;

import java.sql.SQLException;
import java.net.URL;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.util.ResourceBundle;
import javafx.beans.property.SimpleStringProperty;
import javafx.beans.value.ObservableValue;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.*;
import javafx.scene.control.Alert.AlertType;
import javafx.scene.control.TableColumn.CellDataFeatures;
import javafx.util.Callback;

/**
 *
 * @author Davif
 */
public class FXMLDocumentController implements Initializable {
    
    //Pestana ConsultasPredefinidas
    @FXML private MenuButton tiposConsultas;
    @FXML private MenuItem consul1;
    @FXML private MenuItem consul2;
    @FXML private MenuItem consul3;
    @FXML private MenuItem consul4;
    @FXML private MenuItem consul5;
    @FXML private MenuItem consul6;
    @FXML private MenuItem consul7;
    @FXML private MenuItem consul8;
    @FXML private MenuItem consul9;
    @FXML private MenuItem consul10;
    @FXML private MenuItem consul11;
    @FXML private MenuItem consul12;
    @FXML private MenuItem consul13;
    @FXML private MenuItem consul14;
    @FXML private MenuItem consul15;
    @FXML private TableView resultadosPredefinidos;
    
    //Pestana ConsultarMultas
    @FXML private TextField rfcConsulta;
    @FXML private TextField numPlacaConsulta;
    @FXML private Button botonConsultar;
    @FXML private TableView tablaMultas;
    
    //Pestana RegistrarLicencia
    @FXML private TextField rfcRegMult;
    @FXML private TextField vigenLic;
    @FXML private Button botonAgregar1;
    @FXML private RadioButton tipoA;
    @FXML private RadioButton tipoB;
    @FXML private RadioButton tipoC;
    @FXML private RadioButton tipoD;
    @FXML private RadioButton tipoE;
    @FXML private DatePicker fechaVencimiento;
    
    //Pestana RegistrarMultas
    @FXML private TextField numExpediente;
    @FXML private TextField artInfrigido;
    @FXML private TextField importe;
    @FXML private TextField numAgente;
    @FXML private TextField numLicencia;
    @FXML private TextField numTarjeta;
    @FXML private TextField colonia;
    @FXML private TextField calle;
    @FXML private TextField cp;
    @FXML private TextField num;
    @FXML private TextField hora;
    @FXML private TextField minutos;
    @FXML private DatePicker fecha;
    @FXML private Button botonAgregar2;
    
    //Pestana RegistrarPlaca
    @FXML private TextField rfcPlaca;
    @FXML private TextField serialPlaca;
    @FXML private TextField numPlaca1;
    @FXML private DatePicker emisionPlaca;       
    @FXML private Button botonAgregar3;
    
    //Pestana Registrartarjeta
    @FXML private TextField rfcTarjeta;
    @FXML private TextField placaTarjeta;
    @FXML private TextField vigTarjeta;
    @FXML private DatePicker emisionTarjeta;       
    @FXML private Button botonAgregar4;
    
    
    @FXML
    private void botonConsultar(ActionEvent event) {
        String rfc = rfcConsulta.getCharacters().toString();
        String numPlaca = numPlacaConsulta.getCharacters().toString();
        //aqui llama el metodo que le corresponda del controlador.
        String param;
        param = (!rfc.equals("")) ? rfc : numPlaca;

        try {
            llenaTableView(Conexion.getMultas(param),tablaMultas );
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        
    }
    
    @FXML
    private void botonAgregar1(ActionEvent event) {
        String rfc = rfcRegMult.getCharacters().toString();
        String vigenciaLic = vigenLic.getCharacters().toString();
        String tipo = "";
        if(tipoA.isSelected()){
            tipo = "A";
        }else{
            if(tipoB.isSelected()){
                tipo = "B";
            }else{
                if(tipoC.isSelected()){
                     tipo = "C";
                }else{
                    if(tipoD.isSelected()){
                        tipo = "D";
                    }else{
                        if(tipoE.isSelected()){
                            tipo = "E";
                        }else{
                            alerta("Intenta Otra Vez","No seleccionaste algun tipo de Licencia.");
                        }
                    }
                }
            }
        }
        
        LocalDate fVen = fechaVencimiento.getValue();
        
        // Llamada a BD
        try {
            Conexion.regLicencia(tipo, vigenciaLic, rfc, fVen);
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }
    
    @FXML
    private void botonAgregar2(ActionEvent event) {
        String numExp = numExpediente.getCharacters().toString();
        String artInfringido = artInfrigido.getCharacters().toString();
        int art = Integer.parseInt(artInfringido);
        String simporte = importe.getCharacters().toString();
        Float importe = Float.parseFloat(simporte);
        String snumAgente = numAgente.getCharacters().toString();
        String snumLicencia = numLicencia.getCharacters().toString();
        String snumTarjeta = numTarjeta.getCharacters().toString();
        int numLicencia = Integer.parseInt(snumLicencia);
        int numTarjeta = Integer.parseInt(snumTarjeta);
        String scolonia = colonia.getCharacters().toString();
        String scalle = calle.getCharacters().toString();
        String scp = cp.getCharacters().toString();
        String snum = num.getCharacters().toString();
        
        if (snum.equals(""))
            snum = "NULL";
        
        String shora = hora.getCharacters().toString();
        String sminutos = minutos.getCharacters().toString();
        int ihora = Integer.parseInt(shora);
        int iminutos = Integer.parseInt(sminutos);
        
        LocalDate sfecha = fecha.getValue();
        
        // Llamada a BD
        try {
            Conexion.regMultaAgente(sfecha, ihora, iminutos, art, importe, scalle, snum, scolonia, 
                scp, snumAgente, numLicencia, numTarjeta);
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }
  
    @FXML
    private void botonAgregar3(ActionEvent event){
         LocalDate sfecha = emisionPlaca.getValue();
         String rfc = rfcPlaca.getCharacters().toString();
         String numplaca = serialPlaca.getCharacters().toString();
         String serial = numPlaca1.getCharacters().toString();
         
         // Llamada a BD
        try {
            Conexion.regPlaca(numplaca, sfecha, rfc, serial);
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }
    
    @FXML
    private void botonAgregar4(ActionEvent event){
         LocalDate sfecha = emisionTarjeta.getValue();
         String rfc = rfcTarjeta.getCharacters().toString();
         String numplaca = placaTarjeta.getCharacters().toString();
         int serial = Integer.parseInt(vigTarjeta.getCharacters().toString());
         
         // Llamada a BD
        try {
            Conexion.regTarjeta(serial, sfecha, numplaca, rfc);
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }
    
    
    //en todos estos se va a llamarel metodo llenaTableView, con el respectivo resultset.
    @FXML
    private void botonConsulta1(ActionEvent event) {
        try {
            llenaTableView(Conexion.preCon(1), resultadosPredefinidos);
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }
    
     @FXML
    private void botonConsulta2(ActionEvent event) {
        try {
            llenaTableView(Conexion.preCon(2), resultadosPredefinidos);
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }
    
     @FXML
    private void botonConsulta3(ActionEvent event) {
        try {
            llenaTableView(Conexion.preCon(3), resultadosPredefinidos);
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }
    
     @FXML
    private void botonConsulta4(ActionEvent event) {
        try {
            llenaTableView(Conexion.preCon(4), resultadosPredefinidos);
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }
    
     @FXML
    private void botonConsulta5(ActionEvent event) {
        try {
            llenaTableView(Conexion.preCon(5), resultadosPredefinidos);
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }
    
     @FXML
    private void botonConsulta6(ActionEvent event) {
        try {
            llenaTableView(Conexion.preCon(6), resultadosPredefinidos);
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }
    
     @FXML
    private void botonConsulta7(ActionEvent event) {
        try {
            llenaTableView(Conexion.preCon(7), resultadosPredefinidos);
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }
    
     @FXML
    private void botonConsulta8(ActionEvent event) {
        try {
            llenaTableView(Conexion.preCon(8), resultadosPredefinidos);
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }
    
     @FXML
    private void botonConsulta9(ActionEvent event) {
        try {
            llenaTableView(Conexion.preCon(9), resultadosPredefinidos);
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }
    
     @FXML
    private void botonConsulta10(ActionEvent event) {
        try {
            llenaTableView(Conexion.preCon(10), resultadosPredefinidos);
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }
    
     @FXML
    private void botonConsulta11(ActionEvent event) {
        try {
            llenaTableView(Conexion.preCon(11), resultadosPredefinidos);
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }
    
     @FXML
    private void botonConsulta12(ActionEvent event) {
        try {
            llenaTableView(Conexion.preCon(12), resultadosPredefinidos);
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }
    
     @FXML
    private void botonConsulta13(ActionEvent event) {
        try {
            llenaTableView(Conexion.preCon(13), resultadosPredefinidos);
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }
    
     @FXML
    private void botonConsulta14(ActionEvent event) {
        try {
            llenaTableView(Conexion.preCon(14), resultadosPredefinidos);
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }
    
     @FXML
    private void botonConsulta15(ActionEvent event) {
        try {
            llenaTableView(Conexion.preCon(15), resultadosPredefinidos);
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }
    
    @Override
    public void initialize(URL url, ResourceBundle rb) {
        // TODO
    }  
    
    /**
     * Para poder mostrar mensajes de error.
     * @param msg Es el mensaje de la cabecera.
     * @param msg1 Es el mensaje con mas informacion de error ocurrido.
     */
     private static void alerta(String msg,String msg1){
        Alert alert = new Alert(AlertType.ERROR);
        alert.setTitle("Error");
        alert.setHeaderText(msg);
        alert.setContentText(msg1);
        alert.showAndWait();
    }
     
     /**
      * Llena el tableview que se le pase como parametro con el resultado de la consultada que se haya realizado.
      * @param rs El resultado de la consulta.
      * @param tableview La tabla a llenar.
      */
    private void llenaTableView(ResultSet rs,TableView tableview){
        tableview.getColumns().clear();
        ObservableList<ObservableList> data = FXCollections.observableArrayList();
          try{
             for(int i=0 ; i<rs.getMetaData().getColumnCount(); i++){
                //We are using non property style for making dynamic table
                final int j = i;                
                TableColumn col = new TableColumn(rs.getMetaData().getColumnName(i+1));
                col.setCellValueFactory(new Callback<CellDataFeatures<ObservableList,String>,ObservableValue<String>>(){                    
                    public ObservableValue<String> call(CellDataFeatures<ObservableList, String> param) {
                        String s = "";
                        try{
                      s = param.getValue().get(j).toString();
                        }catch(Exception e) {
                        }
                     if( s == null)
                         s = "null";
                        return new SimpleStringProperty(s);                        
                    }                    
                });

                tableview.getColumns().addAll(col); 
            }

            while(rs.next()){
                //Iterate Row
                ObservableList<String> row = FXCollections.observableArrayList();
                for(int i=1 ; i<=rs.getMetaData().getColumnCount(); i++){
                    //Iterate Column
                    row.add(rs.getString(i));
                }
                data.add(row);

            }
            tableview.setItems(data);
          }catch(Exception e){
              e.printStackTrace();
              System.out.println("Error on Building Data");             
          }
    }
    
}
