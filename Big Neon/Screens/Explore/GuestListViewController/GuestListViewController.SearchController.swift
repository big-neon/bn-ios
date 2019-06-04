

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
        
        self.filteredSearchResults = (self.guests!.filter({ (guestTicket: RedeemableTicket) -> Bool in
            
            guard let email = guestTicket.email else {
                return false
            }
            
            return guestTicket.firstName.lowercased().contains(searchText.lowercased()) || guestTicket.lastName.lowercased().contains(searchText.lowercased()) ||
                guestTicket.id.suffix(8).lowercased().contains(searchText.lowercased()) ||
                email.lowercased().contains(searchText.lowercased())
        }))
        
        self.guestTableView.reloadData()
        
    }
    
    internal func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
    
//    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        self.isSearching = false
//        self.searchBar.text = "";
//        self.searchBar.setShowsCancelButton(false, animated: true)
//        self.searchBar.endEditing(true)
//        self.guestTableView.reloadData()
//    }
//
//    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        self.searchBar.endEditing(true)
//    }
    
}
