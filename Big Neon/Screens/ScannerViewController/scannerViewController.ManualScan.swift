
import Foundation
import Big_Neon_UI
import Big_Neon_Core
import AVFoundation

extension ScannerViewController {
    
    func checkinManually(withTicketID ticketID: String) {
        self.scannerViewModel?.getRedeemTicket(ticketID: ticketID) { [weak self] (scanFeedback, errorString) in
            DispatchQueue.main.async {
                switch scanFeedback {
                case .validTicketID?:
                    self?.stopScanning = false
                    if let ticket = self?.scannedTicket {
                        self?.showRedeemedTicket(forTicket: ticket)
                    }
                case .wrongEvent?:
                    self?.checkinAutomatically(withTicketID: ticketID, fromGuestTableView: false, atIndexPath: nil)
                default:
                      print("Ticket Not Found")    // To be modified to handle different types of errors
                    //  self?.manualCheckinFeedback(scanFeedback: scanFeedback) 
                }
            }
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
            self.stopScanning = true
        })
    }
    
    func showRedeemedTicket(forTicket ticket: RedeemableTicket) {
        self.stopScanning = true
        self.isShowingScannedUser = true
        self.manualUserCheckinView.event = self.event
        self.scannedTicketID = ticket.id
        self.manualUserCheckinView.redeemableTicket = ticket
        self.playSuccessSound(forValidTicket: false)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.scanningBoarderView.layer.opacity = 1.0
            self.showGuestView.layer.opacity = 0.0
            self.closeButton.layer.opacity = 0.0
            self.blurView?.layer.opacity = 1.0
            self.scanningBoarderView.layer.opacity = 0.0
            self.scannerModeView.layer.opacity = 0.0
            self.manualCheckingTopAnchor?.constant = UIScreen.main.bounds.height - 272.0
            self.view.layoutIfNeeded()
        }, completion: { (completed) in
            self.stopScanning = true
        })
    }
    
    internal func completeCheckin() {
        
        guard let ticketID = self.scannedTicketID else {
            return
        }
        
        self.isShowingScannedUser = false
        self.scannerViewModel?.automaticallyCheckin(ticketID: ticketID) { (scanFeedback, errorString, ticket) in
            DispatchQueue.main.async {
                self.manualUserCheckinView.completeCheckinButton.stopAnimation()
                UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
                    self.showManuallyScannedUser(feedback: scanFeedback, ticket: ticket)
                    self.view.layoutIfNeeded()
                }, completion: { (completed) in
                    self.stopScanning = false
                })
            }
            
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
        self.scanningBoarderView.layer.opacity = 1.0
        self.scannerViewModel?.lastRedeemedTicket = nil
        self.scannedUserBottomAnchor?.constant = -100.0
        self.manualCheckingTopAnchor?.constant = UIScreen.main.bounds.height + 250.0
        self.generator.notificationOccurred(.success)
    }
}
