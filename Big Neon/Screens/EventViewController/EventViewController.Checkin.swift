

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
        
        if let id = ticketID {
            let guestCell: EventGuestsCell = self.guestTableView.cellForRow(at: index) as! EventGuestsCell
            guestCell.ticketStateView.startAnimation()
            self.checkinAutomatically(withTicketID: id, fromGuestTableView: true, atIndexPath: index)
        }
    }
    
    
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
