

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
                //  Do Offline Checking
                self.saveScannedOfflineTickets()
            }
        }
    }
    
    /*
     Complete Online Checkin
     */
    func handleCompleteOnlineCheckin() {
    
        
//        guard let ticketID = self.guestData?.id, let eventID = self.event?.id else {
//            return
//        }
        
        guard let ticketID = self.guest?.id, let eventID = self.event?.id else {
            return
        }
        
        print(ticketID)
        print(eventID)
        
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
                    
                    self.dismissController()
                    self.scannerVC?.showScannedUser(feedback: scanFeedback, ticket: ticket)
                    
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
            //  self.updateGuestCell(ticketID: ticketID, atIndexPath: indexPath)
            return
        }
        
        self.updateTicketStatusAndSave(forTicketID: ticketID, eventID: eventID)
        
        
        //  Dismiss View
        self.playSuccessSound(forValidTicket: true)
        self.generator.notificationOccurred(.success)
        self.dismissController()
        
        if fromGuestListVC == true {
            self.reloadGuestList(ticketID: ticketID)
            return
        }
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
