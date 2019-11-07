

import UIKit
import PanModal
import CoreData
import Big_Neon_UI
import Big_Neon_Core
import TransitionButton
import AVFoundation

extension GuestViewController {
    
    @objc func handleCheckin() {
        NetworkManager.shared.startNetworkReachabilityObserver { (isReachable) in
            if isReachable == true {
                self.handleCompleteOnlineCheckin()
            } else {
                self.saveScannedOfflineTickets()
            }
        }
    }
    
    /*
     Complete Online Checkin
     */
    func handleCompleteOnlineCheckin() {
    
        guard let ticketID = self.guestData?.id, let eventID = self.event?.id else {
            return
        }
        
        let fromGuestListVC = guestListVC == nil ? false : true
        
        self.completeCheckinButton.startAnimation()
        self.checkinViewModel.automaticallyCheckin(ticketID: ticketID, eventID: eventID) { [weak self] (scanFeedback, errorString, ticket) in
            DispatchQueue.main.async {
                
                guard let self = self else { return }
                
                //  Stop Animating the Button
                self.completeCheckinButton.stopAnimation(animationStyle: .normal, revertAfterDelay: 0.0) {
                    self.completeCheckinButton.layer.cornerRadius = 6.0
                    
                    //  Update the Redeemed Ticket
                    //  self.guest = ticket
                    self.guest?.status = ticket!.status
                    
                    //  Checking from Guestlist
                    if fromGuestListVC == true {
                        self.reloadGuestList(ticketID: ticketID)
                        self.playSuccessSound(forValidTicket: true)
                        self.generator.notificationOccurred(.success)
                        self.dismissController()
                        return
                    }
                    
                    self.scannerVC?.showScannedUser()
                    self.scannerVC?.showScannedUser(feedback: scanFeedback, ticket: ticket)
                    self.dismissController()
            
                }
            }
        }
    }
    
    /*
     Complete Offline Checkin
    */
    func saveScannedOfflineTickets() {
        
        let fromGuestListVC = guestListVC == nil ? false : true
        guard let ticketID = self.guestData?.id, let eventID = self.event?.id else {
            return
        }
        
        self.updateTicketStatusAndSave(forTicketID: ticketID, eventID: eventID)
        
        
        //  Dismiss View
        self.playSuccessSound(forValidTicket: true)
        self.generator.notificationOccurred(.success)
        
        //  Hide Show Guest Button View
        self.scannerVC?.hideShowGuestButton()
        
        //  Show the Scanned User
        UIView.animate(withDuration: 0.5) {
            
        }
        
        if fromGuestListVC == true {
            self.reloadGuestList(ticketID: ticketID)
        }
        self.dismissController()
        
        UIView.animate(withDuration: 0.5, delay: 0.8, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.scannerVC?.showOfflineScannedUser(feedback: ScanFeedback.valid, ticket: self.guestData)
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    /*
        Update Ticket Status and save
     */
    func updateTicketStatusAndSave(forTicketID ticketID: String, eventID: String) {
        
        do {
            let ticket = try self.eventViewModel.dataStack.fetch(ticketID, inEntityNamed: GUEST_ENTITY_NAME) as! GuestData
            ticket.status = TicketStatus.Redeemed.rawValue
            let ticketDict = convertManagedObjectToDictionary(managedObject: ticket)
            try self.eventViewModel.dataStack.insertOrUpdate(ticketDict, inEntityNamed: GUEST_ENTITY_NAME)
        } catch let err {
            print(err)
        }
        
        let scannedTicketDict = ["event_id": eventID,
                                 "id": ticketID] as [String : AnyObject]
        self.checkinViewModel.saveScannedTicketInCoreDataWith(array: [scannedTicketDict])
    }
    
    /*
     Convert Managed Object Context to Dictionary
    */
    func convertManagedObjectToDictionary(managedObject: NSManagedObject) -> [String : Any] {
        var dict: [String: Any] = [:]
        for attribute in managedObject.entity.attributesByName {
            if let value = managedObject.value(forKey: attribute.key) {
                dict[attribute.key] = value
            }
        }
        return dict
    }
    
    
    /*
     Reload the Cells in the Guest List
     */
    func reloadGuestList(ticketID: String) {
        
        guard let indexPath = guestListIndex else {
            return
        }
        
        if self.guestListVC?.isSearching == true {
            self.guestListVC?.eventViewModel.guestCoreDataSearchResults.first(where: { $0.id == ticketID})?.status = TicketStatus.Redeemed.rawValue
            self.reloadGuestCells(atIndexPath: indexPath)
        } else {
            self.guestListVC?.eventViewModel.guestCoreData.first(where: { $0.id == ticketID})?.status = TicketStatus.Redeemed.rawValue
            self.reloadGuestCells(atIndexPath: indexPath)
        }
    }
    
    func reloadGuestCells(atIndexPath indexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        let guestCell: EventGuestsCell = self.guestListVC?.guestTableView.cellForRow(at: indexPath) as! EventGuestsCell
        guestCell.ticketStateView.stopAnimation(animationStyle: .normal, revertAfterDelay: 0.0) {
            guestCell.ticketStateView.layer.cornerRadius = 3.0
            guestCell.ticketStateView.setTitle("REDEEMED", for: UIControl.State.normal)
            guestCell.ticketStateView.backgroundColor = UIColor.brandBlack
        }

    }
    
}
