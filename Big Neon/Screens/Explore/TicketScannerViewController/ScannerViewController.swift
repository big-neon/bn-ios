
import Foundation
import AVFoundation
import UIKit
import Big_Neon_UI
import Big_Neon_Core
import PanModal

public protocol ScannerViewDelegate: class {
    func completeCheckin()
    func scannerSetAutomatic()
    func scannerSetManual()
    func checkinAutomatically(withTicketID ticketID: String, fromGuestTableView: Bool, atIndexPath: IndexPath?)
//    func reloadGuests()
    func dismissScannedUserView()
}

final class ScannerViewController: UIViewController, ScannerViewDelegate {
    
    //  Video Capture Session
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var scannedTicket: RedeemableTicket?
    var lastScannedTicket: RedeemableTicket?
    var scannedTicketID: String?
    var event: EventsData?
    var fetcher: Fetcher
    var guestListVC: GuestListViewController?
    
    //  Layout
    let generator = UINotificationFeedbackGenerator()
    var guestListTopAnchor: NSLayoutConstraint?
    var manualCheckingTopAnchor: NSLayoutConstraint?
    var scannedUserBottomAnchor: NSLayoutConstraint?
    var stopScanning: Bool?
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
    
    var guests: [RedeemableTicket]? {
        didSet {
            showGuestView.loadingView.stopAnimating()
            if guests != nil {
                showGuestView.isUserInteractionEnabled = true
            }
        }
    }
    
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
        view.loadingView.startAnimating()
        view.isUserInteractionEnabled = false
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showGuestList)))
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
        hideNavBar()
        configureScanner()
        configureManualCheckinView()
        configureHeader()
        self.fetchGuests()
    }
    
    func fetchGuests() {
        guard let eventID = self.event?.id else {
            return
        }
        
        self.scannerViewModel?.fetchGuests(forEventID: eventID, page: 0, completion: { [weak self] (completed) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.guests = self.scannerViewModel?.ticketsFetched
            }
        })
    }

    private func configureViewModel() {
        scannerViewModel = TicketScannerViewModel()
        scannerViewModel?.scanVC = self
        scannerModeView.setAutoMode = scannerViewModel!.scannerMode()
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
        
        showGuestView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -18).isActive = true
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
        
    }
    
    @objc func dismissView() {
        dismiss(animated: true, completion: nil)
    }

    private func configureManualCheckinView() {
        view.addSubview(manualUserCheckinView)
        
        manualUserCheckinView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        manualUserCheckinView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        manualCheckingTopAnchor = manualUserCheckinView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: UIScreen.main.bounds.height + 50.0)
        manualCheckingTopAnchor?.isActive = true
        manualUserCheckinView.heightAnchor.constraint(equalToConstant: 250.0).isActive = true
    }
    
    private func configureScannedUserView() {
        view.addSubview(scannedUserView)
        scannedUserView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20.0).isActive = true
        scannedUserView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20.0).isActive = true
        scannedUserBottomAnchor = scannedUserView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 200.0)
        scannedUserBottomAnchor?.isActive = true
        scannedUserView.heightAnchor.constraint(equalToConstant: 76.0).isActive = true
    }
    
    @objc func showGuestList() {
        viewAnimationBounce(viewSelected: showGuestView,
                            bounceVelocity: 10.0,
                            springBouncinessEffect: 3.0)
        self.stopScanning = true
        guard let guests = self.guests else {
            return
        }
        guestListVC = GuestListViewController()
        guestListVC!.guests = guests
        guestListVC!.guestViewModel.totalGuests = self.scannerViewModel?.totalGuests
        guestListVC!.guestViewModel.currentTotalGuests = self.scannerViewModel!.currentTotalGuests
        guestListVC!.guestViewModel.currentPage = self.scannerViewModel!.currentPage
        guestListVC!.guestViewModel.ticketsFetched = guests
        guestListVC!.totalGuests = self.scannerViewModel?.totalGuests
        guestListVC!.event = self.event
        guestListVC!.scanVC = self
        guestListVC!.delegate = self
        let navGuestVC = GuestListNavigationController(rootViewController: guestListVC!)
        self.presentPanModal(navGuestVC)
    }

    @objc func syncEventsData() {
        fetcher.syncCheckins { result in
            switch result {
            case .success:
                print("Syncing Data")
            case .failure(let error):
                print(error)
            }
        }
    }
}


