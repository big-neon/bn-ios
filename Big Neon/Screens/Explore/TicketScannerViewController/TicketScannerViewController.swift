

import UIKit
import Big_Neon_UI
import Big_Neon_Core
import AVFoundation
import QRCodeReader

final class TicketScannerViewController: BaseViewController, AVCaptureMetadataOutputObjectsDelegate, QRCodeReaderViewControllerDelegate, GuestListViewProtocol, ScannerModeViewDelegate, ManualCheckinModeDelegate {

    internal var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    
    internal var captureSession: AVCaptureSession!
    internal var previewLayer: AVCaptureVideoPreviewLayer!
    
    internal var guestListTopAnchor: NSLayoutConstraint?
    internal var manualCheckingTopAnchor: NSLayoutConstraint?
    internal let generator = UINotificationFeedbackGenerator()
    internal var reader : QRCodeReader?
    internal var scanCompleted: Bool?
    internal var scannerViewModel : TicketScannerViewModel = TicketScannerViewModel()
    internal let blurEffect = UIBlurEffect(style: .dark)
    internal var blurView: UIVisualEffectView?

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
    
    internal lazy var manualUserCheckinView: ManualCheckinModeView = {
        let view =  ManualCheckinModeView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    internal lazy var feedbackView: TicketScanFeedbackView = {
        let view =  TicketScanFeedbackView()
        view.layer.opacity = 0.0
        view.layer.contentsScale = 0.0
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
        self.view.backgroundColor = UIColor.black
        self.configureNavBar()
        self.configureCameraSession()
        self.configureCameraView()
        self.configureScan()
        self.configureManualCheckinView()
        self.configureScanFeedbackView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    
    
    private func configureCameraSession() {
        self.captureSession = AVCaptureSession()
        
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
    
    private func configureManualCheckinView() {
        self.view.addSubview(manualUserCheckinView)
        
        manualUserCheckinView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        manualUserCheckinView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.manualCheckingTopAnchor = manualUserCheckinView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: UIScreen.main.bounds.height + 50.0)
        self.manualCheckingTopAnchor?.isActive = true
        manualUserCheckinView.heightAnchor.constraint(equalToConstant: 250.0).isActive = true
    }
    
    private func configureScanFeedbackView() {
        self.view.addSubview(feedbackView)
        feedbackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        feedbackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -20.0).isActive = true
        feedbackView.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        feedbackView.widthAnchor.constraint(equalToConstant: 220.0).isActive = true
    }

    private func configureCameraView() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        cameraTintView.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        captureSession.startRunning()
        self.configureBlur()
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
    
    private func configureBlur() {
        let blur = UIBlurEffect(style: .dark)
        self.blurView = UIVisualEffectView(effect: blur)
        self.blurView?.frame = self.view.bounds
        self.blurView?.layer.opacity = 0.0
        self.blurView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(self.blurView!)
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
        
        if metadataObjects.isEmpty == true {
            self.reader?.stopScanning()
            self.reader = nil
            self.scanCompleted = true
            return
        }
        
        let metadataObj = metadataObjects.first as! AVMetadataMachineReadableCodeObject
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                messageLabel.text = metadataObj.stringValue
            }
        }
        
        /*
        if supportedCodeTypes.contains(metadataObj.type) {

            guard let metaDataString = metadataObj.stringValue else {
                self.reader?.stopScanning()
                return
            }
            
            guard self.scannerViewModel.getRedeemKey(fromStringValue: metaDataString) != nil else {
                self.reader?.stopScanning()
                return
            }
            
            guard let ticketID = self.scannerViewModel.getTicketID(fromStringValue: metaDataString) else {
                self.reader?.stopScanning()
                return
            }
            
            self.reader?.stopScanning()
            self.scannerViewModel.getRedeemTicket(ticketID: ticketID) { (scanFeedback) in
                switch scanFeedback {
                case .alreadyRedeemed?:
                    UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                        self.blurView?.layer.opacity = 1.0
                        self.feedbackView.layer.opacity = 1.0
                        self.feedbackView.scanFeedback = .alreadyRedeemed
                        self.scannerModeView.layer.opacity = 0.0
                        self.view.layoutIfNeeded()
                    }, completion: { (completed) in
                        self.dismissFeedbackView()
                    })
                    return
                case .issueFound?:
                    UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                        self.blurView?.layer.opacity = 1.0
                        self.feedbackView.layer.opacity = 1.0
                        self.feedbackView.scanFeedback = .issueFound
                        self.scannerModeView.layer.opacity = 0.0
                        self.view.layoutIfNeeded()
                    }, completion: { (completed) in
                        self.dismissFeedbackView()
                    })
                    return
                case .wrongEvent?:
                    UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                        self.blurView?.layer.opacity = 1.0
                        self.feedbackView.layer.opacity = 1.0
                        self.feedbackView.scanFeedback = .wrongEvent
                        self.scannerModeView.layer.opacity = 0.0
                        self.view.layoutIfNeeded()
                    }, completion: { (completed) in
                        self.dismissFeedbackView()
                    })
                    return
                default:
                    self.reader?.stopScanning()
                    self.showRedeemedTicket()
                    self.reader = nil
                    return
                }
            }
        } else {
            self.reader?.stopScanning()
            self.reader = nil
            return
        }
        */
    }

    private func showRedeemedTicket() {
        if self.scanCompleted == true {
            return
        }
        self.generator.notificationOccurred(.success)
        self.manualUserCheckinView.redeemableTicket = self.scannerViewModel.redeemableTicket
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.feedbackView.layer.contentsScale = 1.0
            self.blurView?.layer.opacity = 1.0
            self.scannerModeView.layer.opacity = 0.0
            self.manualCheckingTopAnchor?.constant = UIScreen.main.bounds.height - 250.0
            self.view.layoutIfNeeded()
        }, completion: { (completed) in
            self.scanCompleted = true
            
        })
    }

    internal func completeCheckin() {
        self.scannerViewModel.completeCheckin { (scanFeedback) in
            
            switch scanFeedback {
            case .alreadyRedeemed:
                UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.blurView?.layer.opacity = 1.0
                    self.feedbackView.layer.opacity = 1.0
                    self.feedbackView.scanFeedback = .alreadyRedeemed
                    self.scannerModeView.layer.opacity = 0.0
                    self.manualCheckingTopAnchor?.constant = UIScreen.main.bounds.height + 250.0
                    self.view.layoutIfNeeded()
                }, completion: { (completed) in
                    self.dismissFeedbackView()
                })
                return
            case .issueFound:
                UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.blurView?.layer.opacity = 1.0
                    self.feedbackView.layer.opacity = 1.0
                    self.feedbackView.scanFeedback = .issueFound
                    self.scannerModeView.layer.opacity = 0.0
                    self.manualCheckingTopAnchor?.constant = UIScreen.main.bounds.height + 250.0
                    self.view.layoutIfNeeded()
                }, completion: { (completed) in
                    self.dismissFeedbackView()
                })
                return
            case .wrongEvent:
                UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.blurView?.layer.opacity = 1.0
                    self.feedbackView.layer.opacity = 1.0
                    self.feedbackView.scanFeedback = .wrongEvent
                    self.scannerModeView.layer.opacity = 0.0
                    self.manualCheckingTopAnchor?.constant = UIScreen.main.bounds.height + 250.0
                    self.view.layoutIfNeeded()
                }, completion: { (completed) in
                    self.dismissFeedbackView()
                })
                return
            default:
                UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.blurView?.layer.opacity = 1.0
                    self.feedbackView.layer.opacity = 1.0
                    self.feedbackView.scanFeedback = .valid
                    self.scannerModeView.layer.opacity = 0.0
                    self.manualCheckingTopAnchor?.constant = UIScreen.main.bounds.height + 250.0
                    self.view.layoutIfNeeded()
                }, completion: { (completed) in
                    self.dismissFeedbackView()
                })
                return
            }
        }
    }
    
    private func dismissFeedbackView() {
        UIView.animate(withDuration: 0.8, delay: 1.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blurView?.layer.opacity = 0.0
            self.feedbackView.layer.opacity = 0.0
            self.scannerModeView.layer.opacity = 1.0
            self.manualCheckingTopAnchor?.constant = UIScreen.main.bounds.height + 250.0
            self.view.layoutIfNeeded()
        }, completion: { (completed) in
            self.scanCompleted = true
        })
    }
}

