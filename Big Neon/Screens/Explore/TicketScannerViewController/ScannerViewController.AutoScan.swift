
import Foundation
import Big_Neon_UI
import Big_Neon_Core
import AVFoundation

extension ScannerViewController {
    
    func reloadGuestCells(atIndexPath indexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        let guestCell: GuestTableViewCell = self.guestListVC?.guestTableView.cellForRow(at: indexPath) as! GuestTableViewCell
        guestCell.ticketStateView.tagLabel.text = "REDEEMED"
        guestCell.ticketStateView.backgroundColor = UIColor.brandBlack
        
        let guestKey = self.guestListVC?.guestSectionTitles[indexPath.section]
        let guestValues = self.guestListVC?.isSearching == true ? self.guestListVC?.guestViewModel.guestSearchResults :  self.guestListVC?.guestsDictionary[guestKey!]
        guestValues![indexPath.row].status = TicketStatus.Redeemed.rawValue
    }
    
    func checkinAutomatically(withTicketID ticketID: String, fromGuestTableView: Bool, atIndexPath indexPath: IndexPath?) {
        self.stopScanning = true
        self.scannerViewModel?.automaticallyCheckin(ticketID: ticketID) { [weak self] (scanFeedback, errorString, ticket) in
            DispatchQueue.main.async {
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
        runCountDownTimer()
        if ticket?.eventName != self.event?.name {
            self.playSuccessSound(forValidTicket: false)
            feedFound = .wrongEvent
        } else {
            self.playSuccessSound(forValidTicket: true)
        }
        
        scannedUserView.redeemableTicket = ticket
        scannedUserView.scanFeedback = feedFound
        scannerViewModel?.redeemedTicket = ticket
        blurView?.layer.opacity = 0.0
        scannerModeView.layer.opacity = 1.0
        scannedUserBottomAnchor?.constant = -90.0
        manualCheckingTopAnchor?.constant = UIScreen.main.bounds.height + 250.0
        generator.notificationOccurred(.success)
        
        
    }
    
    func runCountDownTimer() {
        self.scanSeconds = 10
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        self.scanSeconds -= 1
        if self.scanSeconds == 0 {
            self.timer?.invalidate()
            self.scanSeconds = 10
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
