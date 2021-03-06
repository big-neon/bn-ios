
import Foundation
import AVFoundation
import UIKit
import Big_Neon_UI
import Big_Neon_Core
import PanModal

public protocol ScannerViewDelegate: class {
//    func completeCheckin()
    func scannerSetAutomatic()
    func scannerSetManual()
    func checkinAutomatically(withTicketID ticketID: String, fromGuestTableView: Bool, atIndexPath: IndexPath?)
    func dismissScannedUserView()
    func showRedeemedTicket()
}

final class ScannerViewController: UIViewController, ScannerViewDelegate {
    
    //  Video Capture Session
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var scannedTicket: RedeemableTicket?
    var lastScannedTicket: RedeemableTicket?
    var scannedTicketID: String?
    var event: EventsData?
    var guestListVC: EventViewController?
    
    //  Layout
    let generator = UINotificationFeedbackGenerator()
    var audioPlayer: AVAudioPlayer?
    var manualCheckingTopAnchor: NSLayoutConstraint?
    var scannedUserBottomAnchor: NSLayoutConstraint?
    var viewGuestListBottomAnchor: NSLayoutConstraint?
    var stopScanning: Bool?
    var isShowingScannedUser: Bool?
    var scannerViewModel = CheckinService()
    let eventViewModel = EventViewModel()
    
    //  Last Scanned Ticked Time
    var lastScannedTicketTime: Date?
    
    //  Scanned Time
    var lastScannedTicketTimer: Timer?
    
    var displayedScannedUser: Bool = false {
        didSet {
            if displayedScannedUser == true {
                let timeDelaySeconds = Double(BundleInfo.fetchScanViewDimissSeconds())
                lastScannedTicketTimer = Timer.scheduledTimer(timeInterval: timeDelaySeconds, target: self, selector: #selector(hideScannedUser), userInfo: nil, repeats: false)
            }
        }
    }
    
    let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
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
    
    lazy var scannerModeView: ScannerModeView = {
        let view =  ScannerModeView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(dismissView), for: UIControl.Event.touchUpInside)
        button.setImage(#imageLiteral(resourceName: "ic_closeBUtton"), for: UIControl.State.normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var scanningBoarderView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "ic_scsnner_view")
        imageView.layer.opacity = 0.5
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var showGuestView: ShowGuestListView = {
        let view =  ShowGuestListView()
        view.headerLabel.textColor = UIColor.brandPrimary
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showGuestList)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var scannedUserView: LastScannedUserView = {
        let view =  LastScannedUserView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var cameraTintView: UIView = {
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
        configureViewModel()
        view.backgroundColor = UIColor.black
        hideNavBar()
        configureAutoMode()
        configureScanner()
        configureHeader()
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    func configureAutoMode() {
        if scannerViewModel.setScannerModeFirstTime() == true {
            self.scannerModeView.setAutoMode = true
        }
    }

    private func configureViewModel() {
        scannerViewModel.scanVC = self
        scannerModeView.setAutoMode = scannerViewModel.scannerMode()
    }

    private func configureHeader() {
        view.addSubview(scannerModeView)
        view.addSubview(closeButton)
        view.addSubview(showGuestView)
        view.addSubview(scanningBoarderView)
        
        scannerModeView.delegate = self
        scannerModeView.layer.cornerRadius = 24.0
        showGuestView.layer.cornerRadius = 20.0
        
        scannerModeView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12).isActive = true
        scannerModeView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -12).isActive = true
        scannerModeView.widthAnchor.constraint(equalToConstant: 200.0).isActive = true
        scannerModeView.heightAnchor.constraint(equalToConstant: 48.0).isActive = true
        
        closeButton.centerYAnchor.constraint(equalTo: scannerModeView.centerYAnchor).isActive = true
        closeButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 12).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 48.0).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 48.0).isActive = true
        
        viewGuestListBottomAnchor = showGuestView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -18)
        viewGuestListBottomAnchor?.isActive = true
        showGuestView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        showGuestView.widthAnchor.constraint(equalToConstant: 180.0).isActive = true
        showGuestView.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        scanningBoarderView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scanningBoarderView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        scanningBoarderView.widthAnchor.constraint(equalToConstant: 200.0).isActive = true
        scanningBoarderView.heightAnchor.constraint(equalToConstant: 200.0).isActive = true
    }

    private func configureScanner() {
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            configureScannedUserView()
            return
        }
        
        //  Configuring the camera to focus on near objects
        if videoCaptureDevice.isAutoFocusRangeRestrictionSupported == true {
            do {
                try videoCaptureDevice.lockForConfiguration()
                videoCaptureDevice.autoFocusRangeRestriction = .near
                videoCaptureDevice.focusPointOfInterest = CGPoint(x: 0.5, y: 0.5)
            } catch {
                AnalyticsService.reportError(errorType: ErrorType.scanning, error: error.localizedDescription)
            }
        }

        do {
            let input = try AVCaptureDeviceInput(device: videoCaptureDevice)
            captureSession.addInput(input)
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
        } catch {
            AnalyticsService.reportError(errorType: ErrorType.scanning, error: error.localizedDescription)
            return
        }

        // Video preview Layer 
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        captureSession.startRunning()
        configureScannedUserView()
    }
    
    @objc func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
    private func configureScannedUserView() {
        view.addSubview(scannedUserView)
        scannedUserView.isUserInteractionEnabled = true
        scannedUserView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showRedeemedTicket)))
    
        if self.isiPhoneSE() == true {
            scannedUserView.layer.cornerRadius = 0.0
            scannedUserView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            scannedUserView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        } else {
            scannedUserView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20.0).isActive = true
            scannedUserView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20.0).isActive = true
        }

        scannedUserBottomAnchor = scannedUserView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 250.0) 
        scannedUserBottomAnchor?.isActive = true
        scannedUserView.heightAnchor.constraint(equalToConstant: 76.0).isActive = true
    }
    
    
    @objc func showGuestList() {
        viewAnimationBounce(viewSelected: showGuestView,
                            bounceVelocity: 10.0,
                            springBouncinessEffect: 3.0)
        self.stopScanning = true
        
        guard let event = event else {
            return
        }
        
        let eventVC = EventViewController(event: event, presentedFromScannerVC: true)
        let eventNavVC = UINavigationController(rootViewController: eventVC)
        eventNavVC.modalPresentationStyle = .fullScreen
        self.present(eventNavVC, animated: true, completion: nil)
    }
}


