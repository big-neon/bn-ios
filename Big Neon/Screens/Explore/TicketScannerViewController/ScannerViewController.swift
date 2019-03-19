
import Foundation
import AVFoundation
import UIKit
import Big_Neon_UI
import Big_Neon_Core

final class ScannerViewController: UIViewController, ScannerModeViewDelegate {
    
    //  Video Capture Session
    internal var captureSession = AVCaptureSession()
    internal var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    //  Layout
    internal var qrCodeFrameView: UIView?
    internal let generator = UINotificationFeedbackGenerator()
    internal var guestListTopAnchor: NSLayoutConstraint?
    internal var manualCheckingTopAnchor: NSLayoutConstraint?
    internal var scanCompleted: Bool?
    internal var scannerViewModel : TicketScannerViewModel = TicketScannerViewModel()
    internal let blurEffect = UIBlurEffect(style: .dark)
    internal var blurView: UIVisualEffectView?
    
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.itf14,
                                      AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.interleaved2of5,
                                      AVMetadataObject.ObjectType.qr]
    
    internal lazy var scannerModeView: ScannerModeView = {
        let view =  ScannerModeView()
        view.setAutoMode = self.scannerViewModel.scannerMode()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        self.configureNavBar()
        self.configureScanner()
    }
    
    private func configureNavBar() {
        self.navigationClearBar()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_close"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(handleClose))
        
        scannerModeView.delegate = self
        scannerModeView.widthAnchor.constraint(equalToConstant: 290.0).isActive = true
        scannerModeView.heightAnchor.constraint(equalToConstant: 48.0).isActive = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: scannerModeView)
    }
    
    private func configureScanner() {
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: videoCaptureDevice)
            captureSession.addInput(input)
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        } catch {
            print(error)
            return
        }
        
        // Video preview Layer Init
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        captureSession.startRunning()
    }
    
    private func configureScannerFrame() {
        
        // Move the message label and top bar to the front
//        view.bringSubview(toFront: messageLabel)
//        view.bringSubview(toFront: topbar)
        
        // Initialize QR Code Frame to highlight the QR code
//        qrCodeFrameView = UIView()
//
//        if let qrCodeFrameView = qrCodeFrameView {
//            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
//            qrCodeFrameView.layer.borderWidth = 2
//            view.addSubview(qrCodeFrameView)
//            view.bringSubview(toFront: qrCodeFrameView)
//        }
    }
}


extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    @objc private func handleClose() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func scannerSetAutomatic() {
        print("Automatic")
    }
    
    func scannerSetManual() {
        print("Automatic")
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            print("No QR code is detected")
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
//                launchApp(decodedURL: metadataObj.stringValue!)
//                messageLabel.text = metadataObj.stringValue
                self.generator.notificationOccurred(.success)
                print(metadataObj.stringValue)
            }
        }
    }
    
}
