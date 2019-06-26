

import Foundation
import UIKit
import Big_Neon_Core

extension GuestListViewController {
    
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
            guestCell.guestNameLabel.text = guestValues!.lastName + ", " + guestValues!.firstName
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

//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//    }
//
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//
//        let guestKey = guestSectionTitles[indexPath.section]
//        var guestValues: [RedeemableTicket]?
//        if self.isSearching == true {
//            guestValues = self.guestViewModel.guestSearchResults
//        } else {
//            guestValues = guestsDictionary[guestKey]
//        }
//
//        if guestValues![indexPath.row].status == TicketStatus.purchased.rawValue {
//            let checkinAction = UITableViewRowAction(style: .default, title: "Checkin") { (action, indexPath) in
//                let ticketID = guestValues![indexPath.row].id
//                print(guestValues![indexPath.row].id)
//
//                //  self.checkinTicket(ticketID: ticketID, atIndex: indexPath, direction: false)
//            }
//
//            checkinAction.backgroundColor = UIColor.brandPrimary
//            return [checkinAction]
//        } else {
//            let alreadyRedeemedAction = UITableViewRowAction(style: .default, title: "Already Redeemed") { (action, indexPath) in
//                print("Already Redeemed")
//            }
//            alreadyRedeemedAction.backgroundColor = UIColor.brandLightGrey
//            return [alreadyRedeemedAction]
//        }
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let guestKey = guestSectionTitles[indexPath.section]
        var guestValues: [RedeemableTicket]?
        if self.isSearching == true {
            guestValues = self.guestViewModel.guestSearchResults
        } else {
            guestValues = guestsDictionary[guestKey]
        }
        
        if guestValues![indexPath.row].status == TicketStatus.purchased.rawValue {
            let checkinAction = UIContextualAction(style: .destructive, title: "Checkin") { (action, view, handler) in
                let ticketID = guestValues![indexPath.row].id
                self.checkinTicket(ticketID: ticketID, atIndex: indexPath, direction: true)
            }
            checkinAction.backgroundColor = .brandPrimary
            let configuration = UISwipeActionsConfiguration(actions: [checkinAction])
            configuration.performsFirstActionWithFullSwipe = true
            return configuration
        } else {
            let alreadyRedeemedAction = UIContextualAction(style: .destructive, title: "Already Redeemed") { (action, view, handler) in
                print("Already Redeemed")
            }
            alreadyRedeemedAction.backgroundColor = .brandLightGrey
            let configuration = UISwipeActionsConfiguration(actions: [alreadyRedeemedAction])
            configuration.performsFirstActionWithFullSwipe = false
            return configuration
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let guestKey = guestSectionTitles[indexPath.section]
        var guestValues: [RedeemableTicket]?
        if self.isSearching == true {
            guestValues = self.guestViewModel.guestSearchResults
        } else {
            guestValues = guestsDictionary[guestKey]
        }
        
//        if guestValues![indexPath.row].status == TicketStatus.purchased.rawValue {
//            let checkinAction = UIContextualAction(style: .destructive, title: "Checkin") { (action, view, handler) in
//                let ticketID = guestValues![indexPath.row].id
//                self.checkinTicket(ticketID: ticketID, atIndex: indexPath, direction: true)
//            }
//            checkinAction.backgroundColor = .brandPrimary
//            let configuration = UISwipeActionsConfiguration(actions: [checkinAction])
//            configuration.performsFirstActionWithFullSwipe = true
//            return configuration
            
//            let checkin = checkinAction(atIndexPath: indexPath, guestValues: guestValues!)
//            let configuration = UISwipeActionsConfiguration(actions: [checkin])
//            return configuration
//        } else {
//            let configuration = UISwipeActionsConfiguration(actions: [alreadyRedeemedAction()])
//            configuration.performsFirstActionWithFullSwipe = false
//            return configuration
//        }
        
        let action = guestValues![indexPath.row].status == TicketStatus.purchased.rawValue ? checkinAction(atIndexPath: indexPath, guestValues: guestValues!) : alreadyRedeemedAction()
        let configuration = UISwipeActionsConfiguration(actions: [action])
        configuration.performsFirstActionWithFullSwipe = guestValues![indexPath.row].status == TicketStatus.purchased.rawValue ? true : false
        return configuration
        
    }
    
    func checkinAction(atIndexPath indexPath: IndexPath, guestValues: [RedeemableTicket]) -> UIContextualAction {
        
        let checkinAction = UIContextualAction(style: .destructive, title: "Checkin") { (action, view, handler) in
            let ticketID = guestValues[indexPath.row].id
            self.checkinTicket(ticketID: ticketID, atIndex: indexPath, direction: true)
        }
        checkinAction.backgroundColor = .brandPrimary
        return checkinAction
    }
    
    func alreadyRedeemedAction() -> UIContextualAction {
        let alreadyRedeemedAction = UIContextualAction(style: .destructive, title: "Already Redeemed") { (action, view, handler) in
            print("Already Redeemed")
        }
        alreadyRedeemedAction.backgroundColor = .brandLightGrey
        return alreadyRedeemedAction
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
