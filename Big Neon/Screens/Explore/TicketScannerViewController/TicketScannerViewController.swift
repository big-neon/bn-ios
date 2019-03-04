

import UIKit
import Big_Neon_UI
import AVFoundation
import QRCodeReader

final class TicketScannerViewController: BaseViewController, AVCaptureMetadataOutputObjectsDelegate, QRCodeReaderViewControllerDelegate, GuestListViewProtocol, ScannerModeViewDelegate {
    
    internal var captureSession = AVCaptureSession()
    internal var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    internal var guestListTopAnchor: NSLayoutConstraint?
    internal let generator = UINotificationFeedbackGenerator()
    internal var reader : QRCodeReader?
    internal var scannerViewModel : TicketScannerViewModel = TicketScannerViewModel()
    
    internal let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)
    
    internal var isShowingGuests: Bool = false {
        didSet {
            if isShowingGuests == true {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
                    self.cameraTintView.layer.opacity = 0.85
                    self.guestListTopAnchor?.constant = UIScreen.main.bounds.height - 560.0
                    self.view.layoutIfNeeded()
                }) { (complete) in
                    print("De-Activated Camera")
                }
                return
            }
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
                self.cameraTintView.layer.opacity = 0.0
                self.guestListTopAnchor?.constant = UIScreen.main.bounds.height - 80.0
                self.view.layoutIfNeeded()
            }) { (complete) in
                print("Activated Camera")
            }
            return
            
        }
    }
    
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

    internal lazy var guestListView: GuestListView = {
        let view =  GuestListView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    internal lazy var cameraTintView: UIView = {
        let view =  UIView()
        view.backgroundColor = UIColor.black
        view.layer.opacity = 0.0
        return view
    }()
    
    internal lazy var scannerModeView: ScannerModeView = {
        let view =  ScannerModeView()
        view.setAutoMode = self.scannerViewModel.scannerMode()
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
        cameraTintView.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        captureSession.startRunning()
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
    
    @objc private func handleClose() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func configureScan() {
        self.reader = QRCodeReader(metadataObjectTypes: supportedCodeTypes, captureDevicePosition: AVCaptureDevice.Position.back)
        self.videoPreviewLayer = reader!.previewLayer
    }
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
    }
    
    func showGuestList() {
        self.isShowingGuests = !self.isShowingGuests
    }
    
    func scannerSetAutomatic() {
        self.scannerViewModel.setCheckingModeAutomatic()
    }
    
    func scannerSetManual() {
        self.scannerViewModel.setCheckingModeManual()
    }
}

extension TicketScannerViewController {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if metadataObjects.isEmpty {
            self.generator.notificationOccurred(.error)
            self.reader?.stopScanning()
            print("No QR code is detected")
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            self.generator.notificationOccurred(.success)
            // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
//            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
//            qrCodeFrameView?.frame = barCodeObject!.bounds

            if metadataObj.stringValue != nil {
                print(metadataObj.stringValue)
            }
            self.reader?.stopScanning()
            return
        }
    }
}

