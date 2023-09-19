//
//  SolInscripcionViewController.swift
//  LineaExpres
//

import UIKit
import SignaturePad
import SwiftUI
import Alamofire
import SwiftGifOrigin
import DropDown
import UniformTypeIdentifiers


class SolInscripcionViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, UITextFieldDelegate, UIDocumentPickerDelegate {

    @IBOutlet weak var ImageLoaderGif: UIImageView!
    @IBOutlet weak var LoaderContainer: UIView!
    
    @IBOutlet weak var LineamientosContainer: UIView!
    @IBOutlet weak var SignaturePad: SignaturePad!
    @IBOutlet weak var SignContainer: UIView!
    @IBOutlet weak var SignaturePadContainer: UIView!
    @IBOutlet weak var SignaturePadContainerFather: UIView!
    
    @IBOutlet weak var Contenedor: UIStackView!
    @IBOutlet weak var Pleca: UILabel!
    
    //Getting Titles and Fields
    /// Sentri
    @IBOutlet weak var noSentriPassIDTitle: UILabel!
    @IBOutlet weak var SentriInput: UITextField!
    @IBOutlet weak var BtnUploadSentri: UIButton!
    @IBOutlet weak var SentriImage: UIImageView!
    @IBOutlet weak var FechaExpTitle: UILabel!
    @IBOutlet weak var DateInput: UITextField!
    @IBOutlet weak var advSentriTitle: UILabel!
    /// ID Oficial
    @IBOutlet weak var BtnUploadIDOfFrontal: UIButton!
    @IBOutlet weak var idOficialFrontal: UIImageView!
    @IBOutlet weak var BtnUploadIDOfReverso: UIButton!
    @IBOutlet weak var idOficialReverso: UIImageView!
    /// Domicilio
    @IBOutlet weak var DomicilioPartTitle: UILabel!
    @IBOutlet weak var CalleTitle: UILabel!
    @IBOutlet weak var PersonalCalleInput: UITextField!
    @IBOutlet weak var NoExteriorTitle: UILabel!
    @IBOutlet weak var PersonalExteriorNumberInput: UITextField!
    @IBOutlet weak var ColoniaTitle: UILabel!
    @IBOutlet weak var PersonalColoniaInput: UITextField!
    @IBOutlet weak var CiudadTitle: UILabel!
    @IBOutlet weak var PersonalCityInput: UITextField!
    @IBOutlet weak var EstadoTitle: UILabel!
    @IBOutlet weak var PersonalStateInput: UITextField!
    @IBOutlet weak var CPTitle: UILabel!
    @IBOutlet weak var PersonalCPInput: UITextField!
    ///Facturación
    @IBOutlet weak var DatosFactTitle: UILabel!
    @IBOutlet weak var RazonSocialTitle: UILabel!
    @IBOutlet weak var FactRazonSocialInput: UITextField!
    @IBOutlet weak var RFCTitle: UILabel!
    @IBOutlet weak var FactRFCInput: UITextField!
    @IBOutlet weak var FacDomicilioTitle: UILabel!
    @IBOutlet weak var FactDomicilioInput: UITextField!
    @IBOutlet weak var FacEmailTitle: UILabel!
    @IBOutlet weak var FactEmailInput: UITextField!
    @IBOutlet weak var FacPhoneTitle: UILabel!
    @IBOutlet weak var FactPhoneInput: UITextField!
    
    
    ///Datos del vehículo
    @IBOutlet weak var DatosVehTitle: UILabel!
    
    ///Subseccion vehiculo anterior
    @IBOutlet weak var Veh1Orig: UILabel!
    @IBOutlet weak var veh1OrigSegment: UISegmentedControl!
    ///Subseccion vehiculo anterior
    ///Subseccion vehiculo nuevo
    @IBOutlet weak var Veh2Orig: UILabel!
    @IBOutlet weak var veh2OrigSegment: UISegmentedControl!
    ///Subseccion vehiculo nuevor
    
    @IBOutlet weak var VehMarcaTitle: UILabel!
    @IBOutlet weak var BrandInput: UITextField!
    @IBOutlet weak var VehModeloTitle: UILabel!
    @IBOutlet weak var ModelInput: UITextField!
    @IBOutlet weak var VehColorTitle: UILabel!
    @IBOutlet weak var ColorInput: UITextField!
    @IBOutlet weak var VehYearTitle: UILabel!
    @IBOutlet weak var YearInput: UITextField!
    @IBOutlet weak var VehPlacasTitle: UILabel!
    @IBOutlet weak var PlacasInput: UITextField!
    @IBOutlet weak var PuenteAdscripcionTitle: UILabel!
    @IBOutlet weak var PuenteAdscripcionSegment: UISegmentedControl!
    @IBOutlet weak var MotivoBajaTitle: UILabel!
    @IBOutlet weak var MotivoBajaInput: UITextView!
    
    var currentPdfUrl = ""
    
    var pdfUrlOne = ""
    var pdfUrlTwo = ""
    var pdfUrlThree = ""
    var pdfUrlFour = ""
    var pdfUrlFive = ""
    var pdfUrlSix = ""
    var pdfUrlSeven = ""
    var pdfUrlEighth = ""
    
    
    @IBOutlet weak var CarStateInput: UITextField!
    var CarState:String = "Nacional"
    
    
    @IBOutlet weak var VehicleStateSegment: UISegmentedControl!
    
    ///Imanenes y botones
    @IBOutlet weak var btnTarjetaCirculacion: UIButton!
    @IBOutlet weak var tarjCirculacion: UIImageView!
    @IBOutlet weak var btnPolizaSeguro: UIButton!
    @IBOutlet weak var polizaSeguro: UIImageView!
    @IBOutlet weak var btnPolizaSeguroDos: UIButton!
    @IBOutlet weak var polizaSeguroDos: UIImageView!
    @IBOutlet weak var btnAprobacionUSA: UIButton!
    @IBOutlet weak var AprobacionUSA: UIImageView!
    @IBOutlet weak var btnCartaPoder: UIButton!
    @IBOutlet weak var CartaPoderOpcional: UIImageView!
    
    //Tipo de convenio
    @IBOutlet weak var TipoConvenioTitle: UILabel!
    @IBOutlet weak var SeleccioneOrigenTitle: UILabel!
    @IBOutlet weak var SegmentUSAMX: UISegmentedControl!
    @IBOutlet weak var AnualidadTitle: UILabel!
    @IBOutlet weak var AnualidadSegment: UISegmentedControl!
    @IBOutlet weak var SaldoTitle: UILabel!
    @IBOutlet weak var SaldoSegment: UISegmentedControl!
    @IBOutlet weak var UICantidadACargar: UITextField!
    @IBOutlet weak var TipoDeConvenio: UITextField!
    
    @IBOutlet weak var TagVeh2Title: UILabel!
    @IBOutlet weak var TagVeh2: UITextField!
    
    @IBOutlet weak var TarifasView: UIView!
    @IBOutlet weak var TarifasImageView: UIImageView!
    @IBOutlet weak var verTarifasBtn: UIButton!
    
    var currentPhoto:Int = 0
    
    let blackGlobal = UIColor(named: "BlackGlobal")
    
    var anual_zaragoza_mx:String = ""
    var anual_lerdo_mx:String = ""
    var anual_zaragoza_us:String = ""
    var anual_lerdo_us:String = ""
    var anual_mixto_mx:String = ""
    var anual_mixto_us:String = ""
    var saldo_zaragoza1_mx:String = ""
    var saldo_zaragoza2_mx:String = ""
    var saldo_zaragoza1_us:String = ""
    var saldo_zaragoza2_us:String = ""
    var pago_minimotp_mx:String = ""
    var mbPreciosURL:String = ""
    var seguroOrigen:String = ""
    @IBOutlet weak var polizaSeguroOrigenTitle: UILabel!
    @IBOutlet weak var PolizaSeguroOrigen: UISegmentedControl!
    
    var pais = "Mexico"
    var tag = ""
    var vehContrato = ""
    var puente = ""
    var tipoContrato = ""
    var Cantidad = ""
    var DropSelector: [String] = []
    var positionCountry = 0
    let dropDown = DropDown()
    
    var TipoTramite: Int = 0
    
    var Email:String = ""
    // var Name:String = ""
    var FirebaseToken:String = ""
    var LoginToken:String = ""
    var Sentri:String = ""
    var SentriFecha:String = ""
    var localRazonSocialFiscal:String = ""
    var localRFCFiscal:String = ""
    var localDomFiscal:String = ""
    var localEmailFiscal:String = ""
    var localTelefonoFiscal:String = ""
    var localCPFiscal:String = ""

    var vehID: Int = 0
    var json: [String: Any] = [:]
    @IBOutlet weak var msgError: UILabel!
    
    
    var veh1Marca:String = ""
    var veh1Modelo:String = ""
    var veh1Color:String = ""
    var veh1Anio:String = ""
    var veh1Placa:String = ""
    var veh1Orig:String = ""
    var veh2Orig:String = ""
    
    var conv_saldo:String = "0"
    var conv_anualidad:String = "0"
    
    var PuenteAdscripcionZaragoza:String = "0"
    var PuenteAdscripcionLerdo:String = "0"
    
    var id_proc_type:String = ""
    var ctl_stall_id:String = ""
    
    var CantidadACargar:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SentriInput.tintColor = UIColor.black
        DateInput.tintColor = UIColor.black
        PersonalCalleInput.tintColor = UIColor.black
        PersonalExteriorNumberInput.tintColor = UIColor.black
        PersonalColoniaInput.tintColor = UIColor.black
        PersonalCityInput.tintColor = UIColor.black
        PersonalStateInput.tintColor = UIColor.black
        PersonalCPInput.tintColor = UIColor.black
        FactRazonSocialInput.tintColor = UIColor.black
        FactRFCInput.tintColor = UIColor.black
        FactDomicilioInput.tintColor = UIColor.black
        FactEmailInput.tintColor = UIColor.black
        FactPhoneInput.tintColor = UIColor.black
        BrandInput.tintColor = UIColor.black
        ModelInput.tintColor = UIColor.black
        ColorInput.tintColor = UIColor.black
        YearInput.tintColor = UIColor.black
        PlacasInput.tintColor = UIColor.black
        CarStateInput.tintColor = UIColor.black
        UICantidadACargar.tintColor = UIColor.black
        TipoDeConvenio.tintColor = UIColor.black
        TagVeh2.tintColor = UIColor.black
            
        SentriInput.applyTextFieldStyle()
        DateInput.applyTextFieldStyle()
        PersonalCalleInput.applyTextFieldStyle()
        PersonalExteriorNumberInput.applyTextFieldStyle()
        PersonalColoniaInput.applyTextFieldStyle()
        PersonalCityInput.applyTextFieldStyle()
        PersonalStateInput.applyTextFieldStyle()
        PersonalCPInput.applyTextFieldStyle()
        FactRazonSocialInput.applyTextFieldStyle()
        FactRFCInput.applyTextFieldStyle()
        FactDomicilioInput.applyTextFieldStyle()
        FactEmailInput.applyTextFieldStyle()
        FactPhoneInput.applyTextFieldStyle()
        BrandInput.applyTextFieldStyle()
        ModelInput.applyTextFieldStyle()
        ColorInput.applyTextFieldStyle()
        YearInput.applyTextFieldStyle()
        PlacasInput.applyTextFieldStyle()
        CarStateInput.applyTextFieldStyle()
        UICantidadACargar.applyTextFieldStyle()
        TipoDeConvenio.applyTextFieldStyle()
        TagVeh2.applyTextFieldStyle()
        
         let Lista:Array<String> = DB_Manager().getUsuario()
         for i in 0..<(Lista.count) {
             
             let Usuario = Lista[i].components(separatedBy: "∑")
             print("La lista a ver k podo: \(Usuario)")
             //Email = Usuario[0]
             //Name = Usuario[1]
             //FirebaseToken = Usuario[2]
             LoginToken = Usuario[3]
             Sentri = Usuario[5]
             SentriFecha = Usuario[6]
             localRazonSocialFiscal = Usuario[7]
             localRFCFiscal = Usuario[8]
             localDomFiscal = Usuario[9]
             localCPFiscal = Usuario[10]
             localEmailFiscal = Usuario[11]
             localTelefonoFiscal = Usuario[12]
             
             if Sentri.isEmpty {
                 Sentri = "N/A"
             }
             
         }
        
        if (LoginToken.isEmpty) {
            NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "LoginViewController")
        }
        
        BtnUploadIDOfFrontal.titleLabel?.textAlignment = .center
        BtnUploadIDOfReverso.titleLabel?.textAlignment = .center
        btnTarjetaCirculacion.titleLabel?.textAlignment = .center
        btnAprobacionUSA.titleLabel?.textAlignment = .center
        btnCartaPoder.titleLabel?.textAlignment = .center
 
   
        NotificationCenter.default.addObserver(self, selector: #selector(didGetNotification(_:)), name: Notification.Name("TipoTramite"), object: nil)
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(tapDetected))
        TarifasImageView.isUserInteractionEnabled = true
        TarifasImageView.addGestureRecognizer(singleTap)
        
        
        ImageLoaderGif.image = UIImage.gif(asset: "linea_expres_loader")
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: UIControl.Event.valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 300)
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minimumDate = Date()
        DateInput.inputView = datePicker
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
            view.addGestureRecognizer(tap)
        
        startRounding()
        createBorderColor()
        
        SignContainer.isHidden = true
        TarifasView.isHidden = true
        SignaturePadContainerFather.isHidden = true
        LoaderContainer.isHidden = true
        TipoDeConvenio.text = ""
        
        MotivoBajaInput.layer.borderWidth = 1.0
        MotivoBajaInput.layer.borderColor = UIColor.black.cgColor
        MotivoBajaInput.backgroundColor = .white
        
        let tapGesLink = UITapGestureRecognizer(target: self, action: #selector(SolInscripcionViewController.tapFunction(sender:)))
            advSentriTitle.isUserInteractionEnabled = true
        advSentriTitle.addGestureRecognizer(tapGesLink)
        
        let htmlText = """
            <html>
            <body>
                <p style="color:black; font-size: 16px;">
                    Necesitas como registro tu SENTRI, si no lo tienes visita:
        <b style="color:blue;">https://ttp.cbp.dhs.gov/</b>
                </p>
            </body>
            </html>
        """

        if let attributedString = try? NSAttributedString(
            data: htmlText.data(using: .utf8)!,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil
        ) {
            advSentriTitle.attributedText = attributedString
        }


        SentriInput.delegate = self
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        requestMob()
    }
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        if let url = URL(string: "https://ttp.cbp.dhs.gov/") {
                UIApplication.shared.open(url)
            }
    }
    
    @objc func didGetNotification(_ notification: Notification) {
        let TramiteString:String = notification.object as! String
        let TramiteData = TramiteString.components(separatedBy: ",")
    
        print("Todo sobre el didGetNotif \(TramiteData)")
        
        TipoTramite = Int(TramiteData[0])!
        veh1Marca = TramiteData[1]
        veh1Modelo = TramiteData[2]
        veh1Color = TramiteData[3]
        veh1Anio = TramiteData[4]
        veh1Placa = TramiteData[5]
        tag = TramiteData[6]
        vehContrato = TramiteData.count > 7 ? TramiteData[7] : ""
        ctl_stall_id = TramiteData.count > 8 ? TramiteData[8] : ""
        
        print("Haber dame vehContrato \(vehContrato)")
        
        if !veh1Marca.contains("0") {
            SentriInput.isHidden = true
            FechaExpTitle.isHidden = true
            DateInput.isHidden = true
            noSentriPassIDTitle.isHidden = true
            SentriImage.isHidden = true
            BtnUploadSentri.isHidden = true
            advSentriTitle.isHidden = false
        }
        if veh1Marca.elementsEqual("1"){
            Pleca.text = "Registro de vehículo"
            SentriInput.isHidden = true
            advSentriTitle.isHidden = true
            FechaExpTitle.isHidden = true
            DateInput.isHidden = true
            noSentriPassIDTitle.isHidden = true
            SentriImage.isHidden = true
            BtnUploadSentri.isHidden = true
            advSentriTitle.isHidden = true
            verTarifasBtn.isHidden = true
            BtnUploadIDOfFrontal.isHidden = true
            BtnUploadIDOfReverso.isHidden = true
            idOficialFrontal.isHidden = true
            idOficialReverso.isHidden = true
            DatosFactTitle.isHidden = true
            RazonSocialTitle.isHidden = true
            FactRazonSocialInput.isHidden = true
            RFCTitle.isHidden = true
            FactRFCInput.isHidden = true
            FacDomicilioTitle.isHidden = true
            FactDomicilioInput.isHidden = true
            FacEmailTitle.isHidden = true
            FactEmailInput.isHidden = true
            FacPhoneTitle.isHidden = true
            FactPhoneInput.isHidden = true
            Veh1Orig.isHidden = true
            veh1OrigSegment.isHidden = true
        
            DomicilioPartTitle.isHidden = true
            CalleTitle.isHidden = true
            PersonalCalleInput.isHidden = true
            NoExteriorTitle.isHidden = true
            PersonalExteriorNumberInput.isHidden = true
            ColoniaTitle.isHidden = true
            PersonalColoniaInput.isHidden = true
            CiudadTitle.isHidden = true
            PersonalCityInput.isHidden = true
            EstadoTitle.isHidden = true
            PersonalStateInput.isHidden = true
            CPTitle.isHidden = true
            PersonalCPInput.isHidden = true
            TipoConvenioTitle.isHidden = true
            
            //SeleccioneOrigenTitle.isHidden = true
            //SegmentUSAMX.isHidden = true
            //AnualidadTitle.isHidden = true
            //AnualidadSegment.isHidden = true
            //SaldoTitle.isHidden = true
            //SaldoSegment.isHidden = true
            //UICantidadACargar.isHidden = true
            //TipoDeConvenio.isHidden = true
            PuenteAdscripcionTitle.isHidden = true
            PuenteAdscripcionSegment.isHidden = true
            MotivoBajaTitle.isHidden = true
            MotivoBajaInput.isHidden = true
            TagVeh2Title.isHidden = true
            TagVeh2.isHidden = true
            
        }
        if veh1Marca.elementsEqual("0"){
            Pleca.text = "Solicitud de inscripción a Linea Exprés"
        }

        print(vehContrato)
        
        if TipoTramite == 7 {
            //C = Saldo, V = Vigencia 1 puente, M = Mixto
            if vehContrato != "" {
                var tipoConvenioInformative: String = ""
                if vehContrato == "C" {
                    SaldoTitle.isHidden = true
                    SaldoSegment.isHidden = true
                    AnualidadSegment.setEnabled(false, forSegmentAt: 0)
                    tipoConvenioInformative = "Zaragoza"
                }
                if vehContrato == "M" {
                    AnualidadSegment.setEnabled(false, forSegmentAt: 2)
                    tipoConvenioInformative = "Zaragoza y Lerdo"
                }
                if vehContrato == "V" {
                    AnualidadSegment.setEnabled(false, forSegmentAt: 0)
                    AnualidadSegment.setEnabled(false, forSegmentAt: 1)
                    if ctl_stall_id == "104" {
                        tipoConvenioInformative = "Lerdo-Anualidad"
                    }
                    if ctl_stall_id == "105" {
                        tipoConvenioInformative = "Zaragoza-Anualidad"
                    }
                }
                
                
                TipoConvenioTitle.numberOfLines = 5
                
                TipoConvenioTitle.text = "Usted tiene convenio con el siguiente puente \(tipoConvenioInformative) y puede cambiarlo a: "
                
                SeleccioneOrigenTitle.isHidden = true
            }
        }
        
        if TipoTramite == 8 {
            //C = Saldo, V = Vigencia 1 puente, M = Mixto
            if vehContrato != "" {
                var tipoConvenioInformative: String = ""
                if vehContrato == "C" {
                    SaldoTitle.isHidden = true
                    SaldoSegment.isHidden = true
                    tipoConvenioInformative = "saldo"
                }
                if vehContrato == "M" {
                    AnualidadSegment.setEnabled(false, forSegmentAt: 2)
                    tipoConvenioInformative = "mixto"
                }
                if vehContrato == "V" {
                    AnualidadSegment.setEnabled(false, forSegmentAt: 0)
                    AnualidadSegment.setEnabled(false, forSegmentAt: 1)
                    SegmentUSAMX.selectedSegmentIndex = 1
                    AnualidadSegment.selectedSegmentIndex = 2
                    tipoConvenioInformative = "vigencia"
                }
                
                TipoConvenioTitle.numberOfLines = 5
                TipoConvenioTitle.text = "Usted está bajo el siguiente convenio \(tipoConvenioInformative) y puede cambiarlo a: "
                SeleccioneOrigenTitle.isHidden = true
            }
        }

        Veh2Orig.numberOfLines = 3
        msgError.isHidden = true
        
        print("Tipo de Trámite: \(TipoTramite) \(vehID)")
     
        switch TipoTramite{
        case 0:
            PuenteAdscripcionTitle.isHidden = true
            PuenteAdscripcionSegment.isHidden = true
            MotivoBajaTitle.isHidden = true
            MotivoBajaInput.isHidden = true
            Veh1Orig.isHidden = true
            veh1OrigSegment.isHidden = true
            TagVeh2Title.isHidden = true
            TagVeh2.isHidden = true
            polizaSeguroOrigenTitle.isHidden = true
            PolizaSeguroOrigen.isHidden = true
            Contenedor.layoutIfNeeded()
            let visibleSubviews = Contenedor.arrangedSubviews.filter { !$0.isHidden }
            let totalHeight = visibleSubviews.reduce(0) { $0 + $1.frame.size.height }
            Contenedor.frame.size.height = totalHeight
            
        case 1:
            Pleca.text = "Cambio de vehículo"
            SentriInput.isHidden = true
            FechaExpTitle.isHidden = true
            DateInput.isHidden = true
            noSentriPassIDTitle.isHidden = true
            SentriImage.isHidden = true
            BtnUploadSentri.isHidden = true
            advSentriTitle.isHidden = true
            verTarifasBtn.isHidden = true
            BtnUploadIDOfFrontal.isHidden = true
            BtnUploadIDOfReverso.isHidden = true
            idOficialFrontal.isHidden = true
            idOficialReverso.isHidden = true
            DatosFactTitle.isHidden = true
            RazonSocialTitle.isHidden = true
            FactRazonSocialInput.isHidden = true
            RFCTitle.isHidden = true
            FactRFCInput.isHidden = true
            FacDomicilioTitle.isHidden = true
            FactDomicilioInput.isHidden = true
            FacEmailTitle.isHidden = true
            FactEmailInput.isHidden = true
            FacPhoneTitle.isHidden = true
            FactPhoneInput.isHidden = true
            Veh1Orig.isHidden = true
            veh1OrigSegment.isHidden = true
        
            DomicilioPartTitle.isHidden = true
            CalleTitle.isHidden = true
            PersonalCalleInput.isHidden = true
            NoExteriorTitle.isHidden = true
            PersonalExteriorNumberInput.isHidden = true
            ColoniaTitle.isHidden = true
            PersonalColoniaInput.isHidden = true
            CiudadTitle.isHidden = true
            PersonalCityInput.isHidden = true
            EstadoTitle.isHidden = true
            PersonalStateInput.isHidden = true
            CPTitle.isHidden = true
            PersonalCPInput.isHidden = true
            TipoConvenioTitle.isHidden = true
            SeleccioneOrigenTitle.isHidden = true
            SegmentUSAMX.isHidden = true
            AnualidadTitle.isHidden = true
            AnualidadSegment.isHidden = true
            SaldoTitle.isHidden = true
            SaldoSegment.isHidden = true
            UICantidadACargar.isHidden = true
            TipoDeConvenio.isHidden = true
            PuenteAdscripcionTitle.isHidden = true
            PuenteAdscripcionSegment.isHidden = true
            MotivoBajaTitle.isHidden = true
            MotivoBajaInput.isHidden = true
            TagVeh2Title.isHidden = true
            TagVeh2.isHidden = true
            Contenedor.layoutIfNeeded()
            let visibleSubviews = Contenedor.arrangedSubviews.filter { !$0.isHidden }
            let totalHeight = visibleSubviews.reduce(0) { $0 + $1.frame.size.height }
            Contenedor.frame.size.height = totalHeight

        case 2:
            Pleca.text = "Cambio de TAG"
            MotivoBajaTitle.text = "Por favor, explique brevemente la razón por la cual solicita el cambio del tag \(tag)"
           
            Veh1Orig.text = "Seleccione el origen de su vehículo"
            noSentriPassIDTitle.isHidden = true
            SentriInput.isHidden = true
            btnPolizaSeguroDos.isHidden = true
            polizaSeguroDos.isHidden = true
            BtnUploadSentri.isHidden = true
            SentriImage.isHidden = true
            FechaExpTitle.isHidden = true
            DateInput.isHidden = true
            advSentriTitle.isHidden = true
            BtnUploadIDOfFrontal.isHidden = true
            polizaSeguroOrigenTitle.isHidden = true
            PolizaSeguroOrigen.isHidden = true
            idOficialFrontal.isHidden = true
            BtnUploadIDOfReverso.isHidden = true
            idOficialReverso.isHidden = true
            DomicilioPartTitle.isHidden = true
            CalleTitle.isHidden = true
            PersonalCalleInput.isHidden = true
            NoExteriorTitle.isHidden = true
            PersonalExteriorNumberInput.isHidden = true
            ColoniaTitle.isHidden = true
            PersonalColoniaInput.isHidden = true
            CiudadTitle.isHidden = true
            PersonalCityInput.isHidden = true
            EstadoTitle.isHidden = true
            PersonalStateInput.isHidden = true
            CPTitle.isHidden = true
            PersonalCPInput.isHidden = true
            DatosVehTitle.isHidden = true
            Veh2Orig.isHidden = true
            veh2OrigSegment.isHidden = true
            VehMarcaTitle.isHidden = true
            BrandInput.isHidden = true
            VehModeloTitle.isHidden = true
            ModelInput.isHidden = true
            VehColorTitle.isHidden = true
            ColorInput.isHidden = true
            VehYearTitle.isHidden = true
            YearInput.isHidden = true
            VehPlacasTitle.isHidden = true
            PlacasInput.isHidden = true
            PuenteAdscripcionTitle.isHidden = true
            PuenteAdscripcionSegment.isHidden = true
            CarStateInput.isHidden = true
            VehicleStateSegment.isHidden = true
            btnTarjetaCirculacion.isHidden = true
            tarjCirculacion.isHidden = true
            btnPolizaSeguro.isHidden = true
            polizaSeguro.isHidden = true
            btnAprobacionUSA.isHidden = true
            AprobacionUSA.isHidden = true
            btnCartaPoder.isHidden = true
            CartaPoderOpcional.isHidden = true
            TipoConvenioTitle.isHidden = true
            SeleccioneOrigenTitle.isHidden = true
            SegmentUSAMX.isHidden = true
            AnualidadTitle.isHidden = true
            AnualidadSegment.isHidden = true
            SaldoTitle.isHidden = true
            SaldoSegment.isHidden = true
            UICantidadACargar.isHidden = true
            TipoDeConvenio.isHidden = true
            DatosFactTitle.isHidden = true
            RazonSocialTitle.isHidden = true
            FactRazonSocialInput.isHidden = true
            RFCTitle.isHidden = true
            FactRFCInput.isHidden = true
            FacDomicilioTitle.isHidden = true
            FactDomicilioInput.isHidden = true
            FacEmailTitle.isHidden = true
            FactEmailInput.isHidden = true
            FacPhoneTitle.isHidden = true
            FactPhoneInput.isHidden = true
            Veh1Orig.isHidden = true
            veh1OrigSegment.isHidden = true
            TagVeh2Title.isHidden = true
            TagVeh2.isHidden = true
            verTarifasBtn.isHidden = true
            
            Contenedor.layoutIfNeeded()
            let visibleSubviews = Contenedor.arrangedSubviews.filter { !$0.isHidden }
            let totalHeight = visibleSubviews.reduce(0) { $0 + $1.frame.size.height }
            Contenedor.frame.size.height = totalHeight
        case 3:
            Pleca.text = "Actualización de poliza de seguro"
            
            Veh1Orig.text = "Seleccione el país origen de su vehículo"
            MotivoBajaTitle.isHidden = true
            MotivoBajaInput.isHidden = true
            noSentriPassIDTitle.isHidden = true
            SentriInput.isHidden = true
            BtnUploadSentri.isHidden = true
            SentriImage.isHidden = true
            FechaExpTitle.isHidden = true
            DateInput.isHidden = true
            advSentriTitle.isHidden = true
            BtnUploadIDOfFrontal.isHidden = true
            idOficialFrontal.isHidden = true
            BtnUploadIDOfReverso.isHidden = true
            idOficialReverso.isHidden = true
            DomicilioPartTitle.isHidden = true
            CalleTitle.isHidden = true
            PersonalCalleInput.isHidden = true
            NoExteriorTitle.isHidden = true
            PersonalExteriorNumberInput.isHidden = true
            ColoniaTitle.isHidden = true
            PersonalColoniaInput.isHidden = true
            CiudadTitle.isHidden = true
            PersonalCityInput.isHidden = true
            EstadoTitle.isHidden = true
            PersonalStateInput.isHidden = true
            CPTitle.isHidden = true
            PersonalCPInput.isHidden = true

            btnTarjetaCirculacion.isHidden = true
            DatosVehTitle.isHidden = true
            Veh2Orig.isHidden = true
            veh2OrigSegment.isHidden = true
            VehMarcaTitle.isHidden = true
            BrandInput.isHidden = true
            VehModeloTitle.isHidden = true
            ModelInput.isHidden = true
            VehColorTitle.isHidden = true
            ColorInput.isHidden = true
            VehYearTitle.isHidden = true
            YearInput.isHidden = true
            VehPlacasTitle.isHidden = true
            PlacasInput.isHidden = true
            PuenteAdscripcionTitle.isHidden = true
            PuenteAdscripcionSegment.isHidden = true
            CarStateInput.isHidden = true
            VehicleStateSegment.isHidden = true
            tarjCirculacion.isHidden = true
            btnAprobacionUSA.isHidden = true
            AprobacionUSA.isHidden = true
            btnCartaPoder.isHidden = true
            CartaPoderOpcional.isHidden = true
            TipoConvenioTitle.isHidden = true
            SeleccioneOrigenTitle.isHidden = true
            SegmentUSAMX.isHidden = true
            AnualidadTitle.isHidden = true
            AnualidadSegment.isHidden = true
            SaldoTitle.isHidden = true
            SaldoSegment.isHidden = true
            UICantidadACargar.isHidden = true
            TipoDeConvenio.isHidden = true
            DatosFactTitle.isHidden = true
            RazonSocialTitle.isHidden = true
            FactRazonSocialInput.isHidden = true
            RFCTitle.isHidden = true
            FactRFCInput.isHidden = true
            FacDomicilioTitle.isHidden = true
            FactDomicilioInput.isHidden = true
            FacEmailTitle.isHidden = true
            FactEmailInput.isHidden = true
            FacPhoneTitle.isHidden = true
            FactPhoneInput.isHidden = true
            Veh1Orig.isHidden = true
            veh1OrigSegment.isHidden = true
            
            TagVeh2Title.isHidden = true
            TagVeh2.isHidden = true
            verTarifasBtn.isHidden = true
            
            Contenedor.layoutIfNeeded()
            let visibleSubviews = Contenedor.arrangedSubviews.filter { !$0.isHidden }
            let totalHeight = visibleSubviews.reduce(0) { $0 + $1.frame.size.height }
            Contenedor.frame.size.height = totalHeight
        case 4:
            
            Pleca.text = "Actualización de placas"
            Veh1Orig.text = "Seleccione el país origen de su vehículo"
            MotivoBajaTitle.isHidden = true
            btnPolizaSeguroDos.isHidden = true
            polizaSeguroDos.isHidden = true
            MotivoBajaInput.isHidden = true
            noSentriPassIDTitle.isHidden = true
            SentriInput.isHidden = true
            polizaSeguroOrigenTitle.isHidden = true
            PolizaSeguroOrigen.isHidden = true
            BtnUploadSentri.isHidden = true
            SentriImage.isHidden = true
            FechaExpTitle.isHidden = true
            DateInput.isHidden = true
            advSentriTitle.isHidden = true
            BtnUploadIDOfFrontal.isHidden = true
            idOficialFrontal.isHidden = true
            BtnUploadIDOfReverso.isHidden = true
            idOficialReverso.isHidden = true
            DomicilioPartTitle.isHidden = true
            CalleTitle.isHidden = true
            PersonalCalleInput.isHidden = true
            NoExteriorTitle.isHidden = true
            PersonalExteriorNumberInput.isHidden = true
            ColoniaTitle.isHidden = true
            PersonalColoniaInput.isHidden = true
            CiudadTitle.isHidden = true
            PersonalCityInput.isHidden = true
            EstadoTitle.isHidden = true
            PersonalStateInput.isHidden = true
            CPTitle.isHidden = true
            PersonalCPInput.isHidden = true
            btnTarjetaCirculacion.isHidden = true
            DatosVehTitle.isHidden = true
            Veh2Orig.isHidden = true
            veh2OrigSegment.isHidden = true
            VehMarcaTitle.isHidden = true
            BrandInput.isHidden = true
            VehModeloTitle.isHidden = true
            ModelInput.isHidden = true
            VehColorTitle.isHidden = true
            ColorInput.isHidden = true
            VehYearTitle.isHidden = true
            YearInput.isHidden = true
            PuenteAdscripcionTitle.isHidden = true
            PuenteAdscripcionSegment.isHidden = true
            CarStateInput.isHidden = true
            VehicleStateSegment.isHidden = true
            tarjCirculacion.isHidden = true
            btnAprobacionUSA.isHidden = true
            AprobacionUSA.isHidden = true
            btnPolizaSeguro.isHidden = true
            polizaSeguro.isHidden = true
            btnCartaPoder.isHidden = true
            CartaPoderOpcional.isHidden = true
            TipoConvenioTitle.isHidden = true
            SeleccioneOrigenTitle.isHidden = true
            SegmentUSAMX.isHidden = true
            AnualidadTitle.isHidden = true
            AnualidadSegment.isHidden = true
            SaldoTitle.isHidden = true
            SaldoSegment.isHidden = true
            UICantidadACargar.isHidden = true
            TipoDeConvenio.isHidden = true
            DatosFactTitle.isHidden = true
            RazonSocialTitle.isHidden = true
            FactRazonSocialInput.isHidden = true
            RFCTitle.isHidden = true
            FactRFCInput.isHidden = true
            FacDomicilioTitle.isHidden = true
            FactDomicilioInput.isHidden = true
            FacEmailTitle.isHidden = true
            FactEmailInput.isHidden = true
            FacPhoneTitle.isHidden = true
            FactPhoneInput.isHidden = true
            Veh1Orig.isHidden = true
            veh1OrigSegment.isHidden = true
            
            TagVeh2Title.isHidden = true
            TagVeh2.isHidden = true
            verTarifasBtn.isHidden = true
            
            Contenedor.layoutIfNeeded()
            let visibleSubviews = Contenedor.arrangedSubviews.filter { !$0.isHidden }
            let totalHeight = visibleSubviews.reduce(0) { $0 + $1.frame.size.height }
            Contenedor.frame.size.height = totalHeight
            
        case 5:
            Pleca.text = "Baja de Vehículo"
            Veh1Orig.text = "Seleccione el país origen de su vehículo"
            MotivoBajaTitle.text = "Por favor, explique brevemente la razón por la cual solicita la baja del vehículo con placas \(veh1Placa)"
          
            noSentriPassIDTitle.isHidden = true
            SentriInput.isHidden = true
            btnPolizaSeguroDos.isHidden = true
            polizaSeguroDos.isHidden = true
            BtnUploadSentri.isHidden = true
            SentriImage.isHidden = true
            FechaExpTitle.isHidden = true
            DateInput.isHidden = true
            polizaSeguroOrigenTitle.isHidden = true
            PolizaSeguroOrigen.isHidden = true
            advSentriTitle.isHidden = true
            BtnUploadIDOfFrontal.isHidden = true
            idOficialFrontal.isHidden = true
            BtnUploadIDOfReverso.isHidden = true
            idOficialReverso.isHidden = true
            DomicilioPartTitle.isHidden = true
            CalleTitle.isHidden = true
            PersonalCalleInput.isHidden = true
            NoExteriorTitle.isHidden = true
            PersonalExteriorNumberInput.isHidden = true
            ColoniaTitle.isHidden = true
            PersonalColoniaInput.isHidden = true
            CiudadTitle.isHidden = true
            PersonalCityInput.isHidden = true
            EstadoTitle.isHidden = true
            PersonalStateInput.isHidden = true
            CPTitle.isHidden = true
            PersonalCPInput.isHidden = true
            btnTarjetaCirculacion.isHidden = true
            DatosVehTitle.isHidden = true
            Veh2Orig.isHidden = true
            veh2OrigSegment.isHidden = true
            VehMarcaTitle.isHidden = true
            BrandInput.isHidden = true
            VehModeloTitle.isHidden = true
            ModelInput.isHidden = true
            VehColorTitle.isHidden = true
            ColorInput.isHidden = true
            VehYearTitle.isHidden = true
            YearInput.isHidden = true
            PlacasInput.isHidden = true
            VehPlacasTitle.isHidden = true
            CarStateInput.isHidden = true
            VehicleStateSegment.isHidden = true
            tarjCirculacion.isHidden = true
            btnAprobacionUSA.isHidden = true
            AprobacionUSA.isHidden = true
            btnPolizaSeguro.isHidden = true
            polizaSeguro.isHidden = true
            btnCartaPoder.isHidden = true
            CartaPoderOpcional.isHidden = true
            TipoConvenioTitle.isHidden = true
            SeleccioneOrigenTitle.isHidden = true
            SegmentUSAMX.isHidden = true
            AnualidadTitle.isHidden = true
            AnualidadSegment.isHidden = true
            SaldoTitle.isHidden = true
            SaldoSegment.isHidden = true
            UICantidadACargar.isHidden = true
            TipoDeConvenio.isHidden = true
            DatosFactTitle.isHidden = true
            RazonSocialTitle.isHidden = true
            FactRazonSocialInput.isHidden = true
            RFCTitle.isHidden = true
            FactRFCInput.isHidden = true
            FacDomicilioTitle.isHidden = true
            FactDomicilioInput.isHidden = true
            FacEmailTitle.isHidden = true
            FactEmailInput.isHidden = true
            FacPhoneTitle.isHidden = true
            FactPhoneInput.isHidden = true
            Veh1Orig.text = "Confirme el país de origen de su vehículo"
            verTarifasBtn.isHidden = true
            TagVeh2Title.isHidden = true
            TagVeh2.isHidden = true
            
            Contenedor.layoutIfNeeded()
            let visibleSubviews = Contenedor.arrangedSubviews.filter { !$0.isHidden }
            let totalHeight = visibleSubviews.reduce(0) { $0 + $1.frame.size.height }
            Contenedor.frame.size.height = totalHeight
        case 6:
            Pleca.text = "Desactivar TAG"
        
            MotivoBajaTitle.text = "Por favor, explique brevemente la razón por la cual solicita la baja del tag \(tag)"
          
            noSentriPassIDTitle.isHidden = true
            SentriInput.isHidden = true
            BtnUploadSentri.isHidden = true
            btnPolizaSeguroDos.isHidden = true
            polizaSeguroDos.isHidden = true
            SentriImage.isHidden = true
            FechaExpTitle.isHidden = true
            DateInput.isHidden = true
            advSentriTitle.isHidden = true
            BtnUploadIDOfFrontal.isHidden = true
            idOficialFrontal.isHidden = true
            BtnUploadIDOfReverso.isHidden = true
            polizaSeguroOrigenTitle.isHidden = true
            PolizaSeguroOrigen.isHidden = true
            idOficialReverso.isHidden = true
            DomicilioPartTitle.isHidden = true
            CalleTitle.isHidden = true
            PersonalCalleInput.isHidden = true
            NoExteriorTitle.isHidden = true
            PersonalExteriorNumberInput.isHidden = true
            ColoniaTitle.isHidden = true
            PersonalColoniaInput.isHidden = true
            CiudadTitle.isHidden = true
            PersonalCityInput.isHidden = true
            EstadoTitle.isHidden = true
            PersonalStateInput.isHidden = true
            CPTitle.isHidden = true
            PersonalCPInput.isHidden = true
            btnTarjetaCirculacion.isHidden = true
            DatosVehTitle.isHidden = true
            Veh2Orig.isHidden = true
            veh2OrigSegment.isHidden = true
            VehMarcaTitle.isHidden = true
            BrandInput.isHidden = true
            VehModeloTitle.isHidden = true
            ModelInput.isHidden = true
            VehColorTitle.isHidden = true
            ColorInput.isHidden = true
            VehYearTitle.isHidden = true
            YearInput.isHidden = true
            PlacasInput.isHidden = true
            VehPlacasTitle.isHidden = true
            
            PuenteAdscripcionTitle.isHidden = true
            PuenteAdscripcionSegment.isHidden = true
            CarStateInput.isHidden = true
            VehicleStateSegment.isHidden = true
            tarjCirculacion.isHidden = true
            btnAprobacionUSA.isHidden = true
            AprobacionUSA.isHidden = true
            btnPolizaSeguro.isHidden = true
            polizaSeguro.isHidden = true
            btnCartaPoder.isHidden = true
            CartaPoderOpcional.isHidden = true
            TipoConvenioTitle.isHidden = true
            SeleccioneOrigenTitle.isHidden = true
            SegmentUSAMX.isHidden = true
            AnualidadTitle.isHidden = true
            AnualidadSegment.isHidden = true
            SaldoTitle.isHidden = true
            SaldoSegment.isHidden = true
            UICantidadACargar.isHidden = true
            TipoDeConvenio.isHidden = true
            DatosFactTitle.isHidden = true
            RazonSocialTitle.isHidden = true
            FactRazonSocialInput.isHidden = true
            RFCTitle.isHidden = true
            FactRFCInput.isHidden = true
            FacDomicilioTitle.isHidden = true
            FactDomicilioInput.isHidden = true
            FacEmailTitle.isHidden = true
            FactEmailInput.isHidden = true
            FacPhoneTitle.isHidden = true
            FactPhoneInput.isHidden = true
            Veh1Orig.isHidden = true
            veh1OrigSegment.isHidden = true
            
            TagVeh2Title.isHidden = true
            TagVeh2.isHidden = true
            verTarifasBtn.isHidden = true
            Contenedor.layoutIfNeeded()
            let visibleSubviews = Contenedor.arrangedSubviews.filter { !$0.isHidden }
            let totalHeight = visibleSubviews.reduce(0) { $0 + $1.frame.size.height }
            Contenedor.frame.size.height = totalHeight
        case 7:
            Pleca.text = "Cambio de puente"
            Veh1Orig.isHidden = true
            veh1OrigSegment.isHidden = true
            MotivoBajaTitle.isHidden = true
            MotivoBajaInput.isHidden = true
            noSentriPassIDTitle.isHidden = true
            SentriInput.isHidden = true
            polizaSeguroOrigenTitle.isHidden = true
            PolizaSeguroOrigen.isHidden = true
            BtnUploadSentri.isHidden = true
            btnPolizaSeguroDos.isHidden = true
            polizaSeguroDos.isHidden = true
            SentriImage.isHidden = true
            FechaExpTitle.isHidden = true
            DateInput.isHidden = true
            advSentriTitle.isHidden = true
            BtnUploadIDOfFrontal.isHidden = true
            idOficialFrontal.isHidden = true
            BtnUploadIDOfReverso.isHidden = true
            idOficialReverso.isHidden = true
            DomicilioPartTitle.isHidden = true
            CalleTitle.isHidden = true
            PersonalCalleInput.isHidden = true
            NoExteriorTitle.isHidden = true
            PersonalExteriorNumberInput.isHidden = true
            ColoniaTitle.isHidden = true
            PersonalColoniaInput.isHidden = true
            CiudadTitle.isHidden = true
            PersonalCityInput.isHidden = true
            EstadoTitle.isHidden = true
            PersonalStateInput.isHidden = true
            CPTitle.isHidden = true
            PersonalCPInput.isHidden = true
            btnTarjetaCirculacion.isHidden = true
            DatosVehTitle.isHidden = true
            Veh2Orig.isHidden = true
            veh2OrigSegment.isHidden = true
            VehMarcaTitle.isHidden = true
            BrandInput.isHidden = true
            VehModeloTitle.isHidden = true
            ModelInput.isHidden = true
            VehColorTitle.isHidden = true
            ColorInput.isHidden = true
            VehYearTitle.isHidden = true
            YearInput.isHidden = true
            PlacasInput.isHidden = true
            VehPlacasTitle.isHidden = true
            PuenteAdscripcionTitle.isHidden = true
            PuenteAdscripcionSegment.isHidden = true
            CarStateInput.isHidden = true
            VehicleStateSegment.isHidden = true
            tarjCirculacion.isHidden = true
            btnAprobacionUSA.isHidden = true
            AprobacionUSA.isHidden = true
            btnPolizaSeguro.isHidden = true
            polizaSeguro.isHidden = true
            btnCartaPoder.isHidden = true
            CartaPoderOpcional.isHidden = true
            DatosFactTitle.isHidden = true
            RazonSocialTitle.isHidden = true
            FactRazonSocialInput.isHidden = true
            RFCTitle.isHidden = true
            FactRFCInput.isHidden = true
            FacDomicilioTitle.isHidden = true
            FactDomicilioInput.isHidden = true
            FacEmailTitle.isHidden = true
            FactEmailInput.isHidden = true
            FacPhoneTitle.isHidden = true
            FactPhoneInput.isHidden = true
            Veh1Orig.isHidden = true
            veh1OrigSegment.isHidden = true
            
            TagVeh2Title.isHidden = true
            TagVeh2.isHidden = true
            verTarifasBtn.isHidden = true
            Contenedor.layoutIfNeeded()
            let visibleSubviews = Contenedor.arrangedSubviews.filter { !$0.isHidden }
            let totalHeight = visibleSubviews.reduce(0) { $0 + $1.frame.size.height }
            Contenedor.frame.size.height = totalHeight
            
        case 8:
            Pleca.text = "Cambio de convenio"
            Veh1Orig.isHidden = true
            veh1OrigSegment.isHidden = true
            MotivoBajaTitle.isHidden = true
            MotivoBajaInput.isHidden = true
            noSentriPassIDTitle.isHidden = true
            SentriInput.isHidden = true
            BtnUploadSentri.isHidden = true
            SentriImage.isHidden = true
            FechaExpTitle.isHidden = true
            btnPolizaSeguroDos.isHidden = true
            polizaSeguroDos.isHidden = true
            DateInput.isHidden = true
            advSentriTitle.isHidden = true
            BtnUploadIDOfFrontal.isHidden = true
            idOficialFrontal.isHidden = true
            BtnUploadIDOfReverso.isHidden = true
            idOficialReverso.isHidden = true
            polizaSeguroOrigenTitle.isHidden = true
            PolizaSeguroOrigen.isHidden = true
            DomicilioPartTitle.isHidden = true
            CalleTitle.isHidden = true
            PersonalCalleInput.isHidden = true
            NoExteriorTitle.isHidden = true
            PersonalExteriorNumberInput.isHidden = true
            ColoniaTitle.isHidden = true
            PersonalColoniaInput.isHidden = true
            CiudadTitle.isHidden = true
            PersonalCityInput.isHidden = true
            EstadoTitle.isHidden = true
            PersonalStateInput.isHidden = true
            CPTitle.isHidden = true
            PersonalCPInput.isHidden = true
            btnTarjetaCirculacion.isHidden = true
            DatosVehTitle.isHidden = true
            Veh2Orig.isHidden = true
            veh2OrigSegment.isHidden = true
            VehMarcaTitle.isHidden = true
            BrandInput.isHidden = true
            VehModeloTitle.isHidden = true
            ModelInput.isHidden = true
            VehColorTitle.isHidden = true
            ColorInput.isHidden = true
            VehYearTitle.isHidden = true
            YearInput.isHidden = true
            PlacasInput.isHidden = true
            VehPlacasTitle.isHidden = true
            PuenteAdscripcionTitle.isHidden = true
            PuenteAdscripcionSegment.isHidden = true
            CarStateInput.isHidden = true
            VehicleStateSegment.isHidden = true
            tarjCirculacion.isHidden = true
            btnAprobacionUSA.isHidden = true
            AprobacionUSA.isHidden = true
            btnPolizaSeguro.isHidden = true
            polizaSeguro.isHidden = true
            btnCartaPoder.isHidden = true
            CartaPoderOpcional.isHidden = true
            DatosFactTitle.isHidden = true
            RazonSocialTitle.isHidden = true
            FactRazonSocialInput.isHidden = true
            RFCTitle.isHidden = true
            FactRFCInput.isHidden = true
            FacDomicilioTitle.isHidden = true
            FactDomicilioInput.isHidden = true
            FacEmailTitle.isHidden = true
            FactEmailInput.isHidden = true
            FacPhoneTitle.isHidden = true
            FactPhoneInput.isHidden = true
            Veh1Orig.isHidden = true
            veh1OrigSegment.isHidden = true
            
            TagVeh2Title.isHidden = true
            TagVeh2.isHidden = true
            verTarifasBtn.isHidden = true
            Contenedor.layoutIfNeeded()
            let visibleSubviews = Contenedor.arrangedSubviews.filter { !$0.isHidden }
            let totalHeight = visibleSubviews.reduce(0) { $0 + $1.frame.size.height }
            Contenedor.frame.size.height = totalHeight
        case 9:
            Pleca.text = "Transferencia de saldo"
            MotivoBajaTitle.isHidden = true
            MotivoBajaTitle.isHidden = true
            noSentriPassIDTitle.isHidden = true
            SentriInput.isHidden = true
            BtnUploadSentri.isHidden = true
            SentriImage.isHidden = true
            FechaExpTitle.isHidden = true
            DateInput.isHidden = true
            advSentriTitle.isHidden = true
            BtnUploadIDOfFrontal.isHidden = true
            polizaSeguroOrigenTitle.isHidden = true
            PolizaSeguroOrigen.isHidden = true
            idOficialFrontal.isHidden = true
            BtnUploadIDOfReverso.isHidden = true
            idOficialReverso.isHidden = true
            DomicilioPartTitle.isHidden = true
            CalleTitle.isHidden = true
            PersonalCalleInput.isHidden = true
            NoExteriorTitle.isHidden = true
            PersonalExteriorNumberInput.isHidden = true
            ColoniaTitle.isHidden = true
            btnPolizaSeguroDos.isHidden = true
            polizaSeguroDos.isHidden = true
            PersonalColoniaInput.isHidden = true
            CiudadTitle.isHidden = true
            PersonalCityInput.isHidden = true
            EstadoTitle.isHidden = true
            PersonalStateInput.isHidden = true
            CPTitle.isHidden = true
            PersonalCPInput.isHidden = true
            btnTarjetaCirculacion.isHidden = true
            DatosVehTitle.text = "Vehiculo a transferir saldo"
            PuenteAdscripcionTitle.isHidden = true
            PuenteAdscripcionSegment.isHidden = true
            CarStateInput.isHidden = true
            VehicleStateSegment.isHidden = true
            tarjCirculacion.isHidden = true
            btnAprobacionUSA.isHidden = true
            AprobacionUSA.isHidden = true
            btnPolizaSeguro.isHidden = true
            polizaSeguro.isHidden = true
            btnCartaPoder.isHidden = true
            CartaPoderOpcional.isHidden = true
            TipoConvenioTitle.isHidden = true
            SeleccioneOrigenTitle.isHidden = true
            SegmentUSAMX.isHidden = true
            AnualidadTitle.isHidden = true
            AnualidadSegment.isHidden = true
            SaldoTitle.isHidden = true
            SaldoSegment.isHidden = true
            UICantidadACargar.isHidden = true
            TipoDeConvenio.isHidden = true
            DatosFactTitle.isHidden = true
            RazonSocialTitle.isHidden = true
            FactRazonSocialInput.isHidden = true
            RFCTitle.isHidden = true
            FactRFCInput.isHidden = true
            FacDomicilioTitle.isHidden = true
            FactDomicilioInput.isHidden = true
            FacEmailTitle.isHidden = true
            FactEmailInput.isHidden = true
            FacPhoneTitle.isHidden = true
            FactPhoneInput.isHidden = true
            Veh1Orig.isHidden = true
            veh1OrigSegment.isHidden = true
            MotivoBajaInput.isHidden = true
            verTarifasBtn.isHidden = true
            Contenedor.layoutIfNeeded()
            let visibleSubviews = Contenedor.arrangedSubviews.filter { !$0.isHidden }
            let totalHeight = visibleSubviews.reduce(0) { $0 + $1.frame.size.height }
            Contenedor.frame.size.height = totalHeight
        default:
            break
        }

       
    }
    
    @IBAction func segmentVehOrig(_ sender: UISegmentedControl) {
        positionCountry = sender.selectedSegmentIndex
        if positionCountry == 0 {
            veh1Orig = "Nacional"
        }else {
            veh1Orig = "USA"
        }
        
        AnualidadSegment.selectedSegmentIndex = UISegmentedControl.noSegment
        SaldoSegment.selectedSegmentIndex = UISegmentedControl.noSegment
    }
    
    @IBAction func segmentVehOrigNuevo(_ sender: UISegmentedControl) {
        positionCountry = sender.selectedSegmentIndex
        if positionCountry == 0 {
            veh2Orig = "Nacional"
        }else {
            veh2Orig = "USA"
        }
        
        AnualidadSegment.selectedSegmentIndex = UISegmentedControl.noSegment
        SaldoSegment.selectedSegmentIndex = UISegmentedControl.noSegment
    }
    
    
    @IBAction func segmentPolizaSeguroOrigen(_ sender: UISegmentedControl) {
        positionCountry = sender.selectedSegmentIndex
        if positionCountry == 0 {
            seguroOrigen = "MEX"
        }else {
            seguroOrigen = "USA"
        }
    }
    
    @IBAction func segmentCountry(_ sender: UISegmentedControl) {
        positionCountry = sender.selectedSegmentIndex
        self.UICantidadACargar.text = ""
        self.Cantidad = ""
        self.TipoDeConvenio.text = ""
        if positionCountry == 0 {
            pais = "Mexico"
            SaldoSegment.setTitle("$\(saldo_zaragoza1_mx) MXN", forSegmentAt: 0)
            SaldoSegment.setTitle("$\(saldo_zaragoza2_mx) MXN", forSegmentAt: 1)
        }else {
            pais = "USA"
            SaldoSegment.setTitle("$\(saldo_zaragoza1_us) MXN", forSegmentAt: 0)
            SaldoSegment.setTitle("$\(saldo_zaragoza2_us) MXN", forSegmentAt: 1)
        }
        
        AnualidadSegment.selectedSegmentIndex = UISegmentedControl.noSegment
        SaldoSegment.selectedSegmentIndex = UISegmentedControl.noSegment
    }
 
    @IBAction func AnualidadSegment(_ sender: UISegmentedControl) {
        SaldoSegment.selectedSegmentIndex = -1
        
        let selectedIndex = sender.selectedSegmentIndex
        
        
        switch selectedIndex {
        case 0:
            TipoDeConvenio.text = "Zaragoza"
            if pais.contains("Mexico") {
                Cantidad = anual_zaragoza_mx
                conv_saldo = "0"
                conv_anualidad = anual_zaragoza_mx
                UICantidadACargar.text = "Tarifa: \(anual_zaragoza_mx)"
                CantidadACargar = anual_zaragoza_mx
            }else {
                conv_saldo = "0"
                conv_anualidad = anual_zaragoza_us
                Cantidad = anual_zaragoza_us
                UICantidadACargar.text = "Tarifa: \(anual_zaragoza_us)"
                CantidadACargar = anual_zaragoza_us
            }
        case 1:
            TipoDeConvenio.text = "Lerdo"
            if pais.contains("Mexico") {
                Cantidad = anual_lerdo_mx
                conv_saldo = "0"
                conv_anualidad = anual_lerdo_mx
                UICantidadACargar.text = "Tarifa: \(anual_lerdo_mx)"
                CantidadACargar = anual_lerdo_mx
            }else {
                Cantidad = anual_lerdo_us
                conv_saldo = "0"
                conv_anualidad = anual_lerdo_us
                UICantidadACargar.text = "Tarifa: \(anual_lerdo_us)"
                CantidadACargar = anual_lerdo_us
                
            }
        case 2:
            TipoDeConvenio.text = "Mixta (Zaragoza - Lerdo)"
            if pais.contains("Mexico") {
                Cantidad = anual_mixto_mx
                conv_saldo = "0"
                conv_anualidad = anual_mixto_mx
                UICantidadACargar.text = "Tarifa: \(anual_mixto_mx)"
                CantidadACargar = anual_mixto_mx
            }else {
                Cantidad = anual_mixto_us
                conv_saldo = "0"
                conv_anualidad = anual_mixto_us
                UICantidadACargar.text = "Tarifa: \(anual_mixto_us)"
                CantidadACargar = anual_mixto_us
            }
        default:
            break
        }
       
    }
    
    @IBAction func SaldoSegment(_ sender: UISegmentedControl) {
        AnualidadSegment.selectedSegmentIndex = -1
        
        let selectedIndex = sender.selectedSegmentIndex
        
        switch selectedIndex {
        case 0:
            
            if pais.contains("Mexico") {
                TipoDeConvenio.text = "Zaragoza"
                Cantidad = saldo_zaragoza1_mx
                conv_saldo = saldo_zaragoza1_mx
                conv_anualidad = "0"
                UICantidadACargar.text = "Tarifa: \(saldo_zaragoza1_mx)"
                CantidadACargar = saldo_zaragoza1_mx
            }else {
                TipoDeConvenio.text = "Zaragoza"
                Cantidad = saldo_zaragoza1_us
                conv_saldo = saldo_zaragoza1_us
                conv_anualidad = "0"
                UICantidadACargar.text = "Tarifa: \(saldo_zaragoza1_us)"
                CantidadACargar = saldo_zaragoza1_us
    
            }
            
        case 1:
            
            if pais.contains("Mexico") {
                TipoDeConvenio.text = "Zaragoza"
                Cantidad = saldo_zaragoza2_mx
                conv_saldo = saldo_zaragoza2_mx
                conv_anualidad = "0"
                UICantidadACargar.text = "Tarifa: \(saldo_zaragoza2_mx)"
                CantidadACargar = saldo_zaragoza2_mx
            }else {
                TipoDeConvenio.text = "Zaragoza"
                Cantidad = saldo_zaragoza2_us
                conv_saldo = saldo_zaragoza2_us
                conv_anualidad = "0"
                UICantidadACargar.text = "Tarifa: \(saldo_zaragoza2_us)"
                CantidadACargar = saldo_zaragoza2_us
            }
        default:
            break
        }
        
    }
    
    @objc func tapDetected() {
        TarifasView.isHidden = true
   }
    
    @IBAction func showSign(_ sender: Any) {
        SignContainer.isHidden = false
    }
    
    @IBAction func hideLineamientosContainer(_ sender: Any) {
        SignContainer.isHidden = true
    }
    
    @IBAction func showSignaturePad(_ sender: Any) {
        SignContainer.isHidden = true
        SignaturePadContainerFather.isHidden = false
    }
    
    @IBAction func clearSign(_ sender: Any) {
        SignaturePad.clear()
    }
    
    @IBAction func ComenzarTramite(_ sender: Any) {
        SignContainer.isHidden = true
        SignaturePadContainerFather.isHidden = true
        
       // var Email:String = ""
       // var Name:String = ""
       // var FirebaseToken:String = ""
        var LoginToken:String = ""
        
        let Lista:Array<String> = DB_Manager().getUsuario()
        for i in 0..<(Lista.count) {
            
            let Usuario = Lista[i].components(separatedBy: "∑")
            
            //Email = Usuario[0]
            //Name = Usuario[1]
            //FirebaseToken = Usuario[2]
            LoginToken = Usuario[3]
        }
        
       
        LoaderContainer.isHidden = false

        
        switch TipoTramite{
        case 0:
            sendTramite(token: LoginToken, tramite: "https://lineaexpressapp.desarrollosenlanube.net/api/v1/procs/p01", noTramite: TipoTramite)
        case 1:
            sendTramite(token: LoginToken, tramite: "https://lineaexpressapp.desarrollosenlanube.net/api/v1/procs/p03", noTramite: TipoTramite)
        case 2:
            sendTramite(token: LoginToken, tramite: "https://lineaexpressapp.desarrollosenlanube.net/api/v1/procs/p03", noTramite: TipoTramite)
        case 3:
            sendTramite(token: LoginToken, tramite: "https://lineaexpressapp.desarrollosenlanube.net/api/v1/procs/p03", noTramite: TipoTramite)
        case 4:
            sendTramite(token: LoginToken, tramite: "https://lineaexpressapp.desarrollosenlanube.net/api/v1/procs/p03", noTramite: TipoTramite)
        case 5:
            sendTramite(token: LoginToken, tramite: "https://lineaexpressapp.desarrollosenlanube.net/api/v1/procs/p05", noTramite: TipoTramite)
        case 6:
            sendTramite(token: LoginToken, tramite: "https://lineaexpressapp.desarrollosenlanube.net/api/v1/procs/p03", noTramite: TipoTramite)
        case 7:
            sendTramite(token: LoginToken, tramite: "https://lineaexpressapp.desarrollosenlanube.net/api/v1/procs/p02", noTramite: TipoTramite)
        case 8:
            sendTramite(token: LoginToken, tramite: "https://lineaexpressapp.desarrollosenlanube.net/api/v1/procs/p02", noTramite: TipoTramite)
        case 9:
            sendTramite(token: LoginToken, tramite: "https://lineaexpressapp.desarrollosenlanube.net/api/v1/procs/p04", noTramite: TipoTramite)
        default:
            break
        }

        
        
        
        
        
    }
    
    @IBAction func VehicleState(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        
        switch selectedIndex {
        case 0:
            PuenteAdscripcionZaragoza = "1"
            PuenteAdscripcionLerdo = "0"
        case 1:
            PuenteAdscripcionZaragoza = "0"
            PuenteAdscripcionLerdo = "1"
        default:
            break
        }
    }
    
    @objc func dateChange(datePicker: UIDatePicker) {
        DateInput.text = formatDate(date: datePicker.date)
    }
    
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func createBorderColor() {
    
        
        SentriInput.layer.borderColor = blackGlobal?.cgColor
        DateInput.layer.borderColor = blackGlobal?.cgColor
        PersonalCalleInput.layer.borderColor = blackGlobal?.cgColor
        PersonalExteriorNumberInput.layer.borderColor = blackGlobal?.cgColor
        PersonalColoniaInput.layer.borderColor = blackGlobal?.cgColor
        PersonalCityInput.layer.borderColor = blackGlobal?.cgColor
        PersonalStateInput.layer.borderColor = blackGlobal?.cgColor
        PersonalCPInput.layer.borderColor = blackGlobal?.cgColor
        FactRazonSocialInput.layer.borderColor = blackGlobal?.cgColor
        FactRFCInput.layer.borderColor = blackGlobal?.cgColor
        FactDomicilioInput.layer.borderColor = blackGlobal?.cgColor
        FactEmailInput.layer.borderColor = blackGlobal?.cgColor
        FactPhoneInput.layer.borderColor = blackGlobal?.cgColor
        BrandInput.layer.borderColor = blackGlobal?.cgColor
        ModelInput.layer.borderColor = blackGlobal?.cgColor
        ColorInput.layer.borderColor = blackGlobal?.cgColor
        YearInput.layer.borderColor = blackGlobal?.cgColor
        PlacasInput.layer.borderColor = blackGlobal?.cgColor
        CarStateInput.layer.borderColor = blackGlobal?.cgColor
        TipoDeConvenio.layer.borderColor = blackGlobal?.cgColor
        SignaturePad.layer.borderColor = blackGlobal?.cgColor
        
        SentriInput.layer.borderWidth = 1
        DateInput.layer.borderWidth = 1
        PersonalCalleInput.layer.borderWidth = 1
        PersonalExteriorNumberInput.layer.borderWidth = 1
        PersonalColoniaInput.layer.borderWidth = 1
        PersonalCityInput.layer.borderWidth = 1
        PersonalStateInput.layer.borderWidth = 1
        PersonalCPInput.layer.borderWidth = 1
        FactRazonSocialInput.layer.borderWidth = 1
        FactRFCInput.layer.borderWidth = 1
        FactDomicilioInput.layer.borderWidth = 1
        FactEmailInput.layer.borderWidth = 1
        FactPhoneInput.layer.borderWidth = 1
        BrandInput.layer.borderWidth = 1
        ModelInput.layer.borderWidth = 1
        ColorInput.layer.borderWidth = 1
        YearInput.layer.borderWidth = 1
        PlacasInput.layer.borderWidth = 1
        CarStateInput.layer.borderWidth = 1
        TipoDeConvenio.layer.borderWidth = 1
        SignaturePad.layer.borderWidth = 1
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           guard let text = textField.text else { return true }
           let newLength = text.count + string.count - range.length
           
           // Impedir que se ingresen más caracteres una vez que se alcance el límite de 9
           return newLength <= 9
       }
    
    
    func startRounding() {
        self.Contenedor.layer.cornerRadius = 20
        self.Pleca.layer.cornerRadius = 10
        self.LineamientosContainer.layer.cornerRadius = 20
        self.SignaturePad.layer.cornerRadius = 20
        self.SignaturePadContainer.layer.cornerRadius = 20
        
        //Inputs Corners
        self.SentriInput.layer.cornerRadius = 5
        self.DateInput.layer.cornerRadius = 5
        self.PersonalCalleInput.layer.cornerRadius = 5
        self.PersonalExteriorNumberInput.layer.cornerRadius = 5
        self.PersonalColoniaInput.layer.cornerRadius = 5
        self.PersonalCityInput.layer.cornerRadius = 5
        self.PersonalStateInput.layer.cornerRadius = 5
        self.PersonalCPInput.layer.cornerRadius = 5
        self.FactRazonSocialInput.layer.cornerRadius = 5
        self.FactRFCInput.layer.cornerRadius = 5
        self.FactDomicilioInput.layer.cornerRadius = 5
        self.FactEmailInput.layer.cornerRadius = 5
        self.FactPhoneInput.layer.cornerRadius = 5
        self.BrandInput.layer.cornerRadius = 5
        self.ModelInput.layer.cornerRadius = 5
        self.ColorInput.layer.cornerRadius = 5
        self.YearInput.layer.cornerRadius = 5
        self.PlacasInput.layer.cornerRadius = 5
        self.CarStateInput.layer.cornerRadius = 5
        self.TipoDeConvenio.layer.cornerRadius = 5
        
        //End Inputs Corners
        
        Contenedor.layer.masksToBounds = true
        Pleca.layer.masksToBounds = true
        SignaturePad.layer.masksToBounds = true
        
        //Ajustar padding a StackView
        Contenedor.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        Contenedor.isLayoutMarginsRelativeArrangement = true
        
    }
    
    @IBAction func SentriBtnClicked(_ sender: Any) {
    
        let title:String = "SENTRI"
        currentPhoto = 1
        
        let ac = UIAlertController(title: "Toma Fotografía", message: "Toma o selecciona una fotografía de \(title) ", preferredStyle: .actionSheet)
        let cameraBtn = UIAlertAction(title: "Cámara", style: .default) { [self] (_) in
            self.showImagePicker(selectedSource: .camera)
        }

        let libraryBtn = UIAlertAction(title: "Galería", style: .default) { (_) in
            self.showImagePicker(selectedSource: .photoLibrary)
        }
        let documentPickerBtn = UIAlertAction(title: "Seleccionar Archivo", style: .default) { (_) in
            let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf])

            documentPicker.delegate = self
            self.present(documentPicker, animated: true, completion: nil)
        }
        let cancelBtn = UIAlertAction(title: "Cancelar", style: .cancel) { (_) in
        }
        
        ac.addAction(cameraBtn)
        ac.addAction(libraryBtn)
        ac.addAction(documentPickerBtn)
        ac.addAction(cancelBtn)
        
        self.present(ac, animated: true, completion: nil)
    }
    
    @IBAction func idOficialFrontalClicked(_ sender: Any) {
        let title:String = "ID Oficial (Frontal)"
        currentPhoto = 2
        
        let ac = UIAlertController(title: "Toma Fotografía", message: "Toma o selecciona una fotografía de \(title) ", preferredStyle: .actionSheet)
        let cameraBtn = UIAlertAction(title: "Cámara", style: .default) { [self] (_) in
            self.showImagePicker(selectedSource: .camera)
        }
        let libraryBtn = UIAlertAction(title: "Galería", style: .default) { (_) in
            self.showImagePicker(selectedSource: .photoLibrary)
        }
        let documentPickerBtn = UIAlertAction(title: "Seleccionar Archivo", style: .default) { (_) in
            let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf])
            documentPicker.delegate = self
            self.present(documentPicker, animated: true, completion: nil)
        }
        let cancelBtn = UIAlertAction(title: "Cancelar", style: .cancel) { (_) in
        }
        
        ac.addAction(cameraBtn)
        ac.addAction(libraryBtn)
        ac.addAction(documentPickerBtn)
        ac.addAction(cancelBtn)
        
        self.present(ac, animated: true, completion: nil)
    }
    
    @IBAction func idOficialReversoClicked(_ sender: Any) {
        let title:String = "ID Oficial (Reverso)"
        currentPhoto = 3
        
        let ac = UIAlertController(title: "Toma Fotografía", message: "Toma o selecciona una fotografía de \(title) ", preferredStyle: .actionSheet)
        let cameraBtn = UIAlertAction(title: "Cámara", style: .default) { [self] (_) in
            self.showImagePicker(selectedSource: .camera)
        }
        let libraryBtn = UIAlertAction(title: "Galería", style: .default) { (_) in
            self.showImagePicker(selectedSource: .photoLibrary)
        }
        let documentPickerBtn = UIAlertAction(title: "Seleccionar Archivo", style: .default) { (_) in
            let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf])
            documentPicker.delegate = self
            self.present(documentPicker, animated: true, completion: nil)
        }
        let cancelBtn = UIAlertAction(title: "Cancelar", style: .cancel) { (_) in
        }
        
        ac.addAction(cameraBtn)
        ac.addAction(libraryBtn)
        ac.addAction(documentPickerBtn)
        ac.addAction(cancelBtn)
        
        self.present(ac, animated: true, completion: nil)
    }
    
    @IBAction func tarjetaCirculacionClicked(_ sender: Any) {
        let title:String = "Tarjeta de circulación"
        currentPhoto = 4
        
        let ac = UIAlertController(title: "Toma Fotografía", message: "Toma o selecciona una fotografía de \(title) ", preferredStyle: .actionSheet)
        let cameraBtn = UIAlertAction(title: "Cámara", style: .default) { [self] (_) in
            self.showImagePicker(selectedSource: .camera)
        }
        let libraryBtn = UIAlertAction(title: "Galería", style: .default) { (_) in
            self.showImagePicker(selectedSource: .photoLibrary)
        }
        let documentPickerBtn = UIAlertAction(title: "Seleccionar Archivo", style: .default) { (_) in
            let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf])
            documentPicker.delegate = self
            self.present(documentPicker, animated: true, completion: nil)
        }
        let cancelBtn = UIAlertAction(title: "Cancelar", style: .cancel) { (_) in
        }
        
        ac.addAction(cameraBtn)
        ac.addAction(libraryBtn)
        ac.addAction(documentPickerBtn)
        ac.addAction(cancelBtn)
        
        self.present(ac, animated: true, completion: nil)
    }
    
    @IBAction func polizaSeguroClicked(_ sender: Any) {
        let title:String = "Poliza de Seguro"
        currentPhoto = 5
        
        let ac = UIAlertController(title: "Toma Fotografía", message: "Toma o selecciona una fotografía de \(title) ", preferredStyle: .actionSheet)
        let cameraBtn = UIAlertAction(title: "Cámara", style: .default) { [self] (_) in
            self.showImagePicker(selectedSource: .camera)
        }
        let libraryBtn = UIAlertAction(title: "Galería", style: .default) { (_) in
            self.showImagePicker(selectedSource: .photoLibrary)
        }
        let documentPickerBtn = UIAlertAction(title: "Seleccionar Archivo", style: .default) { (_) in
            let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf])
            documentPicker.delegate = self
            self.present(documentPicker, animated: true, completion: nil)
        }
        let cancelBtn = UIAlertAction(title: "Cancelar", style: .cancel) { (_) in
        }
        
        ac.addAction(cameraBtn)
        ac.addAction(libraryBtn)
        ac.addAction(documentPickerBtn)
        ac.addAction(cancelBtn)
        
        self.present(ac, animated: true, completion: nil)
    }
    
    @IBAction func polizaSeguroDosClicked(_ sender: Any) {
        let title:String = "Poliza de Seguro"
        currentPhoto = 9
        
        let ac = UIAlertController(title: "Toma Fotografía", message: "Toma o selecciona una fotografía de \(title) ", preferredStyle: .actionSheet)
        let cameraBtn = UIAlertAction(title: "Cámara", style: .default) { [self] (_) in
            self.showImagePicker(selectedSource: .camera)
        }
        let libraryBtn = UIAlertAction(title: "Galería", style: .default) { (_) in
            self.showImagePicker(selectedSource: .photoLibrary)
        }
        let documentPickerBtn = UIAlertAction(title: "Seleccionar Archivo", style: .default) { (_) in
            let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf])
            documentPicker.delegate = self
            self.present(documentPicker, animated: true, completion: nil)
        }
        let cancelBtn = UIAlertAction(title: "Cancelar", style: .cancel) { (_) in
        }
        
        ac.addAction(cameraBtn)
        ac.addAction(libraryBtn)
        ac.addAction(documentPickerBtn)
        ac.addAction(cancelBtn)
        
        self.present(ac, animated: true, completion: nil)
    }
    
    @IBAction func aprobacionUsaClicked(_ sender: Any) {
        let title:String = "Aprobación de vehículo por USA"
        currentPhoto = 6
        
        let ac = UIAlertController(title: "Toma Fotografía", message: "Toma o selecciona una fotografía de \(title) ", preferredStyle: .actionSheet)
        let cameraBtn = UIAlertAction(title: "Cámara", style: .default) { [self] (_) in
            self.showImagePicker(selectedSource: .camera)
        }
        let libraryBtn = UIAlertAction(title: "Galería", style: .default) { (_) in
            self.showImagePicker(selectedSource: .photoLibrary)
        }
        let documentPickerBtn = UIAlertAction(title: "Seleccionar Archivo", style: .default) { (_) in
            let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf])
            documentPicker.delegate = self
            self.present(documentPicker, animated: true, completion: nil)
        }
        let cancelBtn = UIAlertAction(title: "Cancelar", style: .cancel) { (_) in
        }
        
        ac.addAction(cameraBtn)
        ac.addAction(libraryBtn)
        ac.addAction(documentPickerBtn)
        ac.addAction(cancelBtn)
        
        self.present(ac, animated: true, completion: nil)
    }
    
    @IBAction func cartaPoderOpcionalClicked(_ sender: Any) {
        let title:String = "Carta Poder Del Titular (Opcional)"
        currentPhoto = 7
        
        let ac = UIAlertController(title: "Toma Fotografía", message: "Toma o selecciona una fotografía de \(title) ", preferredStyle: .actionSheet)
        let cameraBtn = UIAlertAction(title: "Cámara", style: .default) { [self] (_) in
            self.showImagePicker(selectedSource: .camera)
        }
        let libraryBtn = UIAlertAction(title: "Galería", style: .default) { (_) in
            self.showImagePicker(selectedSource: .photoLibrary)
        }
        let documentPickerBtn = UIAlertAction(title: "Seleccionar Archivo", style: .default) { (_) in
            let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf])
            documentPicker.delegate = self
            self.present(documentPicker, animated: true, completion: nil)
        }
        let cancelBtn = UIAlertAction(title: "Cancelar", style: .cancel) { (_) in
        }
        
        ac.addAction(cameraBtn)
        ac.addAction(libraryBtn)
        ac.addAction(documentPickerBtn)
        ac.addAction(cancelBtn)
        
        self.present(ac, animated: true, completion: nil)
    }
    
    @IBAction func verTarifas(_ sender: Any) {
        TarifasView.isHidden = false
        
    }
    
    
    
    func showImagePicker(selectedSource: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(selectedSource) else {
            print("El recurso introducido no está disponible")
            return
        }
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = selectedSource
        imagePickerController.allowsEditing = false
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        let selectedImage = originalImage.scale(to: CGSize(width: 480, height: 640))
        print("PDFURL ha sido borrada")
        
        switch currentPhoto {
        case 1:
            pdfUrlOne = ""
            self.SentriImage.image = selectedImage
        case 2:
            pdfUrlTwo = ""
            self.idOficialFrontal.image = selectedImage
        case 3:
            pdfUrlThree = ""
            self.idOficialReverso.image = selectedImage
        case 4:
            pdfUrlFour = ""
            self.tarjCirculacion.image = selectedImage
        case 5:
            pdfUrlFive = ""
            self.polizaSeguro.image = selectedImage
        case 6:
            pdfUrlSix = ""
            self.AprobacionUSA.image = selectedImage
        case 7:
            pdfUrlSeven = ""
            self.CartaPoderOpcional.image = selectedImage
        case 9:
            pdfUrlEighth = ""
            self.polizaSeguroDos.image = selectedImage
        default:
            break
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        print("No ha seleccionado ninguna imagen")
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            // Aquí puedes manejar los archivos seleccionados
        var pdfUrl = ""
     
            for url in urls {
                // Procesa el archivo seleccionado
                print("Archivo seleccionado: \(url.lastPathComponent)")
                print("Archivo seleccionado url: \(url)")
                
                let url = URL(string: "\(url)") // Supongamos que tienes la URL

                if let pathString = url?.path {
                    let urlString = URL(fileURLWithPath: pathString).absoluteString
                    pdfUrl = String(urlString)
                } else {
                    print("La URL no es válida")
                }
            }
        
        switch currentPhoto {
        case 1:
            pdfUrlOne = pdfUrl
            self.SentriImage.image = UIImage(named: "pdfImg")
        case 2:
            pdfUrlTwo = pdfUrl
            self.idOficialFrontal.image = UIImage(named: "pdfImg")
        case 3:
            pdfUrlThree = pdfUrl
            self.idOficialReverso.image = UIImage(named: "pdfImg")
        case 4:
            pdfUrlFour = pdfUrl
            self.tarjCirculacion.image = UIImage(named: "pdfImg")
        case 5:
            pdfUrlFive = pdfUrl
            self.polizaSeguro.image = UIImage(named: "pdfImg")
        case 6:
            pdfUrlSix = pdfUrl
            self.AprobacionUSA.image = UIImage(named: "pdfImg")
        case 7:
            pdfUrlSeven = pdfUrl
            self.CartaPoderOpcional.image = UIImage(named: "pdfImg")
        case 9:
            pdfUrlEighth = pdfUrl
            self.polizaSeguroDos.image = UIImage(named: "pdfImg")
        default:
            break
        }
        
        
        }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        // Manejar la cancelación de la selección de archivos
    }
    
    func sendTramite(token:String, tramite:String, noTramite:Int) {
        var sentri:String = ""
        var sentri_vencimiento:String = ""
        sentri = SentriInput.text!
        sentri_vencimiento = DateInput.text!
        let dom_calle:String = PersonalCalleInput.text!
        let dom_numero_ext:String = PersonalExteriorNumberInput.text!
        let dom_colonia:String = PersonalColoniaInput.text!
        let dom_cuidad:String = PersonalCityInput.text!
        let dom_estado:String = PersonalStateInput.text!
        let dom_cp:String = PersonalCPInput.text!
        let num_tag:String = tag
        let veh_marca:String = BrandInput.text!
        let veh_modelo:String = ModelInput.text!
        let veh_color:String = ColorInput.text!
        let veh_anio:String = YearInput.text!
        let veh_placas:String = PlacasInput.text!
        let veh_origen:String = CarState
        let tipoConvenio:String = CantidadACargar
        
        if sentri.isEmpty {
            sentri = Sentri
        }
        if sentri_vencimiento.isEmpty {
            sentri_vencimiento = SentriFecha
        }
        
        if noTramite == 0 {
            
            
            if veh1Marca.contains("0") {
                print("Entra a 0")
                json = ["sentri":sentri,"sentri_vencimiento":sentri_vencimiento,"dom_calle":dom_calle,"dom_numero_ext":dom_numero_ext,"dom_colonia":dom_colonia,"dom_ciudad":dom_cuidad,"dom_estado":dom_estado,"dom_cp":dom_cp,"fac_razon_social":localRazonSocialFiscal,"fac_rfc":localRFCFiscal,"fac_dom_fiscal":localDomFiscal,"fac_email":localEmailFiscal,"fac_telefono":localTelefonoFiscal,"veh_marca":veh_marca,"veh_modelo":veh_modelo,"veh_color":veh_color,"veh_anio":veh_anio,"veh_placas":veh_placas,"veh_origen":veh_origen,"tipoConvenio":tipoConvenio,"conv_saldo":conv_saldo,"conv_anualidad":conv_anualidad]
                
            }
            if veh1Marca.elementsEqual("1"){
                print("Entra a 1")
                json = ["sentri":sentri,"sentri_vencimiento":sentri_vencimiento,"dom_calle":"N/A","dom_numero_ext":"N/A","dom_colonia":"N/A","dom_ciudad":"N/A","dom_estado":"N/A","dom_cp":"N/A","fac_razon_social":localRazonSocialFiscal,"fac_rfc":localRFCFiscal,"fac_dom_fiscal":localDomFiscal,"fac_email":localEmailFiscal,"fac_telefono":localTelefonoFiscal,"veh_marca":veh_marca,"veh_modelo":veh_modelo,"veh_color":veh_color,"veh_anio":veh_anio,"veh_placas":veh_placas,"veh_origen":veh_origen,"tipoConvenio":tipoConvenio,"conv_saldo":conv_saldo,"conv_anualidad":conv_anualidad]
            }
            
            
           
        }
        if noTramite == 1 { //Cambio de vehiculo
            json = ["sp": 1,"fac_razon_social": localRazonSocialFiscal, "fac_rfc": localRFCFiscal, "fac_dom_fiscal": localDomFiscal, "fac_email": localEmailFiscal, "fac_telefono": localTelefonoFiscal, "num_tag": num_tag, "veh1_marca": veh1Marca, "veh1_modelo": veh1Modelo, "veh1_color": veh1Color, "veh1_anio": veh1Anio, "veh1_placas": veh1Placa, "veh1_origen": "N/A", "veh2_marca": BrandInput.text ?? "", "veh2_modelo": ModelInput.text ?? "", "veh2_color": ColorInput.text ?? "", "veh2_anio": YearInput.text ?? "", "veh2_placas": PlacasInput.text ?? "", "veh2_origen": "N/A", "sentri":Sentri,"sentri_vencimiento":SentriFecha]
        }
        if noTramite == 2 { //Cambio de tag
            json = ["sp": 2, "fac_razon_social": localRazonSocialFiscal, "fac_rfc": localRFCFiscal, "fac_dom_fiscal": localDomFiscal, "fac_email": localEmailFiscal, "fac_telefono": localTelefonoFiscal, "num_tag": num_tag, "veh1_marca": veh1Marca, "veh1_modelo": veh1Modelo, "veh1_color": veh1Color, "veh1_anio": veh1Anio, "veh1_placas": veh1Placa, "veh1_origen": "N/A", "veh2_marca": veh1Marca, "veh2_modelo": veh1Modelo, "veh2_color": veh1Color, "veh2_anio": veh1Anio, "veh2_placas": veh1Placa, "veh2_origen": "N/A", "sentri":Sentri, "comments": MotivoBajaInput.text ?? "", "sentri_vencimiento":SentriFecha]

            //SentriFecha
        }
        if noTramite == 3 { //Actualizacion de poliza
            json = ["sp": 3, "fac_razon_social": localRazonSocialFiscal, "fac_rfc": localRFCFiscal, "fac_dom_fiscal": localDomFiscal, "fac_email": localEmailFiscal, "fac_telefono": localTelefonoFiscal, "num_tag": num_tag, "veh1_marca": veh1Marca, "veh1_modelo": veh1Modelo, "veh1_color": veh1Color, "veh1_anio": veh1Anio, "veh1_placas": veh1Placa, "veh1_origen": "N/A", "veh2_marca": "N/A", "veh2_modelo": "N/A", "veh2_color": "N/A", "veh2_anio": "N/A", "veh2_placas": "N/A", "veh2_origen": "N/A", "sentri":Sentri, "sentri_vencimiento":SentriFecha, "seguro_origen": seguroOrigen]

        }
        if noTramite == 4  { //Actualizacion de placas
            json = ["sp": 4, "fac_razon_social": localRazonSocialFiscal, "fac_rfc": localRFCFiscal, "fac_dom_fiscal": localDomFiscal, "fac_email": localEmailFiscal, "fac_telefono": localTelefonoFiscal, "num_tag": num_tag, "veh1_marca": veh1Marca, "veh1_modelo": veh1Modelo, "veh1_color": veh1Color, "veh1_anio": veh1Anio, "veh1_placas": veh1Placa, "veh1_origen": "N/A", "veh2_marca": "N/A", "veh2_modelo": "N/A", "veh2_color": "N/A", "veh2_anio": "N/A", "veh2_placas": PlacasInput.text ?? "", "veh2_origen": "N/A", "sentri":Sentri, "sentri_vencimiento":SentriFecha]

        }
        
        if noTramite == 5  { //Baja de vehiculo
            json = ["num_tag": num_tag, "veh_marca": veh1Marca, "veh_modelo": veh1Modelo, "veh_color": veh1Color, "veh_anio": veh1Anio, "veh_placas": veh1Placa, "veh_origen": "N/A", "motivo": MotivoBajaInput.text ?? "", "veh_adscrip_zaragoza": PuenteAdscripcionZaragoza, "veh_adscrip_lerdo": PuenteAdscripcionLerdo, "sentri":Sentri, "sentri_vencimiento":SentriFecha]
        }
        if noTramite == 6  { //Desactivar TAG
            json = ["sp": 5,"fac_razon_social": localRazonSocialFiscal, "fac_rfc": localRFCFiscal, "fac_dom_fiscal": localDomFiscal, "fac_email": localEmailFiscal, "fac_telefono": localTelefonoFiscal, "num_tag": num_tag, "veh1_marca": veh1Marca, "veh1_modelo": veh1Modelo, "veh1_color": veh1Color, "veh1_anio": veh1Anio, "veh1_placas": veh1Placa, "comments": MotivoBajaInput.text ?? "", "veh1_origen": "N/A", "veh2_marca": "N/A", "veh2_modelo": "N/A", "veh2_color": "N/A", "veh2_anio": "N/A", "veh2_placas":"N/A", "veh2_origen": "N/A", "sentri":Sentri, "sentri_vencimiento":SentriFecha]
        }
        if noTramite == 7  { //Cambiar puente
            json = ["sp": 6,"sentri":Sentri,"sentri_vencimiento":SentriFecha,"dom_calle":"N/A","dom_numero_ext":"N/A","dom_colonia":"N/A","dom_ciudad":"N/A","dom_estado":"N/A","dom_cp":"N/A", "fac_razon_social": localRazonSocialFiscal, "fac_rfc": localRFCFiscal, "fac_dom_fiscal": localDomFiscal, "fac_email": localEmailFiscal, "fac_telefono": localTelefonoFiscal,"veh_marca":veh1Marca,"veh_modelo":veh1Modelo,"veh_color":veh1Color,"veh_anio":veh1Anio,"veh_placas":veh1Placa,"veh_origen":"N/A","tipoConvenio":tipoConvenio,"conv_saldo":conv_saldo,"conv_anualidad":conv_anualidad]
        }
        if noTramite == 8  { //Cambiar convenio
            json = ["sp": 7,"sentri":Sentri,"sentri_vencimiento":SentriFecha,"dom_calle":"N/A","dom_numero_ext":"N/A","dom_colonia":"N/A","dom_ciudad":"N/A","dom_estado":"N/A","dom_cp":"N/A","fac_razon_social":localRazonSocialFiscal,"fac_rfc":localRFCFiscal,"fac_dom_fiscal":localDomFiscal,"fac_email":localEmailFiscal,"fac_telefono":localTelefonoFiscal,"veh_marca":veh1Marca,"veh_modelo":veh1Modelo,"veh_color":veh1Color,"veh_anio":veh1Anio,"veh_placas":veh1Placa,"veh_origen":"N/A","tipoConvenio":tipoConvenio,"conv_saldo":conv_saldo,"conv_anualidad":conv_anualidad]
        }
        if noTramite == 9  { //Transferir saldo
            json = ["sentri":Sentri,"sentri_vencimiento":SentriFecha,"num_tag1": num_tag, "veh1_marca": veh1Marca, "veh1_modelo": veh1Modelo, "veh1_color": veh1Color, "veh1_anio": veh1Anio, "veh1_placas": veh1Placa, "veh1_origen": "N/A", "num_tag2": TagVeh2.text ?? "", "veh2_marca": BrandInput.text ?? "", "veh2_modelo": ModelInput.text ?? "", "veh2_color": ColorInput.text ?? "",  "veh2_anio": YearInput.text ?? "", "veh2_placas": PlacasInput.text ?? "", "veh2_origen": veh_origen]
        }
        
        
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: tramite)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
                let message: String? = responseJSON["message"] as? String
                
                if ((message?.contains("registrado")) != nil) {
                    if let tramiteID:Int = (responseJSON["ID"] as? Int) {
                        let id_tramite:String = String(tramiteID) as String
                        
                            let SentriDataImg = self.SentriImage.image!.jpegData(compressionQuality: 0.8)
                        
                        let idOficialFrontalDataImg = self.idOficialFrontal.image!.jpegData(compressionQuality: 0.8)
                        let idOficialReversoDataImg = self.idOficialReverso.image!.jpegData(compressionQuality: 0.8)
                        let tarjCirculacionDataImg = self.tarjCirculacion.image!.jpegData(compressionQuality: 0.8)
                        let polizaSeguroDataImg = self.polizaSeguro.image!.jpegData(compressionQuality: 0.8)
                        let polizaSeguroDataImgDos = self.polizaSeguroDos.image!.jpegData(compressionQuality: 0.8)
                        let AprobacionUSADataImg = self.AprobacionUSA.image!.jpegData(compressionQuality: 0.8)
                        let signatureImage = self.SignaturePad.getSignature()?.sd_imageData()
                        
                        
                        if noTramite == 1 {
                         
                            self.sendImages(id: id_tramite, token: token, FileNumber: "4", FileName: "TarjCirculacion.jpeg", Imagen: tarjCirculacionDataImg)
                            self.sendImages(id: id_tramite, token: token, FileNumber: "5", FileName: "PolizaSeguro.jpeg", Imagen: polizaSeguroDataImg)
                            self.sendImages(id: id_tramite, token: token, FileNumber: "9", FileName: "PolizaSeguroDos.jpeg", Imagen: polizaSeguroDataImgDos)
                            self.sendImages(id: id_tramite, token: token, FileNumber: "6", FileName: "AprobacionUsa.jpeg", Imagen: AprobacionUSADataImg)
                            self.sendImages(id: id_tramite, token: token, FileNumber: "8", FileName: "Firma.png", Imagen: signatureImage)
                            let CartaPoderDataImg = self.CartaPoderOpcional.image!.jpegData(compressionQuality: 0.8)
                            self.sendImages(id: id_tramite, token: token, FileNumber: "7", FileName: "CartaPoder.jpeg", Imagen: CartaPoderDataImg)
                        }else if noTramite == 2 {
                            self.sendImages(id: id_tramite, token: token, FileNumber: "8", FileName: "Firma.png", Imagen: signatureImage)
                        }else if (noTramite == 3) {
                            self.sendImages(id: id_tramite, token: token, FileNumber: "8", FileName: "Firma.png", Imagen: signatureImage)
                            self.sendImages(id: id_tramite, token: token, FileNumber: "5", FileName: "PolizaSeguro.jpeg", Imagen: polizaSeguroDataImg)
                            self.sendImages(id: id_tramite, token: token, FileNumber: "9", FileName: "PolizaSeguroDos.jpeg", Imagen: polizaSeguroDataImgDos)
                        }else if (noTramite == 4) {
                            self.sendImages(id: id_tramite, token: token, FileNumber: "8", FileName: "Firma.png", Imagen: signatureImage)
                        }else if (noTramite == 5) {
                            self.sendImages(id: id_tramite, token: token, FileNumber: "8", FileName: "Firma.png", Imagen: signatureImage)
                        }else if (noTramite == 6) {
                            self.sendImages(id: id_tramite, token: token, FileNumber: "8", FileName: "Firma.png", Imagen: signatureImage)
                        }else if (noTramite == 7) {
                            self.sendImages(id: id_tramite, token: token, FileNumber: "8", FileName: "Firma.png", Imagen: signatureImage)
                        }
                        else if (noTramite == 8) {
                            self.sendImages(id: id_tramite, token: token, FileNumber: "8", FileName: "Firma.png", Imagen: signatureImage)
                        } else if (noTramite == 9) {
                            self.sendImages(id: id_tramite, token: token, FileNumber: "8", FileName: "Firma.png", Imagen: signatureImage)
                        }else {
                            self.sendImages(id: id_tramite, token: token, FileNumber: "1", FileName: "Sentri.jpeg", Imagen: SentriDataImg)
                            self.sendImages(id: id_tramite, token: token, FileNumber: "2", FileName: "idOficialFrontal.jpeg", Imagen: idOficialFrontalDataImg)
                            self.sendImages(id: id_tramite, token: token, FileNumber: "3", FileName: "idOficialReverso.jpeg", Imagen: idOficialReversoDataImg)
                            self.sendImages(id: id_tramite, token: token, FileNumber: "4", FileName: "TarjCirculacion.jpeg", Imagen: tarjCirculacionDataImg)
                            self.sendImages(id: id_tramite, token: token, FileNumber: "5", FileName: "PolizaSeguro.jpeg", Imagen: polizaSeguroDataImg)
                            self.sendImages(id: id_tramite, token: token, FileNumber: "9", FileName: "PolizaSeguroDos.jpeg", Imagen: polizaSeguroDataImgDos)
                            self.sendImages(id: id_tramite, token: token, FileNumber: "6", FileName: "AprobacionUsa.jpeg", Imagen: AprobacionUSADataImg)
                            self.sendImages(id: id_tramite, token: token, FileNumber: "8", FileName: "Firma.png", Imagen: signatureImage)
                            let CartaPoderDataImg = self.CartaPoderOpcional.image!.jpegData(compressionQuality: 0.8)
                            self.sendImages(id: id_tramite, token: token, FileNumber: "7", FileName: "CartaPoder.jpeg", Imagen: CartaPoderDataImg)
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                            self.LoaderContainer.isHidden = true
                           
                            NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "HomeViewController")
                           
                        }
                    }else {
                        self.LoaderContainer.isHidden = true
                    }
                 
                }else {
                    DispatchQueue.main.async() {
                        self.msgError.text = message
                        self.msgError.isHidden = false
                    }
                }
               
                
            }
        }
        task.resume()
    }
    
    func sendImages(id:String, token:String, FileNumber:String, FileName:String, Imagen: Data?) {
        var Imagen = Imagen // Declarar Imagen como variable
       
        
        let url = URL(string: "https://lineaexpressapp.desarrollosenlanube.net/api/v1/files")!
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token) )"
        ]
        var mimeType = "image/jpeg"
        
        if TipoTramite == 0 {
            id_proc_type = "1"
        }
        if TipoTramite == 1 {
            id_proc_type = "3"
        }
        if TipoTramite == 2 {
            id_proc_type = "3"
        }
        if TipoTramite == 3 {
            id_proc_type = "3"
        }
        if TipoTramite == 4 {
            id_proc_type = "3"
        }
        if TipoTramite == 5 {
            id_proc_type = "5"
        }
        if TipoTramite == 6 {
            id_proc_type = "3"
        }
        if TipoTramite == 7 {
            id_proc_type = "2"
        }
        if TipoTramite == 8 {
            id_proc_type = "2"
        }
        if TipoTramite == 9 {
            id_proc_type = "4"
        }
        
        if FileNumber.contains("1") {
            if !pdfUrlOne.isEmpty {
                if let fileURL = URL(string: pdfUrlOne) {
                    if fileURL.startAccessingSecurityScopedResource() {
                        
                        if let pdfData = try? Data(contentsOf: fileURL) {
                            mimeType = "application/pdf"
                            Imagen = pdfData
                        } else {
                            print("No se pudo cargar el archivo PDF")
                        }
                        
                    }
                    fileURL.stopAccessingSecurityScopedResource()
                } else {
                    print("La URL del archivo PDF no es válida")
                }
            }
        }
        if FileNumber.contains("2") {
            if !pdfUrlTwo.isEmpty {
                if let fileURL = URL(string: pdfUrlTwo) {
                    if fileURL.startAccessingSecurityScopedResource() {
                        
                        if let pdfData = try? Data(contentsOf: fileURL) {
                            mimeType = "application/pdf"
                            Imagen = pdfData
                        } else {
                            print("No se pudo cargar el archivo PDF")
                        }
                        
                    }
                    fileURL.stopAccessingSecurityScopedResource()
                } else {
                    print("La URL del archivo PDF no es válida")
                }
            }
        }
        if FileNumber.contains("3") {
            if !pdfUrlThree.isEmpty {
                if let fileURL = URL(string: pdfUrlThree) {
                    if fileURL.startAccessingSecurityScopedResource() {
                        
                        if let pdfData = try? Data(contentsOf: fileURL) {
                            mimeType = "application/pdf"
                            Imagen = pdfData
                        } else {
                            print("No se pudo cargar el archivo PDF")
                        }
                        
                    }
                    fileURL.stopAccessingSecurityScopedResource()
                } else {
                    print("La URL del archivo PDF no es válida")
                }
            }
        }
        if FileNumber.contains("4") {
            if !pdfUrlFour.isEmpty {
                if let fileURL = URL(string: pdfUrlFour) {
                    if fileURL.startAccessingSecurityScopedResource() {
                        
                        if let pdfData = try? Data(contentsOf: fileURL) {
                            mimeType = "application/pdf"
                            Imagen = pdfData
                        } else {
                            print("No se pudo cargar el archivo PDF")
                        }
                        
                    }
                    fileURL.stopAccessingSecurityScopedResource()
                } else {
                    print("La URL del archivo PDF no es válida")
                }
            }
        }
        if FileNumber.contains("5") {
            print("Este ya es para enviar \(pdfUrlFive)")
            if !pdfUrlFive.isEmpty {
                if let fileURL = URL(string: pdfUrlFive) {
                    if fileURL.startAccessingSecurityScopedResource() {
                        
                        if let pdfData = try? Data(contentsOf: fileURL) {
                            mimeType = "application/pdf"
                            Imagen = pdfData
                        } else {
                            print("No se pudo cargar el archivo PDF")
                        }
                        
                    }
                    fileURL.stopAccessingSecurityScopedResource()
                } else {
                    print("La URL del archivo PDF no es válida")
                }
            }
        }
        if FileNumber.contains("6") {
            if !pdfUrlSix.isEmpty {
                if let fileURL = URL(string: pdfUrlSix) {
                    if fileURL.startAccessingSecurityScopedResource() {
                        
                        if let pdfData = try? Data(contentsOf: fileURL) {
                            mimeType = "application/pdf"
                            Imagen = pdfData
                        } else {
                            print("No se pudo cargar el archivo PDF")
                        }
                        
                    }
                    fileURL.stopAccessingSecurityScopedResource()
                } else {
                    print("La URL del archivo PDF no es válida")
                }
            }
        }
        if FileNumber.contains("7") {
            if !pdfUrlSeven.isEmpty {
                if let fileURL = URL(string: pdfUrlSeven) {
                    if fileURL.startAccessingSecurityScopedResource() {
                        
                        if let pdfData = try? Data(contentsOf: fileURL) {
                            mimeType = "application/pdf"
                            Imagen = pdfData
                        } else {
                            print("No se pudo cargar el archivo PDF")
                        }
                        
                    }
                    fileURL.stopAccessingSecurityScopedResource()
                } else {
                    print("La URL del archivo PDF no es válida")
                }
            }
        }
        if FileNumber.contains("9") {
            if !pdfUrlEighth.isEmpty {
                if let fileURL = URL(string: pdfUrlEighth) {
                    if fileURL.startAccessingSecurityScopedResource() {
                        
                        if let pdfData = try? Data(contentsOf: fileURL) {
                            mimeType = "application/pdf"
                            Imagen = pdfData
                        } else {
                            print("No se pudo cargar el archivo PDF")
                        }
                        
                    }
                    fileURL.stopAccessingSecurityScopedResource()
                } else {
                    print("La URL del archivo PDF no es válida")
                }
            }
        }
        
        
        
        AF.upload( multipartFormData: { multipartFormData in
            multipartFormData.append(id.data(using: .utf8)!, withName: "id_proc")
            multipartFormData.append(Imagen!, withName: "docfile", fileName: FileName, mimeType: mimeType)
            multipartFormData.append(FileNumber.data(using: .utf8)!, withName: "filetype")
            multipartFormData.append(self.id_proc_type.data(using: .utf8)!, withName: "id_proc_type")
          },
                   to: url, method: .post, headers: headers
        )
        .validate(statusCode: 200..<300)
        .response { resp in
          switch resp.result {
          case .failure(let error):
            print(error)
          case .success(_):
            print("Response after upload Img: \(resp.result)")
          }
        }
    }
    
    func requestMob() {
        // create post request
        let session = URLSession.shared
       
         let sem = DispatchSemaphore.init(value: 0)

         var request = URLRequest(url: URL(string: "https://lineaexpressapp.desarrollosenlanube.net/api/v1/config/mobile")!)
         request.httpMethod = "GET"
         request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")

        let task = session.dataTask(with: request) { data, response, error in
            defer { sem.signal() }
            
            if let error = error {
                print("Error -> \(error)")
                return
            }
            
            if let data = data, let string = String(data: data, encoding: .utf8) {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let dictionary = json as? [String: Any] {
                    
                    self.anual_zaragoza_mx = dictionary["anual_zaragoza_mx"] as? String ?? "undefined"
                    self.anual_lerdo_mx = dictionary["anual_lerdo_mx"] as? String ?? "undefined"
                    self.anual_zaragoza_us = dictionary["anual_zaragoza_us"] as? String ?? "undefined"
                    self.anual_lerdo_us = dictionary["anual_lerdo_us"] as? String ?? "undefined"
                    self.anual_mixto_mx = dictionary["anual_mixto_mx"] as? String ?? "undefined"
                    self.anual_mixto_us = dictionary["anual_mixto_us"] as? String ?? "undefined"
                    self.saldo_zaragoza1_mx = dictionary["saldo_zaragoza1_mx"] as? String ?? "undefined"
                    self.saldo_zaragoza2_mx = dictionary["saldo_zaragoza2_mx"] as? String ?? "undefined"
                    self.saldo_zaragoza1_us = dictionary["saldo_zaragoza1_us"] as? String ?? "undefined"
                    self.saldo_zaragoza2_us = dictionary["saldo_zaragoza2_us"] as? String ?? "undefined"
                    self.pago_minimotp_mx = dictionary["pago_minimotp_mx"] as? String ?? "undefined"
                    self.mbPreciosURL = dictionary["mbPreciosURL"] as? String ?? "undefined"
                    
                    let url = URL(string: self.mbPreciosURL)
                    DispatchQueue.background(background: {
                        let data = try? Data(contentsOf: url!)
                        DispatchQueue.main.async() {
                            self.TarifasImageView.image = UIImage(data: data!)
                            self.TarifasImageView.layer.cornerRadius = 20
                            self.TarifasImageView.layer.masksToBounds = true
                        }
                        
                    }, completion:{
                        print("Img c")
                    })
                    
                }
                
            } else {
                print("Error: Could not convert JSON string to")
            }
            
            
            
        }

         task.resume()

         // This line will wait until the semaphore has been signaled
         // which will be once the data task has completed
         sem.wait()
    }
    
    func getVehicle() -> Array<String> {
        // create post request
        let session = URLSession.shared
         var dataReceived: Array<String> = []
         let sem = DispatchSemaphore.init(value: 0)

         var request = URLRequest(url: URL(string: "https://lineaexpressapp.desarrollosenlanube.net/api/v1/vehicles/\(vehID)")!)
         request.httpMethod = "GET"
         request.addValue("application/json", forHTTPHeaderField: "Content-Type")
         request.setValue("Bearer \(LoginToken)", forHTTPHeaderField: "Authorization")

        let task = session.dataTask(with: request) { data, response, error in
            defer { sem.signal() }
            
            if let error = error {
                print("Error -> \(error)")
                return
            }
            
            if let data = data, let string = String(data: data, encoding: .utf8) {
                if let jsonArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    print("Json Raw = \(jsonArray) además \(jsonArray.count)" )
                    for i in 0...jsonArray.count - 1 {
                        let tipoVeh: Int? = jsonArray[i]["tipo"] as? Int
                        let Marca: String? = jsonArray[i]["marca"] as? String
                        let Linea: String? = jsonArray[i]["linea"] as? String
                        let tag: String? = jsonArray[i]["tag"] as? String
                        let imgurl: String? = jsonArray[i]["imgurl"] as? String
                        let ctl_contract_type: String? = jsonArray[i]["ctl_contract_type"] as? String ?? "undefined"
                        let clt_expiration_date: String? = jsonArray[i]["clt_expiration_date"] as? String ?? "undefined"
                        let saldo: String? = jsonArray[i]["saldo"] as? String ?? "undefined"
                        let placa: String? = jsonArray[i]["placa"] as? String ?? "undefined"
                        
                        let Vehicle:String = String(tipoVeh!) + "∑" + Marca! + "∑" + Linea! + "∑" + tag! + "∑" + imgurl! + "∑" + ctl_contract_type! + "∑" + clt_expiration_date! + "∑" + saldo! + "∑" + placa!
                        dataReceived.append(Vehicle)
                        
                        
                    }
                    
                } else {
                    print("Error: Could not convert JSON string to")
                }
                
                
            }
        }

         task.resume()

         // This line will wait until the semaphore has been signaled
         // which will be once the data task has completed
         sem.wait()

         return dataReceived
    }
    
}

extension UIImage {
    func scale(to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        draw(in: CGRect(origin: .zero, size: size))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage ?? self
    }
}
