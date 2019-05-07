

import Foundation
import UIKit

extension GuestListView {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        guard self.isSearching else {
            return guestSectionTitles.count
        }
        return 1
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard self.isSearching else {
            return guestSectionTitles[section]
        }
        return nil
    }
    
    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        guard self.isSearching else {
            return guestSectionTitles
        }
        return nil
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // guard?
        if self.isSearching == true {
            // remove - explicite unwraping
            return self.filteredSearchResults!.count
        }
        let guestKey = guestSectionTitles[section]
        if let guestValues = guestsDictionary[guestKey] {
            return guestValues.count
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let guestCell: GuestTableViewCell = tableView.dequeueReusableCell(withIdentifier: GuestTableViewCell.cellID, for: indexPath) as! GuestTableViewCell
        
        // guard?
        if self.isSearching == true {
            // remove - explicite unwraping
            let searchResult = self.filteredSearchResults![indexPath.row]
            guestCell.guestNameLabel.text = searchResult.first_name
            let price = Int(searchResult.price_in_cents)
            guestCell.ticketTypeNameLabel.text = price.dollarString + " | " + searchResult.ticket_type!
            
            // string comparison? can we do it in some other way?
            // better: searchResult.status.lowercased() == "Purchased".lowercased()
            // e.g. status should be enum
            if searchResult.status?.lowercased() == "Purchased".lowercased() {
                guestCell.ticketStateView.tagLabel.text = "PURCHASED"
                guestCell.ticketStateView.backgroundColor = UIColor.brandGreen
            } else {
                guestCell.ticketStateView.tagLabel.text = "REDEEMED"
                guestCell.ticketStateView.backgroundColor = UIColor.brandBlack
            }
            return guestCell
        }
        
        let guestKey = guestSectionTitles[indexPath.section]
        if let guestValues = guestsDictionary[guestKey] {
            guestCell.guestNameLabel.text = guestValues[indexPath.row].last_name! + ", " + guestValues[indexPath.row].first_name!
            let price = Int(guestValues[indexPath.row].price_in_cents)
            let ticketID = guestValues[indexPath.row].id?.suffix(8).uppercased()
            guestCell.ticketTypeNameLabel.text = price.dollarString + " | " + guestValues[indexPath.row].ticket_type! + " | " + ticketID!
            
            if guestValues[indexPath.row].status?.lowercased()
                == "Purchased".lowercased() {
                guestCell.ticketStateView.tagLabel.text = "PURCHASED"
                guestCell.ticketStateView.backgroundColor = UIColor.brandGreen
            } else {
                guestCell.ticketStateView.tagLabel.text = "REDEEMED"
                guestCell.ticketStateView.backgroundColor = UIColor.brandBlack
            }
        }
        return guestCell
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    }
    
    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .default, title: "Checkin") { (action, indexPath) in
            return
        }
        deleteButton.backgroundColor = UIColor.black
        return [deleteButton]
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
