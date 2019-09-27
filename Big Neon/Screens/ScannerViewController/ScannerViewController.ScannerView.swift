
import Foundation
import Big_Neon_UI
import Big_Neon_Core
import AVFoundation 

extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func scannerSetAutomatic() {
        self.hideScannedUser()
        self.lastScannedTicketTime = nil
        self.scannerViewModel?.scannedMetaString = nil
        self.stopScanning = false
        self.scannerViewModel?.setCheckingModeAutomatic()
    }
    
    func scannerSetManual() {
        self.hideScannedUser()
        self.lastScannedTicketTime = nil
        self.scannerViewModel?.scannedMetaString = nil
        self.stopScanning = false
        self.scannerViewModel?.setCheckingModeManual()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        guard let metadataObj = metadataObjects.first as? AVMetadataMachineReadableCodeObject else {
            self.stopScanning = false
            print("No Meta Data")
            return
        }
        
        if self.stopScanning == true {
            print("Scanning Stopped")
            return
        }
        
        if supportedCodeTypes.contains(metadataObj.type) {
            guard let metaDataString = metadataObj.stringValue else {
                self.stopScanning = true
                return
            }
            
            guard self.scannerViewModel?.getRedeemKey(fromStringValue: metaDataString) != nil else {
                self.generator.notificationOccurred(.error)
                self.showAlert(presenter: self, title: "No Redeem Key Found", message: "The ticket does not contain a redeem key. Check the guest in from the guest list")
                // **  Save the Meta String to prevent Duplicate Scanning
                self.scannerViewModel?.scannedMetaString = metaDataString
                self.stopScanning = true
                return
            }
            
            guard let ticketID = self.scannerViewModel?.getTicketID(fromStringValue: metaDataString) else {
                self.stopScanning = true
                return
            }
            
            //  Last Meta String and Latest are the same or the Time since scan is greater than the scan date
            if let scannedMetaString = self.scannerViewModel?.scannedMetaString,
                let lastScannedTime = self.lastScannedTicketTime  {
                
                let timeDelaySeconds = BundleInfo.fetchScanSeconds()
//                if metaDataString == scannedMetaString || Date() < Date.init(timeInterval: TimeInterval(timeDelaySeconds), since: lastScannedTime) {
//                    self.checkingTicket(ticketID: ticketID, scannerMode: self.scannerViewModel?.scannerMode())
//                    return
//                }
                
                if let lastScannedTimer = self.lastScannedTicketTimer {
                    if metaDataString == scannedMetaString && lastScannedTimer.isValid {
                        return
                    }
                }
                
                if Date() < Date.init(timeInterval: TimeInterval(timeDelaySeconds), since: lastScannedTime) {
                    //  Date of Last scan is less than the current time + 5 seconds
                    return
                }
            }
            
            // **  Save the Meta String to prevent Duplicate Scanning
            self.scannerViewModel?.scannedMetaString = metaDataString
            
            //  Check if a Scanned User
            if self.isShowingScannedUser == true {
                print("Scanner is still showing a user")
                return
            }
            
            self.hideScannedUser()
            self.stopScanning = true
            
            //  **  // update the Last Scanned User Timer
            self.lastScannedTicketTime = Date()
            self.checkingTicket(ticketID: ticketID, scannerMode: self.scannerViewModel?.scannerMode())
        }
    }
    
    private func checkingTicket(ticketID: String, scannerMode: Bool?) {
        if scannerMode == true {
            self.checkinAutomatically(withTicketID: ticketID, fromGuestTableView: false, atIndexPath: nil)
        } else {
            self.checkinManually(withTicketID: ticketID)
        }
    }
    
    func dismissScannedUserView() {
        self.isShowingScannedUser = false
        self.dismissFeedbackView(feedback: nil)
        self.lastScannedTicketTime = nil
        self.scannerViewModel?.lastRedeemedTicket = nil
    }
    
    func dismissFeedbackView(feedback: ScanFeedback?) {
        UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blurView?.layer.opacity = 0.0
            self.closeButton.layer.opacity = 1.0
            self.scanningBoarderView.layer.opacity = 1.0
            self.showGuestView.layer.opacity = 1.0
            self.scanningBoarderView.layer.opacity = 1.0
            self.scannerModeView.layer.opacity = 1.0
            self.manualCheckingTopAnchor?.constant = UIScreen.main.bounds.height + 250.0
            self.view.layoutIfNeeded()
        }, completion: { (completed) in
            if feedback == .valid {
                self.presentScannedUser()
            } else {
                self.stopScanning = false
            }
        })
    }
    
    func presentScannedUser() {
        self.generator.notificationOccurred(UINotificationFeedbackGenerator.FeedbackType.success)
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.scannedUserBottomAnchor?.constant = -100.0
            self.view.layoutIfNeeded()
        }, completion: { (completed) in
            self.stopScanning = false
        })
    }
    
    @objc func hideScannedUser() {
        self.lastScannedTicket = self.scannedTicket
        self.scannedTicket = nil
        self.stopScanning = true
        self.lastScannedTicketTimer?.invalidate()
        self.displayedScannedUser = false
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            self.scannedUserBottomAnchor?.constant = 250.0
            self.blurView?.layer.opacity = 0.0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
}
