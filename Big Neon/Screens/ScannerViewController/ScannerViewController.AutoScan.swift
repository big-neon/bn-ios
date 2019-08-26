
import Foundation
import Big_Neon_UI
import Big_Neon_Core
import AVFoundation

extension ScannerViewController {
    
    func reloadGuestCells(atIndexPath indexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        let guestCell: GuestTableViewCell = self.guestListVC?.guestTableView.cellForRow(at: indexPath) as! GuestTableViewCell
        guestCell.ticketStateView.stopAnimation(animationStyle: .normal, revertAfterDelay: 0.0) {
            guestCell.ticketStateView.layer.cornerRadius = 3.0
            guestCell.ticketStateView.setTitle("REDEEMED", for: UIControl.State.normal)
            guestCell.ticketStateView.backgroundColor = UIColor.brandBlack
        }
        
        let guestKey = self.guestListVC?.guestSectionTitles[indexPath.section]
        let guestValues = self.guestListVC?.isSearching == true ? self.guestListVC?.guestViewModel.guestSearchResults :  self.guestListVC?.guestsDictionary[guestKey!]
        guestValues![indexPath.row].status = TicketStatus.Redeemed.rawValue
    }
    
    func checkinAutomatically(withTicketID ticketID: String, fromGuestTableView: Bool, atIndexPath indexPath: IndexPath?) {
        self.stopScanning = true
        
        self.scannerViewModel?.automaticallyCheckin(ticketID: ticketID) { [weak self] (scanFeedback, errorString, ticket) in
            DispatchQueue.main.async {
                
                //  Checking from Guestlist
                if fromGuestTableView == true {
                    if self?.guestListVC?.isSearching == true {
                        self?.guestListVC?.guestViewModel.guestSearchResults.first(where: { $0.id == ticketID})?.status = TicketStatus.Redeemed.rawValue
                        self?.reloadGuestCells(atIndexPath: indexPath)
                    } else {
                        self?.guestListVC?.guestViewModel.ticketsFetched.first(where: { $0.id == ticketID})?.status = TicketStatus.Redeemed.rawValue
                        self?.reloadGuestCells(atIndexPath: indexPath)
                    }
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
            self.playSuccessSound(forValidTicket: false)
            self.scannedTicketID = ticket?.id
            feedFound = .wrongEvent
            scannedUserView.userNameLabel.text = ticket?.eventName
            scannedUserView.ticketTypeLabel.text = "-"
        } else {
            playSuccessSound(forValidTicket: true)
            scannerViewModel?.redeemedTicket = ticket
            scannedUserView.redeemableTicket = ticket
        }
        
        
        scannedUserView.scanFeedback = feedFound
        blurView?.layer.opacity = 0.0
        scannerModeView.layer.opacity = 1.0
        scannedUserBottomAnchor?.constant = -90.0
        manualCheckingTopAnchor?.constant = UIScreen.main.bounds.height + 250.0
        generator.notificationOccurred(.success)
        
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
