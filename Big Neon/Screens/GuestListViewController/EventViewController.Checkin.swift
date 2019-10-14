

import Foundation
import UIKit
import CoreData
import Big_Neon_Core

extension EventViewController {
 
    //  Reloading Guests Cells
    func reloadGuestCells(atIndexPath indexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        let guestCell: EventGuestsCell = self.guestTableView.cellForRow(at: indexPath) as! EventGuestsCell
        guestCell.ticketStateView.stopAnimation(animationStyle: .normal, revertAfterDelay: 0.0) {
            guestCell.ticketStateView.layer.cornerRadius = 3.0
            guestCell.ticketStateView.setTitle("REDEEMED", for: UIControl.State.normal)
            guestCell.ticketStateView.backgroundColor = UIColor.brandBlack
        }
        
        let guestValues = self.isSearching == true ? self.eventViewModel.guestCoreDataSearchResults : self.eventViewModel.guestCoreData
        guestValues[indexPath.row].status = TicketStatus.Redeemed.rawValue
    }
    
    //  Checkin Guest
    func checkinAutomatically(withTicketID ticketID: String, fromGuestTableView: Bool, atIndexPath indexPath: IndexPath?) {
        
        self.checkinViewModel.automaticallyCheckin(ticketID: ticketID, eventID: nil) { [weak self] (scanFeedback, errorString, ticket) in
            DispatchQueue.main.async {
                self?.updateGuestCell(ticketID: ticketID, atIndexPath: indexPath)
            }
        }
    }
    
    func saveScannedOfflineTickets(ticket: GuestData?, ticketID: String, atIndexPath indexPath: IndexPath?) {
        
        
        guard let ticket = ticket, let id = ticket.id else {
            self.updateGuestCell(ticketID: ticketID, atIndexPath: indexPath)
            return
        }
        
        self.updateTicketStatusAndSave(forTicketID: id)
        self.updateGuestCell(ticketID: ticketID, atIndexPath: indexPath)
    }
    
    /*
     - Update thhe scanned ticket locally and update the TableView
     - Save the Scanned Ticket Redeemed Tickets where it will be uploaded later
     */
    func updateTicketStatusAndSave(forTicketID ticketID: String) {
        
        do {
            let ticket = try self.eventViewModel.dataStack.fetch(ticketID, inEntityNamed: GUEST_ENTITY_NAME) as! GuestData
            ticket.status = TicketStatus.Redeemed.rawValue
            let ticketDict = convertManagedObjectToDictionary(managedObject: ticket)
            try self.eventViewModel.dataStack.insertOrUpdate(ticketDict, inEntityNamed: GUEST_ENTITY_NAME)
            
            //  Save Ticket to Redeemed Tickets
            try self.eventViewModel.dataStack.insertOrUpdate(ticketDict, inEntityNamed: SCANNED_GUEST_ENTITY_NAME)
        } catch let err {
            print(err)
        }
        
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
    
    func updateGuestCell(ticketID: String, atIndexPath indexPath: IndexPath?) {
        if self.isSearching == true {
            self.eventViewModel.guestCoreDataSearchResults.first(where: { $0.id == ticketID})?.status = TicketStatus.Redeemed.rawValue
            self.reloadGuestCells(atIndexPath: indexPath)
        } else {
            self.eventViewModel.guestCoreData.first(where: { $0.id == ticketID})?.status = TicketStatus.Redeemed.rawValue
            self.reloadGuestCells(atIndexPath: indexPath)
        }
    }
}
