
//
//  TramiteFixViewController.swift
//  LineaExpres
//

import UIKit
import SignaturePad
import Alamofire
import UniformTypeIdentifiers

class TramiteFixViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, UIDocumentPickerDelegate {
    
    var Email:String = ""
    var Name:String = ""
    var SizeConstant:Int = 0
    var LoginToken:String = ""
    var FirebaseToken:String = ""
    
    var FileID:String = ""
    var FileStatus:String = ""
    var FileTypeDesc:String = ""
    var Comment:String = ""
    var IDProc:String = ""
    var IDProcType:String = ""
    var FileName:String = ""
    var fileExtension:String = ""
    var fileNameWithoutExtension: String = ""
    
    @IBOutlet weak var mainContainer: UIStackView!
    @IBOutlet weak var topBody: UIStackView!
    @IBOutlet weak var middleBody: UIStackView!
    @IBOutlet weak var bottomBody: UIStackView!
    
    @IBOutlet weak var MainTitle: UILabel!
    @IBOutlet weak var DocumentLabel: UILabel!
    @IBOutlet weak var ReasonLabel: UILabel!
    @IBOutlet weak var btnTakePhoto: UIButton!
    
    @IBOutlet weak var photoImg: UIImageView!
    @IBOutlet weak var SignaturePad: SignaturePad!
    
    @IBOutlet weak var sendRev: UIButton!
    @IBOutlet weak var sendSign: UIButton!
    var json: [String: Any] = [:]
    
    var pdfUrl: String = ""
    
    @IBOutlet weak var loaderContainer: UIView!
    @IBOutlet weak var loaderGif: UIImageView!
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(didGetNotification(_:)), name: Notification.Name("TramiteFix"), object: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loaderGif.image = UIImage.gif(asset: "linea_expres_loader")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                  self.loaderContainer.isHidden = true
        }
        let validationPass:Bool = verifyLogging()
        if (!validationPass) {
            NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "LoginViewController")
        }
        photoImg.isHidden = true
        SignaturePad.isHidden = true
        
        //Ajustar padding a StackView
        
        self.mainContainer.layer.cornerRadius = 20
        mainContainer.layer.masksToBounds = true
        
        mainContainer.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        mainContainer.isLayoutMarginsRelativeArrangement = true
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (!verifyLogging()) {
            NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "LoginViewController")
        }
        
        if IDProcType.contains("1") {
            MainTitle.text = "Solicitud Inscripción"
            
        }
        sendSign.isHidden = true
        if FileTypeDesc.contains("Firma") {
            btnTakePhoto.isHidden = true
            sendSign.isHidden = false
            sendRev.isHidden = true
            SignaturePad.isHidden = false
            
            SignaturePad.layer.borderWidth = 1
            SignaturePad.layer.borderColor = UIColor.black.cgColor
            SignaturePad.layer.cornerRadius = 15
            SignaturePad.layer.masksToBounds = true
        }
        
        
        DocumentLabel.text = FileTypeDesc
        ReasonLabel.text = Comment
        
    }
    
    
    @IBAction func EnviarFoto(_ sender: Any) {
        self.loaderContainer.isHidden = false
        let photoImg = self.photoImg.image!.jpegData(compressionQuality: 0.8)
        self.sendImages(id: IDProc, token: LoginToken, FileNumber: FileID, Imagen: photoImg, id_proc_type: IDProcType)
    }
    
    @IBAction func EnviarFirma(_ sender: Any) {
        let signatureImage = self.SignaturePad.getSignature()?.sd_imageData()
        self.sendImages(id: IDProc, token: LoginToken, FileNumber: FileID, Imagen: signatureImage, id_proc_type: IDProcType)
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        photoImg.isHidden = false
        let ac = UIAlertController(title: "Toma Fotografía", message: "Toma o selecciona una fotografía", preferredStyle: .actionSheet)
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
    
    @objc func didGetNotification(_ notification: Notification) {
        let text:String = notification.object as! String
        let Values = text.components(separatedBy: "∑")
        FileID = Values[0]
        FileStatus = Values[1]
        FileTypeDesc = Values[2]
        Comment = Values[3]
        IDProc = Values[4]
        IDProcType = Values[5]
        FileName = Values[6]
        let fileURL = URL(fileURLWithPath: FileName)
        fileNameWithoutExtension = fileURL.deletingPathExtension().lastPathComponent
        fileExtension = URL(fileURLWithPath: FileName).pathExtension
        
        print("vamos a ver: \(Values) ")
        
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
        
        
        self.photoImg.image = selectedImage
        pdfUrl = ""
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        print("No ha seleccionado ninguna imagen")
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        // Aquí puedes manejar los archivos seleccionados
        
        for url in urls {
            let url = URL(string: "\(url)") // Supongamos que tienes la URL
            
            if let pathString = url?.path {
                let urlString = URL(fileURLWithPath: pathString).absoluteString
                pdfUrl = String(urlString)
            } else {
                print("La URL no es válida")
            }
        }
        
        
        self.photoImg.image = UIImage(named: "pdfImg")
        
        
        
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        // Manejar la cancelación de la selección de archivos
    }
    
    func verifyLogging() -> Bool {
        
        var pass:Bool = false
        let Lista:Array<String> = DB_Manager().getUsuario()
        print("Lista = \(Lista.count) ")
        if (Lista.count != 0) {
            for i in 0..<(Lista.count) {
                
                let Usuario = Lista[i].components(separatedBy: "∑")
                
                Email = Usuario[0]
                Name = Usuario[1]
                FirebaseToken = Usuario[2]
                LoginToken = Usuario[3]
                if (LoginToken.isEmpty) {
                    NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "LoginViewController")
                }
                pass = true
            }
        }else {
            print("Está entrando a aqui?zasd")
            NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "LoginViewController")
            pass = false
        }
        return pass
        
    }
    
    func sendImages(id:String, token:String, FileNumber:String, Imagen: Data?, id_proc_type: String) {
        
        var Imagen = Imagen
        var mimeType = "image/jpeg"
        
        //let url = URL(string: "https://lineaexpressapp.desarrollosenlanube.net/api/v1/files")!
        let url = URL(string: "https://apis.fpfch.gob.mx/api/v1/files")!
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token) )"
        ]
        
        if !pdfUrl.isEmpty {
            if let fileURL = URL(string: pdfUrl) {
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
        
        
        AF.upload( multipartFormData: { multipartFormData in
            multipartFormData.append(id.data(using: .utf8)!, withName: "id_proc")
            multipartFormData.append(Imagen!, withName: "docfile", fileName: self.fileNameWithoutExtension, mimeType: mimeType)
            multipartFormData.append(FileNumber.data(using: .utf8)!, withName: "filetype")
            multipartFormData.append(id_proc_type.data(using: .utf8)!, withName: "id_proc_type")
        },
                   to: url, method: .post, headers: headers
        )
        .validate(statusCode: 200..<800)
        .response { resp in
            switch resp.result {
            case .failure(let error):
                print(error)
            case .success(_):
                print("Response after upload Img: \(resp.result)")
                self.sendPush()
                self.loaderContainer.isHidden = true
                self.showAlert(titleAlert: "¡Listo!", messageAlert: "Tu corrección se envió a revisión")
                NotificationCenter.default.post(name: Notification.Name("viewChanger"), object:"ProfileViewController")
                
            }
        }
    }
    
    func showAlert(titleAlert: String, messageAlert: String) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }

        let alertController = UIAlertController(title: titleAlert, message: messageAlert, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)

        window.rootViewController?.present(alertController, animated: true, completion: nil)
    }

    
    func sendPush() {
        
        print("Comienza el push")
        let json: [String: Any] = ["email": Email, "device_id": FirebaseToken]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        //let url = URL(string: "https://lineaexpressapp.desarrollosenlanube.net/api/v1/user/saveid")!
        let url = URL(string: "https://apis.fpfch.gob.mx/api/v1/user/saveid")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
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
                
            }
        }
        task.resume()
    }
    
    
}

