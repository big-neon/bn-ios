
import Foundation
import Big_Neon_UI
import Big_Neon_Core
import AVFoundation

extension ScannerViewController {
    
    func reloadGuestCells(atIndexPath indexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        let guestCell: EventGuestsCell = self.guestListVC?.guestTableView.cellForRow(at: indexPath) as! EventGuestsCell
        guestCell.ticketStateView.stopAnimation(animationStyle: .normal, revertAfterDelay: 0.0) {
            guestCell.ticketStateView.layer.cornerRadius = 3.0
            guestCell.ticketStateView.setTitle("REDEEMED", for: UIControl.State.normal)
            guestCell.ticketStateView.backgroundColor = UIColor.brandBlack
        }
        
        let guestValues = self.guestListVC?.isSearching == true ? self.guestListVC?.eventViewModel.guestCoreDataSearchResults : self.guestListVC?.eventViewModel.guestCoreData
        guestValues![indexPath.row].status = TicketStatus.Redeemed.rawValue
    }
    
    func checkinAutomatically(withTicketID ticketID: String, fromGuestTableView: Bool, atIndexPath indexPath: IndexPath?) {
        self.stopScanning = true
        self.scannerViewModel.automaticallyCheckin(ticketID: ticketID, eventID: nil) { [weak self] (scanFeedback, errorString, ticket) in
            DispatchQueue.main.async {
                
                //  Checking from Guestlist
                if fromGuestTableView == true {
                    if self?.guestListVC?.isSearching == true {
                        self?.guestListVC?.eventViewModel.guestCoreDataSearchResults.first(where: { $0.id == ticketID})?.status = TicketStatus.Redeemed.rawValue
                        self?.reloadGuestCells(atIndexPath: indexPath)
                    } else {
                        self?.guestListVC?.eventViewModel.guestCoreData.first(where: { $0.id == ticketID})?.status = TicketStatus.Redeemed.rawValue
                        self?.reloadGuestCells(atIndexPath: indexPath)
                    }
                    self?.generator.notificationOccurred(.success)
                    return
                }
            
//                if let feedback = scanFeedback {
//                    if feedback == .alreadyRedeemed {
//                        print(feedback)
//                        if let ticket = ticket {
//                            self?.showScannedUser(feedback: .alreadyRedeemed, ticket: ticket)
//                        }
//                    }
//                    return
//                }
                
                self?.showScannedUser(feedback: scanFeedback, ticket: ticket)
                self?.stopScanning = false
//                UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
//                    self?.showScannedUser(feedback: scanFeedback, ticket: ticket)
//                    self?.view.layoutIfNeeded()
//                }, completion: { (completed) in
//                    self?.stopScanning = false
//                })
            }
        }
    }
    
    func showScannedUser(feedback: ScanFeedback?, ticket: RedeemableTicket?) {
        
        var feedFound = feedback
        scannedUserView.isFetchingData = false
    
        if ticket?.eventName != self.event?.name {
            self.playSuccessSound(forValidTicket: false)
            self.scannedTicketID = ticket?.id
            feedFound = .wrongEvent
            scannedUserView.userNameLabel.text = ticket?.eventName
            scannedUserView.ticketTypeLabel.text = "-"
        } else {
            playSuccessSound(forValidTicket: true)
            scannerViewModel.redeemedTicket = ticket
            scannedUserView.redeemableTicket = ticket
            scannedUserView.scanFeedback = feedFound
        }
        
        scannedUserView.scanFeedback = feedFound
        self.displayedScannedUser = true
        scannerModeView.layer.opacity = 1.0
        
//        scannedUserBottomAnchor?.constant = -90.0
        manualCheckingTopAnchor?.constant = UIScreen.main.bounds.height + 250.0
//        generator.notificationOccurred(.success)
        
    }
    
    
    func showOfflineScannedUser(feedback: ScanFeedback?, ticket: GuestData?) {
            
        var feedFound = feedback
        scannedUserView.isFetchingData = false
    
        if ticket?.event_name != self.event?.name {
            self.playSuccessSound(forValidTicket: false)
            self.scannedTicketID = ticket?.id
            scannedUserView.userNameLabel.text = ticket?.event_name
            scannedUserView.ticketTypeLabel.text = "-"
            self.displayedScannedUser = true
            scannedUserView.scanFeedback = .wrongEvent
            scannerModeView.layer.opacity = 1.0
            scannedUserBottomAnchor?.constant = -90.0
            manualCheckingTopAnchor?.constant = UIScreen.main.bounds.height + 250.0
        } else {
            playSuccessSound(forValidTicket: true)
            scannedUserView.scanFeedback = ScanFeedback(rawValue: (ticket?.status!)!)
            if let status = ticket?.status {
                if status == "Redeemed" {
                    scannedUserView.scanFeedback = .alreadyRedeemed
                }
            }
            scannedUserView.guestData = ticket
            self.displayedScannedUser = true
            scannerModeView.layer.opacity = 1.0
            scannedUserBottomAnchor?.constant = -90.0
            manualCheckingTopAnchor?.constant = UIScreen.main.bounds.height + 250.0
        }
        
    }
    
    func playSuccessSound(forValidTicket valid: Bool) {
        let sound = valid == true ? "Valid" : "Redeemed"
        if let resourcePath =  Bundle.main.path(forResource: sound, ofType: "m4a") {
            let url = URL(fileURLWithPath: resourcePath)
            audioPlayer = try? AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        }
    }
    
}
