

import Foundation
import Big_Neon_UI
import Big_Neon_Core
import UIKit

extension GuestListViewController {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = self.searchController.searchBar
        let scope = searchBar.scopeButtonTitles?[searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope ?? "")
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String) {
        
        if searchText == "" {
            self.isSearching = false
            self.guestTableView.reloadData()
            return
        }
        
        self.isSearching = true
        
        // Ping DB for information
        self.guestViewModel.fetchGuests(withQuery: searchText, page: nil, isSearching: true) { [weak self] (_) in
            DispatchQueue.main.async {
                self?.headerView.searchResults = self?.guestViewModel.guestSearchResults.count
                self?.guestTableView.reloadData()
            }
        }
        
        /*
        self.filteredSearchResults = (self.guests!.filter({ (guestTicket: RedeemableTicket) -> Bool in

            guard let email = guestTicket.email else {
                return false
            }

            return guestTicket.firstName.lowercased().contains(searchText.lowercased()) || guestTicket.lastName.lowercased().contains(searchText.lowercased()) ||
                guestTicket.id.suffix(8).lowercased().contains(searchText.lowercased()) ||
                email.lowercased().contains(searchText.lowercased())
        }))

        self.guestTableView.reloadData()
        */
        
    }
    
    internal func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
    
}
