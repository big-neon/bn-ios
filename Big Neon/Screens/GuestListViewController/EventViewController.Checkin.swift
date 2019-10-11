

import Foundation
import UIKit
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
        
        //  If no Internet connection, update offline and upload later.
        
        
        //  if there is an internet connection
        self.scannerViewModel.automaticallyCheckin(ticketID: ticketID, eventID: nil) { [weak self] (scanFeedback, errorString, ticket) in
            DispatchQueue.main.async {
                if self?.isSearching == true {
                    self?.eventViewModel.guestCoreDataSearchResults.first(where: { $0.id == ticketID})?.status = TicketStatus.Redeemed.rawValue
                    self?.reloadGuestCells(atIndexPath: indexPath)
                } else {
                    self?.eventViewModel.guestCoreData.first(where: { $0.id == ticketID})?.status = TicketStatus.Redeemed.rawValue
                    self?.reloadGuestCells(atIndexPath: indexPath)
                }
            }
        }
    }
    
    func addScannedOfflineTickets() {
//        let ticket = GuestData(entity: <#T##NSEntityDescription#>, insertInto: <#T##NSManagedObjectContext?#>)
    }
    
}
