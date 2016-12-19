/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package javafxapplication2;

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
    @FXML private Button limpiarTabla;
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
    @FXML private CheckBox tipoA;
    @FXML private CheckBox tipoB;
    @FXML private CheckBox tipoC;
    @FXML private CheckBox tipoD;
    @FXML private CheckBox tipoE;
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
    
    
    @FXML
    private void accionLimpiarTablaBoton(ActionEvent event) {//ni siquiera se si este boton se necesario.
        //SE CREA UNA FUNCION COMO ESTA Y SE LE DA AL BOTON. USTEDES ME DICEN A QUE BOTON.
    }
    
    @FXML
    private void botonConsultar(ActionEvent event) {
        String rfc = rfcConsulta.getCharacters().toString();
        String numPlaca = numPlacaConsulta.getCharacters().toString();
        //aqui llama el metodo que le corresponda del controlador.
        
        
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
        String sfechaVencimiento = fechaVencimiento.getValue().toString();
          //aqui llama el metodo que le corresponda del controlador.
    }
    
    @FXML
    private void botonAgregar2(ActionEvent event) {
        String numExp = numExpediente.getCharacters().toString();
        String artInfringido = artInfrigido.getCharacters().toString();
        String simporte = importe.getCharacters().toString();
        String snumAgente = numAgente.getCharacters().toString();
        String snumLicencia = numLicencia.getCharacters().toString();
        String snumTarjeta = numTarjeta.getCharacters().toString();
        String scolonia = colonia.getCharacters().toString();
        String scalle = calle.getCharacters().toString();
        String scp = cp.getCharacters().toString();
        String snum = num.getCharacters().toString();
        String shora = hora.getCharacters().toString();
        String sminutos = minutos.getCharacters().toString();
        String sfecha = fecha.getValue().toString();
        //aqui llama el metodo que le corresponda del controlador.
    }
    
    //en todos estos se va a llamarel metodo llenaTableView, con el respectivo resultset.
    @FXML
    private void botonConsulta1(ActionEvent event) {
        //SE CREA UNA FUNCION COMO ESTA Y SE LE DA AL BOTON. USTEDES ME DICEN A QUE BOTON.
    }
    
     @FXML
    private void botonConsulta2(ActionEvent event) {
        //SE CREA UNA FUNCION COMO ESTA Y SE LE DA AL BOTON. USTEDES ME DICEN A QUE BOTON.
    }
    
     @FXML
    private void botonConsulta3(ActionEvent event) {
        //SE CREA UNA FUNCION COMO ESTA Y SE LE DA AL BOTON. USTEDES ME DICEN A QUE BOTON.
    }
    
     @FXML
    private void botonConsulta4(ActionEvent event) {
        //SE CREA UNA FUNCION COMO ESTA Y SE LE DA AL BOTON. USTEDES ME DICEN A QUE BOTON.
    }
    
     @FXML
    private void botonConsulta5(ActionEvent event) {
        //SE CREA UNA FUNCION COMO ESTA Y SE LE DA AL BOTON. USTEDES ME DICEN A QUE BOTON.
    }
    
     @FXML
    private void botonConsulta6(ActionEvent event) {
        //SE CREA UNA FUNCION COMO ESTA Y SE LE DA AL BOTON. USTEDES ME DICEN A QUE BOTON.
    }
    
     @FXML
    private void botonConsulta7(ActionEvent event) {
        //SE CREA UNA FUNCION COMO ESTA Y SE LE DA AL BOTON. USTEDES ME DICEN A QUE BOTON.
    }
    
     @FXML
    private void botonConsulta8(ActionEvent event) {
        //SE CREA UNA FUNCION COMO ESTA Y SE LE DA AL BOTON. USTEDES ME DICEN A QUE BOTON.
    }
    
     @FXML
    private void botonConsulta9(ActionEvent event) {
        //SE CREA UNA FUNCION COMO ESTA Y SE LE DA AL BOTON. USTEDES ME DICEN A QUE BOTON.
    }
    
     @FXML
    private void botonConsulta10(ActionEvent event) {
        //SE CREA UNA FUNCION COMO ESTA Y SE LE DA AL BOTON. USTEDES ME DICEN A QUE BOTON.
    }
    
     @FXML
    private void botonConsulta11(ActionEvent event) {
        //SE CREA UNA FUNCION COMO ESTA Y SE LE DA AL BOTON. USTEDES ME DICEN A QUE BOTON.
    }
    
     @FXML
    private void botonConsulta12(ActionEvent event) {
        //SE CREA UNA FUNCION COMO ESTA Y SE LE DA AL BOTON. USTEDES ME DICEN A QUE BOTON.
    }
    
     @FXML
    private void botonConsulta13(ActionEvent event) {
        //SE CREA UNA FUNCION COMO ESTA Y SE LE DA AL BOTON. USTEDES ME DICEN A QUE BOTON.
    }
    
     @FXML
    private void botonConsulta14(ActionEvent event) {
        //SE CREA UNA FUNCION COMO ESTA Y SE LE DA AL BOTON. USTEDES ME DICEN A QUE BOTON.
    }
    
     @FXML
    private void botonConsulta15(ActionEvent event) {
        //SE CREA UNA FUNCION COMO ESTA Y SE LE DA AL BOTON. USTEDES ME DICEN A QUE BOTON.
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
       ObservableList<ObservableList> data = FXCollections.observableArrayList();
          try{
            for(int i=0 ; i<rs.getMetaData().getColumnCount(); i++){
                //We are using non property style for making dynamic table
                final int j = i;                
                TableColumn col = new TableColumn(rs.getMetaData().getColumnName(i+1));
                col.setCellValueFactory(new Callback<CellDataFeatures<ObservableList,String>,ObservableValue<String>>(){                    
                    @Override
                    public ObservableValue<String> call(CellDataFeatures<ObservableList, String> param) {                                                                                              
                        return new SimpleStringProperty(param.getValue().get(j).toString());                        
                    }                    
                });

                tableview.getColumns().addAll(col); 
            }

            /********************************
             * Data added to ObservableList *
             ********************************/
            while(rs.next()){
                //Iterate Row
                ObservableList<String> row = FXCollections.observableArrayList();
                for(int i=1 ; i<=rs.getMetaData().getColumnCount(); i++){
                    //Iterate Column
                    row.add(rs.getString(i));
                }
                data.add(row);

            }

            //FINALLY ADDED TO TableView
            tableview.setItems(data);
          }catch(Exception e){
              e.printStackTrace();
              System.out.println("Error on Building Data");             
          }
    }
    
}
