
import Foundation
import AVFoundation
import UIKit
import Big_Neon_UI
import Big_Neon_Core

public protocol ScannerViewDelegate: class {
    func completeCheckin()
    func scannerSetAutomatic()
    func scannerSetManual()
    func showGuestList()
    func checkinAutomatically(withTicketID ticketID: String, fromGuestTableView: Bool, atIndexPath: IndexPath?)
    func reloadGuests()
}

final class ScannerViewController: UIViewController, ScannerViewDelegate {
    
    //  Video Capture Session
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var scannedTicket: RedeemableTicket?
    var scannedTicketID: String?
    var event: EventsData?
    var fetcher: Fetcher
    
    //  Layout
    let generator = UINotificationFeedbackGenerator()
    var guestListTopAnchor: NSLayoutConstraint?
    var manualCheckingTopAnchor: NSLayoutConstraint?
    var scannedUserBottomAnchor: NSLayoutConstraint?
    var scanCompleted: Bool?
    var scannerViewModel : TicketScannerViewModel?
    let blurEffect = UIBlurEffect(style: .dark)
    var blurView: UIVisualEffectView?
    
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
    
    var isShowingGuests: Bool = false {
        didSet {
            if isShowingGuests == true {
                
                // MARK: we want to be on main thread
                // seems unnecessary too complicate
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
                    self.cameraTintView.layer.opacity = 0.85
                    self.scannerModeView.layer.opacity = 0.0
                    self.guestListTopAnchor?.constant = UIScreen.main.bounds.height - 560
                    self.navigationItem.leftBarButtonItem = nil
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
                self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_close"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.handleClose))
                self.view.layoutIfNeeded()
            }) { (complete) in
                print("Activated Camera")
            }
            return
        }
    }
    
    lazy var scannerModeView: ScannerModeView = {
        let view =  ScannerModeView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var guestListView: GuestListView = {
        let view =  GuestListView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var manualUserCheckinView: ManualCheckinModeView = {
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
    
    lazy var feedbackView: TicketScanFeedbackView = {
        let view =  TicketScanFeedbackView()
        view.layer.opacity = 0.0
        view.layer.contentsScale = 0.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var scannedUserView: LastScannedUserView = {
        let view =  LastScannedUserView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var cameraTintView: UIView = {
        let view =  UIView()
        view.backgroundColor = UIColor.black
        view.layer.opacity = 0.0
        return view
    }()
    
    init(fetcher: Fetcher) {
        self.fetcher = fetcher
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        view.backgroundColor = UIColor.black
        configureNavBar()
        configureScanner()
        configureManualCheckinView()
        configureScanFeedbackView()
    }

    private func configureViewModel() {
        scannerViewModel = TicketScannerViewModel()
        scannerViewModel?.scanVC = self
        scannerModeView.setAutoMode = scannerViewModel!.scannerMode()
    }

    private func configureNavBar() {
        navigationClearBar()
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_close"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(handleClose))
        
        scannerModeView.delegate = self
        scannerModeView.widthAnchor.constraint(equalToConstant: 290.0).isActive = true
        scannerModeView.heightAnchor.constraint(equalToConstant: 48.0).isActive = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: scannerModeView)
    }

    private func configureScanner() {
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            print("Video Failed to Run: Possibly running on a simulator with no video")
            configureScannedUserView()
            configureGuestList()
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
        configureBlur()
        configureScannedUserView()
        configureGuestList()
    }

    private func configureManualCheckinView() {
        view.addSubview(manualUserCheckinView)
        
        manualUserCheckinView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        manualUserCheckinView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        manualCheckingTopAnchor = manualUserCheckinView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: UIScreen.main.bounds.height + 50.0)
        manualCheckingTopAnchor?.isActive = true
        manualUserCheckinView.heightAnchor.constraint(equalToConstant: 250.0).isActive = true
    }
    
    private func configureScanFeedbackView() {
        view.addSubview(feedbackView)
        feedbackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        feedbackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -20.0).isActive = true
        feedbackView.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        feedbackView.widthAnchor.constraint(equalToConstant: 220.0).isActive = true
    }
    
    private func configureScannedUserView() {
        view.addSubview(scannedUserView)
        scannedUserView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40.0).isActive = true
        scannedUserView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40.0).isActive = true
        scannedUserBottomAnchor = scannedUserView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 160.0)
        scannedUserBottomAnchor?.isActive = true
        scannedUserView.heightAnchor.constraint(equalToConstant: 64.0).isActive = true
    }
    
    private func configureGuestList() {
        view.addSubview(guestListView)
        guestListView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        guestListView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        guestListTopAnchor = guestListView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: UIScreen.main.bounds.height - 64.0)
        guestListTopAnchor?.isActive = true
        guestListView.heightAnchor.constraint(equalToConstant: 560.0).isActive = true
        
        guard let eventID = self.event?.id else {
            return
        }
        self.fetchGuests(forEventID: eventID)
    }
    
    private func fetchGuests(forEventID eventID: String) {
        self.scannerViewModel?.fetchGuests(forEventID: eventID, completion: { [weak self] (completed) in
            DispatchQueue.main.async {
//                self?.scannerViewModel?.guestsCoreData = (self?.fetcher.fetchLocalGuests())!
                self?.guestListView.guests = self?.scannerViewModel?.ticketsFetched //    self?.scannerViewModel?.guestsCoreData
            }
        })
    }
    
    func reloadGuests() {
        guard let eventID = self.event?.id else {
            return
        }
        
        self.scannerViewModel?.fetchGuests(forEventID: eventID, completion: { [weak self] (completed) in
            DispatchQueue.main.async {
                self?.guestListView.guests = nil
                self?.guestListView.guests = self?.scannerViewModel?.ticketsFetched
                self?.guestListView.refresher.endRefreshing()
                self?.guestListView.guestTableView.reloadData()
                return
            }
        })
    }
    
    func reloadGuests(atIndex index: IndexPath) {
        guard let eventID = self.event?.id else {
            return
        }
        
        self.scannerViewModel?.fetchGuests(forEventID: eventID, completion: { [weak self] (completed) in
            DispatchQueue.main.async {
                self?.guestListView.guests = self?.scannerViewModel?.ticketsFetched
                self?.guestListView.guestTableView.reloadRows(at: [index], with: UITableView.RowAnimation.fade)
                return
            }
        })
    }

    @objc func syncEventsData() {
        fetcher.syncCheckins { result in
            switch result {
            case .success:
                print("Syncing Data")
//                self.scannerViewModel?.guestsCoreData = self.fetcher.fetchLocalGuests()
            case .failure(let error):
                print(error)
            }
        }
    }
}


