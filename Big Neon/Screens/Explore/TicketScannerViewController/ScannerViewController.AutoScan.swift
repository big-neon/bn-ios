
import Foundation
import Big_Neon_UI
import Big_Neon_Core
import AVFoundation

extension ScannerViewController {
    
    func checkinAutomatically(withTicketID ticketID: String, fromGuestTableView: Bool, atIndexPath: IndexPath?) {
        
        self.scannerViewModel?.automaticallyCheckin(ticketID: ticketID) { [weak self] (scanFeedback, errorString, ticket) in
            DispatchQueue.main.async {
                if fromGuestTableView == true {
//                    self.gues
                    self?.guestListVC?.reloadGuests(atIndex: atIndexPath!)
                    self?.generator.notificationOccurred(.success)
                    return
                }
            
                if scanFeedback == .alreadyRedeemed {
                    if let ticket = ticket {
                        self?.showRedeemedTicket(forTicket: ticket)
                    }
                    return
                }
                
                UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
                    self?.showScannedUser(feedback: scanFeedback, ticket: ticket)
                    self?.view.layoutIfNeeded()
                }, completion: { (completed) in
                    self?.stopScanning = false
                })
            }
        }
    }

    func showScannedUser(feedback: ScanFeedback?, ticket: RedeemableTicket?) {
        var feedFound = feedback
        if ticket?.eventName != self.event?.name {
            feedFound = .wrongEvent
        }
        
        self.scannedUserView.redeemableTicket = ticket
        self.scannedUserView.scanFeedback = feedFound
        self.scannerViewModel?.redeemedTicket = ticket
        self.blurView?.layer.opacity = 0.0
        self.scannerModeView.layer.opacity = 1.0
        self.scannedUserBottomAnchor?.constant = -100.0
        self.manualCheckingTopAnchor?.constant = UIScreen.main.bounds.height + 250.0
        self.generator.notificationOccurred(.success)
    }
    
}
