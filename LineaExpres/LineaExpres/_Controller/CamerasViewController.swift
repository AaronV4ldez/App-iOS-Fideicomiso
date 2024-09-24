import UIKit
import WebKit

class CamerasViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var ZaragozaWebView: WKWebView!
    @IBOutlet weak var webviewGeneral: WKWebView!
    
    @IBOutlet weak var StackViewContainer: UIStackView!
    @IBOutlet weak var Container: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Establecer el delegado de navegación para controlar la carga de los videos
        webviewGeneral.navigationDelegate = self

        // Configurar la WKWebView para permitir la reproducción en línea
        configureWebView(webView: webviewGeneral)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Ajustar padding a StackView
        StackViewContainer.layoutMargins = UIEdgeInsets(top: 80, left: 15, bottom: 90, right: 15)
        StackViewContainer.isLayoutMarginsRelativeArrangement = true
        
        Container.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        Container.isLayoutMarginsRelativeArrangement = true
        Container.layer.cornerRadius = 20
        Container.layer.masksToBounds = true

        // HTML con el contenido de los videos embebidos en pausa
        let htmlString = """
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Live Cameras</title>
            <style>
                body {
                    font-family: Arial, sans-serif;
                    background-color: #f4f4f4;
                    padding: 10px;
                    margin: 0;
                    display: flex;
                    flex-direction: column;
                    align-items: center;
                }
                h1 {
                    font-size: 18px;
                    margin-bottom: 15px;
                    text-align: center;
                    color: #333;
                }
                iframe {
                    width: 100%;
                    height: 300px; /* Ajusta el tamaño del iframe */
                    border: none;
                }
                .container {
                    width: 100%;
                    max-width: 600px;
                    margin: auto;
                }
                .camera-section {
                    margin-bottom: 20px;
                }
            </style>
            <script>
                document.addEventListener('DOMContentLoaded', function() {
                    // Pausar los videos en iframes al cargarse
                    var iframes = document.querySelectorAll('iframe');
                    iframes.forEach(function(iframe) {
                        var iframeDoc = iframe.contentWindow || iframe.contentDocument;
                        if (iframeDoc) {
                            iframe.src += "?autoplay=0";  // Asegurarse de que no se reproduzcan automáticamente
                        }
                    });
                });
            </script>
        </head>
        <body>
            <div class="container">
                <div class="camera-section">
                    <h1>Paso del Norte (Norte)</h1>
                    <iframe src="https://camstreamer.com/embed/RmKKjLTyispBGGbIfFYnNMasTH45jhRs2Wo9Z1nZ?autoplay=0"></iframe>
                </div>
                <div class="camera-section">
                    <h1>Paso del Norte (Sur)</h1>
                    <iframe src="https://camstreamer.com/embed/tRbi7yHcfP1Q0MHaZwXCfd3ymXHZV8QYuulTvofn?autoplay=0"></iframe>
                </div>
                <div class="camera-section">
                    <h1>Lerdo (Norte)</h1>
                    <iframe src="https://camstreamer.com/embed/iEHyfOkiGPdnvCO4RYCLZTiFJGGk8InzjI3bXEx4"></iframe>
                        </div>
                <div class="camera-section">
                    <h1>Lerdo (Sur)</h1>
                    <iframe src="https://camstreamer.com/embed/iEKDRVOUybuFhtdKJKdRlaILyhMCSyrkEc8b0WgB"></iframe>
                        </div>
                        <div class="camera-section">
                            <h1>Lerdo (Fila)</h1>
                            <iframe src="https://camstreamer.com/embed/ozH8YEP3bIkP22lBFoUUdGgB0sEJ1FNppmmw8wJ4"></iframe>
                        </div>
                        <div class="camera-section">
                            <h1>Zaragoza (Norte)</h1>
                            <iframe src="https://camstreamer.com/embed/B3cMCOh60f8wcGEGwRhe3WTc8kFqthAFvUUdxGtE"></iframe>
                        </div>
                        <div class="camera-section">
                            <h1>Zaragoza (Sur)</h1>
                            <iframe src="https://camstreamer.com/embed/HlfBjAnK17GcfIvm0PzDLDuTLFYdtOtruMOIZeQy"></iframe>
                        </div>
                        <div class="camera-section">
                            <h1>Zaragoza Carga (Norte)</h1>
                            <iframe src="https://camstreamer.com/embed/VGvwCDk2Q3llvv72dI1eSvdoBOiZZ7jnQgV1zvN7"></iframe>
                        </div>
                        <div class="camera-section">
                            <h1>Zaragoza Carga (Sur)</h1>
                            <iframe src="https://camstreamer.com/embed/xJBZVxgjwn8N8ix09zaRnP4B8ZnT3nyapF52p38B"></iframe>
                        </div>
                        <div class="camera-section">
                            <h1>Guadalupe (Norte)</h1>
                            <iframe src="https://camstreamer.com/embed/uixDU3cVNl3OkKDDdEqOIkoiuBMeD2mSznGq0wUu"></iframe>
                        </div>
                        <div class="camera-section">
                            <h1>Guadalupe (Sur)</h1>
                            <iframe src="https://camstreamer.com/embed/pgoN0P9OWpB4C7mWffML3EraMCfHKjDnRGwjQO0p"></iframe>
                        </div>            </div>
        </body>
        </html>
        """
        
        // Cargar el HTML en el WKWebView
        webviewGeneral.loadHTMLString(htmlString, baseURL: nil)
    }

    // Función para configurar la WKWebView
    func configureWebView(webView: WKWebView) {
        let webConfiguration = webView.configuration
        webConfiguration.defaultWebpagePreferences.allowsContentJavaScript = true
        webConfiguration.allowsInlineMediaPlayback = true
        webConfiguration.mediaTypesRequiringUserActionForPlayback = []
        webConfiguration.allowsPictureInPictureMediaPlayback = false // Desactivar el picture-in-picture
    }

    // Delegado para controlar la navegación
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated {
            // Evitar que se abran enlaces externos
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}
