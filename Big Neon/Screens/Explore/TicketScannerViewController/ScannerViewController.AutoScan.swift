
import Foundation
import Big_Neon_UI
import Big_Neon_Core
import AVFoundation

extension ScannerViewController {
    
    func checkinAutomatically(withTicketID ticketID: String, fromGuestTableView: Bool, atIndexPath: IndexPath?) {
        
        if fromGuestTableView == true {
            self.reloadGuests(atIndex: atIndexPath!)
            self.generator.notificationOccurred(.success)
            return
        }
        
        self.scannerViewModel?.automaticallyCheckin(ticketID: ticketID) { (scanFeedback, errorString, ticket) in
            print(errorString)
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
                self.showScannedUser(feedback: scanFeedback, ticket: ticket)
                self.view.layoutIfNeeded()
            }, completion: { (completed) in
                self.stopScanning = false
            })
        }
    }
    
    func showScannedUser(feedback: ScanFeedback?, ticket: RedeemableTicket?) {
        self.scannedUserView.redeemableTicket = ticket
        self.scannedUserView.scanFeedback = feedback
        self.blurView?.layer.opacity = 0.0
        self.scannerModeView.layer.opacity = 1.0
        self.scannedUserBottomAnchor?.constant = -100.0
        self.manualCheckingTopAnchor?.constant = UIScreen.main.bounds.height + 250.0
        self.generator.notificationOccurred(.success)
    }
    
}
