
import Foundation
import Big_Neon_UI
import Big_Neon_Core
import AVFoundation 

extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func scannerSetAutomatic() {
        self.hideScannedUser()
        self.stopScanning = false
        self.scannerViewModel?.setCheckingModeAutomatic()
    }
    
    func scannerSetManual() {
        self.hideScannedUser()
        self.stopScanning = false
        self.scannerViewModel?.setCheckingModeManual()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        guard let metadataObj = metadataObjects.first as? AVMetadataMachineReadableCodeObject else {
            self.stopScanning = true
            return
        }
        
        if self.stopScanning == true {
            return
        }
        
        if supportedCodeTypes.contains(metadataObj.type) {
            guard let metaDataString = metadataObj.stringValue else {
                self.generator.notificationOccurred(.error)
                self.stopScanning = true
                return
            }
            
            guard self.scannerViewModel?.getRedeemKey(fromStringValue: metaDataString) != nil else {
                self.generator.notificationOccurred(.error)
                Utils.showAlert(presenter: self, title: "No Redeem Key Found", message: "The ticket does not contain a redeem key. Check the guest in from the guest list")
                self.stopScanning = true
                return
            }
            
            guard let ticketID = self.scannerViewModel?.getTicketID(fromStringValue: metaDataString) else {
                self.generator.notificationOccurred(.error)
                self.stopScanning = true
                return
            }
            
            //  Last Ticket and Latest Ticket are the same - don't rescan.
            print(self.scannerViewModel?.redeemedTicket?.id)
            print(ticketID)
            
            if let scannedTicketID = self.scannerViewModel?.redeemedTicket?.id {
                if ticketID == scannedTicketID {
                    self.stopScanning = false
                    print(self.stopScanning)
                    return
                }
            }
            
            self.hideScannedUser()
            self.stopScanning = true
            if self.scannerViewModel?.scannerMode() == true {
                self.checkinAutomatically(withTicketID: ticketID, fromGuestTableView: false, atIndexPath: nil)
            } else {
                self.checkinManually(withTicketID: ticketID)
            }
        }
    }
    
    func dismissScannedUserView() {
        self.dismissFeedbackView(feedback: nil)
    }
    
    func dismissFeedbackView(feedback: ScanFeedback?) {
        UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blurView?.layer.opacity = 0.0
            self.closeButton.layer.opacity = 1.0
            self.scanningBoarderView.layer.opacity = 1.0
            self.showGuestView.layer.opacity = 1.0
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
    
    private func presentScannedUser() {
        self.manualUserCheckinView.redeemableTicket = self.scannedTicket
        self.generator.notificationOccurred(UINotificationFeedbackGenerator.FeedbackType.success)
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.scannedUserBottomAnchor?.constant = -100.0
            self.view.layoutIfNeeded()
        }, completion: { (completed) in
            self.stopScanning = false
        })
    }
    
    func hideScannedUser() {
        self.manualUserCheckinView.redeemableTicket = nil
        self.lastScannedTicket = self.scannedTicket
        self.scannedTicket = nil
        self.stopScanning = true
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            self.scannedUserBottomAnchor?.constant = 250.0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
}
