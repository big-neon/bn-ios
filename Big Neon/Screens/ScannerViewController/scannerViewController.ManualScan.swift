
import Foundation
import Big_Neon_UI
import Big_Neon_Core
import AVFoundation

extension ScannerViewController {
    
    func checkinManually(withTicketID ticketID: String) {
        self.scannerViewModel.getRedeemTicket(ticketID: ticketID) { [weak self] (scanFeedback, errorString) in
            DispatchQueue.main.async {
                switch scanFeedback {
                case .validTicketID?:
                    self?.stopScanning = false
                    if let ticket = self?.scannedTicket {
                        self?.showOnlineGuest(withTicket: ticket, scannerVC: self, selectedIndex: nil)
                    }
                case .wrongEvent?:
                    self?.checkinAutomatically(withTicketID: ticketID, fromGuestTableView: false, atIndexPath: nil)
                default:
                    print("Ticket Not Found")
                    // To be modified to handle different types of errors
                    //  self?.manualCheckinFeedback(scanFeedback: scanFeedback) 
                }
            }
        }
    }
    
    func manualCheckinFeedback(scanFeedback: ScanFeedback?) {
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.scanningBoarderView.layer.opacity = 0.0
            self.showGuestView.layer.opacity = 0.0
            self.scannerModeView.layer.opacity = 0.0
            self.view.layoutIfNeeded()
        }, completion: { (completed) in
            self.stopScanning = true
        })
    }
    
    @objc func showRedeemedTicket() {
        
        guard let ticket = self.scannerViewModel.redeemedTicket else {
            return
        }
        self.stopScanning = true
        self.scannedTicketID = ticket.id
    }
    
    func showOfflineGuest(withTicket ticket: GuestData?, scannerVC: ScannerViewController?, selectedIndex: IndexPath?) {
        let guestVC = GuestViewController()
        guestVC.event = self.eventViewModel.eventData
        guestVC.event = self.event
        guestVC.guestData = ticket
        guestVC.guestListIndex = selectedIndex
        self.presentPanModal(guestVC)
    }
    
    func showOnlineGuest(withTicket ticket: RedeemableTicket?, scannerVC: ScannerViewController?, selectedIndex: IndexPath?) {
       
        let guestVC = GuestViewController()
        guestVC.event = self.event
        guestVC.guest = ticket
        guestVC.delegate = self
        guestVC.scannerVC = self
        guestVC.guestListIndex = selectedIndex
        self.presentPanModal(guestVC)
    }
}
