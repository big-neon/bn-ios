
import Foundation
import AVFoundation
import UIKit
import Big_Neon_UI
import Big_Neon_Core

final class ScannerViewController: UIViewController, ScannerModeViewDelegate, GuestListViewProtocol, ManualCheckinModeDelegate {
    
    //  Video Capture Session
    internal var captureSession = AVCaptureSession()
    internal var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    //  Layout
//    internal var qrCodeFrameView: UIView?
    internal let generator = UINotificationFeedbackGenerator()
    internal var guestListTopAnchor: NSLayoutConstraint?
    internal var manualCheckingTopAnchor: NSLayoutConstraint?
    internal var scannedUserBottomAnchor: NSLayoutConstraint?
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
    
    internal lazy var scannerModeView: ScannerModeView = {
        let view =  ScannerModeView()
        view.setAutoMode = self.scannerViewModel.scannerMode()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
    
    private func configureBlur() {
        let blur = UIBlurEffect(style: .dark)
        self.blurView = UIVisualEffectView(effect: blur)
        self.blurView?.frame = self.view.bounds
        self.blurView?.layer.opacity = 0.0
        self.blurView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(self.blurView!)
    }
    
    internal lazy var feedbackView: TicketScanFeedbackView = {
        let view =  TicketScanFeedbackView()
        view.layer.opacity = 0.0
        view.layer.contentsScale = 0.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    internal lazy var scannedUserView: LastScannedUserView = {
        let view =  LastScannedUserView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    internal lazy var cameraTintView: UIView = {
        let view =  UIView()
        view.backgroundColor = UIColor.black
        view.layer.opacity = 0.0
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        self.configureNavBar()
        self.configureScanner()
        self.configureManualCheckinView()
        self.configureScanFeedbackView()
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
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
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
        self.configureBlur()
        self.configureScannedUserView()
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
    
    private func configureScannedUserView() {
        self.view.addSubview(scannedUserView)
        scannedUserView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 40.0).isActive = true
        scannedUserView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -40.0).isActive = true
        self.scannedUserBottomAnchor = scannedUserView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 150.0)
        self.scannedUserBottomAnchor?.isActive = true
        scannedUserView.heightAnchor.constraint(equalToConstant: 64.0).isActive = true
    }
}


extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    @objc private func handleClose() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showGuestList() {
        self.isShowingGuests = !self.isShowingGuests
    }
    
    func scannerSetAutomatic() {
        print("Automatic")
    }
    
    func scannerSetManual() {
        print("Automatic")
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
//            qrCodeFrameView?.frame = CGRect.zero
            print("No QR code is detected")
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            guard let metaDataString = metadataObj.stringValue else {
                self.generator.notificationOccurred(.error)
                return
            }
            
            guard self.scannerViewModel.getRedeemKey(fromStringValue: metaDataString) != nil else {
                self.generator.notificationOccurred(.error)
                return
            }
            
            guard let ticketID = self.scannerViewModel.getTicketID(fromStringValue: metaDataString) else {
                self.generator.notificationOccurred(.error)
                return
            }
            
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
                    self.showRedeemedTicket()
                    return
                }
            }
        }
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
            self.presentScannedUser()
        })
    }

    private func presentScannedUser() {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.scannedUserBottomAnchor?.constant = -80.0
            self.view.layoutIfNeeded()
        }, completion: { (completed) in
            self.scanCompleted = true
        })
        
    }

}
