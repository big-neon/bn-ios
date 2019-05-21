
import Foundation
import Big_Neon_UI
import Big_Neon_Core
import AVFoundation

extension ScannerViewController {
    
    func checkinManually(withTicketID ticketID: String) {
        self.scannerViewModel?.getRedeemTicket(ticketID: ticketID) { [weak self] (scanFeedback, errorString) in
            if scanFeedback == .validTicketID {
                self?.stopScanning = false
                if let ticket = self?.scannedTicket {
                  self?.showRedeemedTicket(forTicket: ticket)
                }
                return
            }
            self?.manualCheckinFeedback(scanFeedback: scanFeedback)
        }
    }
    
    func manualCheckinFeedback(scanFeedback: ScanFeedback?) {
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.scanningBoarderView.layer.opacity = 0.0
            self.showGuestView.layer.opacity = 0.0
            self.blurView?.layer.opacity = 1.0
            self.scannerModeView.layer.opacity = 0.0
            self.view.layoutIfNeeded()
        }, completion: { (completed) in
            self.stopScanning = false
        })
    }
    
    func showRedeemedTicket(forTicket ticket: RedeemableTicket) {
        self.manualUserCheckinView.event = self.event
        self.scannedTicketID = ticket.id    //  self.scannedTicket?.id
        self.manualUserCheckinView.redeemableTicket = ticket //self.scannedTicket
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.scanningBoarderView.layer.opacity = 0.0
            self.showGuestView.layer.opacity = 0.0
            self.closeButton.layer.opacity = 0.0
            self.blurView?.layer.opacity = 1.0
            self.scannerModeView.layer.opacity = 0.0
            self.manualCheckingTopAnchor?.constant = UIScreen.main.bounds.height - 250.0
            self.view.layoutIfNeeded()
        }, completion: { (completed) in
            self.stopScanning = true
        })
    }
    
    internal func completeCheckin() {
        
        guard let ticketID = self.scannedTicketID else {
            return
        }
        
        self.scannerViewModel?.automaticallyCheckin(ticketID: ticketID) { (scanFeedback, errorString, ticket) in
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
                self.showManuallyScannedUser(feedback: scanFeedback, ticket: ticket)
                self.view.layoutIfNeeded()
            }, completion: { (completed) in
                self.stopScanning = false
            })
        }
    }
    
    func showManuallyScannedUser(feedback: ScanFeedback?, ticket: RedeemableTicket?) {
        var feedFound = feedback
        if ticket?.eventName != self.event?.name {
            feedFound = .wrongEvent
        }
        self.scannedUserView.redeemableTicket = ticket
        self.scannedUserView.scanFeedback = feedFound
        self.blurView?.layer.opacity = 0.0
        self.scannerModeView.layer.opacity = 1.0
        self.showGuestView.layer.opacity = 1.0
        self.closeButton.layer.opacity = 1.0
        self.scannedUserBottomAnchor?.constant = -100.0
        self.manualCheckingTopAnchor?.constant = UIScreen.main.bounds.height + 250.0
        self.generator.notificationOccurred(.success)
    }
}
