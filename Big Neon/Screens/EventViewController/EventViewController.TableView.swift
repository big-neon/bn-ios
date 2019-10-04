


import Foundation
import UIKit
import Big_Neon_Core

extension EventViewController {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderView: UIView = UIView.init(frame: CGRect(x: 0, y: 0.0, width: tableView.frame.width, height: 56.0))
        sectionHeaderView.backgroundColor = UIColor.brandBackground
        
        let sectionHeaderLabel: UILabel = UILabel.init(frame: CGRect(x: 16.0, y: 16.0, width: tableView.frame.width - 32, height: 20))
        sectionHeaderLabel.font = UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.medium)
        sectionHeaderLabel.textColor = UIColor.brandGrey
        sectionHeaderLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        
        sectionHeaderView.addSubview(sectionHeaderLabel)
        return sectionHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.eventViewModel.ticketsFetched.isEmpty ? "No Guests" : "Guests"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.isSearching == true {
            return self.eventViewModel.guestSearchResults.count
        }
        return self.eventViewModel.ticketsFetched.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let guestCell: EventGuestsCell = tableView.dequeueReusableCell(withIdentifier: EventGuestsCell.cellID, for: indexPath) as! EventGuestsCell
        
        var guestValues: RedeemableTicket?
        
        if self.isSearching == true && !self.eventViewModel.guestSearchResults.isEmpty {
            guestValues = self.eventViewModel.guestSearchResults[indexPath.row]
        } else {
            guestValues = self.eventViewModel.ticketsFetched[indexPath.row]
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
            guestCell.ticketStateView.isHidden = !DateConfig.eventDateIsToday(eventStartDate: guestValues!.eventStart)
            guestCell.ticketStateView.backgroundColor = UIColor.brandGreen
            let buttonValue = DateConfig.eventDateIsToday(eventStartDate: guestValues!.eventStart) == true ? "PURCHASED" : "-"
            guestCell.ticketStateView.setTitle(buttonValue, for: UIControl.State.normal)
        } else {
            guestCell.ticketStateView.isHidden = !DateConfig.eventDateIsToday(eventStartDate: guestValues!.eventStart) //== true ? false : UIColor.white
            guestCell.ticketStateView.backgroundColor = UIColor.brandBlack
            let buttonValue = DateConfig.eventDateIsToday(eventStartDate: guestValues!.eventStart) == true ? "REDEEMED" : "-"
            guestCell.ticketStateView.setTitle(buttonValue, for: UIControl.State.normal)
        }
        
        return guestCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var ticket: RedeemableTicket?
        if self.isSearching == true && !self.eventViewModel.guestSearchResults.isEmpty {
            ticket = self.eventViewModel.guestSearchResults[indexPath.row]
        } else {
            ticket = self.eventViewModel.ticketsFetched[indexPath.row]
        }
        self.showGuest(withTicket: ticket, selectedIndex: indexPath)
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if let lastRow = indexPaths.last?.row, let totalGuests = self.eventViewModel.totalGuests {
           
            //  No neeed to fetch more. Guests are less than 100
            if totalGuests <= 100 {
                return
            }
            
            //  Last Section and Last Row - Fetch more guests
            if lastRow >= self.eventViewModel.currentTotalGuests - 20 {
                fetchNextPage(withIndexPaths: indexPaths)
                return
            }
        }
    }
    
    func fetchNextPage(withIndexPaths indexPaths: [IndexPath]) {
        guard !isFetchingNextPage else {
            return
        }
        self.isFetchingNextPage = true
        self.eventViewModel.fetchNextEventGuests(page: eventViewModel.currentPage, completion: { [unowned self] (_) in
           DispatchQueue.main.async {
               self.isFetchingNextPage = false
               self.guests = self.eventViewModel.ticketsFetched
               self.guestTableView.reloadData()
               return
           }
        })
    }
    
}
