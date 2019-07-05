

import Foundation
import UIKit
import SwipeCellKit
import Big_Neon_Core
import AudioToolbox

extension GuestListViewController: SwipeActionTransitioning {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard self.isSearching else {
            return guestSectionTitles.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard self.isSearching else {
            return guestSectionTitles[section].uppercased()
        }
        return nil
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        guard self.isSearching else {
            return guestSectionTitles
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.isSearching == true {
            return self.guestViewModel.guestSearchResults.count
        }
        
        let guestKey = guestSectionTitles[section]
        if let guestValues = guestsDictionary[guestKey] {
            return guestValues.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let guestCell: GuestTableViewCell = tableView.dequeueReusableCell(withIdentifier: GuestTableViewCell.cellID, for: indexPath) as! GuestTableViewCell
        guestCell.delegate = self
        
        var guestValues: RedeemableTicket?
        
        if self.isSearching == true && !self.guestViewModel.guestSearchResults.isEmpty {
            guestValues = self.guestViewModel.guestSearchResults[indexPath.row]
        } else {
            let guestKey = guestSectionTitles[indexPath.section]
            guestValues = guestsDictionary[guestKey]![indexPath.row]
        }
        
        if guestValues == nil {
            return guestCell
        }
        
        if guestValues!.lastName == "" && guestValues!.firstName  == ""{
            guestCell.guestNameLabel.text = "No Details Provided"
        } else {
            guestCell.guestNameLabel.text = guestValues!.firstName + ", " + guestValues!.lastName
        }
        
        
        let price = Int(guestValues!.priceInCents)
        let ticketID = "#" + guestValues!.id.suffix(8).uppercased()
        guestCell.ticketTypeNameLabel.text = price.dollarString + " | " + guestValues!.ticketType + " | " + ticketID
        
        if guestValues!.status == TicketStatus.purchased.rawValue {
            guestCell.ticketStateView.tagLabel.text = "PURCHASED"
            guestCell.ticketStateView.backgroundColor = UIColor.brandGreen
        } else {
            guestCell.ticketStateView.tagLabel.text = "REDEEMED"
            guestCell.ticketStateView.backgroundColor = UIColor.brandBlack
        }
        
        return guestCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        let guestKey = guestSectionTitles[indexPath.section]
        let guestValues = self.isSearching == true ? self.guestViewModel.guestSearchResults :  guestsDictionary[guestKey]
        return [swipeCellAction(forGuestValues: guestValues!, indexPath)]
    }
    
    func swipeCellAction(forGuestValues guestValues: [RedeemableTicket],_ indexPath: IndexPath) -> SwipeAction {
        let action = guestValues[indexPath.row].status == TicketStatus.purchased.rawValue ? checkAction(atIndexPath: indexPath, guestValues: guestValues) : redeemAction()
        return action
    }
    
    func checkAction(atIndexPath indexPath: IndexPath, guestValues: [RedeemableTicket]) -> SwipeAction {
        
        let checkinAction = SwipeAction(style: .default, title: "Checkin") { action, indexPath in
            let ticketID = guestValues[indexPath.row].id
            self.checkinTicket(ticketID: ticketID, atIndex: indexPath, direction: true)
        }
        checkinAction.highlightedBackgroundColor = UIColor.brandPrimary
        checkinAction.transitionDelegate = self
        checkinAction.title = "Checkin"
        checkinAction.image = #imageLiteral(resourceName: "ic_checkin_check")
        checkinAction.hidesWhenSelected = true
        checkinAction.font = .systemFont(ofSize: 13)
        checkinAction.backgroundColor = UIColor.brandPrimary
        return checkinAction
    }
    
    func didTransition(with context: SwipeActionTransitioningContext) {
        if context.newPercentVisible > 1.19 {   //  2.66
            context.button.setImage(UIImage(named: "ic_checkin_check"), for: UIControl.State.normal)
            context.button.setTitle("Redeemed", for: UIControl.State.normal)
        } else if context.newPercentVisible > 0.8 { //2.2
            context.button.setImage(UIImage(named: "ic_checkin_check"), for: UIControl.State.normal)
            context.button.setTitle("Checking In...", for: UIControl.State.normal)
        } else  {
            context.button.setImage(UIImage(named: "ic_checkin_check"), for: UIControl.State.normal)
            context.button.setTitle("Checkin", for: UIControl.State.normal)
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
        
        let guestKey = guestSectionTitles[indexPath.section]
        let guestValues = self.isSearching == true ? self.guestViewModel.guestSearchResults :  guestsDictionary[guestKey]
        if guestValues![indexPath.row].status == TicketStatus.purchased.rawValue {
            var options = SwipeOptions()
            options.backgroundColor = UIColor.brandPrimary
            options.transitionStyle = .border
            options.minimumButtonWidth = UIScreen.main.bounds.width * 0.4
            options.expansionStyle = .selection
            return options
        }
        var options = SwipeOptions()
        options.transitionStyle = .drag
        options.expansionStyle = .none
        return options
    }
    
    func checkinTicket(ticketID: String?, atIndex index: IndexPath, direction: Bool) {
        if let id = ticketID {
            self.delegate?.checkinAutomatically(withTicketID: id, fromGuestTableView: true, atIndexPath: index)
        }
    }
    
    //  Prefetching Rows in TableView
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let guests = guestViewModel.currentTotalGuests
        let needsFetch = indexPaths.contains { $0.row >= guests - 15 }
        if needsFetch {
            fetchNextPage(withIndexPaths: indexPaths)
        }
    }
    
    func fetchNextPage(withIndexPaths indexPaths: [IndexPath]) {
        guard !isFetchingNextPage else {
            return
        }
        if let id = self.guestViewModel.eventID {
            self.isFetchingNextPage = true
            self.guestViewModel.fetchGuests(forEventID: id, page: guestViewModel.currentPage, completion: { [unowned self] (_) in
                DispatchQueue.main.async {
                    self.isFetchingNextPage = false
                    self.guests = self.guestViewModel.ticketsFetched
                    self.guestTableView.reloadData()
                    return
                }
            })
        }
    }
    
}
