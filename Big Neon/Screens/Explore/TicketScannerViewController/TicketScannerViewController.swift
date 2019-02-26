

import UIKit
import Big_Neon_UI
import AVFoundation
import QRCodeReader

final class TicketScannerViewController: BaseViewController, AVCaptureMetadataOutputObjectsDelegate, QRCodeReaderViewControllerDelegate {
    
    
    
    internal var captureSession = AVCaptureSession()
    internal var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    internal var guestListTopAnchor: NSLayoutConstraint?
    
    internal let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)
    
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
    
//    internal lazy var qrReaderView: QRCodeReaderView  = {
//        let view = QRCodeReaderView(frame: self.view.frame)
////        view.cameraView = videoPreviewLayer
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    
    internal var guestListView: GuestListView = {
        let view =  GuestListView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        self.configureNavBar()
        self.configureCameraSession()
        self.configureCameraView()
        self.configureScan()
        self.configureGuestView()
    }
    
    private func configureCameraSession() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
        
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            //            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
        } catch {
            print(error)
            return
        }
    }
    
    private func configureGuestView() {
        self.view.addSubview(guestListView)
        
        guestListView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        guestListView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.guestListTopAnchor = guestListView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: UIScreen.main.bounds.height - 80.0)
        self.guestListTopAnchor?.isActive = true
        guestListView.heightAnchor.constraint(equalToConstant: 560.0).isActive = true
    }
    
    private func configureCameraView() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        captureSession.startRunning()
    }
    
    private func configureNavBar() {
        self.navigationClearBar()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_close"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(handleClose))
    }
    
    @objc private func handleClose() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func configureScan() {
        let reader = QRCodeReader(metadataObjectTypes: supportedCodeTypes, captureDevicePosition: AVCaptureDevice.Position.back)
        self.videoPreviewLayer = reader.previewLayer
//        reader.de
//        reader.delegate = self
        
        // Or by using the closure pattern
//        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
//            print(result)
//        }
        
        // Presents the readerVC as modal form sheet
//        readerVC.modalPresentationStyle = .formSheet
        
//        present(readerVC, animated: true, completion: nil)
    }
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
    }
}

extension TicketScannerViewController {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if metadataObjects.count == 0 {
            print("No QR code is detected")
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                launchApp(decodedURL: metadataObj.stringValue!)
                messageLabel.text = metadataObj.stringValue
            }
        }
    }
}

