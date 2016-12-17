/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package javafxapplication2;

import java.net.URL;
import java.util.ResourceBundle;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.*;

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
    @FXML private ChoiceBox tipoLic;
    @FXML private DatePicker FechaVencimiento;
    
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
    private void handleButtonAction(ActionEvent event) {
        //SE CREA UNA FUNCION COMO ESTA Y SE LE DA AL BOTON. USTEDES ME DICEN A QUE BOTON.
    }
    
    @Override
    public void initialize(URL url, ResourceBundle rb) {
        // TODO
    }    
    
}
