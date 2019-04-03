

import Foundation
import UIKit

extension GuestListView {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.guestSectionTitles.count
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return guestSectionTitles[section]
    }
    
    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return guestSectionTitles
    }
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return carSectionTitles[section]
//    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let guestKey = guestSectionTitles[section]
        if let guestValues = guestsDictionary[guestKey] {
            return guestValues.count
        }
        
        return 0
        
//        guard let guests =  self.guests?.data else {
//            return 0
//        }
//        return guests.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let guestCell: GuestTableViewCell = tableView.dequeueReusableCell(withIdentifier: GuestTableViewCell.cellID, for: indexPath) as! GuestTableViewCell
        guard let name = self.guests?.data[indexPath.row].firstName, let surname = self.guests?.data[indexPath.row].lastName else {
            return guestCell
        }
        guestCell.guestNameLabel.text = name + " " + surname
        guestCell.ticketTypeNameLabel.text = (self.guests?.data[indexPath.row].priceInCents.dollarString)! + " | " + (self.guests?.data[indexPath.row].ticketType)!
        
        if self.guests?.data[indexPath.row].status == "Purchased" {
            guestCell.ticketStateView.tagLabel.text = "PURCHASED"
            guestCell.ticketStateView.backgroundColor = UIColor.brandGreen
        } else {
            guestCell.ticketStateView.tagLabel.text = "REDEEMED"
            guestCell.ticketStateView.backgroundColor = UIColor.brandBlack
        }
        return guestCell
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            self.handleDeletePayment(atIndex: indexPath.row)
//        }
        
//        switch editingStyle {
//        case .delete:
//            print("")
//        default:
//            return
//        }
    }
    
    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .default, title: "Checkin") { (action, indexPath) in
//            self.tableView.dataSource?.tableView!(self.tableView, commit: .delete, forRowAt: indexPath)
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
