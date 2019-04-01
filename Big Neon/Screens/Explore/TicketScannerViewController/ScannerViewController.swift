
import Foundation
import AVFoundation
import UIKit
import Big_Neon_UI
import Big_Neon_Core

final class ScannerViewController: UIViewController, ScannerModeViewDelegate, GuestListViewProtocol, ManualCheckinModeDelegate {
    
    //  Video Capture Session
    internal var captureSession = AVCaptureSession()
    internal var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    internal var scannedTicket: RedeemableTicket?
    internal var scannedTicketID: String?
    internal var event: Event?
    
    //  Layout
    internal let generator = UINotificationFeedbackGenerator()
    internal var guestListTopAnchor: NSLayoutConstraint?
    internal var manualCheckingTopAnchor: NSLayoutConstraint?
    internal var scannedUserBottomAnchor: NSLayoutConstraint?
    internal var scanCompleted: Bool?
    internal var scannerViewModel : TicketScannerViewModel?
    internal let blurEffect = UIBlurEffect(style: .dark)
    internal var blurView: UIVisualEffectView?
    
    internal let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
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
                    self.scannerModeView.layer.opacity = 0.0
                    self.guestListTopAnchor?.constant = UIScreen.main.bounds.height - 560.0
                    self.view.layoutIfNeeded()
                }) { (complete) in
                    print("De-Activated Camera")
                }
                return
            }
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
                self.cameraTintView.layer.opacity = 0.0
                self.scannerModeView.layer.opacity = 1.0
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

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViewModel()
        view.backgroundColor = UIColor.black
        self.configureNavBar()
        self.configureScanner()
        self.configureManualCheckinView()
        self.configureScanFeedbackView()
    }

    private func configureViewModel() {
        self.scannerViewModel = TicketScannerViewModel()
        self.scannerViewModel?.scanVC = self
        self.scannerModeView.setAutoMode = self.scannerViewModel!.scannerMode()
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
        self.configureGuestList()
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
    
    private func configureGuestList() {
        self.view.addSubview(guestListView)
        guestListView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        guestListView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.guestListTopAnchor = guestListView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: UIScreen.main.bounds.height - 64.0 )
        self.guestListTopAnchor?.isActive = true
        guestListView.heightAnchor.constraint(equalToConstant: 560.0).isActive = true
    }
}


