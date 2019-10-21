


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
        return self.eventViewModel.guestCoreData.isEmpty ? "No Guests" : "Guests"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isSearching == true ? self.eventViewModel.guestCoreDataSearchResults.count : self.eventViewModel.guestCoreData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let guestCell: EventGuestsCell = tableView.dequeueReusableCell(withIdentifier: EventGuestsCell.cellID, for: indexPath) as! EventGuestsCell
        guestCell.delegate = self
        if self.isSearching == true && !self.eventViewModel.guestCoreDataSearchResults.isEmpty {
            guestCell.guest = self.eventViewModel.guestCoreDataSearchResults[indexPath.row]
        } else {
            guestCell.guest = self.eventViewModel.guestCoreData[indexPath.row]
        }
        return guestCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var ticket: GuestData?
        if self.isSearching == true && !self.eventViewModel.guestCoreDataSearchResults.isEmpty {
            ticket = self.eventViewModel.guestCoreDataSearchResults[indexPath.row]
        } else {
            ticket = self.eventViewModel.guestCoreData[indexPath.row]
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
               self.guestTableView.reloadData()
               return
           }
        })
    }
    
}
