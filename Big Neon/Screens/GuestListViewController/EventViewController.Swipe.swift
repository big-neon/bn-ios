

import Foundation
import UIKit
import Big_Neon_Core

extension EventViewController: SwipeActionTransitioning {

    func didTransition(with context: SwipeActionTransitioningContext) {
        
        if context.newPercentVisible > 0.8 {
            context.button.setImage(UIImage(named: "ic_checkin_check"), for: UIControl.State.normal)
            context.button.setTitle("Redeem", for: UIControl.State.normal)
        } else  {
            context.button.setImage(UIImage(named: "ic_checkin_check"), for: UIControl.State.normal)
            context.button.setTitle("Redeem", for: UIControl.State.normal)
        }
    }
    
    func redeemAction() -> SwipeAction {
        let redeemAction = SwipeAction(style: .destructive, title: "Redeemed") { action, indexPath in
            print("Already Redeemed")
        }
        redeemAction.backgroundColor = UIColor.brandLightGrey
        return redeemAction
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        let guestValues = self.isSearching == true ? self.eventViewModel.guestCoreDataSearchResults : self.eventViewModel.guestCoreData
        let ticket = guestValues[indexPath.row]
       
        if DateConfig.eventDateIsToday(eventStartDate: ticket.event_start!) == false {
            var options = SwipeOptions()
            options.transitionStyle = .drag
            options.expansionStyle = .none
            return options
        }
        
        if ticket.status == TicketStatus.purchased.rawValue {
            var options = SwipeOptions()
            options.backgroundColor = UIColor.brandPrimary
            options.transitionStyle = .reveal
            options.expansionStyle = .fillReset(timing: .after)
            return options
        }
        
        var options = SwipeOptions()
        options.transitionStyle = .drag
        options.expansionStyle = .none
        return options
    }
    
    func checkinTicket(ticketID: String?, atIndex index: IndexPath, direction: Bool) {
        var ticket: GuestData?
        if self.isSearching == true && !self.eventViewModel.guestCoreDataSearchResults.isEmpty {
            ticket = self.eventViewModel.guestCoreDataSearchResults[index.row]
        } else {
            ticket = self.eventViewModel.guestCoreData[index.row]
        }
        
        
        if let id = ticketID {
            let guestCell: EventGuestsCell = self.guestTableView.cellForRow(at: index) as! EventGuestsCell
            guestCell.ticketStateView.startAnimation()
            NetworkManager.shared.startNetworkReachabilityObserver { (isReachable) in
                if isReachable == true {
                    self.checkinAutomatically(withTicketID: id, fromGuestTableView: true, atIndexPath: index)
                } else {
                    self.saveScannedOfflineTickets(ticket: ticket, ticketID: id, atIndexPath: index)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        let guestValues = self.isSearching == true ? self.eventViewModel.guestCoreDataSearchResults : self.eventViewModel.guestCoreData
        return [swipeCellAction(forGuestValues: guestValues, indexPath)]
    }
    
    func swipeCellAction(forGuestValues guestValues: [GuestData],_ indexPath: IndexPath) -> SwipeAction {
        let action = guestValues[indexPath.row].status == TicketStatus.purchased.rawValue ? checkAction(atIndexPath: indexPath, guestValues: guestValues) : redeemAction()
        return action
    }
    
    func checkAction(atIndexPath indexPath: IndexPath, guestValues: [GuestData]) -> SwipeAction {
        
        let ticket = guestValues[indexPath.row]
        
        if DateConfig.eventDateIsToday(eventStartDate: ticket.event_start!) == false {
            let checkinAction = SwipeAction(style: .default, title: "") { action, indexPath in
                //  No Action - Not the date of the event
            }
            
            checkinAction.fulfill(with: ExpansionFulfillmentStyle.reset)
            checkinAction.highlightedBackgroundColor = UIColor.white
            checkinAction.title = "Not Event Date"
            checkinAction.hidesWhenSelected = false
            checkinAction.font = .systemFont(ofSize: 15)
            checkinAction.backgroundColor = UIColor.brandBlack
            return checkinAction
        }
        
        let checkinAction = SwipeAction(style: .default, title: "Checkin") { action, indexPath in
            let ticketID = ticket.id
            self.checkinTicket(ticketID: ticketID, atIndex: indexPath, direction: true)
        }
    
        checkinAction.fulfill(with: ExpansionFulfillmentStyle.reset)
        checkinAction.highlightedBackgroundColor = UIColor.brandPrimary
        checkinAction.transitionDelegate = self
        checkinAction.title = "Redeem"
        checkinAction.image = #imageLiteral(resourceName: "ic_checkin_check")
        checkinAction.hidesWhenSelected = false
        checkinAction.font = .systemFont(ofSize: 13)
        checkinAction.backgroundColor = UIColor.brandPrimary
        return checkinAction
    }
    
}
