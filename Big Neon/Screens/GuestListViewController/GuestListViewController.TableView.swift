

import Foundation
import UIKit
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
            guestCell.guestNameLabel.text = guestValues!.firstName + " " + guestValues!.lastName
        }
        
        
        let price = Int(guestValues!.priceInCents)
        let ticketID = "#" + guestValues!.id.suffix(8).uppercased()
        guestCell.ticketTypeNameLabel.text = price.dollarString + " | " + guestValues!.ticketType + " | " + ticketID
        
        if guestValues!.status == TicketStatus.purchased.rawValue {
            guestCell.ticketStateView.backgroundColor = DateConfig.eventDateIsToday(eventStartDate: guestValues!.eventStart) == true ? UIColor.brandGreen : UIColor.white
            let buttonValue = DateConfig.eventDateIsToday(eventStartDate: guestValues!.eventStart) == true ? "PURCHASED" : "-"
            guestCell.ticketStateView.setTitle(buttonValue, for: UIControl.State.normal)
        } else {
            guestCell.ticketStateView.backgroundColor = DateConfig.eventDateIsToday(eventStartDate: guestValues!.eventStart) == true ? UIColor.brandBlack : UIColor.white
            let buttonValue = DateConfig.eventDateIsToday(eventStartDate: guestValues!.eventStart) == true ? "REDEEMED" : "-"
            guestCell.ticketStateView.setTitle(buttonValue, for: UIControl.State.normal)
        }
        
        return guestCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var ticket: RedeemableTicket?
        if self.isSearching == true && !self.guestViewModel.guestSearchResults.isEmpty {
            ticket = self.guestViewModel.guestSearchResults[indexPath.row]
        } else {
            let guestKey = guestSectionTitles[indexPath.section]
            ticket = guestsDictionary[guestKey]![indexPath.row]
        }
        self.showGuest(withTicket: ticket, selectedIndex: indexPath)
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
        
        let ticket = guestValues[indexPath.row]
        
        if DateConfig.eventDateIsToday(eventStartDate: ticket.eventStart) == false {
            let checkinAction = SwipeAction(style: .default, title: "") { action, indexPath in
                //  No Action
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
        
        let guestKey = guestSectionTitles[indexPath.section]
        let guestValues = self.isSearching == true ? self.guestViewModel.guestSearchResults :  guestsDictionary[guestKey]
        let ticket = guestValues![indexPath.row]
       
        if DateConfig.eventDateIsToday(eventStartDate: ticket.eventStart) == false {
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
            let guestCell: GuestTableViewCell = self.guestTableView.cellForRow(at: index) as! GuestTableViewCell
            guestCell.ticketStateView.startAnimation()
            self.delegate?.checkinAutomatically(withTicketID: id, fromGuestTableView: true, atIndexPath: index)
        }
    }
    
    //  Prefetching Rows in TableView
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if let lastSection = indexPaths.last?.section, let lastRow = indexPaths.last?.row, let totalGuests = self.guestViewModel.totalGuests {
           
            //  No neeed to fetch more. Guests are less than 100
            if totalGuests <= 100 {
                return
            }
            
            //  Last Section and Last Row - Fetch more guests
            if lastSection >= guestSectionTitles.count - 1 && lastRow >= self.guestViewModel.currentTotalGuests - 20 {
                fetchNextPage(withIndexPaths: indexPaths)
                return
            }
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
