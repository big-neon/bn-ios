

import UIKit
import Big_Neon_UI
import AVFoundation
import QRCodeReader

final class TicketScannerViewController: BaseViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    internal var captureSession = AVCaptureSession()
    internal var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    
    internal var guestListView: GuestListView = {
        let view =  GuestListView()
//        view.
        return view
    }()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        self.configureNavBar()
        self.configureScanner()
        self.configureCameraView()
    }
    
    private func configureScanner() {
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
    
    private func configureView() {
        self.addSubview(eventImageView)
        self.addSubview(eventNameLabel)
        self.addSubview(eventDateLabel)
        self.addSubview(favouriteButton)
        self.addSubview(priceView)
        
        eventImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        eventImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.eventImageTopAnchor = eventImageView.topAnchor.constraint(equalTo: self.topAnchor)
        self.eventImageTopAnchor?.isActive = true
        eventImageView.heightAnchor.constraint(equalToConstant: 162.0).isActive = true
        
        favouriteButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15.0).isActive = true
        favouriteButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 15.0).isActive = true
        favouriteButton.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        favouriteButton.widthAnchor.constraint(equalToConstant: 35.0).isActive = true
        
        eventNameLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        eventNameLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        eventNameLabel.topAnchor.constraint(equalTo: eventImageView.bottomAnchor, constant: 12).isActive = true
        eventNameLabel.heightAnchor.constraint(equalToConstant: 16.0).isActive = true
        
        eventDateLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        eventDateLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        eventDateLabel.topAnchor.constraint(equalTo: eventNameLabel.bottomAnchor, constant: 8).isActive = true
        eventDateLabel.heightAnchor.constraint(equalToConstant: 14.0).isActive = true
        
        priceView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15.0).isActive = true
        priceView.bottomAnchor.constraint(equalTo: eventImageView.bottomAnchor, constant: -15.0).isActive = true
        priceView.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
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
    
}

