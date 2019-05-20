

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
            return guestSectionTitles[section]
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
            return self.filteredSearchResults.count
            
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
        
        if self.isSearching == true && !self.filteredSearchResults.isEmpty {
            guestValues = self.filteredSearchResults[indexPath.row]
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
        
        if guestValues!.status == TicketStatus.purchased {
            guestCell.ticketStateView.tagLabel.text = "PURCHASED"
            guestCell.ticketStateView.backgroundColor = UIColor.brandGreen
        } else {
            guestCell.ticketStateView.tagLabel.text = "REDEEMED"
            guestCell.ticketStateView.backgroundColor = UIColor.brandBlack
        }
        
        return guestCell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let guestKey = guestSectionTitles[indexPath.section]
        if let guestValues = guestsDictionary[guestKey] {
            
            if guestValues[indexPath.row].status == TicketStatus.purchased {
                let deleteButton = UITableViewRowAction(style: .default, title: "Checkin") { (action, indexPath) in
                    let ticketID = guestValues[indexPath.row].id
                    self.checkinTicket(ticketID: ticketID, atIndex: indexPath)
                    return
                }
                deleteButton.backgroundColor = UIColor.brandPrimary
                return [deleteButton]
            } else {
                let deleteButton = UITableViewRowAction(style: .default, title: "Already Redeemed") { (action, indexPath) in
                    return
                }
                deleteButton.backgroundColor = UIColor.brandLightGrey
                return [deleteButton]
                
            }
        } else {
            return nil
        }
    }
    
    func checkinTicket(ticketID: String?, atIndex index: IndexPath) {
        if let id = ticketID {
            self.delegate?.checkinAutomatically(withTicketID: id, fromGuestTableView: true, atIndexPath: index)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
